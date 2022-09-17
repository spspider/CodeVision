
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

unsigned char sec,mins,hour,hour_a1,mins_a1,sec_a1,hour_a2,mins_a2,sec_a2;

int d=0,d1=0,d2=0,d3=0;

unsigned char Timer1,bit1,bit0,bit01,bit10,shiftd,Check_1,adress2=10,adress3=15,adress4=16,adress5=20,adress6=21,adress7=26,FreqT=31;

unsigned char U1=0,U2[8][4],sig1[8][4],U3=0; 
int Timer_3,Timer_6,Timer_9,Number[3],Timefreq=5000;
unsigned char U4,bitEr1,bitEr0,Timer_1,Timer_2,Timer_4,Timer_7,Timer_8,TD=0,n,n1[255],n2,n3,IR_Tr=0;
unsigned char PWM_Susp=0,Clock_Susp=0,U5,U6=0,U7=0,U8=0,U9=5,Bee,n2,Dig1,Dig2,Num2[3],l_up=25,l_dwn=0,dig_a,dig_b,dig_c;
char adc1=0;
bit U10=0,IR_1=0,IR_2=0,IR_S=0,L_ON;  
void PWM1(){

Timer_1++;

if (Timer_1==17){Timer_1=1;Timer_2++;} 

if (Timer_1<sig1[0][n2]){U1=1;}else{U1=0;} 
if (U1==1){PORTB|=0b00000001;} 
if (U1==0){PORTB&=~0b00000001;}

if (Timer_1<sig1[1][n2]){U1=2;}else{U1=3;} 
if (U1==2){PORTB|=0b00000010;} 
if (U1==3){PORTB&=~0b00000010;}

if (Timer_1<sig1[2][n2]){U1=4;}else{U1=5;} 
if (U1==4){PORTB|=0b00000100;} 
if (U1==5){PORTB&=~0b00000100;}

if (Timer_1<sig1[3][n2]){U1=6;}else{U1=7;} 
if (U1==6){PORTB|=0b00010000;}  
if (U1==7){PORTB&=~0b00010000;}

if (Timer_1<sig1[4][n2]){U1=8;}else{U1=9;} 
if (U1==8){PORTB|=0b00100000;}  
if (U1==9){PORTB&=~0b00100000;}

if (Timer_1<sig1[5][n2]){U1=10;}else{U1=11;} 
if (U1==10){PORTB|=0b01000000;}  
if (U1==11){PORTB&=~0b01000000;}

if (Timer_1<sig1[6][n2]){U1=12;}else{U1=13;} 
if (U1==12){PORTB|=0b10000000;} 
if (U1==13){PORTB&=~0b10000000;}

if (Timer_1<sig1[7][n2]){U1=14;}else{U1=15;} 
if (U1==14){PORTB|=0b00001000;} 
if (U1==15){PORTB&=~0b00001000;}

if (Timer_2>=U9){ 

for (U3=0;U3<=7;U3++){

if (U2[U3][n2]==1) {if(sig1[U3][n2]<l_up){sig1[U3][n2]=sig1[U3][n2]+1;}}
if (U2[U3][n2]==0) {if(sig1[U3][n2]>l_dwn){sig1[U3][n2]=sig1[U3][n2]-1;}else{sig1[U3][n2]=l_dwn;}}

}
Timer_2=0;}
}

void Dig_1(){
switch (Dig1){
case 1: {U2[3][n2]=1;break;}
case 2: {U2[6][n2]=1;break;}
case 3: {U2[6][n2]=1;U2[3][n2]=1;break;}
case 4: {U2[1][n2]=1;break;}
case 5: {U2[1][n2]=1;U2[3][n2]=1;break;}
case 6: {U2[1][n2]=1;U2[6][n2]=1;break;}
case 7: {U2[1][n2]=1;U2[6][n2]=1;U2[3][n2]=1;break;}
case 8: {U2[0][n2]=1;break;}
case 9: {U2[0][n2]=1;U2[3][n2]=1;break;}
case 10: {U2[0][n2]=1;U2[3][n2]=1;U2[6][n2]=1;U2[1][n2]=1;break;}
default: ;
}
}
void Dig_2(){
switch (Dig2){
case 1: {U2[4][n2]=1;break;}
case 2: {U2[2][n2]=1;break;}
case 3: {U2[4][n2]=1;U2[2][n2]=1;break;}
case 4: {U2[5][n2]=1;break;}
case 5: {U2[5][n2]=1;U2[4][n2]=1;break;}
case 6: {U2[2][n2]=1;U2[5][n2]=1;break;}
case 7: {U2[2][n2]=1;U2[5][n2]=1;U2[4][n2]=1;break;}
case 8: {U2[7][n2]=1;break;}
case 9: {U2[4][n2]=1;U2[7][n2]=1;break;}
case 11: {U2[4][n2]=1;U2[7][n2]=1;{U2[5][n2]=1;U2[2][n2]=1;break;}}
default: ;
}
}
void Dig_0(){

for (U3=0;U3<=7;U3++){U2[U3][0]=0;}
for (U3=0;U3<=7;U3++){U2[U3][1]=0;}
for (U3=0;U3<=7;U3++){U2[U3][2]=0;}
PORTB&=~0b11111111;

}

void U4M()
{
if (U4==0){DDRD|=0b10000000;DDRD&=~0b01100000;}
if (U4==1){DDRD|=0b00100000;DDRD&=~0b11000000;}
if (U4==2){DDRD|=0b01000000;DDRD&=~0b10100000;}
}

void null(){
dig_a=0,dig_b=0,dig_c=0,Timer_9=0;
}

void Parts(){
Num2[n2]=0;
if(Number[n2]<0){Number[n2]*=-1;}
while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
Dig1 = Number[n2];
Dig2 = Num2[n2];
}
void Parts1(){
Num2[n2]=0;
while (Number[n2] >= 10000){Number[n2] -= 10000;}
while (Number[n2] >= 1000){Number[n2] -= 1000;}
while (Number[n2] >= 100){Number[n2] -= 100;}
while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
Dig1 = Number[n2];
Dig2 = Num2[n2];
}

void Dig(){
if (PWM_Susp==0){
PWM1();
Timer_4++;
if (Timer_4==20){U4++;Timer_4=0;

if (U4==3){U4=0;}

Dig_0();
n2=U4;

U4M();
if (U8==0){ 
Number[0] = hour;
Number[1] = mins;
Number[2] = sec;
Parts();
}
if (U8==1){ 
Timer_9++;if (Timer_9==1){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==300){dig_a=7,dig_b=17,dig_c=47;};if (Timer_9==600){dig_a=0,dig_b=0,dig_c=0;};if (Timer_9==1200){dig_a=7,dig_b=57,dig_c=11;}if (Timer_9==2200){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==2400){Timer_9=0;U8=4;U9=10;}

Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
}
if (U8==2){
Number[n2]=Num2[n2]=0;
Parts();
}
if (U8==3){ 
Timer_9++;if (Timer_9==300){dig_a=0,dig_b=0;}if (Timer_9==600){Timer_9=0;U10=0,dig_a=7,dig_b=50;}

Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = adc1;
Parts();
}
if (U8==4){

Timer_9++;if (Timer_9==1){dig_a=rand();dig_b=rand();dig_c=rand();}if (Timer_9==300){Timer_9=0;}
Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts1();
;}
if (U8==5){

Timer_9++;if (Timer_9==100){dig_a=07;dig_b=57;dig_c=57;}if (Timer_9==400){if (PIND.3==1){dig_b=77;}if (PIND.2==1){dig_c=77;}Timer_9=0;}
Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
;}
if (U8==6){

Timer_9++;if (Timer_9==100){dig_a=hour_a1;dig_b=mins_a1;dig_c=sec_a1;}if (Timer_9==200){dig_a=hour_a2;dig_b=mins_a2;dig_c=sec_a2;}if (Timer_9==300){dig_a=0;dig_b=0;dig_c=80;Timer_9=0;}

Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
;}

Dig_1();
Dig_2();
}

}
}
void Time1(){

if (Clock_Susp==1){Check_1=0;}
if (Clock_Susp==0){Timer_3++;

if (Timer_3==Timefreq){
if(L_ON==1){Check_1++;};
if(L_ON==0){Check_1=10;};
Timer_3=0;}

if ((IR_S==1)&&(Timer_3==4000)){IR_S=0;}

if (Check_1==1){U8=5;U9=5;null();} 

if (Check_1==7){U8=2;U10=0;}
if (Check_1==10){PWM_Susp=1;U10=1;PORTD|=0b00010000;}
if (Check_1==40){PWM_Susp=0;U8=3;PORTD&=~0b00010000,U9=5;null();}
if (Check_1==50){Check_1=0;}

}
}

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|1;

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
adc1 = ADCH;
}

void IR(){
PORTD&=~0b00010000;
if (IR_2==1){                 
Timer1++;
if (PINC.0==0) {bit1++;}
if (PINC.0==1) {n++;n1[n]=bit1;Timer1=bit1=0;IR_2=0;} 

if (n==2){
if (n1[1]==n1[2]){

}
else{
IR_2=0;IR_Tr=n=0;
;}}

}

if (IR_1==1){

Timer1++;
if (PINC.0==0) {bit1++;}
if (PINC.0==1) {bit0++;}
if (Timer1==FreqT){
Timer1=0;
if (bit1>bit0){

bit1=bit0=0;

d=d<<1; 
d|=1;

}
if (bit0>bit1){

bit0=bit1=0;

d=d<<1; 
d&=~1;

}
shiftd++;

if ((shiftd==adress2)){d = 0;}       
if ((shiftd==adress3)){d1 = d;d=0;}
if ((shiftd==adress4)){d = 0;}

if ((shiftd>=adress7)){d3=d1+d2+d;   

IR_1=0;

if (d3==832){PORTD^=0b00000100;Bee=7;}
if (d3==864){PORTD^=0b00001000;Bee=7;} 
if (d3==840){L_ON^=1;Bee=10;}

d=d1=d2=d3=shiftd=bitEr0=bitEr1=0;

PORTD|=0b00010000;

IR_S=1;
}
}
}
}
void Beep (){
if (Bee>1){
Timer_7++;
if (Timer_7>=Bee){
Timer_7=0;
Timer_8++;
PORTC^=0b00000100;
}
if (Timer_8>120){
Timer_8=Bee=0;
PORTC&=~0b00000100;
}
}
}
interrupt [10] void timer0_ovf_isr(void)
{
IR();
if (IR_1==0){
Dig();
Time1();
Beep();
}
}
interrupt [9] void timer1_ovf_isr(void)
{

}

void main(void)   
{

PORTB=0x00;
DDRB=0xff;
PORTC=0b00000000;
DDRC=0b11111100;
PORTD=0b00000000;
DDRD=0b11111100;
TCCR0=0x01;

TIMSK|=0x01; 

ACSR=0x80;
ADMUX=0b00000001;
ADCSRA=0x84;

#asm("sei")

while (1)
{

if ((U8==3)&&(U10==0)){
adc1 = 255-62-read_adc(1);
U10=1;
}

if ((PINC.0==0)&&(PWM_Susp==1)&&(IR_S==0))
{
IR_1=1;

}

}
}
