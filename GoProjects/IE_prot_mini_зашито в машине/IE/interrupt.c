unsigned char disable_count=0,mini_stand_by,Count=0,alarm=0,Timer_1,Timer_2,Count_1,
pressed,Timer_wrong_pressed_enable,Timer_3,Timer_6,delay_after_alarm,Timer_4_ext,Timer_4,
shadow=0,Timer_signal_sinus,Timer_signal_sinus_enabled,alarm_recieved,
Count_this_event=0;
unsigned int stand_by=0, Timer_wrong_pressed,Timer_if_long_pressed;
//unsigned int voltage,Show_voltage;
//unsigned char Show_voltage_start,Timer_end_show_voltage;
//unsigned char U1,U3,U2[2],current_level[2],Timer_4;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
//PORTD=0b00010000;

if ((disable_count==0)&&(alarm==0)&&(Count==0)&&(stand_by==0)&&(Timer_wrong_pressed_enable==0)){
Timer_4_ext++;
if (Timer_4_ext==200){
Timer_4++;}
if (Timer_4>=10){
    PORTD^=0b00100001;
    Timer_4=0;

}

//?????????? ??????? ?? ????? PIND.3
if ((PIND.3==0)&&(stand_by==0)&&(Count_this_event<3)){  //?? ????? ????, ?? ???????, ? ???? ?? ?????? 2?
Count_this_event++;
alarm=1;       //??????
shadow=1;
Count=0;
stand_by=20000;//????????
//power off
}
if ((Count_this_event>=2)&&(PIND.3==1)){
shadow=0;
Count_this_event=0;}

}

 



if ((Timer_wrong_pressed>6000)&&(stand_by==0)){
PORTD&=~0b00100000;

disable_count=Count=Timer_wrong_pressed=0;
Timer_wrong_pressed_enable=0;
}

if (Timer_wrong_pressed_enable==1){
Timer_wrong_pressed++;
}
////////////////////

//PORTD^=0b00000001;
////////////////////
if (PIND.2==1){        
Timer_signal_sinus=0;
Timer_signal_sinus_enabled=1;
//alarm_recieved=1;
alarm_recieved=0;


if ((alarm==0)&&(stand_by==0)){
    Timer_if_long_pressed++;
        if (Timer_if_long_pressed>2000){//???? ????????????????? ????? 2000 ??????????
        PORTD|=0b00100000;
        Count=0;
        alarm=1;
        stand_by=10;
        }
    }
}

if(Timer_signal_sinus_enabled==1){Timer_signal_sinus++;}
if (Timer_signal_sinus>250){Timer_signal_sinus=0;alarm_recieved=0;Timer_signal_sinus_enabled=0;}

if (PIND.2==0){

    if (Timer_signal_sinus>40){//40 - ????? ????? ????????? ????, ??? ??????, ??? ?????? ???????? ????? ???????
    alarm_recieved=1;
    
    disable_count=0;
    Timer_if_long_pressed=0;
    
    }
    if (Timer_signal_sinus>41){//????? ????????, ??? ?? ????????????? ????
    alarm_recieved=0;
    Timer_signal_sinus_enabled=0;
    Timer_signal_sinus=0;
    

    }
    
}


if ((alarm_recieved==1)&&(alarm==0)&&(stand_by==0)) {//???? ???? ??????, ?????? ??? ?? ??????????, ???????? ?? ????????

if (disable_count==0){
    disable_count=1;
    Timer_wrong_pressed_enable=1;
    Timer_wrong_pressed=0;
    PORTD|=0b00100000;
     //?????????? ????????? ??????????//   PORTD|=0b00100000;
    Count++;
    stand_by=2;
        if (Count==5){
        Count=0;
        alarm=1;
        }
}


}


if((PIND.2==0)&&(stand_by==0)){

}

if (alarm==1){ //???????????? ?????????
Timer_1++;
if (pressed==0){
if (shadow==0){
PORTD|=0b10010000;
}
else{
PORTD|=0b00010000;
}
//DDRD|=0b00010000;
pressed=1;}


if (Timer_1>250){
Timer_2++;
Timer_1=0;
}

if (Timer_2>10){

if (shadow==0){
    PORTD^=0b10010000;//???????? ?????? ???????
    }
    else{
    PORTD^=0b00010000;//???????? ?????? ???????
    }
    //DDRD^=0b00010000;
    Timer_2=0;
    Count_1++;
}
if (Count_1>2){
if (shadow==0){
PORTD&=~0b10010000;
}
else{
PORTD&=~0b00010000;
}
//DDRD&=~0b00001000;
Count_1=0;
pressed=0;
PORTC|=0b00000100;
stand_by=20000;
alarm=0;
delay_after_alarm=1;
}


}
if (mini_stand_by>0){
mini_stand_by--;
}
if (mini_stand_by==2){
stand_by=2;
}
if (stand_by>0){
Timer_3++;
    if (Timer_3>5){
        if (delay_after_alarm==1){
        Timer_6++;
            if (Timer_6==20){
            PORTD^=0b00100000;
            Timer_6=0;
            }
        }
    stand_by--;
    Timer_3=0;
    }
   }
if ((stand_by==0)&&(delay_after_alarm==1)){
delay_after_alarm=0;
}

// Place your code here

}