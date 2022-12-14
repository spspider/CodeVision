/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 16.07.2010
Author  : 
Company : 
Comments: 


Chip type           : ATmega8L
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

unsigned char adc1,c;
bit S_1=1;
unsigned char Timer_2;
unsigned int Timer_1,DataS[255];
#include <stdlib.h>
#include <stdio.h>
#include <delay.h>
#include <mega8.h>
#include <ADC.c>
#include <Sound_1.c>



// Declare your global variables here



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
sound();
#include <Timer.c>

}

void main(void)
{

PORTB=0x00;
DDRB=0x00;

PORTC=0xFF;
DDRC=0xFF;

PORTD=0x00;
DDRD=0x00;

TCCR0=0x02;
TCNT0=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;


// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AREF pin
ACSR=0x80;
ADCSRA=0x84;

#asm("sei")

while (1)
      {
      
      // Place your code here
      };
}
