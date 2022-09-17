#pragma once

#include <string.h>
#include <stdlib.h>
#include <avr/pgmspace.h>
#include "lan.h"
#include "mime.h"


void smtp_reset();
void smtp_data(uint8_t id, eth_frame_t *frame, uint16_t len);

void smtp_fill_packet(char **ptr, char *str);
void smtp_fill_packet_p(char **ptr, prog_char *str);

// callbacks

typedef enum smtp_info_class {
	SMTP_USERNAME,
	SMTP_PASSWORD,
	SMTP_FROM_EMAIL,
	SMTP_TO_EMAIL,
	SMTP_SUBJECT,
	SMTP_MESSAGE,
} smtp_info_class_t;

void smtp_info(smtp_info_class_t type, char **buf);
void smtp_done(uint8_t success);

typedef enum smtp_status_code {
	SMTP_INIT,
	SMTP_HELLO_SENT,
	SMTP_AUTH_SENT,
	SMTP_FROM_SENT,
	SMTP_TO_SENT,
	SMTP_DATA_SENT,
	SMTP_MESSAGE_SENT,
	SMTP_QUIT_SENT
} smtp_status_code_t;
