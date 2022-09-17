/*
HiSRE (c)2012 08
*/
#include "_clock.h"

void *PClock;
bit ClockUpdate;
bit ClockDate;

#define CLOCK_1 ((tClock1*)PClock)
#define CLOCK_2 ((tClock2*)PClock)

void _rstdayincmonth() {
CLOCK_2->Day=1;
CLOCK_2->Month++;
}

interrupt [TIM2_OVF] void tmr2_ovf() {
CLOCK_1->Second++;
if (CLOCK_1->Second>59) {
CLOCK_1->Second=0;
CLOCK_1->Minute++;
if (CLOCK_1->Minute>59) {
CLOCK_1->Minute=0;
CLOCK_1->Hour++;
if (CLOCK_1->Hour>23) {
CLOCK_1->Hour=0;
if (ClockDate!=0) {
CLOCK_2->DayWeek++;
if (CLOCK_2->DayWeek>6) CLOCK_2->DayWeek=0;
CLOCK_2->Day++;
switch (CLOCK_2->Month) {
case 1:
case 3:
case 5:
case 7:
case 8:
case 10:
case 12:
if (CLOCK_2->Day>31) _rstdayincmonth();
break;
case 2:
if ((CLOCK_2->Year&3)==0) {
if (CLOCK_2->Day>29) _rstdayincmonth();
}else{
if (CLOCK_2->Day>28) _rstdayincmonth();
}
break;
case 4:
case 6:
case 9:
case 11:
if (CLOCK_2->Day>30) _rstdayincmonth();
break;
}
if (CLOCK_2->Month>12) {
CLOCK_2->Month=1;
CLOCK_2->Year++;
}
}
}
}
}
ClockUpdate=1;
}

byte clock_update() {
if (ClockUpdate==0) {
return 0;
}else{
ClockUpdate=0;
return 1;
}
}

void clock_ctr(byte ctr) {
if (ctr==CLOCK_CTR_START) {
TIMSK&=~0xc0;
ASSR=8;
TCNT2=0;
OCR2=0;
TCCR2=5;
while ((ASSR&7)!=0);
TIFR&=~0xc0;
TIMSK|=0x40;
}else{
TIMSK&=~0x40;
TCCR2=0;
ASSR=0;
}
}

void clock_init(void *Pointer,byte pt) {
if (pt==0) ClockDate=0; else ClockDate=1;
PClock=Pointer;
#ifdef CLOCK_DEFAULT_START
clock_ctr(CLOCK_CTR_START);
#endif
}
