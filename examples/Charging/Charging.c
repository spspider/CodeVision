#include <mega8.h>

// Standard Input/Output functions
#include <stdio.h>
//unsigned int adc1[2],Timer6;
unsigned char Timer1,Timer4,c1,Timer2,Timer3,bat,Timer5,a1,Timer7,aStop,Timer8;
unsigned char adc1[2],Timer6;                             
// Timer 0 overflow interrupt service routine
#include <INT.c>

#include <delay.h>

// Read the AD conversion result
#include <ADC.c>

// Declare your global variables here

void main(void)
{

PORTB=0b00000000;
DDRB=0b01000011;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0b10101100;

TCCR0=0x01;
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
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      if (c1==1){c1=0;adc1[bat] = read_adc(bat);} //�������� ������ ������
      
  
      };
}
