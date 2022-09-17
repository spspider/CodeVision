
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

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

#pragma used-
#pragma library lcd.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
unsigned char on[6],off[6],PWM[6],n,nowPORT[6],PWMmax=40;

void allPWM(){

nowPORT[2] = 0b00000100;
nowPORT[3] = 0b00001000;
nowPORT[4] = 0b00010000;
nowPORT[5] = 0b00100000;

on[2]=4;
on[3]=4;
on[4]=4;
on[5]=4;

for (n=2;n<6;n++) {
off[n]=on[n]+1;
if (PWM[n]==on[n]){PORTD|=nowPORT[n];}
if (PWM[n]==off[n]){PORTD&=~nowPORT[n] ;}
if (PWM[n]>=PWMmax){PORTD|=nowPORT[n];PWM[n]=0;}
PWM[n]++;

};

}

unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch,LCD_switch1;
unsigned int adc[6],Time_sec;

float Voltage2,Temp,SetVoltage,VoltPower,VoltBat1,VoltBat2,VoltBat3,VoltBat4;
float Voltage2_old,Time;
char Voltage2_str[20],Temp_str[20],SetVoltage_str[20],VoltPower_str[20],Time_str[20],VoltBat1_str[20],VoltBat2_str[20],VoltBat3_str[20],VoltBat4_str[20];

unsigned char now_is_charge,now_is_discharge;
float Time;
unsigned char Timer_allPWM;

char *_off;
char *_charPIN;
unsigned char pressed_PIND_0,pressed_PIND_1;

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
PORTD^=0b10000000;
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
PORTD&=~0b10000000;
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

interrupt [9] void timer1_ovf_isr(void)
{

Time_sec++;
PORTD^=0b01000000;

}
interrupt [10] void timer0_ovf_isr(void)
{

if (PIND.6==0){buzzer(10,10,3);};

Timer_read_adc_1++;
if(Timer_read_adc_1==100){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}

if(Timer_read_adc_2==5){
adc[0]=read_adc(0);
}if(Timer_read_adc_2==10){
adc[1]=read_adc(1);
}if(Timer_read_adc_2==15){
adc[2]=read_adc(2);
}if(Timer_read_adc_2==20){
adc[3]=read_adc(3);
}if(Timer_read_adc_2==25){
adc[4]=read_adc(4);
}if(Timer_read_adc_2==30){
adc[5]=read_adc(5);
}if(Timer_read_adc_2==35){

Temp=adc[0]/102.4;
Voltage2=adc[1]/18.7;
SetVoltage=adc[2]/18.7;
VoltPower=adc[3]/200.0;

if (Voltage2!=Voltage2_old){
if (Voltage2_old>Voltage2){
now_is_charge=0;
now_is_discharge=1;

}
if (Voltage2_old<Voltage2){
now_is_charge=1;
now_is_discharge=0;

}
Time=((Time_sec*(SetVoltage-Voltage2))/(Voltage2-Voltage2_old))/60;
Time_sec=0;
Voltage2_old=Voltage2;
}

if (LCD_switch==0){
lcd_clear();
lcd_gotoxy(0,0);

sprintf(Voltage2_str, "%.2fV", Voltage2);
sprintf(SetVoltage_str, " %.2fV", SetVoltage);
sprintf(VoltPower_str, "I:%.2fA", VoltPower);
sprintf(Time_str, " %.2fm", Time);

lcd_puts(Voltage2_str);   
lcd_puts(SetVoltage_str);   
lcd_gotoxy(0,1);
lcd_puts(VoltPower_str);

lcd_puts(Time_str);  

}

if (LCD_switch==1){
lcd_clear();
lcd_gotoxy(0,0);
VoltBat1=5.0-adc[0]/204.6;
VoltBat2=5.0-adc[4]/204.6;
VoltBat3=5.0-adc[5]/204.6;
VoltBat4=5.0-adc[5]/204.6;

sprintf(VoltBat1_str, "B1:%.2fV", VoltBat1);
sprintf(VoltBat2_str, "B2:%.2fV", VoltBat2);
sprintf(VoltBat3_str, "B3:%.2fV", VoltBat3);
sprintf(VoltBat4_str, "B4:%.2fV", VoltBat4);

lcd_puts(VoltBat1_str);
lcd_puts(VoltBat2_str);
lcd_puts(VoltBat3_str);
lcd_puts(VoltBat4_str);

}

Timer_read_adc_2=0;   

}
if ((PIND.0==0)&&(pressed_PIND_0==0)){
on[2]++;
pressed_PIND_0=1;
}
if ((PIND.1==0)&&(pressed_PIND_1==0)){
pressed_PIND_1=1;
on[2]--;
}
if (PIND.0==1){pressed_PIND_0=0;}
if (PIND.1==1){pressed_PIND_1=0;}

PORTD|=0b00000100;
}

void main(void)
{

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0b00000000;
DDRD=0b11111100;

TCCR0=0x01;
TCNT0=0x00;

TCCR1A=0x00;
TCCR1B=0x03;
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

TIMSK=0x05;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x83;

lcd_init(16);

#asm("sei")

while (1)
{

};
}
