#include <mega8.h>
#include <delay.h>        // ���������� ���������� ��������
#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 0
unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x20
//////////////////////////////////////////////////
interrupt [ADC_INT] void adc_isr(void)                      //����������� ���������� �� ADC �� CVAVR
{
static unsigned char input_index=0;
// Read the 8 most significant bits
// of the AD conversion result
adc_data[input_index]=ADCH;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}

//////////////////////////////////////////////////
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
//TCCR0=0x00;
//TCNT0=0x00;
//TCCR1A=0x00;
//TCCR1B=0x05;
//TCNT1H=0x00;
//TCNT1L=0x00;
//ICR1H=0x00;
//ICR1L=0x00;
//OCR1AH=0x1E;
//OCR1AL=0x85;
//OCR1BH=0x00;
//OCR1BL=0x00;
//ASSR=0x00;
//TCCR2=0x00;
//TCNT2=0x00;
//OCR2=0x00;
//MCUCR=0x00;
//TIMSK=0x10;         
//ACSR=0x80;
//SFIOR=0x00;


ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCC;
#asm("sei")
Dig_init(); //������������� ������� � �������� �����
while (1)
      {
 if (PINC.2==0) // ���� ������ ������ ������
  {        
  hour++ ; // � �������� ���� ��������� �������  
  }
  if (PINC.3==0) // ���� ������ ������ ������
  {
  hour--; // � �������� ���� �������� ������� �
  }      
    
min = adc_data[0] - adc_data[0]/16.6666;
hour = adc_data[0]/16.6666;

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
