/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 31.08.2013
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
unsigned int t;
 #define out PORTB.0
  #define out2 PORTB.1   
  
// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
 TCNT2=0x05;  //начальное значение таймера
t++;
if(t==0){out=0;out2=1;}
if(t==1){out=1;out2=0;}
if(t==2){out=0;out2=1;t=0;}
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=P State5=P State4=P State3=P State2=P State1=P State0=P 
PORTC=0x7F;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=T 
PORTD=0x00;
DDRD=0x02;

// Timer/Counter 2 initialization
// Clock source: TOSC1 pin
// Clock value: PCK2/128
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x08;
TCCR2=0x05;
TCNT2=0x05;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x40;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      }
}
