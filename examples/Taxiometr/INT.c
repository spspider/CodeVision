//interrupt #include <INT.c>

unsigned char adc[5];
unsigned int Timer1,Timer4,Timer5,Timer7;
unsigned char Timer2,Timer6,Timer3,interval,cl[5],temp,sw=0,data;
char *adc_c[5];
unsigned char a,pulse_ok=0,buzzer,ready_adc_2=0;

unsigned int previous_value[4];


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
Timer1++;
if (Timer1==1000){
Timer1=0;a=1;
sw++;
if (sw==2){sw=0;}


#include <count1000.c> 
}
#include <count_TIM0_OVF.c> 

}