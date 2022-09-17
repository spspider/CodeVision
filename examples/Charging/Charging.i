
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

unsigned char Timer1,Timer4,c1,Timer2,Timer3,bat,Timer5,a1,Timer7,aStop,Timer8;
unsigned char adc1[2],Timer6;                             

interrupt [10] void timer0_ovf_isr(void)
{
if((a1==1)&&(aStop==1)){
Timer6++;
if (Timer6>=1000)
{
Timer5++;
if(Timer5==10){
PORTD^=0b00000100;
Timer5=0;
}
}
if(Timer6>=1500)
{PORTD&=~0b00000100;
Timer6=0;Timer7++;}
}
if(Timer7>=5){
a1=0;aStop=0;Timer6=Timer5=Timer7=0;
}

if((a1==2)&&(aStop==1)){
Timer6++;
if (Timer6>=800)
{
Timer5++;
if(Timer5==5){
PORTD^=0b00000100;
Timer5=0;
}
}
if(Timer6>=1000)
{PORTD&=~0b00000100;
Timer6=0;Timer7++;}
}
if(Timer7>=2){
a1=0;aStop=0;Timer6=Timer5=Timer7=0;
}

Timer8++;  
if (Timer8==1){PORTD^=0b00001000;}

if (Timer1>=255){Timer1=0;Timer2++;Timer3++;Timer4++;
}
if(Timer3>=5){

if((adc1[0]<300)&&(adc1[0]>=500)){PORTD^=0b10000000;Timer3=0;a1=1;}
if((adc1[1]<300)&&(adc1[1]>=500)){PORTD^=0b00100000;Timer3=0;a1=1;}
Timer3=0;
}

if(Timer4>=10){
if(adc1[0]<500){PORTD^=0b10000000;Timer4=0;}
if(adc1[1]<500){PORTD^=0b00100000;Timer4=0;}
Timer4=0;
}

if(Timer2>=20){
PORTB&=~0b00000011;
}
if(Timer2>=22){
switch (bat){
case 1: {bat=0;break;}
case 0: {bat=1;break;}
}

c1=1;
}
if(Timer2>=25){
if(adc1[0]<500){PORTB|=0b00000001;Timer2=0;}
if(adc1[1]<500){PORTB|=0b00000010;Timer2=0;}

if(adc1[0]>500){PORTB&=~0b00000001;PORTD|=0b10000000;Timer2=0;a1=2;aStop=1;}
if(adc1[1]>500){PORTB&=~0b00000010;PORTD|=0b00100000;Timer2=0;a1=2;aStop=1;}
Timer2=0;

printf("bat0=%d bat1=%d#",adc1[0],adc1[1]);
} 
}                  

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|(0 & 0xff);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

void main(void)
{

PORTB=0b00000000;
DDRB=0b01000011;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0b10101100;

TCCR0=0x01;
TCNT0=0x00;

TIMSK|=0x01;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0 & 0xff;
ADCSRA=0x83;

#asm("sei")

while (1)
{

if (c1==1){c1=0;adc1[bat] = read_adc(bat);} 

};
}
