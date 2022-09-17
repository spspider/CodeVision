//OVF
//if (Timer5==200){interval=Timer5;Timer5=0;died=1;}
if (adc[1]==1){
if (pulse_ok==1){
    //таймер для звука, работает при обнаружении пульса
Timer3++;
        if (Timer3==5){
        PORTD^=0b00001000;
        Timer4++;
        Timer3=0;
        }

        if (Timer4==200){
        Timer4=0;
        buzzer=0;
        pulse_ok=0;
        PORTD&=~0b00011000;
        }
}
}
//PORTC^=0b00000001;
if (sw!=0){
//если получен сигнал    
if (pulse_ok==0){ 
Timer5++;   
//adc[1]=0;
if (Timer5==500){

PORTC^=0b00000001;
Timer5=0;
}

    //if (Timer7==8){
    //Timer7=0;
    //adc[1]=1;data=0;
    //printf("%d",adc[1]);pulse_ok=0;
    //}
    if (adc[1]==1){
    Timer7++;
        if (Timer7==2000){
        Timer7=0;adc[1]=0;};
        }    
    
    
    

}
}
//PORTC|=0b00000001;