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