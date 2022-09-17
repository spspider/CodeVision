#pragma once

#include <avr/pgmspace.h>
#include <stdlib.h>
#include <string.h>
#include "ff/ff.h"
#include "lan.h"
#include "cgi.h"

#define HTTPD_PORT			htons(80)
#define HTTPD_PACKET_BULK	10
#define HTTPD_MAX_BLOCK		512
#define HTTPD_NAME			"ATmega32"
#define HTTPD_INDEX_FILE	"/index.htm"

#define httpd_init() cgi_init_all()
#define httpd_poll() cgi_poll_all()

typedef enum httpd_state_code {
	HTTPD_CLOSED,
	HTTPD_INIT,
	HTTPD_READ_HEADER,
	HTTPD_WRITE_DATA
} httpd_state_code_t;

typedef enum httpd_data_mode {
	HTTPD_DATA_RAM,
	HTTPD_DATA_CALLBACK,
	HTTPD_DATA_PROGMEM,
	HTTPD_DATA_FILE
} httpd_data_mode_t;

typedef uint16_t (*httpd_data_callback_t)(uint8_t id, char *buf);

typedef union httpd_data {
	char ram[32];					// buffer with small data to send
	httpd_data_callback_t callback;	// callback
	const prog_char *prog;			// pointer to buffer in progmem
	FIL fs;							// file
} httpd_data_t;

typedef struct httpd_state {
	httpd_state_code_t status;

	// header
	uint8_t statuscode;				// HTTP status code
	const prog_char *type;			// content type

	// data
	httpd_data_mode_t data_mode;	// data source type
	uint32_t cursor;				// data cursor
	uint32_t numbytes;				// data length
	httpd_data_t data;				// data

	// saved state
#ifdef WITH_TCP_REXMIT
	uint8_t statuscode_saved;		// status code
	uint32_t numbytes_saved;		// content length
	uint32_t cursor_saved;			// data cursor
#endif
} httpd_state_t;
