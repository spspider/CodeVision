/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 06.02.2010
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

#include <mega8.h>
#include <delay.h>
#include <stdio.h>
eeprom unsigned long int Push1=-19095,Push2=-19098;
unsigned int d=0,d1=0,d2=0,d3=0,adress1=4,adress2=5,adress3=24;
unsigned int PWM1=0,PWM1_V=0,Timer1,Timer2,bit1,bit0,FreqT=10,TOL=2,bit01,bit10,shiftd;
unsigned int U1,U2,Timer_1;
// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
/* if(PWM1==1)  {
  PWM1_V-=1;
  if (PWM1_V==200){PWM1=0;}
  }
 
 if (PWM1==0)  {
  PWM1_V+=1;
  if (PWM1_V==255){PWM1=1;}
  }
*/  

Timer_1++;
if (Timer_1<20){U1=1;U2=0;}
if (Timer_1>=20){U2=1;U1=0;}
if (Timer_1>=255){Timer_1=0;}

if (U1==1){PORTB|=0b00000010;}
if (U2==1){PORTB&=~0b00000010;}



// OCR1AL = PWM1_V;
OCR1AL = 255;

  
  }
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
PWM1++;
// Place your code here
  if ((PWM1=20)&&(PINB.1 == 1)){PORTB|=0b00000001;}
  if (PWM1=25){PORTB&=~0b00000001;}
  if ((PWM1=30)&&(PINB.2 == 1)){PORTB|=0b00000001;}
  if (PWM1=35){PORTB&=~0b00000001;}
  if ((PWM1=40)&&(PINB.3 == 1)){PORTB|=0b00000001;}
  if (PWM1=45){PORTB&=~0b00000001;}
  if ((PWM1=50)&&(PINB.4 == 1)){PORTB|=0b00000001;}
  if (PWM1=55){PORTB&=~0b00000001;}
  if ((PWM1=60)&&(PINB.5 == 1)){PORTB|=0b00000001;}
  if (PWM1=65){PORTB&=~0b00000001;}
  if ((PWM1=70)&&(PINB.6 == 1)){PORTB|=0b00000001;}
  if (PWM1=75){PORTB&=~0b00000001;}
  if ((PWM1=80)&&(PINB.7 == 1)){PORTB|=0b00000001;}
  if (PWM1=85){PORTB&=~0b00000001;}
  if (PWM1==100){PWM1=0;}


/*PORTB^=0b00000001;
  Timer2++;
  if(Timer2==20){Timer2=0;TCCR0&=~0x04;}
*/
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here
//PORTB^=0b00000100;
Timer1++;
if (PINC.0==0) {bit1++;}
if (PINC.0==1) {bit0++;}
if (Timer1==FreqT){
Timer1=0;
if ((bit1>=TOL)&&(bit1>bit0)){// ���� ��� (25) ����� ���� �������������, �� ��������� 1
bit1=bit0=0;
bit01=0;
bit10++;
d=d<<1; //�������� ���������� ��� �����
d|=1;//��������� � ����� ������ ������������� ���
putchar('1');
}
if ((bit0>=TOL)&&(bit0>bit1)){
//���� ��� (25) ����� ���� 0, �� ��������� 0
bit0=bit1=0;
bit01++;
bit10=0;
d=d<<1; //�������� ���������� ��� �����
d&=~1;//��������� � ����� ������ ������� ���
putchar('0');
}
shiftd++;
////////////////////////////
if ((bit01>5)||(bit10>5)){d=d1=d2=d3=shiftd=0;bit10=bit01=0;TCCR2&=~0x01;putchar('n');};//���� ������� 4-� ���� ������ �� ������ ���������������.
if (shiftd==adress1){d1 = d;putchar('_');d = 0;}
if ((shiftd==adress2)){d2 = d;putchar('_');;d = 0;}
//if ((shiftd==adress3)){d3 = d;d = 0;}
if ((shiftd==adress3)){d3 = d;;
printf("#d1=%d#d2=%d#d3=%d#",d1,d2,d3);
//putchar('#');
if (((d3==-19095)||(d3==23188))&&(Timer2==0)){PORTB^=0b00000100;putchar('A');} 
if (((d3==-19098)||(d3==23187))&&(Timer2==0)){PORTB^=0b01000000;putchar('B');} 

d=d1=d2=d3=shiftd=0;
TCCR2&=~0x01;

}
}
}
// Declare your global variables here
void main(void)
{

PORTB=0x00;
DDRB=0xff;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x00;
TCCR0|=0x04; //Timer1 31,250
TCNT0=0x00;

TCCR1B=0x0A;
TCCR1A=0x00;
//TIM1_COMPA
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0;
OCR1AL=0;
OCR1BH=0x00;
OCR1BL=0x00;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

ASSR=0x00;
TCCR2=0x00;

TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x10;
TIMSK|=0x01; //Timer1
TIMSK|=0x40; //Timer2

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
       
  // Place your code here
 if ((PINC.0==0)&&(d1==0))
{
TCCR2|=0x01;
}

   
 };
}
