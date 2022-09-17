//unsigned char Dig[20],DisOther,Num3,Num2,Disp6,Disp7,Timer_3;
// Timer 0 overflow interrupt service routine
unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch=1,Timer_LCD,Time_one_sec,start_delay_switch,delay_switch,is_on;
unsigned int adc[6];

//float Voltage2_old,Time;
char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20],_CO_sensor[20];

//unsigned char delay_start,delay_start_timer;
unsigned int Time_sec_all,Time,Time_sec,Time_min,Time_hour;

//for IR
unsigned char Startsomedelay,delayneed,Timer_IR,Timer_IR_Start;
unsigned int databits,show_data; 
#include <buzzer.c>
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here

}
// Timer 2 overflow interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
// Place your code here
ASSR=0x00;
TCCR2=0x01;
TCNT2=0x00;
OCR2=0x22;

}

interrupt [TIM1_COMPA] void timer1_compa_isr(void){
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
delay_switch=0;
start_delay_switch=1;
is_on=1;
}
if (Temp>STemp){
delay_switch=0;
start_delay_switch=1;
is_on=0;
}
if (start_delay_switch==1){
delay_switch++;
}
if (delay_switch==20){
    if (is_on==0){
    PORTD&=~0b00100000;
    }
    if (is_on==1){
    PORTD|=0b00100000;
    }
    start_delay_switch=0;

}

if (EEPromIn==1){
STempEE=STemp*100.00;
EEPromIn=0;
}

// Place your code here
if (PIND.5==1){
Time_one_sec++;
    if (Time_one_sec==2){
    Time_sec_all++;
    Time_one_sec=0;
    }
}

  //ststus lamp

}
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=0x00;
//#include <IR.c>
//allPWM();

Timer_LCD++;
Timer_read_adc_1++;
if(Timer_read_adc_1==50){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}


}