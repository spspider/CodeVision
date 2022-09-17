
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

void BCD_1Lcd(unsigned char value);

void BCD_2Lcd(unsigned char value);

void BCD_3Lcd(unsigned char value);

void BCD_3IntLcd(unsigned int value);

void BCD_4IntLcd(unsigned int value);

void TIM_Init(void);       
void TIM_Handle(void);     
void TIM_Display(void);    

volatile unsigned int icr1 = 0;
volatile unsigned int icr2 = 0;
enum state {IDLE = 0, RESEIVE = 1};  
enum state currentState = IDLE;

volatile unsigned char flag = 0;

unsigned char buf[5];

void TIM_Init(void)
{
DDRD &= ~(1<<6       );
PORTD |= (1<<6       );

TIMSK = (1<<5       ); 
TCCR1A=(0<<7       )|(0<<6       )|(0<<1       )|(0<<0       );  
TCCR1B=(0<<7       )|(0<<6       )|(0<<4       )|(0<<3       )|(0<<2       )|(1<<1       )|(1<<0       ); 
TCNT1 = 0;

currentState = IDLE;
}

interrupt [6] void Timer1Capt(void)
{

icr1 = icr2;
icr2 = ((unsigned int)ICR1H<<8)|ICR1L;  
flag |= (1<<(0))	;
}

unsigned int TIM_CalcPeriod(void)
{
unsigned int buf1, buf2;

#asm("cli");
buf1 = icr1;
buf2 = icr2;
#asm("sei"); 

if (buf2 > buf1) {
buf2 -= buf1;
}
else {
buf2 += (65535 - buf1);    
}
return buf2;
}

void TIM_Handle(void)
{
unsigned int period;
static unsigned char data; 
static unsigned char countBit, countByte;

if (((flag & (1<<(0))) == 0)) return;

period = TIM_CalcPeriod();

switch(currentState){

case IDLE:
if (period < (15000UL*16UL)/64UL) {
if (period > (12000UL*16UL)/64UL){
data = 0;
countBit = 0;
countByte = 0;
buf[4] = 0;
currentState = RESEIVE;
}
else {
buf[4]++;
}
}
break;

case RESEIVE:
if (period < (3000UL*16UL)/64UL){
if (period > (1500UL*16UL)/64UL){
data |= (1<<(7))	;
}
countBit++;
if (countBit == 8){
buf[countByte] = data;
countBit = 0;
data = 0;
countByte++;
if (countByte == (5 - 1)){
flag |= (1<<(1))	;
currentState = IDLE;
break;
}             
}
data = data>>1;
}
break;

default:
break;
}

flag &= (~(1<<(0)));
}

void TIM_Display(void)
{
if(((flag & (1<<(1))) != 0)){
LCD_WriteCom(((((0)& 1)*0x40)+((0)& 15))|128) ;
BCD_3Lcd(buf[0]);
LCD_WriteData(' ');
BCD_3Lcd(buf[1]);
LCD_WriteData(' ');
BCD_3Lcd(buf[2]);
LCD_WriteData(' ');
BCD_3Lcd(buf[3]);
LCD_WriteData(' ');
flag &= (~(1<<(1)));
}

LCD_WriteCom(((((1)& 1)*0x40)+((0)& 15))|128) ;  
BCD_3Lcd(buf[4]);
}
