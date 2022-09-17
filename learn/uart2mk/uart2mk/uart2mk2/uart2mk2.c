#include <mega8.h>

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>  

char lcd_buffer[32];
char uart_data[16];
int i=0,j=0;
unsigned char lcd_can_clear=0,status_usart;

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
PORTD^=0b00001000;
//lcd_can_clear++;

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
}
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   }; 
  uart_data[i]=data;
  status_usart=UCSRA;
  i++;
  if(UCSRA==48)
  {
  i=0;
  }
  
  
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void main(void)
{


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 1786
UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x86;
UBRRH=0x01;
UBRRL=0x17;

DDRD=0b00001000;

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

TIMSK=0x10;
ACSR=0x80;
SFIOR=0x00;
// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {
      if (lcd_can_clear>3){

        j=0;
            while(j<12){
            uart_data[j]=0;
            j++;
            }
        lcd_clear();
        lcd_can_clear=0;
        lcd_gotoxy(0,0);
            j=0;
      } 
      while(j<12)
      {                  
      lcd_gotoxy(j,0);
      sprintf(lcd_buffer,"%c",uart_data[j]);
      //sprintf(lcd_buffer,"%d",status_usart);
      
      lcd_puts(lcd_buffer);
      j++;
      }
      j=0;
      //lcd_clear();
      };
}
