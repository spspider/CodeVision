
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
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
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
sfrb OCDR=0x31;
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
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

void LCD_Init(void);
void LCD_Clear(void);
void LCD_WriteData(unsigned char data); 
void LCD_WriteCom(unsigned char data); 
void LCD_SendStringFlash(char __flash *str); 
void LCD_SendString(char *str); 

unsigned char __swap_nibbles(unsigned char data)
{
#asm
 ld r30, Y
 swap r30 
 #endasm
}

void LCD_WriteComInit(unsigned char data)
{
unsigned char tmp; 
delay_us(40);
PORTC &= (~(1<<(2)));	
tmp  = PORTC & 0x0f;
tmp |= (data & 0xf0);
PORTC = tmp;		
PORTC |= (1<<(0))	;	        
delay_us(2);
PORTC &= (~(1<<(0)));	
}

inline static void LCD_CommonFunc(unsigned char data)
{
unsigned char tmp; 
tmp  = PORTC & 0x0f;
tmp |= (data & 0xf0);

PORTC = tmp;		
PORTC |= (1<<(0))	;	        
delay_us(2);
PORTC &= (~(1<<(0)));	

data = __swap_nibbles(data);
tmp  = PORTC & 0x0f;
tmp |= (data & 0xf0);

PORTC = tmp;		
PORTC |= (1<<(0))	;	        
delay_us(2);
PORTC &= (~(1<<(0)));	 
}

inline static void LCD_Wait(void)
{

delay_us(40);
}

void LCD_WriteCom(unsigned char data)
{
LCD_Wait();
PORTC &= (~(1<<(2)));	
LCD_CommonFunc(data);
}

void LCD_WriteData(unsigned char data)
{
LCD_Wait();
PORTC |= (1<<(2))	;	        
LCD_CommonFunc(data);
}

void LCD_Init(void)
{
DDRC |= 0xf0;
PORTC |= 0xf0; 

DDRC |= (1<<1)|(1<<2)|(1<<0);
PORTC |= (1<<1)|(1<<2)|(1<<0);
PORTC &= (~(1<<(1)));
delay_ms(40);

LCD_WriteComInit(0x30); 
delay_ms(10);
LCD_WriteComInit(0x30);
delay_ms(1);
LCD_WriteComInit(0x30);

LCD_WriteComInit(0x20); 
LCD_WriteCom(0x28); 
LCD_WriteCom(0x08);
LCD_WriteCom(0x0c);  
LCD_WriteCom(0x01);  
delay_ms(2);
LCD_WriteCom(0x06);  
}

void LCD_SendStringFlash(char __flash *str)
{
unsigned char data;			
while (*str)
{
data = *str++;
LCD_WriteData(data);
}
}

void LCD_SendString(char *str)
{
unsigned char data;
while (*str)
{
data = *str++;
LCD_WriteData(data);
}
}

void LCD_Clear(void)
{
LCD_WriteCom(0x01);
delay_ms(2);
}
