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
#include <math.h>
//��������� ����������
unsigned long int M, M0, M1;                     
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
TIMSK&=0b11011111;                                  // ������ ���������� �� �������
} 


/********************** �������� ��������� ******************************/

void main(void)
{

UCSRA=0x00; 
UCSRB=0b11000; 
UCSRC=0b10000110; 
UBRRH=0x00; 
UBRRL=0x19;

PORTC=0x00;
DDRC=0x00011111;
PORTB=0x00;
DDRB=0b00111110;
PORTD=0x00;
DDRD=0b11101111;
  
/************ ������������� ��������-��������� *************************/

//������������� Timer/Counter 0
TCCR0=0b00000111; //������ �������, �������� �������
TCNT0=0x00;//�� ���� ����

//������������� Timer/Counter 1
TCCR1A=0x00;
TCCR1B=0b01000001;
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
TCNT0 = TCNT1 = 0;
#asm("sei")                                   // ���������� ����������
TIMSK|=0b100000;                                  // ��������� ������
while ((TIMSK&0x20)==0x20){}                  // �������� ���������� �� �������
M0=(((unsigned long int)(OVF_T0))<<16)+Mx;     // ������ ������ ���������� ����� ������� �������
delay_ms(200);                               // �������� 
TIMSK|=0x20;                                  // ��������� ������
while ((TIMSK&0x20)==0x20){}                  // �������� ���������� �� �������
M=(((unsigned long int)(OVF_T0))<<16)+Mx;      // ������ ������ ���������� ����� ������� �������
M1=M-M0;                                       // ������ ���������� ����� ������� ������� �� ����� ���������

printf("M %d\n\r ",M1);
//printf("M %d\n\r ",Mx);


 } // ����� ������������ �����

}