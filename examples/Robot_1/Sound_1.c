
void sound(){
if (S_1==1){ // если получено разрешение слышать сигнал
Timer_1++;
if (Timer_1==1000){ //если таймер равен промежутку времени
adc1=read_adc(0);
Timer_1=0;
Timer_2++;
DataS[Timer_2]=adc1;
if (Timer_2==20){Timer_2=0;
for (c=0;c<20;c++){printf("%d\n",DataS[c]);}printf("%d\n\r");}
}
}
}