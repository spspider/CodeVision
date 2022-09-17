#include <mega8.h>

// Standard Input/Output functions
#include <stdio.h>
unsigned int adc1;
unsigned char Timer1,c1;
//bit c1;                              
// Timer 0 overflow interrupt service routine
#include <INT.c>

#include <delay.h>

// Read the AD conversion result
#include <ADC.c>

// Declare your global variables here

void main(void)
{

PORTB=0x00;
DDRB=0x00;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0x00;

TCCR0=0x02;
TCNT0=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK|=0x01;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=0b00000001;
ADCSRA=0x83;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      if (c1==1){adc1 = read_adc(0);c1=0;}
      };
}
