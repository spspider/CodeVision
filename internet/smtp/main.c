#include <avr/io.h>
#include <stdlib.h>
#include "lan.h"
#include "counter.h"
#include "smtp.h"
#include "ds1820.h"

#define EMAIL_SMTP_SERVER		inet_addr(87,250,250,38)//smtp.yandex.ru
#define EMAIL_SMTP_PORT			htons(25)
#define EMAIL_SMTP_USERNAME		"username@yandex.ru"
#define EMAIL_SMTP_PASSWORD		"password"

#define EMAIL_TO				"email@example.com"

#define EMAIL_MIN_INTERVAL		10*60 // sec

#define TEMP_POLL_INTERVAL		1500
#define TEMP_THRESOLD			40

uint8_t email_sending_id = 0xff;
uint8_t email_num_attempts_failed;
uint32_t email_next_attempt_time;

int current_temp;
int last_reported_temp;

// ignoring
void udp_packet(eth_frame_t *frame, uint16_t len) {}

// TCP
uint8_t tcp_listen(uint8_t id, eth_frame_t *frame)
{
	return 0;
}

void tcp_opened(uint8_t id, eth_frame_t *frame)
{
	if(id == email_sending_id)
		smtp_reset();
}

void tcp_data(uint8_t id, eth_frame_t *frame, uint16_t len, uint8_t closing)
{
	if(id == email_sending_id)
		smtp_data(id, frame, len);
}

void tcp_closed(uint8_t id, uint8_t reset)
{
	if(id == email_sending_id)
		email_sending_id = 0xff;
}

// Email

void smtp_info(smtp_info_class_t type, char **buf)
{
	char str[8];

	switch(type)
	{
	case SMTP_USERNAME:
		smtp_fill_packet_p(buf, PSTR(EMAIL_SMTP_USERNAME));
		break;
	case SMTP_PASSWORD:
		smtp_fill_packet_p(buf, PSTR(EMAIL_SMTP_PASSWORD));
		break;
	case SMTP_FROM_EMAIL:
		smtp_fill_packet_p(buf, PSTR(EMAIL_SMTP_USERNAME));
		break;
	case SMTP_TO_EMAIL:
		smtp_fill_packet_p(buf, PSTR(EMAIL_TO));
		break;
	case SMTP_SUBJECT:
		smtp_fill_packet_p(buf, PSTR("Thermo sensor"));
		break;
	case SMTP_MESSAGE:
		itoa(current_temp, str, 10);
		smtp_fill_packet_p(buf, PSTR("Temperature reached "));
		smtp_fill_packet(buf, str);
		smtp_fill_packet_p(buf, PSTR("'C !"));
		break;
	}
}

void smtp_done(uint8_t success)
{
	if(!success)
	{
		email_num_attempts_failed++;
		return;
	}

	email_next_attempt_time = rtime() + EMAIL_MIN_INTERVAL;
	last_reported_temp = current_temp;
	email_num_attempts_failed = 0;
}

void email_send()
{
	uint16_t local_port;

	if(!lan_up())
		return;

	if(email_num_attempts_failed >= 5)
		return;
	
	if(email_sending_id == 0xff)
	{
		local_port = 1025 + (gettc() & 0x7fff);

		email_sending_id = tcp_open(
			EMAIL_SMTP_SERVER,
			EMAIL_SMTP_PORT,
			htons(local_port));

		if(email_sending_id != 0xff)
			email_next_attempt_time = rtime() + 1*60;
	}
}

// temp
void temp_poll()
{
	static uint8_t converted = 0;
	
	if(converted)
	{
		if( (current_temp = ds1820_read()) != 0x7fff )
		{
			if( (current_temp > TEMP_THRESOLD) &&
				(abs(current_temp - last_reported_temp) >= 5) &&
				(rtime() > email_next_attempt_time) )
			{
				email_send();
			}
		}
	}

	converted = ds1820_start();
}

int main()
{
	uint32_t temp_last_poll = 0;
	
	_delay_ms(20);

	DDRA |= (1<<PA0);
	PORTA |= (1<<PA0);
	lan_init();

	counter_init();
	sei();
	
	while(1)
	{
		lan_poll();

		if(lan_up())
			PORTA &= ~(1<<PA0);
		else
			PORTA |= (1<<PA0);
		
		if(gettc() - temp_last_poll >= TEMP_POLL_INTERVAL)
		{
			temp_last_poll = gettc();
			temp_poll();
		}
	}

	return 0;
}
