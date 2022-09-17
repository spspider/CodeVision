#include "httpd.h"

#define len(some) (sizeof(some)/sizeof(some[0]))

const prog_char http_200[] = "HTTP/1.0 200 OK\r\n";
const prog_char http_404[] = "HTTP/1.0 404 Not Found\r\n";
const prog_char http_server[] = "Server: "HTTPD_NAME"\r\n";
const prog_char http_content_type[] = "Content-Type: ";
const prog_char http_content_length[] = "Content-Length: ";
const prog_char http_connection_close[] = "Connection: close\r\n";
const prog_char http_linebreak[] = "\r\n";
const prog_char http_header_end[] = "\r\n\r\n";
const prog_char http_not_found[] = "<h1>404 - Not Found</h1>";

const prog_char http_text_plain[] = "text/plain";
const prog_char http_text_html[] = "text/html";
const prog_char http_text_js[] = "text/javascript";
const prog_char http_text_css[] = "text/css";
const prog_char http_image_gif[] = "image/gif";
const prog_char http_image_png[] = "image/png";
const prog_char http_image_jpeg[] = "image/jpeg";

const prog_char http_ext_txt[] = "txt";
const prog_char http_ext_htm[] = "htm";
const prog_char http_ext_html[] = "html";
const prog_char http_ext_js[] = "js";
const prog_char http_ext_css[] = "css";
const prog_char http_ext_gif[] = "gif";
const prog_char http_ext_png[] = "png";
const prog_char http_ext_jpg[] = "jpg";
const prog_char http_ext_jpeg[] = "jpeg";

const prog_char* PROGMEM mime_type_table[][2] =
{
	{http_ext_txt, http_text_plain},
	{http_ext_htm, http_text_html},
	{http_ext_html, http_text_html},
	{http_ext_js, http_text_js},
	{http_ext_css, http_text_css},
	{http_ext_gif, http_image_gif},
	{http_ext_png, http_image_png},
	{http_ext_jpg, http_image_jpeg},
	{http_ext_jpeg, http_image_jpeg}
};

// httpd state
httpd_state_t httpd_pool[TCP_MAX_CONNECTIONS];

void fill_buf(char **buf, char *str);
void fill_buf_P(char **buf, const prog_char * str);

// get mime type from filename extension
const prog_char *httpd_get_mime_type(char *url)
{
	const prog_char *t_ext, *t_type;
	char *ext;
	uint8_t i;

	if((ext = strrchr(url, '.')))
	{
		ext++;
		strlwr(ext);

		for(i = 0; i < len(mime_type_table); ++i)
		{
			t_ext = (void*)pgm_read_word(mime_type_table[i] + 0);

			if(!strcmp_P(ext, t_ext))
			{
				t_type = (void*)pgm_read_word(mime_type_table[i] + 1);
				return t_type;
			}
		}
	}
	return 0;
}

// processing HTTP request
void httpd_request(uint8_t id, httpd_state_t *st, char *url)
{
	uint16_t stat;
	
	// index file requested?
	if(!strcmp_P(url, PSTR("/")))
		url = HTTPD_INDEX_FILE;

	// defaults
	st->statuscode = 4;					// status: 404 Not Found
	st->type = http_text_plain;			// type: text/plain
	st->data_mode = HTTPD_DATA_RAM;		// source: memory
	st->cursor = 0;						// cursor: beginning
	st->numbytes = 0;					// no data

	if(!memcmp_P(url, PSTR("/cgi-bin"), 8))
	{
		stat = cgi_exec(id, url+8, st->data.ram, &(st->data.callback));
		
		if(stat == CGI_USE_CALLBACK)
		{
			st->statuscode = 2;
			st->data_mode = HTTPD_DATA_CALLBACK;
		}
		
		else if(stat != CGI_NOT_FOUND)
		{
			st->statuscode = 2;
			st->numbytes = stat;
		}
	}
	else
	{
		if(!f_open(&(st->data.fs), url, FA_READ))
		{
			st->statuscode = 2;							// status: 200 OK
			st->type = httpd_get_mime_type(url);		// data type
			st->data_mode = HTTPD_DATA_FILE;			// source: file
			st->numbytes = st->data.fs.fsize;			// data length
		}
	}
	
	// send 404 error page
	if(st->statuscode == 4)
	{
		st->data_mode = HTTPD_DATA_PROGMEM;				// source: flash
		st->type = http_text_html;						// document type
		st->data.prog = http_not_found;					// document data
		st->numbytes = sizeof(http_not_found)-1;		// document length
	}

#ifdef WITH_TCP_REXMIT
	// save state
	st->statuscode_saved = st->statuscode;
	st->numbytes_saved = st->numbytes;
	st->cursor_saved = st->cursor;
#endif
}

// prepare HTTP reply header
void httpd_header(httpd_state_t *st, char **buf)
{
	char str[16];

	// Status
	if(st->statuscode == 2)
		fill_buf_P(buf, http_200);
	else
		fill_buf_P(buf, http_404);

	// Content-Type
	if(st->type)
	{
		fill_buf_P(buf, http_content_type);
		fill_buf_P(buf, st->type);
		fill_buf_P(buf, http_linebreak);
	}

	// Content-Length
	if(st->numbytes)
	{
		ltoa(st->numbytes, str, 10);
		fill_buf_P(buf, http_content_length);
		fill_buf(buf, str);
		fill_buf_P(buf, http_linebreak);
	}

	// Server
	fill_buf_P(buf, http_server);

	// Connection: close
	fill_buf_P(buf, http_connection_close);

	// Header end
	fill_buf_P(buf, http_linebreak);
}

// accepts incoming connections
uint8_t tcp_listen(uint8_t id, eth_frame_t *frame)
{
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);

	// accept connections to port 80
	return (tcp->to_port == HTTPD_PORT);
}

// upstream callback
void tcp_read(uint8_t id, eth_frame_t *frame, uint8_t re)
{
	httpd_state_t *st = httpd_pool + id;
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *buf = (void*)(tcp->data), *bufptr;
	uint16_t blocklen;
	uint8_t i;
	uint16_t sectorbytes;
	uint8_t options;

	// Connection opened
	if(st->status == HTTPD_CLOSED)
	{
		st->status = HTTPD_INIT;
	}

	// Sending data
	else if(st->status == HTTPD_WRITE_DATA)
	{

#ifdef WITH_TCP_REXMIT
		if(re)
		{
			// load previous state
			st->statuscode = st->statuscode_saved;
			st->cursor = st->cursor_saved;
			st->numbytes = st->numbytes_saved;

			if(st->data_mode == HTTPD_DATA_FILE)
				f_lseek(&(st->data.fs), st->cursor);
		}
		else
		{
			// save state
			st->statuscode_saved = st->statuscode;
			st->cursor_saved = st->cursor;
			st->numbytes_saved = st->numbytes;
		}
#endif

		// Send bulk of packets
		for(i = HTTPD_PACKET_BULK; i; --i)
		{
			blocklen = HTTPD_MAX_BLOCK;
			bufptr = buf;

			// Put HTTP header to buffer
			if(st->statuscode != 0)
			{
				httpd_header(st, &bufptr);
				blocklen -= bufptr - buf;
				st->statuscode = 0;
			}

			// Send up to 512 bytes (-header)
			if(st->numbytes < blocklen)
				blocklen = st->numbytes;

			switch(st->data_mode)
			{
			// data from RAM
			case HTTPD_DATA_RAM:
				memcpy(bufptr, st->data.ram + st->cursor, blocklen);
				break;

			// data through callback
			case HTTPD_DATA_CALLBACK:
				blocklen = st->data.callback(id, bufptr);
				break;

			// data from progmem
			case HTTPD_DATA_PROGMEM:
				memcpy_P(bufptr, st->data.prog + st->cursor, blocklen);
				break;

			// data from file
			case HTTPD_DATA_FILE:

				// align read to sector boundary
				sectorbytes = 512 - ((uint16_t)(st->cursor) & 0x1ff);
				if(blocklen > sectorbytes)
					blocklen = sectorbytes;

				// read data from file
				f_read(&(st->data.fs), bufptr, blocklen, &blocklen);
				break;
			}

			bufptr += blocklen;
			st->cursor += blocklen;
			st->numbytes -= blocklen;

			// Send packet
			if( (st->data_mode == HTTPD_DATA_CALLBACK) || 
				(!st->numbytes) )
			{
				options = TCP_OPTION_CLOSE;
			}
			else if(i == 1)
			{
				options = TCP_OPTION_PUSH;
			}
			else
			{
				options = 0;
			}

			tcp_send(id, frame, bufptr - buf, options);

			if(options == TCP_OPTION_CLOSE)
				break;
		}
	}
}

// downstream callback
void tcp_write(uint8_t id, eth_frame_t *frame, uint16_t len)
{
	httpd_state_t *st = httpd_pool + id;
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *request = (void*)tcp_get_data(tcp);
	char *url, *p;

	request[len] = 0;

	// just connected?
	if(st->status == HTTPD_INIT)
	{
		// extract URL from request header
		url = request + 4;
		if( (!memcmp_P(request, PSTR("GET "), 4)) &&
			((p = strchr(url, ' '))) )
		{
			*(p++) = 0;

			// process URL request
			httpd_request(id, st, url);

			// skip other fields
			if(strstr_P(p, http_header_end))
				st->status = HTTPD_WRITE_DATA;
			else
				st->status = HTTPD_READ_HEADER;
		}
	}

	// receiving HTTP header?
	else if(st->status == HTTPD_READ_HEADER)
	{
		// skip all fields
		if(strstr_P(request, http_header_end))
			st->status = HTTPD_WRITE_DATA;
	}
}

// connection closing handler
void tcp_closed(uint8_t id, uint8_t hard)
{
	httpd_state_t *st = httpd_pool + id;

	if(st->data_mode == HTTPD_DATA_FILE)
		f_close(&(st->data.fs));
	st->data_mode = HTTPD_DATA_RAM;
	st->status = HTTPD_CLOSED;
}

// utilities
void fill_buf(char **buf, char *str)
{
	uint16_t len = 0;
	char *p = *buf;

	while(*str)
		p[len++] = *(str++);
	*buf += len;
}

void fill_buf_P(char **buf, const prog_char * str)
{
	uint16_t len = 0;
	char *p = *buf, byte;

	while((byte = pgm_read_byte(str++)))
		p[len++] = byte;
	*buf += len;
}
