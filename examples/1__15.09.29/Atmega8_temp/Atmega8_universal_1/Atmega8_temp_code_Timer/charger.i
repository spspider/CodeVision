
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

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

#pragma used+

unsigned char bcd2bin(unsigned char n);
unsigned char bin2bcd(unsigned char n);

#pragma used-

#pragma library bcd.lib

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(200);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
unsigned char on[6],nowPORT[6];

void allPWM(){

nowPORT[2] = 0b00000100;
nowPORT[3] = 0b00001000;
nowPORT[4] = 0b00010000;
nowPORT[5] = 0b00100000;

on[2]=4;
on[3]=4;
on[4]=4;
on[5]=4;

}

unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch=1,Timer_LCD,Time_one_sec;
unsigned int adc[6];

float Temp=99.9,STemp,Temp_min=99.9;

char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20];

unsigned int Time_sec_all,Time,Time_sec,Time_min,Time_hour;

unsigned char Startsomedelay,delayneed,Timer_IR,Timer_IR_Start,count1bit,devider,start_devider;
unsigned int databits,show_data; 
void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){
if (time>0){
Timer_buzzer_active_1++;
if (Timer_buzzer_active_1>250){
Timer_buzzer_active++;
Timer_buzzer_active_1=0;
}

if(Timer_buzzer_active<time){
Timer_buzzer_signal++;
if (Timer_buzzer_signal==freq){
PORTB^=0b00001000;
Timer_buzzer_signal=0;
}
Timer_buzzer_silence=0;
}
if(Timer_buzzer_active>time){
Timer_buzzer_silence_1++;
if(Timer_buzzer_silence_1>250){
Timer_buzzer_silence_1=0;
Timer_buzzer_silence++;
}
PORTB&=~0b00001000;
if(Timer_buzzer_silence>time){
if (repeat>0){
Timer_buzzer_active=0;
}
repeat--;
if (repeat==0){
time=0;freq=0;
}
}
}
}
}
interrupt [8] void timer1_compb_isr(void)
{

}
interrupt [9] void timer1_ovf_isr(void){

if (PIND.5==1){
Time_one_sec++;
if (Time_one_sec==2){
Time_sec_all++;
Time_one_sec=0;
}
}

}
interrupt [7] void timer1_compa_isr(void){

TCNT1H=0xFF-0x1E;  
TCNT1L=0xFF-0x83;
OCR1AH=0x1E;  
OCR1AL=0x83;

PORTD^=0b00001000;

}
interrupt [10] void timer0_ovf_isr(void)
{
PORTD^=0b01000000;
TCNT0=0x22;

if ((PIND.7==0)&&(Startsomedelay==0)){
Timer_IR_Start=1;

count1bit=0;

}

if ((Timer_IR_Start==1)&&(Startsomedelay==0)){
if (Timer_IR==0){databits=0;}
Timer_IR++;
if (PIND.7==0){
databits=databits<<1; 

databits|=1;
}else{

databits=databits<<1; 
databits&=~1;
}
if (Timer_IR==16){
Timer_IR_Start=0;
Timer_IR=0;
Startsomedelay=1;
if(databits!=0){
show_data=databits;
}

}

devider=0; 
}

if (Startsomedelay==1){
PORTD|=0b00001000;
delayneed++;
if (delayneed==255){
PORTD&=~0b00001000;
Timer_IR=0;
delayneed=Startsomedelay=0;

}
}

Timer_LCD++;
Timer_read_adc_1++;
if(Timer_read_adc_1==50){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}

if (Temp<STemp){
PORTD|=0b00100000;
}
if (Temp>STemp){
PORTD&=~0b00100000;
}
if ((Temp<Temp_min)&&(Temp!=0.00)){
Temp_min=Temp;
}

if (Timer_LCD==250){

if (LCD_switch==0){

}

if (LCD_switch==1){

}
Timer_LCD=0;
}
}

void main(void)
{

PORTB=0b00000000;
DDRB=0b00001000;

PORTC=0x00;
DDRC=0b00000000;

PORTD=0b00011100;
DDRD=0b01101000;

TCCR0=0x01;
TCNT0=0x22;

TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0xE1;
TCNT1L=0x7A;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x03;

MCUCR=0x00;

TIMSK=0x15;

ACSR=0x80;
SFIOR=0x00;

SPCR=0x00;
SPSR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x83;

#asm("sei")

while (1)
{

};
}
