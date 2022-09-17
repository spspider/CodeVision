#include <mega8.h>
#include <delay.h>
//#include <stdio.h>
#include <stdlib.h>

unsigned char sec,mins,hour,hour_a1,mins_a1,sec_a1,hour_a2,mins_a2,sec_a2;
//eeprom unsigned long int Push1=-19095,Push2=-19098;
int d=0,d1=0,d2=0,d3=0;
//unsigned char Timer1,bit1,bit0,bit01,bit10,shiftd,Check_1,adress2=5,adress3=9,adress4=11,adress5=15,adress6=17,adress7=26,FreqT=29;//частота приема ИК
unsigned char Timer1,bit1,bit0,bit01,bit10,shiftd,Check_1,adress2=10,adress3=15,adress4=16,adress5=20,adress6=21,adress7=26,FreqT=31;//частота приема ИК

unsigned char U1=0,U2[8][4],sig1[8][4],U3=0; // для PWM
int Timer_3,Timer_6,Timer_9,Number[3],Timefreq=5000;//частота времени
unsigned char U4,bitEr1,bitEr0,Timer_1,Timer_2,Timer_4,Timer_7,Timer_8,TD=0,n,n1[255],n2,n3,IR_Tr=0;
unsigned char PWM_Susp=0,Clock_Susp=0,U5,U6=0,U7=0,U8=0,U9=5,Bee,n2,Dig1,Dig2,Num2[3],l_up=25,l_dwn=0,dig_a,dig_b,dig_c;
char adc1=0;
bit U10=0,IR_1=0,IR_2=0,IR_S=0,L_ON;  
#include <LED-Driver.c>
#include <Time.c>
#include <ADC.c>
#include <IR.c>
#include <Beep.c>
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
IR();
if (IR_1==0){
Dig();
Time1();
Beep();
}
}
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{


}

// Declare your global variables here
void main(void)   // в этом проэкте  PB - "+", PD 7,6,5 - "-", PC0 - IR, PC1 - Temp;PD2,3 -EL;
{

PORTB=0x00;
DDRB=0xff;
PORTC=0b00000000;
DDRC=0b11111100;
PORTD=0b00000000;
DDRD=0b11111100;
TCCR0=0x01;

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;
*/

TIMSK|=0x01; //Timer0
//TIMSK|=0x40; //Timer2
//TIMSK|=0x04; //Timer1


ACSR=0x80;
ADMUX=0b00000001;
ADCSRA=0x84;

#asm("sei")

while (1)
{

#include <While.c>

}
}
