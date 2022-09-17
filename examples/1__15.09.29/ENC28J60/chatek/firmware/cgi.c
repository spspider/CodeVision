#include "cgi.h"

#define TEST_LED_PORT		PORTB
#define TEST_LED_DDR		DDRB
#define TEST_LED_BIT		(1<<PB1)

#define test_led_state()	((TEST_LED_PORT & TEST_LED_BIT) ? 0 : 1)
#define test_led_on()		TEST_LED_PORT &= ~TEST_LED_BIT
#define test_led_off()		TEST_LED_PORT |= TEST_LED_BIT
#define test_led_init()		TEST_LED_DDR |= TEST_LED_BIT; test_led_off()

// utils
void simple_urldecode(char *url);
char *single_param(char *str, prog_char *param);


/*
 * cgi_led
 */

uint16_t cgi_led_exec(char *action, char *buf)
{
	if(strcmp_P(action, PSTR("/on/")) == 0)
		test_led_on();
	else if(strcmp_P(action, PSTR("/off/")) == 0)
		test_led_off();
	else if(strcmp_P(action, PSTR("/state/")) != 0)
		return CGI_NOT_FOUND;

	*buf = test_led_state() + '0';
	return 1;
}

#define cgi_led_init() test_led_init()

/*
 * cgi_ds1820
 */

int ds1820_temp = 0x7fff;
uint32_t ds1820_start_time;
uint8_t ds1820_converted;

uint16_t cgi_ds1820_exec(char *url, char *buf)
{
	uint8_t temp, len;
	
	if(!strcmp_P(url, PSTR("/value/")))
	{
		if(ds1820_temp == 0x7fff)
		{
			memcpy_P(buf, PSTR("N/A"), 3);
			return 3;
		}
		
		itoa(ds1820_temp>>4, buf, 10);
		len = strlen(buf);

		temp = ((abs(ds1820_temp) & 0x0f) * 10 + 7) >> 4;
		if(temp) {
			buf[len++] = '.';
			buf[len++] = '0'+temp;
		}
		
		return len;
	}
	
	return CGI_NOT_FOUND;
}
 
void cgi_ds1820_poll()
{
	if(rtime() >= ds1820_start_time)
	{
		if(ds1820_converted)
			ds1820_temp = ds1820_read();
		else
			ds1820_temp = 0x7fff;
		
		ds1820_converted = ds1820_start();
		ds1820_start_time = rtime() + 3;
	}
}

/*
 * cgi_chat
 */

#define CHAT_MSG_MAX	40
#define CHAT_MSG_HIST	3
 
uint8_t chat_wp, chat_num_msg;
uint32_t chat_msg_id;
char chat_msg[CHAT_MSG_HIST][CHAT_MSG_MAX];

uint16_t cgi_chat_data(uint8_t id, char *buf)
{
	char *bufptr = buf;
	uint8_t rp = chat_wp+CHAT_MSG_HIST-chat_num_msg;
	uint32_t msg_id = chat_msg_id;

	uint8_t i, len;
	char *s;
	
	// output format:
	// id1:msg1\r\n
	// id2:msg2\r\n

	for(i = 0; i < chat_num_msg; ++i)
	{
		while(rp >= CHAT_MSG_HIST)
			rp -= CHAT_MSG_HIST;
		
		// id
		ultoa(msg_id++, bufptr, 10);
		bufptr += strlen(bufptr);
		
		// :
		*(bufptr++) = ':';

		// msg
		s = chat_msg[rp++];
		len = (uint8_t)strnlen(s, CHAT_MSG_MAX);
		memcpy(bufptr, s, len);
		bufptr += len;
		
		// \r\n
		*(bufptr++) = '\r';
		*(bufptr++) = '\n';
	}

	return bufptr - buf;
}

void chat_say(char *str)
{
	if(!*str) return;

	strncpy(chat_msg[chat_wp++], str, CHAT_MSG_MAX);
	if(chat_wp == CHAT_MSG_HIST)
		chat_wp = 0;

	if(chat_num_msg < CHAT_MSG_HIST)
		chat_num_msg++;
	else
		chat_msg_id++;
}

uint16_t cgi_chat_exec(char *url, char *params, cgi_callback_t *callback)
{
	*callback = cgi_chat_data;
	char *msg;
	
	if(strcmp_P(url, PSTR("/load/")) == 0)
		return CGI_USE_CALLBACK;
	
	if( (strcmp_P(url, PSTR("/say/")) == 0) &&
		(msg = single_param(params, PSTR("msg"))) )
	{
		simple_urldecode(msg);
		chat_say(msg);
		return CGI_USE_CALLBACK;
	}
	
	return CGI_NOT_FOUND;
}

/*
 * cgi
 */

uint16_t cgi_exec(uint8_t id, char *url, char *buf, cgi_callback_t *callback)
{
	char *param;
	
	if((param = strchr(url, '?')))
		*(param++) = 0;
	
	if(memcmp_P(url, PSTR("/led"), 4) == 0)
		return cgi_led_exec(url+4, buf);
	
	if(memcmp_P(url, PSTR("/ds1820"), 7) == 0)
		return cgi_ds1820_exec(url+7, buf);
	
	if(memcmp_P(url, PSTR("/chat"), 5) == 0)
		return cgi_chat_exec(url+5, param, callback);
	
	return CGI_NOT_FOUND;
}

void cgi_init_all()
{
	cgi_led_init();
}

void cgi_poll_all()
{
	cgi_ds1820_poll();
}

/*
 * utils
 */

uint8_t unhex(char c)
{
	if((c >= '0') && (c <= '9'))
		return c - '0';
	if((c >= 'A') && (c <= 'F'))
		return c - 'A' + 10;
	if((c >= 'a') && (c <= 'f'))
		return c - 'a' + 10;
	return 0xff;
}
 
void simple_urldecode(char *url)
{
	char *src = url, *dst = url;
	
	while(*src)
	{
		if((src[0] == '%') && src[1] && src[2]) 
		{
			*(dst++) = (unhex(src[1])<<4) | unhex(src[2]);
			src += 3;
		} 
		else if(src[0] == '+')
		{
			*(dst++) = ' ';
			src++;
		}
		else if(src != dst)
		{
			*(dst++) = *(src++);
		}
		else 
		{
			src++;
			dst++;
		}
	}
	*dst = 0;
}

char *single_param(char *str, prog_char *param)
{
	char *p, *val;
	
	while(str)
	{
		p = str;
		
		if((str = strchr(str, '&')))
			*(str++) = 0;
		
		if((val = strchr(p, '=')))
			*(val++) = 0;

		if(!strcmp_P(p, param))
			return val;
	}
	return 0;
}
