#include <mega8.h>
#include <delay.h>        // ���������� ���������� ��������

// unsigned char sek;        // ���������� ���.
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
//       sek++;                // �������������� ������� 
//       PORTD=128;
//       PORTB=253;         // ������� �����
       
      // �������� � ��������
 


}

// Declare your global variables here

void Display (unsigned int Number) //�-��� ��� ���������� ����������� �����
{
  unsigned char Num2, Num3;
  Num2=0, Num3=0;
    while (Number >= 10)
  {
    Number -= 10;  
    Num3++; 
  }
  Num2 = Number;
  Disp6 = Dig[Num3];
  Disp7 = Dig[Num2];
   
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

  

PORTB=0x00;
DDRB=0xFF;
PORTC=0xFF;
DDRC=0x00;
PORTD=0x00;
DDRD=0xFF;
TCCR0=0x00;
TCNT0=0x00;
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
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
MCUCR=0x00;
TIMSK=0x10;
ACSR=0x80;
SFIOR=0x00;

#asm("sei")
Dig_init(); //������������� ������� � �������� �����
while (1)
      {
      
      
 if (PINC.0==0) // ���� ������ ������ ������
  {        
  hour++ ; // � �������� ���� ��������� �������  
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
  }
         // ������ ������������ ����������, ��� ����� ��� ���� ����� � �������� ����� ����� �� ���������� � �����.
  if (hour==99)
  hour=0;
  if (min==99)
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


if(hour>100)
{

}

}
}
