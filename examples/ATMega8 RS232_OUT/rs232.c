#include <mega8.h> 
//#include <1wire.h> 
#include <stdio.h> 
// Declare your global variables here 
void main(void) 
{ 

//PORTB=0x00; 
//DDRB=0x00; 

//PORTC=0x00; 
//DDRC=0x7F; 

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

while(1)
{
printf("Hello World");
} 
}