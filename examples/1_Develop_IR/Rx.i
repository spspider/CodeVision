
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

#asm 
.equ __lcd_port=0x18; PORTB 
#endasm  // Инициализируем PORTB как порт ЖКИ 

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

unsigned char port,Timer_1=0,Timer_2,Timer_4;
unsigned int Timer_3,adc[6];
unsigned char U1,U3,U2[7];
int sig1[1];
unsigned char _adc0[4],_adc1[4],*_str3="Temp=",*_str4="V=";

void PWM2(){
Timer_1++;

if (Timer_1==30){Timer_1=1;Timer_2++;} 

if (Timer_1<sig1[0]){U1=1;}else{U1=0;}
if (U1==1){PORTD|=0b00010000;}
if (U1==0){PORTD&=~0b00010000;}

if (Timer_2>=20){ 
for (U3=0;U3<=1;U3++){
if (U2[U3]==1) {if(sig1[U3]<=20){sig1[U3]=sig1[U3]+1;}}
if (U2[U3]==0) {if(sig1[U3]>=1){sig1[U3]=sig1[U3]-1;}}
Timer_2=0;}

}

Timer_3++;
if (Timer_3==10000){Timer_3=0;
Timer_4++;
U2[0]^=1;

itoa(adc[0], _adc0);
itoa(adc[1], _adc1);
lcd_clear();
lcd_gotoxy(8, 0);
lcd_puts(_str3);
lcd_puts(_adc0);
lcd_gotoxy(8, 1);
lcd_puts(_str4);
lcd_puts(_adc1);

}
}
void ADC_(){

}
void IR(){

}
unsigned int adc_data[5-0+1];
static unsigned char input_index=0;

interrupt [15] void adc_isr(void)
{
adc[input_index]=ADCW;
if (++input_index > (5-0)){input_index=0;}

ADMUX=(0 | (0x00 & 0xff))+input_index;

}

interrupt [10] void timer0_ovf_isr(void)
{
PWM2();
IR();
ADC_();
}

void main(void)
{

DDRB=0xFF;

DDRD=0b00011000;

TCCR0|=0x01;
TIMSK|=0x01;

UCSRA|=0x00;
UCSRB|=0x18;
UCSRC|=0x86;
UBRRH|=0x00;
UBRRL|=0x33;

ACSR|=0x80;

ADMUX=0 | (0x00 & 0xff);
ADCSRA=0b11001001;

lcd_init(16);

#asm("sei")
while (1)
{
if (Timer_4==1){ADCSRA|=0x40;Timer_4=0;}

}
}
