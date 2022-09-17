
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

eeprom unsigned long int Push1=-19095,Push2=-19098;
unsigned int d=0,d1=0,d2=0,d3=0,adress1=4,adress2=5,adress3=24;
unsigned int PWM1=0,PWM1_V=0,Timer1,Timer2,bit1,bit0,FreqT=10,TOL=2,bit01,bit10,shiftd;
unsigned int U1,U2,Timer_1;

interrupt [7] void timer1_compa_isr(void)
{

Timer_1++;
if (Timer_1<20){U1=1;U2=0;}
if (Timer_1>=20){U2=1;U1=0;}
if (Timer_1>=255){Timer_1=0;}

if (U1==1){PORTB|=0b00000010;}
if (U2==1){PORTB&=~0b00000010;}

OCR1AL = 255;

}
interrupt [10] void timer0_ovf_isr(void)
{
PWM1++;

if ((PWM1=20)&&(PINB.1 == 1)){PORTB|=0b00000001;}
if (PWM1=25){PORTB&=~0b00000001;}
if ((PWM1=30)&&(PINB.2 == 1)){PORTB|=0b00000001;}
if (PWM1=35){PORTB&=~0b00000001;}
if ((PWM1=40)&&(PINB.3 == 1)){PORTB|=0b00000001;}
if (PWM1=45){PORTB&=~0b00000001;}
if ((PWM1=50)&&(PINB.4 == 1)){PORTB|=0b00000001;}
if (PWM1=55){PORTB&=~0b00000001;}
if ((PWM1=60)&&(PINB.5 == 1)){PORTB|=0b00000001;}
if (PWM1=65){PORTB&=~0b00000001;}
if ((PWM1=70)&&(PINB.6 == 1)){PORTB|=0b00000001;}
if (PWM1=75){PORTB&=~0b00000001;}
if ((PWM1=80)&&(PINB.7 == 1)){PORTB|=0b00000001;}
if (PWM1=85){PORTB&=~0b00000001;}
if (PWM1==100){PWM1=0;}

}

interrupt [5] void timer2_ovf_isr(void)
{

Timer1++;
if (PINC.0==0) {bit1++;}
if (PINC.0==1) {bit0++;}
if (Timer1==FreqT){
Timer1=0;
if ((bit1>=TOL)&&(bit1>bit0)){
bit1=bit0=0;
bit01=0;
bit10++;
d=d<<1; 
d|=1;
putchar('1');
}
if ((bit0>=TOL)&&(bit0>bit1)){

bit0=bit1=0;
bit01++;
bit10=0;
d=d<<1; 
d&=~1;
putchar('0');
}
shiftd++;

if ((bit01>5)||(bit10>5)){d=d1=d2=d3=shiftd=0;bit10=bit01=0;TCCR2&=~0x01;putchar('n');};
if (shiftd==adress1){d1 = d;putchar('_');d = 0;}
if ((shiftd==adress2)){d2 = d;putchar('_');;d = 0;}

if ((shiftd==adress3)){d3 = d;;
printf("#d1=%d#d2=%d#d3=%d#",d1,d2,d3);

if (((d3==-19095)||(d3==23188))&&(Timer2==0)){PORTB^=0b00000100;putchar('A');} 
if (((d3==-19098)||(d3==23187))&&(Timer2==0)){PORTB^=0b01000000;putchar('B');} 

d=d1=d2=d3=shiftd=0;
TCCR2&=~0x01;

}
}
}

void main(void)
{

PORTB=0x00;
DDRB=0xff;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x00;
TCCR0|=0x04; 
TCNT0=0x00;

TCCR1B=0x0A;
TCCR1A=0x00;

TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0;
OCR1AL=0;
OCR1BH=0x00;
OCR1BL=0x00;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

ASSR=0x00;
TCCR2=0x00;

TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x10;
TIMSK|=0x01; 
TIMSK|=0x40; 

ACSR=0x80;
SFIOR=0x00;

#asm("sei")

while (1)
{

if ((PINC.0==0)&&(d1==0))
{
TCCR2|=0x01;
}

};
}
