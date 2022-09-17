#include <mega8.h>
#include <stdio.h>

void main(void)
{

char massiv[5]={'h','e','l','l','o'};
bit on=0; 
int i=0;  

PORTC=0x01;
DDRC=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;


while (1)
      {
       if(PINC.0==0 && on==0)
       {
         UDR=massiv[i];
         i++;
         if(i>4)
         {
         i=0;
         }
         on=1;
       } 
       if(PINC.0!=0)
       {
       on=0;
       }
       
      };
}
