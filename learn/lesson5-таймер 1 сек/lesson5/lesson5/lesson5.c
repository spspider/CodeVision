#include <mega8.h>

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
int s = 0;

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
   s++;
   if(s>59)
   {
      s=0;
   }
   
  TCNT1H=0;
  TCNT1L=0;
}

void main(void)
{

TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x1E;
OCR1AL=0x85;

TIMSK=0x10; 

lcd_init(8);

#asm("sei")

while (1)
      {
       lcd_gotoxy(0,0);  
        lcd_putchar(s/10+0x30);
        lcd_putchar(s%10+0x30);
      };
}
