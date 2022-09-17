#include <mega8.h>
#include <stdio.h>
#include <delay.h>

//#include <bcd.h>
#asm 
.equ __lcd_port=0x18; PORTB 
#endasm  // Инициализируем PORTB как порт ЖКИ 
#include <lcd.h> //Включаем библиотеку для работы с ЖКИ
#include <stdlib.h> 
unsigned char port,Timer_1=0,Timer_2,Timer_4;
unsigned int Timer_3,adc[6];
unsigned char U1,U3,U2[7];
int sig1[1];
unsigned char _adc0[4],_adc1[4],*_str3="Temp=",*_str4="V=";

#include <PWM.c>
#include <IR.c> 
#include <ADC1.c>

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
PWM2();
IR();
ADC_();
}

void main(void)
{


DDRB=0xFF;
//DDRC=0xFF;
DDRD=0b00011000;
//DDRD=0xFF;

TCCR0|=0x01;
TIMSK|=0x01;// TIM0


UCSRA|=0x00;
UCSRB|=0x18;
UCSRC|=0x86;
UBRRH|=0x00;
UBRRL|=0x33;


ACSR|=0x80;
//ADMUX=ADC_VREF_TYPE & 0xff;
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0b11001001;//!!!!!!!!!!!!
//SFIOR&=0xEF;

lcd_init(16);

 
#asm("sei")
while (1)
{
if (Timer_4==1){ADCSRA|=0x40;Timer_4=0;}
//if (Timer_4==2{ADCSRA&=~0x40;Timer_4=0;}

//;
//if ((PIND.2==0)&&(d1==0)){}
}
}