
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

unsigned char adc;
unsigned char cycleL; 
unsigned char MS=5,cycleN;
unsigned char Disp6,Disp7,Other;
unsigned char Num2, Num3,Dig[17],BipL=1;
bit PINC5,PINC4,PIND7,PIND4,PIND0,PIND01,DisOther,Bip,HW=0,INJ=0,cycle,HW_1,INJ_1;

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
unsigned char Disp6,Disp7,Timer_5,TimeHW=10,Timer_7,Dis1,Dis2,Timer_9,Timer_10,Timer_3,Timer_2,Timer_8,Timer_11,Timer_4,Timer_6,Timer_12;

interrupt [10] void timer0_ovf_isr(void)
{

if ((PINC.5==0)&&(PINC5==0)){PINC5=1;MS=MS+5;;DisOther=0;Bip=1;}
if (PINC.5==1){PINC5=0;}
if ((PINC.4==0)&&(PINC4==0)){PINC4=1;MS=MS-5;DisOther=0;Bip=1;}

if (PINC.4==1){PINC4=0;}

if ((PIND.7==0)&&(PIND7==0)){PIND7=1;DisOther=0;HW=1;Bip=1;}
if (PIND.7==1){PIND7=0;}

if ((PIND.4==0)&&(PIND4==0)){PIND4=1;HW=0;BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}
if (PIND.4==1){PIND4=0;}

if ((PIND.0==0)&&(PIND0==0)){PIND0=1;PIND01=0;Bip=1;cycleN=5;PORTD|=0b00000100;PORTD&=~0b00000010;DisOther=1;Num2=0;Num3=5;}
if ((PIND.0==1)&&(PIND01==0)){PIND0=0;PIND01=1;Bip=1;cycleN=10;PORTD|=0b00000010;PORTD&=~0b00000100;DisOther=1;Num2=0;Num3=1;}

if (PIND.5==0){Bip=1;INJ=1;DisOther=0;}
if (PIND.6==0){Bip=1;INJ=0;Num2=11;Num3=10;DisOther=1;PORTC&=~0b00000010;Dis1=0;}

if (HW==1){Timer_7++;Timer_8++;
HW_1=1;
if (Timer_7==TimeHW){PORTC^=0b00000001;Timer_7=0;}
if (Timer_8==250){Timer_10++;Dis2=Dig[16];}
if (Timer_10==12){TimeHW=5;}
if (Timer_10==20){TimeHW=10;Timer_8=0;Timer_10=0;Timer_9++;}
if (Timer_9==10){BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}}

Timer_2++;
Timer_3++;
if (INJ==1){
INJ_1=1;
Timer_11++;
if(cycleL>=cycleN){INJ=0;PORTC&=~0b00000010;Dis1=0;BipL=5;Bip=1;cycleL=0;DisOther=1;Num2=11;Num3=10;}
if (Timer_11==250){Timer_4++;;}
if (Timer_4==4){PORTC&=~0b00000010;Dis1=0;}
if (Timer_4>=MS+2){PORTC|=0b00000010;cycleL++;Timer_4=0;Dis1=Dig[16];}

}

if (Bip==1){Timer_5++;
if (Timer_5==5){
PORTD^=0b00001000;

Timer_5=0;
Timer_6++;
if (Timer_6==100){Timer_12++;}
if (Timer_12==BipL){Timer_12=0;Timer_6=0;BipL=1;
Bip=0;}
}
}

if (Timer_3==1){
PORTC&=~0b00000100;
PORTC|=0b00001000;
PORTB=Disp6-Dis1;}
if (Timer_3==100){
PORTC&=~0b00001000;
PORTC|=0b00000100;
PORTB=Disp7-Dis2;
}
if (Timer_3==200){Timer_3=0;}

}

void Dig_init() 
{          
Dig[0] = 0b00000011;
Dig[1] = 0b10011111;
Dig[2] = 0b00100101;
Dig[3] = 0b00001101;
Dig[4] = 0b10011001;
Dig[5] = 0b01001001;
Dig[6] = 0b01000011;
Dig[7] = 0b00011111;
Dig[8] = 0b00000001;
Dig[9] = 0b00001001;
Dig[10]= 0b01001001;
Dig[11]= 0b00110001;
Dig[12]= 0b01100011;
Dig[13]= 0b00001111;
Dig[14]= 0b11001111;
Dig[15]= 0b11100111;
Dig[16]= 0b00000001;
}
void Display (unsigned int Number) 
{
if (DisOther==0){
Num2=0, Num3=0;
while (Number >= 10)
{
Number -= 10;  
Num3++; 
}
Num2 = Number;
}

Disp6 = Dig[Num3];
Disp7 = Dig[Num2];
}

void main(void)
{

PORTB=0b11111111;
DDRB=0b11111111;

PORTC=0b00111100;
DDRC=0b00001111;

PORTD=0b11110001;
DDRD=0b00001110;

TCCR0=0x01;
TCNT0=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x83;

#asm("sei")

while (1)
{

if (Timer_2==200){
Dig_init();
if (DisOther==0){Display(MS);}
if (DisOther==1){Display(Other);}

Timer_2=0;   
}

}

}
