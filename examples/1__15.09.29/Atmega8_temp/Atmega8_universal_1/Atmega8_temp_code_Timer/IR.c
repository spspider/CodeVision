//IR Driver

if ((PIND.7==0)&&(Startsomedelay==0)){
Timer_IR_Start=1;
//delay_start=1;
//databits=0;
count1bit=0;
//start_devider=1;
}
//if(delay_start==1){
//delay_start_timer++;
   // if (delay_start_timer==1){
   // delay_start_timer=0;
   // delay_start=0;
   // }
//}


if ((Timer_IR_Start==1)&&(Startsomedelay==0)){
if (Timer_IR==0){databits=0;}
Timer_IR++;
    if (PIND.7==0){
    databits=databits<<1; //сдвигаем переменную для битов
    //bincode*=bincode*+"1";
    databits|=1;//добавляем в конец строки положительный бит
    }else{
    //if (PIND.7==1){
    databits=databits<<1; //сдвигаем переменную для битов
    databits&=~1;//добавляем в конец строки положительный бит
    }
    if (Timer_IR==16){
    Timer_IR_Start=0;
    Timer_IR=0;
    Startsomedelay=1;
    if(databits!=0){
    show_data=databits;
    }
    //databits=0;
    }
    
devider=0; 
}

/*
if ((PIND.7==1)&&(Timer_IR_Start==1)){
count1bit++;
    if (count1bit==10){
    Timer_IR_Start=0;
    Timer_IR=0;
    Startsomedelay=1;
    //show_data=databits;
    count1bit=0;
    }
}
*/
if (Startsomedelay==1){
PORTD|=0b00001000;
delayneed++;
    if (delayneed==255){
    PORTD&=~0b00001000;
    Timer_IR=0;
    delayneed=Startsomedelay=0;
    //databits=0;
    }
}
//show_data=91;



/*
if(PIND.7==0){
databits++;
}
if(PIND.7==1){

if (databits!=0){
show_data=databits;}
databits=0;
}
*/