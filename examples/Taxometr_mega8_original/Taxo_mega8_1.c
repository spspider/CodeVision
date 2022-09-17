/*****************************************************
Project : 
Version : 
Date    : 25.07.2009
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>   //�����������
#include <stdio.h>   //           ������ 
#include <delay.h>   //                  ���������


#define   ON_LED1      (PORTB = 0b00000010)
#define   ON_LED2      (PORTB = 0b00000110)
#define   ON_LED3      (PORTB = 0b00001110)
#define   ON_LED4      (PORTB = 0b00011110)
#define   ON_LED5      (PORTB = 0b00111110)
//#define   ON_LED6      (PORTB = 0b01111110)
//#define   ON_LED7      (PORTB = 0b11111110)

#define   ON_LED6      (PORTB = 0b00111110) | (PORTC = 0b00000001) 
#define   ON_LED7      (PORTB = 0b00111110) | (PORTC = 0b00000011)
#define   ON_LED8      (PORTB = 0b00111110) | (PORTC = 0b00000111)
#define   ON_LED9      (PORTB = 0b00111110) | (PORTC = 0b00001111) 
#define   ON_LED10     (PORTB = 0b00111110) | (PORTC = 0b00011111)

#define   ON_LED11     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000001)
#define   ON_LED12     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000011)
#define   ON_LED13     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000111)
#define   ON_LED14     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00001111)
#define   ON_LED15     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00101111)
#define   ON_LED16     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b01101111)
#define   ON_LED17     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b11101111)

#define   OFF_LEDS     (PORTB = 0) | (PORTC = 0) | (PORTD = 0)

/***** ���������� ������ ����� ������ ****************************
 ---------------------------------------------------------------------------------------------------
  PORTB  
    PB0 (14) - �������� ���� ������� ICP ���������� �������
    PB1 (15) - �������� ����� �� ���������
    PB2 (16) - �������� �����
    PB3 (17) - �������� �����
    PB4 (18) - �������� �����
    PB5 (19) - �������� �����
    PB6 (9)  - ��� ������
    PB7 (10) - ��� ������
  PORTC
    PC0 (23) - �������� ����� 
    PC1 (24) - �������� �����
    PC2 (25) - �������� �����
    PC3 (26) - �������� �����        
    PC4 (27) - �������� ����� 
    PC5 (28) - �������� ����  ��������� ����������
    PC6 (1)  - 
  PORTD
    PD0 (2 ) - �������� ����� 
    PD1 (3 ) - �������� ����� 
    PD2 (4 ) - �������� ����� 
    PD3 (5 ) - �������� ����� 
    PD4 (6 ) - �������� ���� ���������� �������
    PD5 (11) - �������� �����  
    PD6 (12) - �������� �����  
    PD7 (13) - �������� ����� 
*************************************************************************/

//��������� ����������
float Fx;

unsigned long int N0, M0;                     

unsigned long int N, M;                       // ���������� ��������� �� ����� ���������

unsigned int OVF_T0=0, OVF_T1=0;

unsigned int Ntakt, Mx;                       // ���������� ����� �������� � ���������� �������

//���������� �� ������������ Timer/Counter 0
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
OVF_T0++;                                     
}

//���������� �� ������������ Timer/Counter 1
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
OVF_T1++;                                     
}

//���������� �� ������� Timer/Counter 1
interrupt [TIM1_CAPT] void timer1_capt_isr(void)
{
Mx=TCNT0;                                     // �������� �������� TCNT0 �������������� � ����������

Ntakt=ICR1;                                   // �������� �������� ICR1 �������������� � ����������
  
TIMSK&=0xDF;                                  // ������ ���������� �� �������
  } 


/********************** �������� ��������� ******************************/

void main(void)
{

/************ ������������� ������ �����-������� ***********************/
// ������������� ����� C
// ������, ����� PC5
PORTC=0x00;
DDRC=0x00011111;

// ������������� ����� B
// ������, ����� PB0, PB6, PB7
PORTB=0x00;
DDRB=0b00111110;

// ������������� ����� D
// ������, ����� PD4
PORTD=0x00;
DDRD=0b11101111;
  
/************ ������������� ��������-��������� *************************/

//������������� Timer/Counter 0
TCCR0=0x07;
TCNT0=0x00;

//������������� Timer/Counter 1
TCCR1A=0x00;
TCCR1B=0x41;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// ������������� ���������� ��������/���������
TIMSK=0x05;

/****************** ����������� ���� **********************************/
while (1)                                     
{
#asm("cli")

OVF_T1 = 0;                                   

OVF_T0 = 0;                                 

Fx = 0;

TCNT0 = TCNT1 = 0;

#asm("sei")                                   // ���������� ����������

TIMSK|=0x20;                                  // ��������� ������

while ((TIMSK&0x20)==0x20){}                  // �������� ���������� �� �������

N0=(((unsigned long int)(OVF_T1))<<16)+Ntakt; // ������ ������ ���������� ����� ��������� �������

M0=(((unsigned long int)(OVF_T0))<<8)+Mx;     // ������ ������ ���������� ����� ������� �������

delay_ms(500);                               // �������� 

TIMSK|=0x20;                                  // ��������� ������

while ((TIMSK&0x20)==0x20){}                  // �������� ���������� �� �������

N=(((unsigned long int)(OVF_T1))<<16)+Ntakt;  // ������ ������ ���������� ����� ��������� �������

M=(((unsigned long int)(OVF_T0))<<8)+Mx;      // ������ ������ ���������� ����� ������� �������

N=N-N0;                                       // ������ ���������� ����� ��������� ������� �� ����� ���������

M=M-M0;                                       // ������ ���������� ����� ������� ������� �� ����� ���������

Fx=8000000.0*(float)M/(float)N;               // ���������� ������� �������� �������


if (Fx >= 126.7)                              // 3800 ��/��� 126.66666 ���/�
{
 OFF_LEDS; 
// ON_LED19;
 } 
else
if (Fx >= 120)                                // 3600 ��/��� 120 ���/�
{
 OFF_LEDS; 
// ON_LED18;
 } 
else
if (Fx >= 113.3)                              // 3400 ��/��� 113.33333 ���/�
{
 OFF_LEDS; 
 ON_LED17;
 } 
else
if (Fx >= 106.7)                              // 3200 ��/��� 106.66666 ���/�
{
 OFF_LEDS; 
 ON_LED16;
 } 
else
if (Fx >= 100)                                // 3000 ��/��� 100 ���/�
{
 OFF_LEDS; 
 ON_LED15;
 } 
else
if (Fx >= 93.3)                               // 2800 ��/��� 93.33333 ���/�
{
 OFF_LEDS; 
 ON_LED14;
 } 
else
if (Fx >= 86.7)                               // 2600 ��/��� 86.66666 ���/�
{                                             
 OFF_LEDS; 
 ON_LED13;
 } 
else
if (Fx >= 80)                                 // 2400 ��/��� 80 ���/�
{
 OFF_LEDS; 
 ON_LED12;
 } 
else
if (Fx >= 73.3)                               // 2200 ��/��� 73.33333 ���/�
{
 OFF_LEDS; 
 ON_LED11;
 } 
else
if (Fx >= 66.7)                               // 2000 ��/��� 66.66666 ���/�
{
 OFF_LEDS; 
 ON_LED10;
 } 
else
if (Fx >= 60)                                 // 1800 ��/��� 60 ���/�
{
 OFF_LEDS; 
 ON_LED9;
 } 
else
if (Fx >= 53.3)                               // 1600 ��/��� 53.33333 ���/� 
{
 OFF_LEDS; 
 ON_LED8;
 }
else 
if (Fx >= 46.7)                               // 1400 ��/��� 46.66666 ���/� 
{
 OFF_LEDS; 
 ON_LED7;
 }
else  
if (Fx >= 40)                                 // 1200 ��/��� 40 ���/� 
{
 OFF_LEDS; 
 ON_LED6;
 }
else  
if (Fx >= 33.3)                               // 1000 ��/��� 33.33333 ���/� 
{
 OFF_LEDS; 
 ON_LED5;
 } 
else
if (Fx >= 26.7)                               // 800 ��/��� 26.66666 ���/� 
{
 OFF_LEDS; 
 ON_LED4;
 } 
else
if (Fx >= 20)                                 // 600 ��/��� 20 ���/�
{
 OFF_LEDS; 
 ON_LED3;
 } 
else
if (Fx >= 13.3)                               // 400 ��/��� 13.33333 ���/� 
{
 OFF_LEDS; 
 ON_LED2;
 } 
else
if (Fx >= 6.7)                                // 200 ��/��� 6.66666 ���/� 
{
 OFF_LEDS; 
 ON_LED1;
 }
else   
if (Fx < 6.7)
{
 OFF_LEDS; 
 }
 } // ����� ������������ �����

}