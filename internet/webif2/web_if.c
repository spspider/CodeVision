#include "web_if.h"

prog_char webif_404_reply[] =
	"HTTP/1.0 404 Not Found\r\n"
	"Content-Type: text/html; charset=windows-1251\r\n"
	"Server: ATmega16\r\n"
	"\r\n"
	"<pre>Page not found\r\n\r\n"
	"<a href='/'>Home page</a></pre>\r\n";

prog_char webif_200_header[] =
	"HTTP/1.0 200 OK\r\n"
	"Content-Type: text/html; charset=windows-1251\r\n"
	"Server: ATmega16\r\n"
	"\r\n";

uint8_t led_brightness;

void fill_buf_p(char **buf, const prog_char *pstr)
{
	char c;
	while((c = pgm_read_byte(pstr)))
	{
		*((*buf)++) = c;
		pstr++;
	}
}

void fill_buf(char **buf, const char *str)
{
	while(*str) *((*buf)++) = *(str++);
}

void webif_init()
{
	// Fast PWM
	DDRB |= (1<<PB2)|(1<<PB3);
	TCCR0 = (1<<WGM01)|(1<<WGM00)|(1<<COM01)|(1<<COM00)|(1<<CS02);
}

void webif_data(uint8_t id, eth_frame_t *frame, uint16_t len)
{
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *req = (void*)tcp_get_data(tcp);
	char *buf = (void*)(tcp->data), *buf_ptr = buf;
	char *url, *p, *params, *name, *value;
	char str[8];
	int val;

	if(!len) return;

	if( (memcmp_P(req, PSTR("GET "), 4) == 0) &&
		((p = strchr(req + 4, ' ')) != 0) )
	{
		url = req + 4;
		*p = 0;

		if((params = strchr(url, '?')))
			*(params++) = 0;

		if(strcmp_P(url, PSTR("/")) == 0)
		{
			while(params)
			{
				if((p = strchr(params, '&')))
					*(p++) = 0;
				
				name = params;
				if((value = strchr(name, '=')))
					*(value++) = 0;
				
				if( (strcmp_P(name, PSTR("pwm")) == 0 ) && value )
				{
					val = atoi(value);
					if(val < 0) val = 0;
					if(val > 255) val = 255;
					led_brightness = val;
					
					OCR0 = led_brightness;
				}
				
				params = p;
			}

			itoa(led_brightness, str, 10);

			fill_buf_p(&buf_ptr, webif_200_header);
			fill_buf_p(&buf_ptr, PSTR("<pre>"));
			fill_buf_p(&buf_ptr, PSTR("Brightness: "));
			fill_buf(&buf_ptr, str);
			fill_buf_p(&buf_ptr, PSTR(". <a href='/edit'>Change</a>"));
			fill_buf_p(&buf_ptr, PSTR("</pre>"));
		}

		else if(strcmp_P(url, PSTR("/edit")) == 0)
		{
			itoa(led_brightness, str, 10);

			fill_buf_p(&buf_ptr, webif_200_header);
			fill_buf_p(&buf_ptr, PSTR("<pre>"));
			fill_buf_p(&buf_ptr, PSTR("<form action='/' method='GET'>\r\n"));
			fill_buf_p(&buf_ptr, PSTR("Enter value (0..255):\r\n"));
			fill_buf_p(&buf_ptr, PSTR("<input type='text' name='pwm' size='4' value='"));
				fill_buf(&buf_ptr, str);
					fill_buf_p(&buf_ptr, PSTR("'>  "));
			fill_buf_p(&buf_ptr, PSTR("<input type='submit' value='OK'>\r\n"));
			fill_buf_p(&buf_ptr, PSTR("</form>"));
			fill_buf_p(&buf_ptr, PSTR("</pre>"));
		}

		else
		{
			fill_buf_p(&buf_ptr, webif_404_reply);
		}
	}

	tcp_send(id, frame, buf_ptr-buf, 1);
}
