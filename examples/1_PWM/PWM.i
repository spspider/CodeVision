
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

int Timer_1=0,Timer_2,Timer_4,U1=0,U3=0;
unsigned int Timer_3=0,U2[4],sig1[4],;

void Time(){

Timer_3++;
if (Timer_3==1){U2[0]=1;}
if (Timer_3==10000){U2[1]=1;}
if (Timer_3==20000){U2[2]=1;}
if (Timer_3==30000){U2[0]=U2[1]=U2[2]=0;Timer_3=0;}
}

void PWM2(){
Time();

Timer_1++;
if (Timer_1==20){Timer_1=0;Timer_2++;} 

if (Timer_1<sig1[0]){U1=1;}else{U1=6;} 
if (U1==1){PORTC|=0b00000100;}
if (U1==6){PORTC&=~0b00000100;}

if (Timer_1<sig1[1]){U1=2;}else{U1=3;} 
if (U1==2){PORTC|=0b00001000;}
if (U1==3){PORTC&=~0b00001000;}

if (Timer_1<sig1[2]){U1=4;}else{U1=5;} 
if (U1==4){PORTC|=0b00010000;}
if (U1==5){PORTC&=~0b00010000;}

if (Timer_2==5){ 

for (U3=0;U3<=3;U3++){
if (U2[U3]==1) {if(sig1[U3]<=20){sig1[U3]=sig1[U3]+1;}}
if (U2[U3]==0) {if(sig1[U3]>=0){sig1[U3]=sig1[U3]-1;}}
}
Timer_2=0;}
}

interrupt [10] void timer0_ovf_isr(void)
{
Timer_4++;
if (Timer_4==1){PORTC^=0b00000001;}
if (Timer_4==2){PORTC^=0b00000010;}
if (Timer_4==3){PORTC^=0b00000100;}
if (Timer_4==4){PORTC^=0b00001000;}
if (Timer_4==5){PORTC^=0b00100000;Timer_4=0;}

}

void main(void)
{
PORTB=0x00;
DDRB=0x00;
DDRC=0xFF;
PORTD=0x00;

DDRD=0x00;
TCCR0=0x01; 
TCNT0=0x00;

TCCR1A=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0;
OCR1AL=0;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;

TCNT2=0x00;
OCR2=0x00;
MCUCR=0x00;

TIMSK|=0x01; 

ACSR=0x80;
SFIOR=0x00;

#asm("sei")

while (1)
{

};
}
