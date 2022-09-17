//unsigned char Dig[20],DisOther,Num3,Num2,Disp6,Disp7,Timer_3;
// Timer 0 overflow interrupt service routine
unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch,LCD_switch1;
unsigned int adc[6],Time_sec;

float Voltage2,Temp,SetVoltage,VoltPower,VoltBat1,VoltBat2,VoltBat3,VoltBat4;
float Voltage2_old,Time;
char Voltage2_str[20],Temp_str[20],SetVoltage_str[20],VoltPower_str[20],Time_str[20],VoltBat1_str[20],VoltBat2_str[20],VoltBat3_str[20],VoltBat4_str[20];

unsigned char now_is_charge,now_is_discharge;
float Time;
unsigned char Timer_allPWM;

char *_off;
char *_charPIN;
unsigned char pressed_PIND_0,pressed_PIND_1;

#include <buzzer.c>

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
//LCD_switch1++;
//if (LCD_switch1==5){
//LCD_switch++;
//LCD_switch1=0;

//if (LCD_switch>=2){LCD_switch=0;}
//}


// Place your code here
Time_sec++;
PORTD^=0b01000000;

}
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
//allPWM();




if (PIND.6==0){buzzer(10,10,3);};


Timer_read_adc_1++;
if(Timer_read_adc_1==100){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}

//берем параметры
if(Timer_read_adc_2==5){
adc[0]=read_adc(0);//чтение температуры
}if(Timer_read_adc_2==10){
adc[1]=read_adc(1);//чтение батареи
}if(Timer_read_adc_2==15){
adc[2]=read_adc(2);//чтение батареи
}if(Timer_read_adc_2==20){
adc[3]=read_adc(3);//чтение батареи
}if(Timer_read_adc_2==25){
adc[4]=read_adc(4);//чтение батареи
}if(Timer_read_adc_2==30){
adc[5]=read_adc(5);//чтение батареи
}if(Timer_read_adc_2==35){

Temp=adc[0]/102.4;
Voltage2=adc[1]/18.7;
SetVoltage=adc[2]/18.7;
VoltPower=adc[3]/200.0;
//if ()

if (Voltage2!=Voltage2_old){
    if (Voltage2_old>Voltage2){
    now_is_charge=0;
    now_is_discharge=1;
    //Volt_diff= Voltage2-Voltage2_old;
    }
    if (Voltage2_old<Voltage2){
    now_is_charge=1;
    now_is_discharge=0;
    //Volt_diff= Voltage2_old-Voltage2;
    }
    Time=((Time_sec*(SetVoltage-Voltage2))/(Voltage2-Voltage2_old))/60;
    Time_sec=0;
    Voltage2_old=Voltage2;
}

//отображение


if (LCD_switch==0){
lcd_clear();
lcd_gotoxy(0,0);
//sprintf(Temp_str, "t:%.2f", Temp);}
sprintf(Voltage2_str, "%.2fV", Voltage2);
sprintf(SetVoltage_str, " %.2fV", SetVoltage);
sprintf(VoltPower_str, "I:%.2fA", VoltPower);
sprintf(Time_str, " %.2fm", Time);


lcd_puts(Voltage2_str);   // Выводим строку _str на дисплей ЖКИ
lcd_puts(SetVoltage_str);   // Выводим строку _str на дисплей ЖКИ
lcd_gotoxy(0,1);
lcd_puts(VoltPower_str);
//if (Temp!=0){
//lcd_puts(Temp_str);}   // Выводим строку _str на дисплей ЖКИ
lcd_puts(Time_str);  
//lcd_gotoxy(0,1);
//lcd_putsf(" Time:");
//lcd_puts(_data[1]);
}



if (LCD_switch==1){
lcd_clear();
lcd_gotoxy(0,0);
VoltBat1=5.0-adc[0]/204.6;
VoltBat2=5.0-adc[4]/204.6;
VoltBat3=5.0-adc[5]/204.6;
VoltBat4=5.0-adc[5]/204.6;
//off[2]=1;
//if (VoltBat1>4.1){on[2]--;}
//if (VoltBat1<4.0){on[2]++;}


sprintf(VoltBat1_str, "B1:%.2fV", VoltBat1);
sprintf(VoltBat2_str, "B2:%.2fV", VoltBat2);
sprintf(VoltBat3_str, "B3:%.2fV", VoltBat3);
sprintf(VoltBat4_str, "B4:%.2fV", VoltBat4);


lcd_puts(VoltBat1_str);
lcd_puts(VoltBat2_str);
lcd_puts(VoltBat3_str);
lcd_puts(VoltBat4_str);

//itoa(on[2], _off);
//lcd_putsf("On");
//lcd_puts(_off);

//itoa(PIND.0, _charPIN);
//lcd_puts(_charPIN);
//lcd_putsf(off[2]);
//Timer_read_adc_2=0;
}

Timer_read_adc_2=0;   // Выводим строку _str на дисплей ЖКИ 




}
if ((PIND.0==0)&&(pressed_PIND_0==0)){
on[2]++;
pressed_PIND_0=1;
}
if ((PIND.1==0)&&(pressed_PIND_1==0)){
pressed_PIND_1=1;
on[2]--;
}
if (PIND.0==1){pressed_PIND_0=0;}
if (PIND.1==1){pressed_PIND_1=0;}

PORTD|=0b00000100;
}
// Place your code here
/*
Timer_3++;
if (Timer_3==1){//первая цифра
PORTC&=~0b00000100;
PORTC|=0b00001000;
PORTB=Disp6-Dis1;}
if (Timer_3==100){//вторая цифра
PORTC&=~0b00001000;
PORTC|=0b00000100;
PORTB=Disp7-Dis2;
}
if (Timer_3==200){Timer_3=0;}
//Timer_8++
*/
//}














/*
void Dig_init() //Массив для отображения цифр на семисегментном индикаторе
{          //ABCDEFG DP
  Dig[0] = 0b00000011;
  Dig[1] = 0b10011111;
  Dig[2] = 0b00100101;
  Dig[3] = 0b00001101;
  Dig[4] = 0b10011001;
  Dig[5] = 0b01001001;
  Dig[6] = 0b01000011;
  Dig[7] = 0b00011111;
  Dig[8] = 0b00000001;
  Dig[9] = 0b00001001;
  Dig[10]= 0b01001001;//s
  Dig[11]= 0b00110001;//p
  Dig[12]= 0b01100011;//C
  Dig[13]= 0b00001111;//C
  Dig[14]= 0b11001111;//u
  Dig[15]= 0b11100111;//u
  Dig[16]= 0b00000001;//.
}
void Display (unsigned int Number) //Ф-ция для разложения десятичного цисла
{
if (DisOther==0){
  Num2=0, Num3=0;
    while (Number >= 10)
  {
    Number -= 10;  
    Num3++; 
  }
  Num2 = Number;
 }

  Disp6 = Dig[Num3];
  Disp7 = Dig[Num2];
}
*/