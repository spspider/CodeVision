#include <mega8.h>
#include <stdio.h>
#include <delay.h>
#include <bcd.h>
int x,num1;
int d=0,d1=0,d2=0,d3=0;

interrupt [EXT_INT0] void ext_int0_isr(void)
{
}
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
PORTB^=0b00000001;
//TCNT1H=0;
//TCNT1L=0;
if (x<=15){
//d = d | (1 << PIND.2);
d=d<<1;
if (PIND.2==1) {d|=1;x++;};
if (PIND.2==0) {d&=~1;x++;};}

if (x>15 & x<=30){
d1 = d1 << 1;
if (PIND.2==1) {d1|=1;x++;};
if (PIND.2==0) {d&=~1;x++;};}
if (x>30 & x<=45){
d2 = d2 << 1;
if (PIND.2==1) {d2|=1;x++;};
if (PIND.2==0) {d&=~1;x++;};}            
if (x>45 & x<=60){
d3 = d3 << 1;
if (PIND.2==1) {d3|=1;x++;};
if (PIND.2==0) {d&=~1;x++;};}

if (x>=60)
{
printf(" %d",d);
printf(" %d",d1);
printf(" %d",d2);
printf(" %d",d3);
//putchar('\r');

TCCR1B=0x00;
delay_ms(200);
num1=0;
x=0;
d=d1=d2=d3=0;
}

}
void main(void)
{

PORTB=0x00;
DDRB=0xFF;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x00;
TCNT0=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0xde;//6f
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x10;

ACSR=0x80;
SFIOR=0x00;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

GICR|=0x40;
MCUCR=0x02;
GIFR=0x40;

// Global enable interrupts
#asm("sei")

while (1)
{
if (PIND.2==0 & num1==0)
{
TCCR1B=0x09;
num1=1;
}

}
}