
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
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
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

float Fx;

unsigned long int N0, M0;                     

unsigned long int N, M;                       

unsigned int OVF_T0=0, OVF_T1=0;

unsigned int Ntakt, Mx;                       

interrupt [10] void timer0_ovf_isr(void)
{
OVF_T0++;                                     
}

interrupt [9] void timer1_ovf_isr(void)
{
OVF_T1++;                                     
}

interrupt [6] void timer1_capt_isr(void)
{
Mx=TCNT0;                                     

Ntakt=ICR1;                                   

TIMSK&=0xDF;                                  
} 

void main(void)
{

PORTC=0x00;
DDRC=0x00011111;

PORTB=0x00;
DDRB=0b00111110;

PORTD=0x00;
DDRD=0b11101111;

TCCR0=0x07;
TCNT0=0x00;

TCCR1A=0x00;
TCCR1B=0x41;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

TIMSK=0x05;

while (1)                                     
{
#asm("cli")

OVF_T1 = 0;                                   

OVF_T0 = 0;                                 

Fx = 0;

TCNT0 = TCNT1 = 0;

#asm("sei")                                   

TIMSK|=0x20;                                  

while ((TIMSK&0x20)==0x20){}                  

N0=(((unsigned long int)(OVF_T1))<<16)+Ntakt; 

M0=(((unsigned long int)(OVF_T0))<<8)+Mx;     

delay_ms(500);                               

TIMSK|=0x20;                                  

while ((TIMSK&0x20)==0x20){}                  

N=(((unsigned long int)(OVF_T1))<<16)+Ntakt;  

M=(((unsigned long int)(OVF_T0))<<8)+Mx;      

N=N-N0;                                       

M=M-M0;                                       

Fx=8000000.0*(float)M/(float)N;               

if (Fx >= 126.7)                              
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 

} 
else
if (Fx >= 120)                                
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 

} 
else
if (Fx >= 113.3)                              
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b11101111);
} 
else
if (Fx >= 106.7)                              
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b01101111);
} 
else
if (Fx >= 100)                                
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00101111);
} 
else
if (Fx >= 93.3)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00001111);
} 
else
if (Fx >= 86.7)                               
{                                             
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000111);
} 
else
if (Fx >= 80)                                 
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000011);
} 
else
if (Fx >= 73.3)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000001);
} 
else
if (Fx >= 66.7)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00011111);
} 
else
if (Fx >= 60)                                 
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00001111) ;
} 
else
if (Fx >= 53.3)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00000111);
}
else 
if (Fx >= 46.7)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00000011);
}
else  
if (Fx >= 40)                                 
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110) | (PORTC = 0b00000001) ;
}
else  
if (Fx >= 33.3)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00111110);
} 
else
if (Fx >= 26.7)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00011110);
} 
else
if (Fx >= 20)                                 
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00001110);
} 
else
if (Fx >= 13.3)                               
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00000110);
} 
else
if (Fx >= 6.7)                                
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
(PORTB = 0b00000010);
}
else   
if (Fx < 6.7)
{
(PORTB = 0) | (PORTC = 0) | (PORTD = 0); 
}
} 

}
