
     
    previous_value[i]=adc0;//записываем данные в массив
    if (i==2){
        
        if ((previous_value[i-1]-previous_value[i])>10){
        pulse_ok=1;
        PORTC|=0b00000001;
        buzzer=1;
        //echo Timer1;
        //printf("interval:%d#",Timer5);
        interval=Timer5;
        //itoa(interval, interval_c);
        Timer5=0;
        //timer_enable_pulse=1;
        //запустить таймер подсчета времени между импульсами
        //добавить импульс

        }
        //if (previous_value[i]!=previous_value[i-1]){
        //pulse_ok=1;
        //printf("pulse%d#",previous_value[1]);
        //}
        else{
        
        //pulse_ok=0;
        }

        i=0;
        }
    i++;
    Timer5++;
    //pulse_ok=0;

}
if (pulse_ok==1){
Timer2++;
    if (Timer2>=30){
    PORTC&=~0b00000001;
    Timer2=0;
    pulse_ok=0;
    }
    
    Timer3++;
        if (Timer3==50){
        PORTB^=0b00001000;
        Timer4++;
        Timer3=0;
        }
        if (Timer4==20){
        Timer4=0;
        buzzer=0;
        PORTB&=~0b00001000;
        }
    }
if (pulse_ok==0){
    Timer3=0;
    Timer2=0;
    Timer4=0;
    buzzer=0;
    PORTB&=~0b00001000;
    }
    //запускаем таймер который подсчитает длинну времени между импульсами
    
    if (timer_enable_pulse==1){
    //Timer5++;
    
    }