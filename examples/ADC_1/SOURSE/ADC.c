#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>



#define ADC_VREF_TYPE 0x00
//#define ADC_VREF_TYPE 0x20

unsigned int adc0,Timer1,Timer2;
unsigned char Timer_2,Timer_3,sig1,U2;
char data;
bit a, U1;

#include <INT.c>
#include <USART_Rx.c>


unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(20);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
/*

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(50);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}
*/
void main(void)
{

//PORTB=0xFF;         //вкл. подт€гивающие резисторы 
//DDRB=0xFF;           // весь порт как вход
//PORTD=0xFF;

DDRD=0xFF;
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

//////////////////////////////
/*
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 110
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x02;
UBRRL=0x37;
*/
///////////////////////////////////////

TCCR0=0x01;
TIMSK=0x01;
ACSR=0x80;
ADMUX=ADC_VREF_TYPE & 0xff;

ADCSRA=0x87;
#asm("sei")


while (1)
{
if (a==1){
adc0=read_adc(2);
printf("%d#",adc0);
//prin=getchar();
if (data != 0){
printf("%d#",data);
}
a=0;
//delay_ms(500);
//PORTD^=0b00000100;
}
}
}