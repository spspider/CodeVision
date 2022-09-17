
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

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

#pragma used+

unsigned char bcd2bin(unsigned char n);
unsigned char bin2bcd(unsigned char n);

#pragma used-

#pragma library bcd.lib

eeprom signed int STempEE;
float Temp=99.9,STemp,Temp_min=99.9;
char EEPromOut,EEPromIn;

bit rx_buffer_overflow;
char lcd_buffer[32];
char uart_data[16];
int i=0,j=0;
unsigned int databits=0;
unsigned char lcd_can_clear=0,status_usart,now_set;

char rx_buffer[32];

unsigned char rx_wr_index,rx_rd_index,rx_counter;

bit rx_buffer_overflow;

void clear_usart(){
while(i<13)
{
uart_data[i]=0;
i++;
}
i=0;
}

interrupt [12] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer[rx_wr_index]=data;
if (++rx_wr_index == 32) rx_wr_index=0;
if (++rx_counter == 32)
{
rx_counter=0;
rx_buffer_overflow=1;
};
now_set=0;
}; 
uart_data[i]=data;
status_usart=UCSRA;
i++;
if(UCSRA==48)                  
{

i=0;

PORTD&=~0b00001000;
}

if ((status_usart==48)&&(now_set==0)){
uart_data[10]=uart_data[2] ^ uart_data[3];
uart_data[11]=uart_data[4] ^ uart_data[5] ;
uart_data[12]=uart_data[6] ^ uart_data[7];
uart_data[13]=uart_data[12] ^ uart_data[11];
databits=uart_data[13];
databits<<=8;
databits|=uart_data[11];

if (databits==43648){
STemp+=0.1;
}
if (databits==8352){
STemp-=0.1;
}
EEPromIn=1;

now_set=1;

}

}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 32) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(500);

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

char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20];

unsigned char delay_start,delay_start_timer;
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

interrupt [4] void timer2_comp_isr(void)
{

ASSR=0x00;
TCCR2=0x01;
TCNT2=0x00;
OCR2=0x22;

}

interrupt [7] void timer1_compa_isr(void){
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x0F;
OCR1AL=0x42;
OCR1BH=0x00;
OCR1BL=0x00;

PORTD^=0b00001000;

if (Temp<STemp){
PORTD|=0b00100000;
}
if (Temp>STemp){
PORTD&=~0b00100000;
}

if (EEPromIn==1){
STempEE=STemp*100.00;
EEPromIn=0;
}

if (PIND.5==1){
Time_one_sec++;
if (Time_one_sec==2){
Time_sec_all++;
Time_one_sec=0;
}
}

}
interrupt [10] void timer0_ovf_isr(void)
{

Timer_LCD++;
Timer_read_adc_1++;
if(Timer_read_adc_1==50){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}

}

void main(void)
{

PORTB=0b00000000;
DDRB=0b00001000;

PORTC=0x00;
DDRC=0b00000000;

PORTD=0b00010100;
DDRD=0b00101000;

TCCR0=0x02;
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
TCCR2=0x01;
TCNT2=0x00;
OCR2=0x22;

MCUCR=0x00;

TIMSK=0x91;

UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x86;
UBRRH=0x01;
UBRRL=0x17;

ACSR=0x80;
SFIOR=0x00;

SPCR=0x00;
SPSR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x83;

lcd_init(16);

#asm("sei")

while (1)
{

if ((STempEE!=32767)&&(EEPromOut==0)){
STemp = STempEE/100.00;
EEPromOut=1;
}  
if ((STemp<-5.00)||(STempEE<-500)){STemp=-5.00;STempEE=-500;}  
if ((STemp>30.00)||(STempEE>3000)){STemp=30.00;STempEE=30000;}  

if ((Temp<Temp_min)&&(Temp!=0.00)){
Temp_min=Temp;
}

if(Timer_read_adc_2==20){
adc[0]=read_adc(0);
Temp=adc[0]/18.52631578947368;
}if(Timer_read_adc_2==22){

Timer_read_adc_2=0;   
}           

if (Timer_LCD==250){

if (LCD_switch==1){

Time_hour=Time_sec_all/60.0/60.0;
Time_min=((Time_sec_all/60.0)-(Time_hour*60.0));
Time_sec=((Time_sec_all)-((Time_min*60.0)+(Time_hour*60.0*60.0)));

sprintf(Temp_str, "T:%.1f", Temp);
sprintf(_NeedTemp," ST:%.1f",STemp);
sprintf(Time_str," time:%d",Time);
sprintf(_Time_hour,"%d:",Time_hour);
sprintf(_Time_min,"%d:",Time_min);
sprintf(_Time_sec,"%d",Time_sec);
sprintf(_Temp_min,"min:%.1f",Temp_min);

lcd_clear();
lcd_gotoxy(0,0);
lcd_puts(Temp_str);
lcd_puts(_NeedTemp);
lcd_gotoxy(0,1);
lcd_puts(_Time_hour);
lcd_puts(_Time_min);
lcd_puts(_Time_sec);
lcd_gotoxy(7,1);
lcd_puts(_Temp_min);

}

if (LCD_switch==2){

while(j<12)
{                  
lcd_gotoxy(j,0);
sprintf(lcd_buffer,"%c",uart_data[j]);
lcd_puts(lcd_buffer);
j++;
}
j=0;

};

if (LCD_switch==3){

lcd_clear();
lcd_gotoxy(0,0);
sprintf(lcd_buffer,"D:%u",databits);
lcd_puts(lcd_buffer);
databits=0;
}

Timer_LCD=0;
}

};
}
