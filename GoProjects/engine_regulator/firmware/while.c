//while:


#include "pwm.c";
//och=155;


if (Timer_2==0){

adc[0]=read_adc(0)/20;


if (adc[0]<=0){adc[0]=1;}
if (adc[0]>=255){adc[0]=255;}
freq=adc[0];
//och=7812/adc[0]*10;
//if ()
//och=256-31250/(freq*40*4);
//och=39;
och=1000000/(freq*PWM_wide*4)-1;
//och=249;
//och=8000000/(freq*PWM_wide*4)-1;
//och=1999;
}



//freq=adc[0];


if(och>>8==0){
    if (OCR1AL!=och & 0xff){
    Timer_reset();
    }
}
if(och>>8!=0){
   if ((OCR1AL!=och & 0xff)&&(OCR1AH!=och>>8)){
   Timer_reset();
   } 
}



if (Timer_2==1){
adc[1]=read_adc(1);
adc[2]=read_adc(2)/102;

lcd_gotoxy(0,0);
lcd_clear(); 
lcd_putsf("freq:");
sprintf(lcd_buffer,"% i",adc[0]);
lcd_puts(lcd_buffer);

lcd_gotoxy(8,0);
lcd_putsf("CO2:");
sprintf(lcd_buffer,"% i",adc[1]);  
lcd_puts(lcd_buffer);
}
if(Timer_2==2){
Timer_2=0;
}


