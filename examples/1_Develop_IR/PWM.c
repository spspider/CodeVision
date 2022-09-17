void PWM2(){
Timer_1++;

if (Timer_1==30){Timer_1=1;Timer_2++;} //скорость обновления PWM модулирования, значение меняется с частотой

if (Timer_1<sig1[0]){U1=1;}else{U1=0;}
if (U1==1){PORTD|=0b00010000;}
if (U1==0){PORTD&=~0b00010000;}

if (Timer_2>=20){ //скорость затухания
for (U3=0;U3<=1;U3++){//количество PWM
if (U2[U3]==1) {if(sig1[U3]<=20){sig1[U3]=sig1[U3]+1;}}
if (U2[U3]==0) {if(sig1[U3]>=1){sig1[U3]=sig1[U3]-1;}}
Timer_2=0;}
//if((sig1[U3]=1)||(sig1[U3]=20)){U2[1]^=1;}
}



Timer_3++;
if (Timer_3==10000){Timer_3=0;
Timer_4++;
U2[0]^=1;
//PORTD^=0b00010000;

itoa(adc[0], _adc0);
itoa(adc[1], _adc1);
lcd_clear();
lcd_gotoxy(8, 0);
lcd_puts(_str3);
lcd_puts(_adc0);
lcd_gotoxy(8, 1);
lcd_puts(_str4);
lcd_puts(_adc1);

}
}
void ADC_(){

}