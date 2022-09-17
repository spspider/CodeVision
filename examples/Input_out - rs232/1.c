char data1;
#include <mega8.h> 
#include <stdio.h> 
#include <delay.h>
#include <rs232.c> 

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    
//PORTD^=0xFF;
}

void main(void) 
{        
PORTB=0x00;         //���. ������������� ��������� 
DDRB=0xFF;           // ���� ���� ��� ����
PORTC=0x00; //���������� ��� ������ ����� D �� 0, �� ����, ��������� ���� ���� D
DDRC=0xFF;  //������ ���� D, ��� �����, ����� �� ������� ����� ���� ���������� 5�
PORTD=0x00; 
DDRD=0xFF;  

// USART initialization 
// Communication Parameters: 8 Data, 1 Stop, No Parity 
// USART Receiver: On 
// USART Transmitter: On 
// USART Mode: Asynchronous 
// USART Baud rate: 19200 
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

TCCR0=0x02;
TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;


#asm("sei")

while (1) 
{
 if ((data1 == 49)){PORTD|=255;printf("ON\n");data1=0; }
 if ((data1 == 50)) {PORTD|=~255;printf("OFF\n");data1=0; }

/*
prin=getchar(); 
switch (prin) 
{ 
case 49: 
{ 
PORTC.0=1;
break; 
}
case 50: 
{ 
PORTC.0=0;
break; 
}  
*/
};
};