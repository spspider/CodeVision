#include <mega8.h>
#include <delay.h>
int Timer_1=0,Timer_2,Timer_4,U1=0,U2[8],sig1[8],U3=0,U4=0,U5=0,U6=0;
long int Timer_3=0;

void Time(){
//Timer_3++;

Timer_3++;
if (Timer_3==10000){U2[0]=1;}
if (Timer_3==20000){U2[1]=1;}
if (Timer_3==30000){U2[2]=1;}
if (Timer_3==40000){U2[0]=U2[1]=U2[2]=0;Timer_3=0;}
}
// Timer 1 output compare A interrupt service routine
void PWM2(){
Time();

Timer_1++;
if (Timer_1==20){Timer_1=1;Timer_2++;} //скорость обновления PWM модулирования, значение меняется с частотой

if (Timer_1<sig1[0]){U1=1;}else{U1=0;} // sig1 + задержка драйвер для лампы 0 - значение 1й переменной
if (U1==1){PORTC|=0b00000100;}
if (U1==0){PORTC&=~0b00000100;}

if (Timer_1<sig1[1]){U1=2;}else{U1=3;} // sig1 + задержка
if (U1==2){PORTC|=0b00001000;}
if (U1==3){PORTC&=~0b00001000;}

if (Timer_1<sig1[2]){U1=4;}else{U1=5;} // sig1 + задержка
if (U1==4){PORTC|=0b00010000;}
if (U1==5){PORTC&=~0b00010000;}

if (Timer_2==5){ //скорость затухания

for (U3=0;U3<3;U3++){
if (U2[U3]==1) {if(sig1[U3]<20){sig1[U3]=sig1[U3]+1;}}
if (U2[U3]==0) {if(sig1[U3]>0){sig1[U3]=sig1[U3]-1;}}
}
Timer_2=0;}
}


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
Timer_4++;
if (Timer_4==400){PORTC^=0b00000010;Timer_4=0;}
}


interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
PWM2();
}

// Declare your global variables here

void main(void)
{
PORTB=0x00;
DDRB=0xff;
//PORTC=0b00100000;
DDRC=0xFF;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x02; // Clock value: 1000,000 kHz
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
TCCR2=0x02; //включение 2-го тайера 1000

TCNT2=0x00;
OCR2=0x00;
MCUCR=0x00;

TIMSK|=0x01; //  for TIM0
TIMSK|=0x40;// for TIM2
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
  // Place your code here
 //PWM1();
 
 };
}
