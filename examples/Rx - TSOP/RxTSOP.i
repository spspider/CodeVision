
void port_init(void);
void timer0_init(void);
void timer1_init(void);
unsigned int read_IR (void);
void motorControl (unsigned char code, unsigned char address);
void init_devices(void);
void delay_ms(int miliSec);

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

void port_init(void)
{
PORTB = 0x00; 
DDRB = 0x06; 
PORTC = 0x00; 
DDRC = 0x20; 
PORTD = 0x00; 
DDRD = 0x01; 
}

void timer0_init(void)
{

TCCR0 = 0x03; 
TCNT0 = 0; 
}

void timer1_init(void)
{
TCCR1B = 0x00; 
TCNT1H = 0xFC; 
TCNT1L = 0x18;
OCR1A = 0x0070;
OCR1B = 0x0070;
ICR1H = 0x03;
ICR1L = 0xE8;
}

void int0_isr(void)                   
{ 
unsigned char count, code, address;
unsigned int IR_input;

TCNT0 = 0;                            
while(!(PIND & 0x04));                
count = TCNT0;

if(count < 30) 
{
delay_ms(20); 
GICR |= 0x40;
return;
}

PORTC |= 0x20;

IR_input = read_IR ();

code = (unsigned char) ((IR_input & 0xff00) >> 8);
address = (unsigned char) (IR_input & 0x00ff);

motorControl ( code, address );

PORTC &= ~0x20;
delay_ms(250);

}

unsigned int read_IR (void)
{
unsigned char pulseCount=0, code = 0, address = 0, timerCount;
unsigned int IR_input;

while(pulseCount < 7)
{
while(PIND & 0x04);
TCNT0 = 0;

while(!(PIND & 0x04));
pulseCount++;

timerCount = TCNT0;

if(timerCount > 14)
code = code | (1 << (pulseCount-1));
else
code = code & ~(1 << (pulseCount-1)); 
}

pulseCount = 0;
while(pulseCount < 5)
{
while(PIND & 0x04);
TCNT0 = 0;

while(!(PIND & 0x04));
pulseCount++;

timerCount = TCNT0;

if(timerCount > 14)
address = address | (1 << (pulseCount-1));
else
address = address & ~(1 << (pulseCount-1)); 
}

IR_input = (((unsigned int)code) << 8) | address;

return(IR_input);
}

void motorControl (unsigned char code, unsigned char address)
{
static unsigned char counter, dir, dir1;

if (address != 1) 
return;

if((code == 16) || (code == 17)) 
{ 
if(code == 16) 
dir = 0;
else 
dir = 1;

if(dir != dir1) 
{
TCCR1B = 0x00; TCCR1A = 0x00;
delay_ms(500);

if(dir == 0)
TCCR1A = 0x81;
else
TCCR1A = 0x21;

TCCR1B = 0x09;
dir1 = dir;
} 
} 

if(code == 18) 
{
if(counter >= 0x00f8) 
counter = 0x00f8;
else 
counter += 0x0008; 

OCR1A = counter;
OCR1B = counter;
}

if(code == 19) 
{
if(counter <= 0x0070) 
counter = 0x0070;
else 
counter -= 0x0008; 

OCR1A = counter;
OCR1B = counter;
}

if(code == 9) 
{
OCR1A = 0x0070;
OCR1B = 0x0070;
TCCR1B = 0x00; TCCR1A = 0x00; 
}

if(code == 0) 
{
OCR1A = 0x0070;
OCR1B = 0x0070;

TCCR1A = 0x81;
TCCR1B = 0x09; 
}
}

void init_devices(void)
{

#asm("CLI"); 
port_init();
timer0_init();
timer1_init();

MCUCR = 0x02;
GICR = 0x40;
TIMSK = 0x00; 
#asm ("SEI"); 

}

void delay_ms(int miliSec) 
{
int i,j;

for(i=0;i<miliSec;i++)
for(j=0;j<100;j++)
{
#asm("nop");
#asm("nop");
}
}

void main(void)
{
init_devices();

while(1); 
}
