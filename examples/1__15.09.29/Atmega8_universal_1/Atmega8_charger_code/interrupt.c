//unsigned char Dig[20],DisOther,Num3,Num2,Disp6,Disp7,Timer_3;
// Timer 0 overflow interrupt service routine
unsigned char Timer_read_adc_1,Timer_read_adc_2,Temp1,_str,*_data[5],Timer_buzzer_1,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,Voltage1;
unsigned int adc[5];
float Voltage2;
void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){
if (time>0){
Timer_buzzer_active_1++;
if (Timer_buzzer_active_1>250){//длинна бузера
Timer_buzzer_active++;
Timer_buzzer_active_1=0;
}

if(Timer_buzzer_active<time){
    Timer_buzzer_signal++;
    if (Timer_buzzer_signal==freq){//частота бузера
    PORTD^=0b10000000;
    Timer_buzzer_signal=0;
    }
Timer_buzzer_silence=0;
}
if(Timer_buzzer_active>time){
    Timer_buzzer_silence_1++;
    if(Timer_buzzer_silence_1>250){
    Timer_buzzer_silence_1=0;
    Timer_buzzer_silence++;
    }
    PORTD&=~0b10000000;
        if(Timer_buzzer_silence>time){
            if (repeat>0){
            Timer_buzzer_active=0;
            }
            repeat--;
            if (repeat==0){
            time=0;freq=0;
            }
        }
    }
}
}


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
if (PIND.6==0){buzzer(10,10,3);};
Timer_read_adc_1++;
if(Timer_read_adc_1==255){
Timer_read_adc_2++;
Timer_read_adc_1=0;
}
/*
if(Timer_read_adc_2==10){lcd_clear();}
if(Timer_read_adc_2==15){adc[0]=read_adc(0);}//чтение батареи
if(Timer_read_adc_2==25){Voltage1=adc[0]/204;}
if(Timer_read_adc_2==35){Voltage2=adc[0]/2.048;}
if(Timer_read_adc_2==45){itoa(Voltage1, _data[0]);}
if(Timer_read_adc_2==55){itoa(Voltage2, _data[1]);lcd_gotoxy(0,0);}
if(Timer_read_adc_2==60){lcd_putsf("bat:");}
if(Timer_read_adc_2==70){lcd_puts(_data[0]);lcd_putsf(",");lcd_puts(_data[1]);}   // Выводим строку _str на дисплей ЖКИ 
if(Timer_read_adc_2==80){lcd_gotoxy(7,0);}
if(Timer_read_adc_2==100){lcd_putsf("Time:");}
if(Timer_read_adc_2==110){lcd_puts(_data[1]);Timer_read_adc_2=0;}   // Выводим строку _str на дисплей ЖКИ 
*/
if(Timer_read_adc_2==25){
lcd_clear();
adc[0]=read_adc(0);//чтение батареи
Voltage1=adc[0]/204;
Voltage2=adc[0]/2.048;
itoa(Voltage1, _data[0]);}
if(Timer_read_adc_2==100){
itoa(Voltage2, _data[1]);
lcd_gotoxy(0,0);
lcd_putsf("bat:");
lcd_puts(_data[0]);lcd_putsf(",");lcd_puts(_data[1]);   // Выводим строку _str на дисплей ЖКИ 
lcd_gotoxy(7,0);
lcd_putsf("Time:");
lcd_puts(_data[1]);Timer_read_adc_2=0;   // Выводим строку _str на дисплей ЖКИ 

}
//}
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
}














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