#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
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
