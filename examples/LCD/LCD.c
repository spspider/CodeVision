#include <mega8.h> //Включаем библиотеку для работы с микроконтроллером ATMega8 

#asm 

   .equ __lcd_port=0x18 ;PORTB 

#endasm  // Инициализируем PORTB как порт ЖКИ 

#include <lcd.h> //Включаем библиотеку для работы с ЖКИ 
#include <delay.h>
void main(void) 

{ 

char *_str="Hello! Alina!"; //Создаем выводимую строку 
char *_str1="";


PORTD=0x00;  
DDRD=0xff;
PORTD.0=1;

lcd_init(16); // Инициализация ЖКИ на 16 символов 

lcd_gotoxy(0, 0); // Переводим курсор на первый символ первой строки 
//delay_ms(500)

while (1) 

      { 
lcd_puts(_str);   // Выводим строку _str на дисплей ЖКИ 
delay_ms(50);
lcd_clear();
delay_ms(50);
      }; 

}