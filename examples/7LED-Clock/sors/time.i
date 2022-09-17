
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

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned char sek;        
unsigned char min;        
unsigned char hour;       
unsigned char Dig[10];
char Disp6, Disp7;

interrupt [7] void timer1_compa_isr(void)  
{

TCNT1H=0;
TCNT1L=0;
sek++;                
PORTD=128;
PORTB=253;         

if (PINC.0==0) 
{
hour++; 
}
if (PINC.1==0) 
{
hour--; 
}
if (PINC.2==0) 
{
min++; 
}
if (PINC.3==0) 
{
min--; 
}  
if (PINC.4==0) 
{
sek=0;  
}  

}

void Display (unsigned int Number) 
{
unsigned char Num2, Num3;
Num2=0;
while (Number >= 10)   
{
Number -= 10;  
Num2++; 
}
Num3 = Number;    
Disp6 = Dig[Num2];
Disp7 = Dig[Num3];   
} 
void Dig_init() 
{
Dig[0] = 95;   
Dig[1] = 24;
Dig[2] = 109;
Dig[3] = 124;
Dig[4] = 58;
Dig[5] = 118;
Dig[6] = 119;
Dig[7] = 28;
Dig[8] = 127;
Dig[9] = 126;
}

void main(void)
{

PORTB=0x00;
DDRB=0xFF;

PORTC=0xFF;
DDRC=0x00;

PORTD=0x00;
DDRD=0xFF;

TCCR0=0x00;
TCNT0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x10;

ACSR=0x80;
SFIOR=0x00;

#asm("sei")
Dig_init(); 
while (1)
{
if(sek==60)          
{
min++;              
sek=0;              
}
if(min==60)         
{
hour++;             
min=0;              
}
if (hour==24)        
{                    
hour=0;
min=0;
sek=0;
}

if (hour==255)
hour=0;
if (min==255)
min=0;  

Display(hour); 
PORTB=254;    
PORTD=Disp6;  
delay_ms(5);
PORTB=253;    
PORTD=Disp7;   
delay_ms(5);
Display(min);  
PORTB=251;      
PORTD=Disp6;  
delay_ms(5);
PORTB=247;    
PORTD=Disp7;   
delay_ms(5);
};
}
