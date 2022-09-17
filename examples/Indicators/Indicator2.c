#include "iom16.h"
#define a 1
#define b 4
#define c 16
#define d 64  //Меняем эти числа для другого индикатора
#define e 128
#define f 2
#define g 8
#define DP 32

short unsigned int i = 1;
short unsigned int Number = 0;
unsigned char      Dig[10];
// В этих переменных хранятся цифры, которые нужно отобразить
char               Disp5, Disp6, Disp7;

// Функция выделяет цифры из трехзначного числа Number
void Display (short unsigned int Number)
{
  unsigned char Num1, Num2, Num3;
  Num1=Num2=0;
  while (Number >= 100)  
  {
    Number -= 100;  
    Num1++;  
  }
  while (Number >= 10) 
  {
    Number -= 10;  
    Num2++; 
  }
  Num3 = Number;
  Disp5 = Dig[Num1];
  Disp6 = Dig[Num2];
  Disp7 = Dig[Num3];
}

void io_init() //Инициализация портов ввода/вывода
{
  DDRA = 0xFF;
  PORTA = 0;
  DDRC |= (1 << PINC5) | (1 << PINC6) |(1 << PINC7);
  PORTC = 0;
}

void timer0_init()
{
  OCR0 = 15;
  TCCR0 |= (1 << WGM01) | (1 << CS00) | (1 << CS02);
  TIMSK |= (1 << OCIE0);
}

void Dig_init()
{
  Dig[0] = (a+b+c+d+e+f);
  Dig[1] = (b+c);
  Dig[2] = (a+b+g+e+d);
  Dig[3] = (a+b+g+c+d);
  Dig[4] = (f+g+b+c);
  Dig[5] = (a+f+g+c+d);
  Dig[6] = (a+f+g+c+d+e);
  Dig[7] = (a+b+c);
  Dig[8] = (a+b+c+d+e+f+g);
  Dig[9] = (a+b+c+d+f+g);
}

void main()
{
  unsigned char j, k = 0;
  Dig_init();
  Display(0);
  io_init();
  timer0_init();
  SREG |= (1 << 7);
  while(1)
  {
    for (j = 0; j <= 50; j++){} // Задержка для отображения цифры
    (k == 3) ? k = 0 : k++;
    PORTC &= 31;  //Очистка PC7, PC6, PC5
    for (j = 0; j<=30; j++){} // Задержка для выключения транзистора
    switch (k)
    {
      case 0: PORTC |= (1 << PINC7); // Единицы
              PORTA = Disp7;
        break;
      case 1: PORTC |= (1 << PINC6); // Десятки
              PORTA = Disp6;
        break;
      case 2: PORTC |= (1 << PINC5); // Сотни
              PORTA = Disp5;
    }
  }
}

#pragma vector = TIMER0_COMP_vect
__interrupt void Indic_change()
{
  if (i < 675)
  {
    i++;
  }
  else
  {
    i = 1;
    if (Number < 999)
      Number++;
    else
      Number = 0;
      PORTB++;
    Display(Number); // Увеличение отображаемого числа.
  }
}
