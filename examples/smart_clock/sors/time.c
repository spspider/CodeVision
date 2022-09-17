/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10.01.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTB
#endasm
#include <lcd.h>
#include <delay.h>        // ���������� ���������� ��������
 
 unsigned int sek;        // ���������� ���.
 unsigned int min;        // ���������� ���.
 unsigned int hour;       // ���������� �����
// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)  // ������ ��������� �� ������� 1 ��
{
// Place your code here
       TCNT1H=0;
       TCNT1L=0;
       sek++;            // �������������� ������� 
       
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
PORTC=0x03;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x1E;
OCR1AL=0x85;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
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

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      { // Place your code here 

      // �������� � ��������
       if (PINC.0==0)         // ���� ������ ������ ������
        {
          delay_ms(250);      // �������� 1/4 ���. (��� ��������) ������
          min++;              // � �������� ������ ��������� ������� 
        }
        if (PINC.1==0)        // ���� ������ ������ ������
        {
          delay_ms(250);      // �������� 1/4 ���. (��� ��������) ������
          hour++;             // � �������� ����� ��������� �������
        }
        ///// ������� �����.
       if(sek==60)          // ���� ��� = 60 
       {
       min++;              // ��������� 1 � ���������� "������" 
       sek=0;              // �������� ���������� "�������"
       }
       if(min==60)         // ���� ��� = 60 
       {
       hour++;             // ��������� 1 � ���������� "���" 
       min=0;              // �������� ���������� "������"
       }
       if (hour==24)        // ��� ��� � ��� ���� ����� 24 ������� ������
       {                    // ��� ���������� 24 �����, ��������� ��� ����������.
       hour=0;
       min=0;
       sek=0;
       }
         // ������� ����������
        lcd_gotoxy(4,0);        // ������� ����������, ���� ������ ������� � ������ ������� ����� ����� ��������� lcd_gotoxy(0,0);  
        lcd_putchar(hour/10+0x30);
        lcd_putchar(hour%10+0x30);
        lcd_putchar(':');
        lcd_putchar(min/10+0x30);
        lcd_putchar(min%10+0x30);
        lcd_putchar(':');
        lcd_putchar(sek/10+0x30);
        lcd_putchar(sek%10+0x30);

      };
}
