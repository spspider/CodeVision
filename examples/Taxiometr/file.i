
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

unsigned char adc[5];
unsigned int Timer1,Timer4,Timer5,Timer7;
unsigned char Timer2,Timer6,Timer3,interval,cl[5],temp,sw=0,data;
char *adc_c[5];
unsigned char a,pulse_ok=0,buzzer,ready_adc_2=0;

unsigned int previous_value[4];

interrupt [10] void timer0_ovf_isr(void)
{

Timer1++;
if (Timer1==1000){
Timer1=0;a=1;
sw++;
if (sw==2){sw=0;}

}

if (adc[1]==1){
if (pulse_ok==1){

Timer3++;
if (Timer3==5){
PORTD^=0b00001000;
Timer4++;
Timer3=0;
}

if (Timer4==200){
Timer4=0;
buzzer=0;
pulse_ok=0;
PORTD&=~0b00011000;
}
}
}

if (sw!=0){

if (pulse_ok==0){ 
Timer5++;   

if (Timer5==500){

PORTC^=0b00000001;
Timer5=0;
}

if (adc[1]==1){
Timer7++;
if (Timer7==2000){
Timer7=0;adc[1]=0;};
}    

}
}

}

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

char q;
void clear(char cl_now)
{        
for(q=0;q<5;q++){
if(cl_now==q){cl[q]=1;}
if(cl_now!=q){cl[q]=0;}

}
}

interrupt [2] void ext_int0_isr(void)
{

adc[1]=1;

}

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x20 & 0xff);

delay_us(100);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;

return ADCH;
}

void main(void)
{

PORTB=0x00;

DDRB=0b00000000;

PORTC=0b00000000;
DDRC=0b00000001;

PORTD=0b00000000;
DDRD=0b00001000;

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

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x20 & 0xff;
ADCSRA=0x83;

GICR|=0x40;
MCUCR=0x02;
GIFR=0x40;

lcd_init(16);

#asm("sei")

while (1)
{

if(sw==0){
if (pulse_ok==0){

delay_us(200);
itoa(adc[0], adc_c[0]);
delay_us(200);

adc[2]=read_adc(2);
delay_ms(200);
ready_adc_2=1;

lcd_clear();

lcd_gotoxy(0, 0);
lcd_putsf("temp");
delay_us(100);
lcd_puts(adc_c[0]);
delay_us(200);

itoa(adc[2], adc_c[2]);
delay_us(200);
lcd_gotoxy(8, 0);
lcd_putsf("IR");

delay_us(200);
lcd_puts(adc_c[2]);
delay_us(200);

itoa(adc[1], adc_c[1]);
delay_us(200);
lcd_gotoxy(0, 1);
delay_us(200);
lcd_putsf("int:");
delay_us(200);
lcd_puts(adc_c[1]);
delay_us(200);
}

}

};
}

