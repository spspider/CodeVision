void Time1(){
//Timer_5++;
//if (Timer_5==3000){Timer_5=0;}
  
//приостановка таймера, если услышан сигнал IR
if (Clock_Susp==1){Check_1=0;}
if (Clock_Susp==0){Timer_3++;

if (Timer_3==Timefreq){
if(L_ON==1){Check_1++;};
if(L_ON==0){Check_1=10;};
Timer_3=0;}


if ((IR_S==1)&&(Timer_3==4000)){IR_S=0;}

//U8=3;
//if (Check_1==10){U8=1;U9=7;null();} // включение Sp, затем эффект U8=4
//if (Check_1==45){U8=4;U9=15;null();} // включение ...
if (Check_1==1){U8=5;U9=5;null();} // включение проверки выключателей
//if (Check_1==5){U8=6;U9=5;null();} // включение будильник
//if (Check_1==15){U8=0;U9=5;null();} // включение времени
if (Check_1==7){U8=2;U10=0;}//выключение ламп
if (Check_1==10){PWM_Susp=1;U10=1;PORTD|=0b00010000;}// включение ИК
if (Check_1==40){PWM_Susp=0;U8=3;PORTD&=~0b00010000,U9=5;null();}// выключение ИК, включение температуры
if (Check_1==50){Check_1=0;}

/*
if (sec==59){sec=0;mins++;}
if (mins==59){mins=0;hour++;}
if (hour>=23){hour=1;}

if (hour>=22){l_up=10;}
if ((hour>=11)&&(hour<22)){l_up=25;}
*/
}
}