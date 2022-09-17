#pragma once

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdlib.h>
#include <string.h>
#include "ds1820.h"
#include "counter.h"

#define CGI_NOT_FOUND		0xffff
#define CGI_USE_CALLBACK	0xfffe

void cgi_init_all();
void cgi_poll_all();

typedef uint16_t (*cgi_callback_t)(uint8_t id, char *buf);

uint16_t cgi_exec(uint8_t id, char *url, char *buf, cgi_callback_t *cb);
