/*
HiSER (c)2012 08
*/
#ifndef _clock_h_
#define _clock_h_

#include "mega8.h"
#include "_type.h"

#define CLOCK_DEFAULT_START

#define CLOCK_TYPE_CLOCK1 0
#define CLOCK_TYPE_CLOCK2 1

#define CLOCK_CTR_START 0
#define CLOCK_CTR_STOP 1

void clock_init(void *Pointer,byte pt);
void clock_ctr(byte ctr);
byte clock_update();

#pragma library _clock.c
#endif
