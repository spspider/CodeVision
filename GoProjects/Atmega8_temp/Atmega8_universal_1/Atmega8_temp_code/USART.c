// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
char lcd_buffer[32];
char uart_data[16];
int i=0,j=0;
unsigned int databits=0;
unsigned char lcd_can_clear=0,status_usart,now_set;

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

void clear_usart(){
while(i<13)
    {
    uart_data[i]=0;
    i++;
    }
    i=0;
}
// USART Receiver interrupt service routine
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
   now_set=0;
   }; 
  uart_data[i]=data;
  status_usart=UCSRA;
  i++;
  if(UCSRA==48)                  
  {
  //clear_uart();
  i=0;
  //data_recived=0;
  PORTD&=~0b00001000;
  }
 /////////////////////////////////////////////// 
if ((status_usart==48)&&(now_set==0)){
      uart_data[10]=uart_data[2] ^ uart_data[3];
      uart_data[11]=uart_data[4] ^ uart_data[5] ;
      uart_data[12]=uart_data[6] ^ uart_data[7];
      uart_data[13]=uart_data[12] ^ uart_data[11];
      databits=uart_data[13];
      databits<<=8;
      databits|=uart_data[11];

   //if {   
        if (databits==43648){
        STemp+=0.1;
        }
        if (databits==8352){
        STemp-=0.1;
        }
        EEPromIn=1;
        //clear_usart();
        //STempEE=STemp*100.00;
        now_set=1;
       
      }
   // }      

      //////////////////////////////////  
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