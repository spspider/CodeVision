
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;   
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;   
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

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

interrupt [7] void timer0_ovf_isr(void)
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

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned char len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned char size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned char size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

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
