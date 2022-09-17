
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

unsigned char disable_count=0,mini_stand_by,Count=0,alarm=0,Timer_1,Timer_2,Count_1,
pressed,Timer_wrong_pressed_enable,Timer_3,Timer_6,delay_after_alarm,Timer_4_ext,Timer_4,
shadow=0,Timer_signal_sinus,Timer_signal_sinus_enabled,alarm_recieved,
Count_this_event=0;
unsigned int stand_by=0, Timer_wrong_pressed,Timer_if_long_pressed;

interrupt [10] void timer0_ovf_isr(void)
{

if ((disable_count==0)&&(alarm==0)&&(Count==0)&&(stand_by==0)&&(Timer_wrong_pressed_enable==0)){
Timer_4_ext++;
if (Timer_4_ext==200){
Timer_4++;}
if (Timer_4>=10){
PORTD^=0b00100001;
Timer_4=0;

}

if ((PIND.3==0)&&(stand_by==0)&&(Count_this_event<3)){  
Count_this_event++;
alarm=1;       
shadow=1;
Count=0;
stand_by=20000;

}
if ((Count_this_event>=2)&&(PIND.3==1)){
shadow=0;
Count_this_event=0;}

}

if ((Timer_wrong_pressed>6000)&&(stand_by==0)){
PORTD&=~0b00100000;

disable_count=Count=Timer_wrong_pressed=0;
Timer_wrong_pressed_enable=0;
}

if (Timer_wrong_pressed_enable==1){
Timer_wrong_pressed++;
}

if (PIND.2==1){        
Timer_signal_sinus=0;
Timer_signal_sinus_enabled=1;

alarm_recieved=0;

if ((alarm==0)&&(stand_by==0)){
Timer_if_long_pressed++;
if (Timer_if_long_pressed>2000){
PORTD|=0b00100000;
Count=0;
alarm=1;
stand_by=10;
}
}
}

if(Timer_signal_sinus_enabled==1){Timer_signal_sinus++;}
if (Timer_signal_sinus>250){Timer_signal_sinus=0;alarm_recieved=0;Timer_signal_sinus_enabled=0;}

if (PIND.2==0){

if (Timer_signal_sinus>40){
alarm_recieved=1;

disable_count=0;
Timer_if_long_pressed=0;

}
if (Timer_signal_sinus>41){
alarm_recieved=0;
Timer_signal_sinus_enabled=0;
Timer_signal_sinus=0;

}

}

if ((alarm_recieved==1)&&(alarm==0)&&(stand_by==0)) {

if (disable_count==0){
disable_count=1;
Timer_wrong_pressed_enable=1;
Timer_wrong_pressed=0;
PORTD|=0b00100000;

Count++;
stand_by=2;
if (Count==5){
Count=0;
alarm=1;
}
}

}

if((PIND.2==0)&&(stand_by==0)){

}

if (alarm==1){ 
Timer_1++;
if (pressed==0){
if (shadow==0){
PORTD|=0b10010000;
}
else{
PORTD|=0b00010000;
}

pressed=1;}

if (Timer_1>250){
Timer_2++;
Timer_1=0;
}

if (Timer_2>10){

if (shadow==0){
PORTD^=0b10010000;
}
else{
PORTD^=0b00010000;
}

Timer_2=0;
Count_1++;
}
if (Count_1>2){
if (shadow==0){
PORTD&=~0b10010000;
}
else{
PORTD&=~0b00010000;
}

Count_1=0;
pressed=0;
PORTC|=0b00000100;
stand_by=20000;
alarm=0;
delay_after_alarm=1;
}

}
if (mini_stand_by>0){
mini_stand_by--;
}
if (mini_stand_by==2){
stand_by=2;
}
if (stand_by>0){
Timer_3++;
if (Timer_3>5){
if (delay_after_alarm==1){
Timer_6++;
if (Timer_6==20){
PORTD^=0b00100000;
Timer_6=0;
}
}
stand_by--;
Timer_3=0;
}
}
if ((stand_by==0)&&(delay_after_alarm==1)){
delay_after_alarm=0;
}

}

interrupt [2] void ext_int0_isr(void) 
{

}

void main(void)
{

PORTB=0x00;
DDRB=0b00000000;

PORTC=0x00;
DDRC=0b10000111;

PORTD=0b00000000;
DDRD=0b10111101;

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

MCUCR=0x30;

TIMSK=0x01;

UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x02;
UBRRL=0x37;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x81;

#asm("sei")
#asm("sleep")
while (1)
{

};
}
