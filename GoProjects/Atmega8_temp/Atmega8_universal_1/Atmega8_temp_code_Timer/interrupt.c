//unsigned char Dig[20],DisOther,Num3,Num2,Disp6,Disp7,Timer_3;
// Timer 0 overflow interrupt service routine
unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch=1,Timer_LCD,Time_one_sec;
unsigned int adc[6];

float Temp=99.9,STemp,Temp_min=99.9;
//float Voltage2_old,Time;
char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20];

//unsigned char now_is_charge,now_is_discharge;
unsigned int Time_sec_all,Time,Time_sec,Time_min,Time_hour;

//for IR
unsigned char Startsomedelay,delayneed,Timer_IR,Timer_IR_Start,count1bit,devider,start_devider;
unsigned int databits,show_data; 
#include <buzzer.c>
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here

}
interrupt [TIM1_OVF] void timer1_ovf_isr(void){




// Place your code here
if (PIND.5==1){
Time_one_sec++;
    if (Time_one_sec==2){
    Time_sec_all++;
    Time_one_sec=0;
    }
}
//
}
interrupt [TIM1_COMPA] void timer1_compa_isr(void){
//  TCNT1H=0;
//  TCNT1L=0;                                                                           

//TCNT1H=0xE1;
//TCNT1L=0x7A;

TCNT1H=0xFF-0x1E;  //65536-32768 таймер начинает счет с половины. т.е. делит все пополам
TCNT1L=0xFF-0x83;
OCR1AH=0x1E;  //7813    когда таймер достчитает до до этой цифры, будет 1 сек
OCR1AL=0x83;

PORTD^=0b00001000;

  //ststus lamp

}
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
//PORTD^=0b01000000;
TCNT0=0xFF-0x22;
#include <IR.c>
//allPWM();









Timer_LCD++;
Timer_read_adc_1++;
if(Timer_read_adc_1==50){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}


if (Temp<STemp){
PORTD|=0b00100000;
}
if (Temp>STemp){
PORTD&=~0b00100000;
}
if ((Temp<Temp_min)&&(Temp!=0.00)){
Temp_min=Temp;
}


if (Timer_LCD==250){
//отображение


if (LCD_switch==0){




//lcd_puts(Time_str);
}
/////////////////////////////////////////////////////////////////////
if (LCD_switch==1){



}
Timer_LCD=0;
}
}