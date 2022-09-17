//***********************************************************************
// ************** SOURCE FILE PWM_main.c *****************
//***********************************************************************

//*********************************************************************
// Initializing functions for ports, timer0 & timer1
//********************************************************************* 
#include <mega8.h>
void port_init(void)
{
PORTB = 0x00; 
DDRB = 0x06; //PWM pins OC1A & OC1B defined as outputs
PORTC = 0x00; 
DDRC = 0x20; //LED for IR detection indication
PORTD = 0x00; 
DDRD = 0x01; //LED, for testing purpose
}

//timer0 init
void timer0_init(void)
{
//8-bit timer for measuring delay between IR pulses
TCCR0 = 0x03; //CLK / 64
TCNT0 = 0; //reset the timer
}

//TIMER1 initialize - prescale:1
//PWM Frequency: 1KHz
void timer1_init(void)
{
TCCR1B = 0x00; //stop
TCNT1H = 0xFC; //setup
TCNT1L = 0x18;
OCR1A = COUNTER_LOWER_LIMIT;
OCR1B = COUNTER_LOWER_LIMIT;
ICR1H = 0x03;
ICR1L = 0xE8;
}
