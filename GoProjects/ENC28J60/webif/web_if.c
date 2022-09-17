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

#define LED_DDR		DDRD
#define LED_PORT 	PORTD
#define LED_BIT		(1<<PD0)
	
#define led_on()	{ LED_PORT &= ~LED_BIT; led_state = 1; }
#define led_off()	{ LED_PORT |= LED_BIT; led_state = 0; }

uint8_t led_state;
uint8_t lang_ru;

void fill_buf_p(char **buf, const prog_char *pstr)
{
	char c;
	while((c = pgm_read_byte(pstr)))
	{
		*((*buf)++) = c;
		pstr++;
	}
}

void webif_init()
{
	LED_DDR |= LED_BIT;
	led_off();
}

void webif_data(uint8_t id, eth_frame_t *frame, uint16_t len)
{
	ip_packet_t *ip = (void*)(frame->data);
	tcp_packet_t *tcp = (void*)(ip->data);
	char *req = (void*)tcp_get_data(tcp);
	char *buf = (void*)(tcp->data), *buf_ptr = buf;
	char *url, *p, *params, *name, *value;


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
				
				if( (strcmp_P(name, PSTR("led")) == 0 ) && value )
				{
					if(strcmp_P(value, PSTR("on")) == 0)
						led_on()
					else if(strcmp_P(value, PSTR("off")) == 0)
						led_off()
				}
				
				else if( (strcmp_P(name, PSTR("lang")) == 0) && value )
				{
					if(strcmp_P(value, PSTR("en")) == 0)
						lang_ru = 0;
					else if(strcmp_P(value, PSTR("ru")) == 0)
						lang_ru = 1;
				}
				
				params = p;
			}

			fill_buf_p(&buf_ptr, webif_200_header);
			fill_buf_p(&buf_ptr, PSTR("<pre>"));

			if(!lang_ru)
			{
				fill_buf_p(&buf_ptr, PSTR("<p align='right'>[<b>EN</b> | "
					"<a href='/?lang=ru'>RU</a>]</p>"));
			}
			else
			{
				fill_buf_p(&buf_ptr, PSTR("<p align='right'>[<a href='/?lang=en'>EN</a> | "
					"<b>RU</b>]</p>"));
			}
			
			if((!led_state)&&(!lang_ru))
				fill_buf_p(&buf_ptr, PSTR("Led is OFF. Turn <a href='/?led=on'>on</a>."));
			else if(led_state &&(!lang_ru))
				fill_buf_p(&buf_ptr, PSTR("Led is ON. Turn <a href='/?led=off'>off</a>."));
			else if((!led_state)&&(lang_ru))
				fill_buf_p(&buf_ptr, PSTR("Светодиод выключен. <a href='/?led=on'>Включить</a>."));
			else if(led_state &&(lang_ru))
				fill_buf_p(&buf_ptr, PSTR("Светодиод включен. <a href='/?led=off'>Выключить</a>."));
			
			fill_buf_p(&buf_ptr, PSTR("</pre>"));
		}
		
		else
		{
			fill_buf_p(&buf_ptr, webif_404_reply);
		}
	}

	tcp_send(id, frame, buf_ptr-buf, 1);
}
