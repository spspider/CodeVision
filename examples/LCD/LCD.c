#include <mega8.h> //�������� ���������� ��� ������ � ����������������� ATMega8 

#asm 

   .equ __lcd_port=0x18 ;PORTB 

#endasm  // �������������� PORTB ��� ���� ��� 

#include <lcd.h> //�������� ���������� ��� ������ � ��� 
#include <delay.h>
void main(void) 

{ 

char *_str="Hello! Alina!"; //������� ��������� ������ 
char *_str1="";


PORTD=0x00;  
DDRD=0xff;
PORTD.0=1;

lcd_init(16); // ������������� ��� �� 16 �������� 

lcd_gotoxy(0, 0); // ��������� ������ �� ������ ������ ������ ������ 
//delay_ms(500)

while (1) 

      { 
lcd_puts(_str);   // ������� ������ _str �� ������� ��� 
delay_ms(50);
lcd_clear();
delay_ms(50);
      }; 

}