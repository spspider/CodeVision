/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 29.07.2011
Author  : 
Company : 
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 8,000000 MHz
Memory model        : Tiny
External RAM size   : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>

#define dht_dpin 3
char bGlobalErr;    
char dht_dat[5];    
char dht_in;
flash char znak[]={63,6,91,79,102,109,125,7,127,111,0,99,57,118};
char cyf=1;
char out[]={0,0,0,0};
char des=0, ed=0;
char fase=0;

void InitDHT(void);
void ReadDHT(void);
char read_dht_dat();
char hex2dec(char);

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
    {
        cyf=cyf*2;
        if (cyf==16) cyf=1;
        if (fase==0){
        switch (cyf)
        {
            case 1: PORTB=~znak[12]; PORTD.0=1; PORTD.3=0; break;
            case 2: PORTB=~znak[11]; PORTD.1=1; PORTD.0=0; break;
            case 4: PORTB=~znak[out[2]]; PORTD.2=1; PORTD.1=0; break;
            case 8: PORTB=~znak[out[3]]; PORTD.3=1; PORTD.2=0; break;
        }
        }
        else
        {
            switch (cyf)
        {
            case 1: PORTB=~znak[out[0]]; PORTD.0=1; PORTD.3=0; break;
            case 2: PORTB=~znak[out[1]]; PORTD.1=1; PORTD.0=0; break;
            case 4: PORTB=~znak[10]; PORTD.2=1; PORTD.1=0; break;
            case 8: PORTB=~znak[13]; PORTD.3=1; PORTD.2=0; break;
        }
        }        
    }

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

PORTB=0x80;
DDRB=0x7F;

PORTD=0x7F;
DDRD=0x0F;

UCSRA=0x00;
UCSRB=0x00;
UCSRC=0x00;
UBRRH=0x00;
UBRRL=0x00;

TCCR0A=0x00;
TCCR0B=0x03;
TCNT0=0x00;
TIMSK=0x02;

#asm("sei")

InitDHT();
delay_ms(1000);

while (1)
    {
        #asm("cli")
        PORTB=0xFF;
        fase=1-fase;
        ReadDHT();
        #asm("sei")
        if (bGlobalErr==0)
            {  
                hex2dec(dht_dat[2]);
                out[3]=des;
                out[2]=ed;
                hex2dec(dht_dat[0]);
                out[1]=des;
                out[0]=ed;
            }
        else
            {
                out[0]=10;
                out[1]=10;
                out[2]=10;
                out[3]=10;
            }    
        delay_ms(3000);          
    };
}

void InitDHT(void)
    {
        DDRD.6=1;
        PORTD.6=1;
    }

void ReadDHT(void)
    {
        char dht_check_sum;
        char i = 0;
        bGlobalErr=0;
        PORTD.6=0;
        delay_ms(23);
        PORTD.6=1;
        delay_us(40);
        DDRD.6=0;
        delay_us(40);

        dht_in=PIND.6;

        if(dht_in)
            {
                bGlobalErr=1;
                return;
            }
        delay_us(80);

        dht_in=PIND.6;

        if(!dht_in)
            {
                bGlobalErr=2;
                return;
            }

        delay_us(80);
        for (i=0; i<5; i++)
            dht_dat[i] = read_dht_dat();
        DDRD.6=1;
        PORTD.6=1;
        dht_check_sum = dht_dat[0]+dht_dat[1]+dht_dat[2]+dht_dat[3];
        if(dht_dat[4]!= dht_check_sum)
            {bGlobalErr=3;} 
    };

char read_dht_dat()
    {
        char i = 0;
        char result=0;
        for(i=0; i< 8; i++)
            {
                while(PIND.6==0);
                delay_us(30);
                if (PIND.6==1) result |=(1<<(7-i));
                while (PIND.6==1);
            }
        return result;
    }
    
char hex2dec(char num)
    {
        char result=0;
        char hex=num;
        des=0;
        ed=0;
        while (hex>9) 
            {
                hex=hex-10;
                des=des+1;
            }
        ed=hex;
        result=((des<<4)|ed);
        return result;        
    }    