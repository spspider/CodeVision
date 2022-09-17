#include "smtp.h"

uint8_t smtp_success;
smtp_status_code_t smtp_state;


void smtp_fill_packet(char **ptr, char *str)
{
	while(*str) *((*ptr)++) = *(str++);
}

void smtp_fill_packet_p(char **ptr, prog_char *str)
{
	char c;

	while((c = pgm_read_byte(str))) {
		*((*ptr)++) = c;
		str++;
	}
}

void smtp_reset()
{
	smtp_success = 0;
	smtp_state = SMTP_INIT;
}

// send QUIT
void smtp_quit(uint8_t id, eth_frame_t *frame)
{
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *outdata = (void*)(tcp->data);
	char *p;

	p = outdata;
	smtp_fill_packet_p(&p, PSTR("QUIT\r\n"));
	tcp_send(id, frame, p-outdata, 0);
	smtp_state = SMTP_QUIT_SENT;
}

// server data handler
void smtp_data(uint8_t id, eth_frame_t *frame, uint16_t len)
{
	char buf[64];
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *datain = (void*)tcp_get_data(tcp);
	char *dataout = (void*)(tcp->data), *p;
	int statuscode;
	uint8_t num;

	if(!len) return;

	datain[len] = 0;
	statuscode = atoi(datain);

	switch(smtp_state)
	{
		
	// just started, should receive 220 blah blah blah
	case SMTP_INIT:

		// status code should be 220
		if(statuscode != 220)
		{
			smtp_quit(id, frame);
			break;
		}

		// send HELO localhost\r\n
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("HELO localhost\r\n"));
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_HELLO_SENT;
		break;

	// helo sent, sending AUTH
	case SMTP_HELLO_SENT:
		// status code should be 250
		if(statuscode != 250)
		{
			smtp_quit(id, frame);
			break;
		}

		// buf = \0username\0password
		p = buf;
		*(p++) = 0;
		smtp_info(SMTP_USERNAME, &p);
		*(p++) = 0;
		smtp_info(SMTP_PASSWORD, &p);
		num = (uint8_t)(p - buf);

		// send AUTH PLAIN base64(buf)\r\n
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("AUTH PLAIN "));
		p += base64_encode(p, (uint8_t*)buf, num);
		*(p++) = '\r'; *(p++) = '\n';
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_AUTH_SENT;
		break;

	// auth sent, sending MAIL FROM
	case SMTP_AUTH_SENT:

		// status code should be 235 (auth success)
		if( (statuscode != 235) &&
			(statuscode != 250) )
		{
			smtp_quit(id, frame);
			break;
		}

		// send MAIL FROM srcemail\r\n
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("MAIL FROM:"));
		smtp_info(SMTP_FROM_EMAIL, &p);
		*(p++) = '\r'; *(p++) = '\n';
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_FROM_SENT;
		break;

	// MAIL FROM sent, send RCPT TO
	case SMTP_FROM_SENT:

		// status code should be 250 (ok)
		if(statuscode != 250)
		{
			smtp_quit(id, frame);
			break;
		}

		// send RCPT TO dstemail\r\n
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("RCPT TO:"));
		smtp_info(SMTP_TO_EMAIL, &p);
		*(p++) = '\r'; *(p++) = '\n';
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_TO_SENT;
		break;

	// RCPT TO sent, send "DATA"
	case SMTP_TO_SENT:

		// status code should be 250 (accepted)
		if(statuscode != 250)
		{
			smtp_quit(id, frame);
			break;
		}

		// send DATA
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("DATA\r\n"));
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_DATA_SENT;
		break;

	// "DATA" sent, send message body
	case SMTP_DATA_SENT:

		// status code should be 354 (enter message, blah blah blah)
		if(statuscode != 354)
		{
			smtp_quit(id, frame);
			break;
		}

		// send message body
		p = dataout;
		smtp_fill_packet_p(&p, PSTR("From: "));
		smtp_info(SMTP_FROM_EMAIL, &p);
		smtp_fill_packet_p(&p, PSTR("\r\nTo: "));
		smtp_info(SMTP_TO_EMAIL, &p);
		smtp_fill_packet_p(&p, PSTR("\r\nSubject: "));
		smtp_info(SMTP_SUBJECT, &p);
		smtp_fill_packet_p(&p, PSTR("\r\n"
			"MIME-Version: 1.0\r\n"
			"Content-Type: text/plain; charset=ISO-8859-1; format=flowed\r\n"
			"Content-Transfer-Encoding: 7bit\r\n"
			"\r\n"));

		smtp_info(SMTP_MESSAGE, &p);
		smtp_fill_packet_p(&p, PSTR("\r\n.\r\n"));
		tcp_send(id, frame, p-dataout, 0);

		smtp_state = SMTP_MESSAGE_SENT;
		break;

	// message body sent, send QUIT
	case SMTP_MESSAGE_SENT:

		//status code should be 250 OK
		if(statuscode == 250)
			smtp_success = 1;

		// send QUIT
		smtp_quit(id, frame);
		break;

	// QUIT sent, done
	case SMTP_QUIT_SENT:
		smtp_done(smtp_success);
		break;
	}
}
