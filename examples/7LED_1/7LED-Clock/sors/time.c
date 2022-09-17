#include <mega8.h>
#include <delay.h>        // ���������� ���������� ��������

 unsigned char sek;        // ���������� ���.
 unsigned char min;        // ���������� ���.
 unsigned char hour;       // ���������� �����
 unsigned char Dig[10];
 char Disp6, Disp7;

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)  // ������ ��������� �� ������� 1 ��
{
// Place your code here
       TCNT1H=0;
       TCNT1L=0;
       sek++;                // �������������� ������� 
       PORTD=128;
       PORTB=253;         // ������� �����
       
      // �������� � ��������
  if (PINC.0==0) // ���� ������ ������ ������
  {
  hour++; // � �������� ���� ��������� �������  
  }
  if (PINC.1==0) // ���� ������ ������ ������
  {
  hour--; // � �������� ���� �������� ������� �
  }
  if (PINC.2==0) // ���� ������ ������ ������
  {
  min++; // � �������� ������ ��������� �������  
  }
  if (PINC.3==0) // ���� ������ ��������� ������
  {
  min--; // � �������� ������ �������� ������� 
  }  
  if (PINC.4==0) // ������ RESET
  {
  sek=0;  
  }  


}

// Declare your global variables here

void Display (unsigned int Number) //�-��� ��� ���������� ����������� �����
{
  unsigned char Num2, Num3;
  Num2=0;
  while (Number >= 10)   //����������
  {
    Number -= 10;  
    Num2++; 
  }
  Num3 = Number;    //�������
  Disp6 = Dig[Num2];
  Disp7 = Dig[Num3];   
} 
void Dig_init() //������ ��� ����������� ���� �� �������������� ����������
{
  Dig[0] = 95;   // ������ � ��� ����� � ����� �������
  Dig[1] = 24;
  Dig[2] = 109;
  Dig[3] = 124;
  Dig[4] = 58;
  Dig[5] = 118;
  Dig[6] = 119;
  Dig[7] = 28;
  Dig[8] = 127;
  Dig[9] = 126;
}

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
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0xFF;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFF;

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


// Global enable interrupts
#asm("sei")
Dig_init(); //������������� ������� � �������� �����
while (1)
      {///// ������� �����.
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
         // ������ ������������ ����������, ��� ����� ��� ���� ����� � �������� ����� ����� �� ���������� � �����.
  if (hour==255)
  hour=0;
  if (min==255)
  min=0;  
         // ������� ���������� (�������������)
        Display(hour); //��������� "����" �� 2 ����� � ���������� �� �������
         PORTB=254;    //���� ��� 0 ��� ������ 1 �������
         PORTD=Disp6;  //1 �����     
        delay_ms(5);
         PORTB=253;    //���� ��� 0 ��� ������ 2 �������
        PORTD=Disp7;   //2 �����     
        delay_ms(5);
         Display(min);  //��������� "������" �� 2 ����� � ���������� �� �������
        PORTB=251;      //���� ��� 0 ��� ������ 3 �������
        PORTD=Disp6;  //3 �����      
        delay_ms(5);
         PORTB=247;    //���� ��� 0 ��� ������ 4 �������
        PORTD=Disp7;   //4...     
        delay_ms(5);
      };
}