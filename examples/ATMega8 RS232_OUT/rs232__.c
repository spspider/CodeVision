#include <mega8.h>
// 1 Wire Bus functions
#asm
   .equ __w1_port=0x18 ;PORTB
   .equ __w1_bit=0
#endasm
#include <1wire.h>
// DS1820 Temperature Sensor functions
#include <ds18b20.h>
// Standard Input/Output functions
#include <stdio.h>
// Declare your global variables here
void main(void)
{
char prin;
int  temp;
unsigned char devices; 

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0x7F;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 19200
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x19;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// 1 Wire Bus initialization
devices=w1_init();
printf("Start Device\n\r");
while (1)
      {  
       prin=getchar();
       switch (prin)
            {
             case 49:
              {
               PORTC=getchar()-48;
               break;
              }          
              case 50:
               {    
                temp=ds18b20_temperature(0);  //читаем температуру  
                if (temp>1000)
                 {               //если датчик выдаёт больше 1000
                  temp=4096-temp;            //отнимаем от данных 4096
                  temp=-temp;                //и ставим знак "минус"
                 }
                 printf("Temp=%d\n\r",temp);
                }

           
      };  
} 
}
