#include <mega8.h>
#include <delay.h>        // ���������� ���������� ��������
int f1, g1;
//////////////////////////////////////////////////
interrupt [ADC_INT] void adc_isr(void)                      //����������� ���������� �� ADC �� CVAVR
{
ADMUX=287+1; //287 - ����������� ���������, 1 - ����� �����
delay_us(10); //��� ������������
ADCSRA|=0b1100000;// ��������� ������������ �����������
while ((ADCSRA & 0b1100000)==0);//���� ���� ���� �������
f1 = ADCH;//������� ������ � f1

ADMUX=287+2;
delay_us(10);
ADCSRA|=0b1100000;
g1 = ADCH;
while ((ADCSRA & 0b1100000)==0);
}

//////////////////////////////////////////////////
// unsigned char sek;        // ���������� ���.
 unsigned char min;        // ���������� ���.
 unsigned char hour;       // ���������� �����
 unsigned char Dig[10];
 char Disp6, Disp7;

/*interrupt [EXT_INT0] (void)  // ������ ��������� �� ������� 1 ��
{
       PORTD=128;
       PORTB=253;         // ������� �����
 
 if (PINC.2==0) // ���� ������ ������ ������
  {        
  
  //delay_ms(200);
  }
  else
  {
  g1 = g1/16.6666;
  }
  if (PINC.3==0) // ���� ������ ������ ������
  {
  min--; // � �������� ���� �������� ������� �
  }
}
*/

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
PORTC=0b11011111;
DDRC=0x00;
PORTD=0x00;
DDRD=0xFF;


MCUCR=0x00;
//ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCC;
#asm("sei")

Dig_init(); //������������� ������� � �������� �����


while(1)
{
//g1 = g1/16.6666;
min = g1/16.6666;
hour = f1/12.5;
if (min > 14 | min <11)
{
PORTC=0b11011111;
}
else
{
PORTC=0b11111111;
}
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

}
}
