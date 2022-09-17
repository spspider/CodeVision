/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 29.09.2015
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
#include <stdio.h>
#include <delay.h>

#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 3
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x00

unsigned char lcd_buffer[16];
unsigned int adc[3];
unsigned int freq,och=155;

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
//#include <lcd_rus.h>
//#include <flex_lcd.c>

unsigned char PWM_width=10,PWM_width_now[6],port,Timer_2,Timer_3;
unsigned char PWM_width_set[6]={0,0,0,0,0,0};//������ ���� �������
unsigned char PWM_wide=10;

unsigned char PWM_step[6]={0,0,0,0};
unsigned char PWM_max_voltage=10;
unsigned char period[6];
unsigned char displace[3]={6,0,0};
unsigned char Width_C4=2,Width_C4_now,PWM_width_c=10;
unsigned char Timer_nan_sec,Timer_sec,Timer_min,cycle;

void Timer_reset(void){   

TCNT1H=0x00 >> 8;
TCNT1L=0x00 & 0xff;
OCR1AH=och >> 8;
OCR1AL=och & 0xff;
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 TCNT0=131;//62.5 ��
 Timer_2++;
 //PORTD.7^=1;
 Timer_nan_sec++;
 if(Timer_nan_sec==62){
 Timer_sec++;
 Timer_nan_sec=0;
 }
 if ((Timer_sec==60)&&(cycle==0)){
 Timer_sec=0;
 cycle=1;
 Width_C4=2;
 }
 if ((Timer_sec==90)&&(cycle==1)){
 Timer_sec=0;
 cycle=0;
  Width_C4=10;
 }

 
  
}
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
 //TCNT0=0x01;
// Reinitialize Timer1 value
//TCNT1H=0xFF64 >> 8;
//TCNT1L=0xFF64 & 0xff;
// Place your code here
//TCNT1H=0xffff >> 8;
//TCNT1L=0xffff & 0xff;
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
TCNT1H=0x00 >> 8;
TCNT1L=0x00 & 0xff;
//PORTD.6^=1;

if (Timer_3==(PWM_wide*2-1)){
PORTD.6^=1;
Timer_3=0;
}
Timer_3++;
PWM_max_voltage=PWM_wide/adc[2];




// Place your code here
//for (port_ph=0;port_ph<6;port_ph++;){
if((PWM_step[0]<=0)&&(period[0]==0)){period[0]=1;}   // 10<=0
if((PWM_step[0]>=PWM_wide)&&(period[0]==1)){period[0]=2;}
if (period[0]==1){PWM_step[0]++;PWM_width_set[0]=PWM_step[0]/(PWM_max_voltage);}
if (period[0]==2){PWM_step[0]--;PWM_width_set[0]=PWM_step[0]/(PWM_max_voltage);}

if((PWM_step[0]<=0)&&(period[0]==2)){period[0]=3;PWM_step[0]=0;}
if (period[0]==3){PWM_step[1]++;PWM_width_set[1]=PWM_step[1]/(PWM_max_voltage);}
if((PWM_step[1]>=PWM_wide)&&(period[0]==3)){period[0]=4;}
if (period[0]==4){PWM_step[1]--;PWM_width_set[1]=PWM_step[1]/(PWM_max_voltage);}
if((PWM_step[1]<=0)&&(period[0]==4)){period[0]=0;PWM_step[1]=0;}

////////////////////////////////////////////////////////////////////

if((PWM_step[2]<=0+displace[0])&&(period[2]==0)){period[2]=1;}   // 10<=0
if((PWM_step[2]>=PWM_wide+displace[0])&&(period[2]==1)){period[2]=2;}
if (period[2]==1){PWM_step[2]++;PWM_width_set[2]=(PWM_step[2]-displace[0])/(PWM_max_voltage);}
if (period[2]==2){PWM_step[2]--;PWM_width_set[2]=(PWM_step[2]-displace[0])/(PWM_max_voltage);}

if((PWM_step[2]<=displace[0])&&(period[2]==2)){period[2]=3;PWM_step[2]=displace[0];}
if (period[2]==3){PWM_step[3]++;PWM_width_set[3]=(PWM_step[3]-displace[0])/(PWM_max_voltage);}
if((PWM_step[3]>=PWM_wide+displace[0])&&(period[2]==3)){period[2]=4;}
if (period[2]==4){PWM_step[3]--;PWM_width_set[3]=(PWM_step[3]-displace[0])/(PWM_max_voltage);}
if((PWM_step[3]<=displace[0])&&(period[2]==4)){period[2]=0;PWM_step[3]=displace[0];}


////////////////////////////////////////////////////////////////////
if((PWM_step[4]<=0+displace[1])&&(period[4]==0)){period[4]=1;}   // 10<=0
if((PWM_step[4]>=PWM_wide+displace[1])&&(period[4]==1)){period[4]=2;}
if (period[4]==1){PWM_step[4]++;PWM_width_set[4]=(PWM_step[4]-displace[1])/(PWM_max_voltage);}
if (period[4]==2){PWM_step[4]--;PWM_width_set[4]=(PWM_step[4]-displace[1])/(PWM_max_voltage);}

if((PWM_step[4]<=displace[1])&&(period[4]==2)){period[4]=3;PWM_step[4]=displace[1];}
if (period[4]==3){PWM_step[5]++;PWM_width_set[5]=(PWM_step[5]-displace[1])/(PWM_max_voltage);}
if((PWM_step[5]>=PWM_wide+displace[1])&&(period[4]==3)){period[4]=4;}
if (period[4]==4){PWM_step[5]--;PWM_width_set[5]=(PWM_step[5]-displace[1])/(PWM_max_voltage);}
if((PWM_step[5]<=displace[1])&&(period[4]==4)){period[4]=0;PWM_step[5]=displace[1];}


////////////////////////////////////////////////////////////////////


}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0xC2;
//������� ����� ������������� ��������

for (port=0;port<6;port++){
if (PWM_width_set[port]<PWM_width_now[port]){PORTD&= ~(1<<port);} //�������� ����, ���� now ������ set
if (PWM_width_set[port]>=PWM_width_now[port]){PORTD|=1<<port;}//���������
if (PWM_width_now[port]>=PWM_width){PWM_width_now[port]=0;}
PWM_width_now[port]++;
}

/////////////////////////

if (Width_C4<Width_C4_now){PORTC&= ~(1<<4);} //�������� ����, ���� now ������ set
if (Width_C4>Width_C4_now){PORTC|=1<<4;}//���������
if (Width_C4_now>PWM_width_c){Width_C4_now=0;}
Width_C4_now++;

/////////////////////////
}

#define ADC_VREF_TYPE 0x40

// ADC interrupt service routine
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x08;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0b00010000;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0b11111111;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,977 kHz
TCCR0=0x05;
TCNT0=131;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=15 >> 8;
OCR1AL=15 & 0xFF;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x02;
TCNT2=0xC2;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x55;
//TIMSK=0x01;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")



while (1)
      {
      // Place your code here
#include <while.c>
      };
}
