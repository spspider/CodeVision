/*******************************************************
This program was created by the
CodeWizardAVR V3.10 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : solder station
Version : 
Date    : 13.02.2016
Author  : 
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
//#define HEAT_U PORTD 
#include <delay.h>
#include <stdio.h>
// Alphanumeric LCD functions
#include <alcd.h>
#include <eeprom.h>

// Declare your global variables here
char lcd_buffer[33],lcd_stateU,lcd_stateB,choose[13];
unsigned char Timer_1,Timer_2;
bit BTN3_pressed;
//////////////////////////
eeprom unsigned char PWM_setted_eeprom[2]={1,1};
unsigned char PWM_setted[2]={1,1};
unsigned char PWM_width=10;
//////////////////////////
int now_tempU=0,now_tempB=0;
//unsigned int set_tempB_prev,set_tempU_prev;
unsigned char show_lcd=3,t_sec=0,t_min=0,t_hour=0,port,PWM_step[2],heater_on[2],sec_heat[2],lcd_switcher=1,BTN1_pressed,lcd_freeze,heater_swither=3,start=0,start_BT=0;
unsigned int sec_profile[2],sec_profile_off[2];
int now_tempB_prev=0,now_tempU_prev=0;
//unsigned char Timer_freq_buzz;

//#define HUport 1<<PORTD2;
//int POWER_H_U;
//int POWER_H_B;
unsigned char k=0;
//buzzer:
unsigned char buzz_freg=0,buzz_cont=0;

//heater:
unsigned char BTN_pressed=0,Timer_BTN_Pressed=0;
unsigned char Timer_1sec=0;
//t_profile
unsigned char heat_approved[2]={0,0};
unsigned char  Heat_time_timer_enabler=0,Heat_time[4],Heat_rule[4],Heat_time_timer=0;
unsigned char  count_rules=0,now_rule=0,rule_engadged=0,rule_end=0,set_now_rule=0;
unsigned int Heat_temp_U[4],Heat_temp_B[4];
unsigned char Heat_speed[4],Heat_speed_B;
eeprom unsigned int Heat_temp_U_eeprom[4],Heat_temp_B_eeprom[4];
eeprom unsigned char Heat_speed_eeprom[4],Heat_speed_B_eeprom;
unsigned char i;
unsigned int sec_start_heat[2];

unsigned char freq=111;//Tocr=(1/Tn)*8000000/1024=Tocr=(100/Tn)*78= от31 до 3906
bit compliteU=0;
bit compliteB=0;
int  now_tempB_calc,now_tempU_calc;
//float TCnt_0=70.0;
//sec_iterrupt
float heat_koeff_B =-0.01,heat_koeff_U=-0.01,PWM_koeff[2]={1.0,1.0};
//float heat_koeff_B_profile=-0.01;
int forecast_temp_U=0,forecast_temp_B=0;
//unsigned int heat_koeff_int =0;
//while
unsigned int t_sec_least=0.0;
unsigned char t_min_least=0,t_hour_least;
unsigned char t_power_change_up[2],t_power_change_down[2];

unsigned int koeff_b_int,koeff_u_int;

int heat_k_B_int;
int heat_k_U_int;
void choose_v(char i){

    for (k=0;k<13;k++){
    choose[k]=*" ";
    }
    choose[i]=*">";
}



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=0x00;
// Place your code here

#include <heater.c>;
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0xD8F0 >> 8;//10ms
TCNT1L=0xD8F0 & 0xff;

//TCNT1H=0xCF2C >> 8;//100ms
//TCNT1L=0xCF2C & 0xff;//100ms
// Place your code here
#include <sec_interrupt.c>
}
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0x06;//500Hz
#include <buzzer.c>;    
// Place your code here

}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(100);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}



void main(void)
{

#include <onload.c>;
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x70;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 10 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0xD8;
TCNT1L=0xF0;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 0.664 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0xAD;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 3
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);


//if (set_tempU_eep==255){set_tempB=180;}

// Global enable interrupts
#asm("sei")

while (1)
      {
#include <while.c>;
#include <t_profile.c>;
#include <button_while.c>;

  
      
      
      // Place your code here

      }
}
