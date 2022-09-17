//********************************************************
// *********** PWM DC MOTOR CONTROL with IR *************
//********************************************************
//Controller: ATmega8 (1MHz internal Crystal)
//Compiler:   ICCAVR
//Author:     CC Dharmani, Chennai(India)
//Date:       Dec 2008
//********************************************************
//this program uses two of the three PWM channels (OC1A & OC1B)
//of the ATmega8, for controlling speed & direction of DC motor
//The remote of Sony TV was used for sending IR codes


//***********************************************************************
// ************** HEADER FILE PWM_main.h *****************
//***********************************************************************

#define DIRECTION_FORWARD !(PIND & 0x20)
#define DIRECTION_REVERSE (PIND & 0x20)
#define STOP_MOTOR TCCR1B = 0x00; TCCR1A = 0x00
#define START_MOTOR TCCR1B = 0x09
#define set_FORWARD TCCR1A = 0x81
#define set_REVERSE TCCR1A = 0x21
#define ENABLE_INT0 GICR |= 0x40
#define DISABLE_INT0 GICR &= ~0x40

//defining macros for setting minimum and maximum PWM counter values�
//���������� ��������� � �������� ��� ��������
//and step-size for controlling the voltage applied to MOSFETs base
#define COUNTER_LOWER_LIMIT 0x0070
#define COUNTER_UPPER_LIMIT 0x00f8
#define STEP_SIZE 0x0008


void port_init(void);
void timer0_init(void);
void timer1_init(void);
unsigned int read_IR (void);
void motorControl (unsigned char code, unsigned char address);
void init_devices(void);
void delay_ms(int miliSec);
//#include <iom8v.h>
//#include <macros.h>
#include <PWM_main.h>
#include <mega8.h>

/**************************************************************************
* Interrupt Service Routine for INT0
* Executed whenever a remote code is detected
**************************************************************************/
//#pragma interrupt_handler int0_isr:2  //���. �����
void int0_isr(void)                   //�������
{ 
unsigned char count, code, address;
unsigned int IR_input;

TCNT0 = 0;                            //������ - ����.
while(!(PIND & 0x04));                //����, � �����
count = TCNT0;

if(count < 30) //to verify start pulse (2.4 ms long)
{
delay_ms(20); 
ENABLE_INT0;
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

//*********************************************************************
//Function to read IR message from the detector
//Return value contains code in upper byte and address in lower byte
//********************************************************************* 
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

//****************************************************************************
//Function to control motor speed & direction depending onthe IR code rceived
//Argumets are the code and address values received from IR detector
//**************************************************************************** 
void motorControl (unsigned char code, unsigned char address)
{
static unsigned char counter, dir, dir1;

if (address != 1) //detect only TV remote, other signals rejected
return;

if((code == 16) || (code == 17)) //Channel+ or Channel- button is pressed
{ 
if(code == 16) //Channel+
dir = 0;
else //Channel-
dir = 1;

if(dir != dir1) //change direction
{
STOP_MOTOR;
delay_ms(500);

if(dir == 0)
set_FORWARD;
else
set_REVERSE;

START_MOTOR;
dir1 = dir;
} 
} 

if(code == 18) //Volume- button pressed
{
if(counter >= COUNTER_UPPER_LIMIT) //if speed is already maximum, don't do anything
counter = COUNTER_UPPER_LIMIT;
else 
counter += STEP_SIZE; //increase speed by a fixed step

OCR1A = counter;
OCR1B = counter;
}

if(code == 19) //Volume+ button pressed
{
if(counter <= COUNTER_LOWER_LIMIT) //if speed is already minimum, don't do anything
counter = COUNTER_LOWER_LIMIT;
else 
counter -= STEP_SIZE; //reduce speed by a fixed step

OCR1A = counter;
OCR1B = counter;
}

if(code == 9) //'0' button pressed
{
OCR1A = COUNTER_LOWER_LIMIT;
OCR1B = COUNTER_LOWER_LIMIT;
STOP_MOTOR; 
}

if(code == 0) //'1' button pressed
{
OCR1A = COUNTER_LOWER_LIMIT;
OCR1B = COUNTER_LOWER_LIMIT;

TCCR1A = 0x81;
START_MOTOR; 
}
}

//************************************************************
//*** call this routine to initialize all peripherals
//************************************************************
void init_devices(void)
{
//stop errant interrupts until set up
#asm("CLI"); //disable all interrupts
port_init();
timer0_init();
timer1_init();

MCUCR = 0x02;
GICR = 0x40;
TIMSK = 0x00; //timer interrupt sources
#asm ("SEI"); //re-enable interrupts
//all peripherals are now initialized
}

//************************************************************
//***** FUNCTION FOR SOFTWARE DELAY OF 1 mSEC (appx.) ******* 
//************************************************************
void delay_ms(int miliSec) //for 1 Mhz crystal
{
int i,j;

for(i=0;i<miliSec;i++)
for(j=0;j<100;j++)
{
#asm("nop");
#asm("nop");
}
}

//*******************************************************
// ************ MAIN FUNCTION *************
//******************************************************* 
void main(void)
{
init_devices();

while(1); //infinite loop, waiting for interrups from IR detector
}
