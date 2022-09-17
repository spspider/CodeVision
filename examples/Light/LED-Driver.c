void PWM1(){

Timer_1++;

if (Timer_1==17){Timer_1=1;Timer_2++;} //скорость обновления PWM модулирования, значение меняется с частотой

if (Timer_1<sig1[0][n2]){U1=1;}else{U1=0;} // sig1 + задержка драйвер для лампы 0 - значение 1й переменной
if (U1==1){PORTB|=0b00000001;} //x3,y4
if (U1==0){PORTB&=~0b00000001;}

if (Timer_1<sig1[1][n2]){U1=2;}else{U1=3;} // sig1 + задержка
if (U1==2){PORTB|=0b00000010;} //x3,y3
if (U1==3){PORTB&=~0b00000010;}

if (Timer_1<sig1[2][n2]){U1=4;}else{U1=5;} // sig1 + задержка
if (U1==4){PORTB|=0b00000100;} //x4,y2
if (U1==5){PORTB&=~0b00000100;}

if (Timer_1<sig1[3][n2]){U1=6;}else{U1=7;} // sig1 + задержка
if (U1==6){PORTB|=0b00010000;}  //x3,y1
if (U1==7){PORTB&=~0b00010000;}

if (Timer_1<sig1[4][n2]){U1=8;}else{U1=9;} // sig1 + задержка
if (U1==8){PORTB|=0b00100000;}  //x4,y1
if (U1==9){PORTB&=~0b00100000;}

if (Timer_1<sig1[5][n2]){U1=10;}else{U1=11;} // sig1 + задержка
if (U1==10){PORTB|=0b01000000;}  //x4,y4
if (U1==11){PORTB&=~0b01000000;}

if (Timer_1<sig1[6][n2]){U1=12;}else{U1=13;} // sig1 + задержка
if (U1==12){PORTB|=0b10000000;} //x3,y2
if (U1==13){PORTB&=~0b10000000;}

if (Timer_1<sig1[7][n2]){U1=14;}else{U1=15;} // sig1 + задержка
if (U1==14){PORTB|=0b00001000;} //x4,y2
if (U1==15){PORTB&=~0b00001000;}


if (Timer_2>=U9){ //скорость затухания

for (U3=0;U3<=7;U3++){

if (U2[U3][n2]==1) {if(sig1[U3][n2]<l_up){sig1[U3][n2]=sig1[U3][n2]+1;}}
if (U2[U3][n2]==0) {if(sig1[U3][n2]>l_dwn){sig1[U3][n2]=sig1[U3][n2]-1;}else{sig1[U3][n2]=l_dwn;}}
//if (U2[U3][n2]==0) {if(sig1[U3][n2]>2){sig1[U3][n2]=sig1[U3][n2]-1;}else{sig1[U3][n2]=2;}}

}
Timer_2=0;}
}

void Dig_1(){
switch (Dig1){
case 1: {U2[3][n2]=1;break;}
case 2: {U2[6][n2]=1;break;}
case 3: {U2[6][n2]=1;U2[3][n2]=1;break;}
case 4: {U2[1][n2]=1;break;}
case 5: {U2[1][n2]=1;U2[3][n2]=1;break;}
case 6: {U2[1][n2]=1;U2[6][n2]=1;break;}
case 7: {U2[1][n2]=1;U2[6][n2]=1;U2[3][n2]=1;break;}
case 8: {U2[0][n2]=1;break;}
case 9: {U2[0][n2]=1;U2[3][n2]=1;break;}
case 10: {U2[0][n2]=1;U2[3][n2]=1;U2[6][n2]=1;U2[1][n2]=1;break;}
default: ;
}
}
void Dig_2(){
switch (Dig2){
case 1: {U2[4][n2]=1;break;}
case 2: {U2[2][n2]=1;break;}
case 3: {U2[4][n2]=1;U2[2][n2]=1;break;}
case 4: {U2[5][n2]=1;break;}
case 5: {U2[5][n2]=1;U2[4][n2]=1;break;}
case 6: {U2[2][n2]=1;U2[5][n2]=1;break;}
case 7: {U2[2][n2]=1;U2[5][n2]=1;U2[4][n2]=1;break;}
case 8: {U2[7][n2]=1;break;}
case 9: {U2[4][n2]=1;U2[7][n2]=1;break;}
case 11: {U2[4][n2]=1;U2[7][n2]=1;{U2[5][n2]=1;U2[2][n2]=1;break;}}
default: ;
}
}
void Dig_0(){
//for (n2=0;n2<=3;n2++){
for (U3=0;U3<=7;U3++){U2[U3][0]=0;}
for (U3=0;U3<=7;U3++){U2[U3][1]=0;}
for (U3=0;U3<=7;U3++){U2[U3][2]=0;}
PORTB&=~0b11111111;
//DDRD|=0b00000000;DDRD&=~0b11100000;

}

void U4M()
{
if (U4==0){DDRD|=0b10000000;DDRD&=~0b01100000;}
if (U4==1){DDRD|=0b00100000;DDRD&=~0b11000000;}
if (U4==2){DDRD|=0b01000000;DDRD&=~0b10100000;}
}


void null(){
dig_a=0,dig_b=0,dig_c=0,Timer_9=0;
}

void Parts(){
Num2[n2]=0;
if(Number[n2]<0){Number[n2]*=-1;}
while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
  Dig1 = Number[n2];
  Dig2 = Num2[n2];
}
void Parts1(){
Num2[n2]=0;
while (Number[n2] >= 10000){Number[n2] -= 10000;}
while (Number[n2] >= 1000){Number[n2] -= 1000;}
while (Number[n2] >= 100){Number[n2] -= 100;}
while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
  Dig1 = Number[n2];
  Dig2 = Num2[n2];
}

void Dig(){
if (PWM_Susp==0){
PWM1();
Timer_4++;
if (Timer_4==20){U4++;Timer_4=0;
//U4++;
if (U4==3){U4=0;}


Dig_0();
n2=U4;

U4M();
if (U8==0){ //Time
Number[0] = hour;
Number[1] = mins;
Number[2] = sec;
Parts();
}
if (U8==1){ //sp
Timer_9++;if (Timer_9==1){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==300){dig_a=7,dig_b=17,dig_c=47;};if (Timer_9==600){dig_a=0,dig_b=0,dig_c=0;};if (Timer_9==1200){dig_a=7,dig_b=57,dig_c=11;}if (Timer_9==2200){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==2400){Timer_9=0;U8=4;U9=10;}

Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
}
if (U8==2){//off
Number[n2]=Num2[n2]=0;
Parts();
}
if (U8==3){ //Temp
Timer_9++;if (Timer_9==300){dig_a=0,dig_b=0;}if (Timer_9==600){Timer_9=0;U10=0,dig_a=7,dig_b=50;}//если температура включена
//Num2[n2]=0;
Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = adc1;
Parts();
}
if (U8==4){
//U9=15;
Timer_9++;if (Timer_9==1){dig_a=rand();dig_b=rand();dig_c=rand();}if (Timer_9==300){Timer_9=0;}//
Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts1();
;}
if (U8==5){
//U9=15;
Timer_9++;if (Timer_9==100){dig_a=07;dig_b=57;dig_c=57;}if (Timer_9==400){if (PIND.3==1){dig_b=77;}if (PIND.2==1){dig_c=77;}Timer_9=0;}//
Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
;}
if (U8==6){
//U9=15;
//Timer_9++;if (Timer_9==1){dig_a=hour_a1;dig_b=mins_a1;dig_c=sec_a1;}if (Timer_9==100){dig_a=hour_a2;dig_b=mins_a2;dig_c=sec_a2;Timer_9=0;}if (Timer_9==200){dig_a=0;dig_b=0;dig_c=80;Timer_9=0;}//
Timer_9++;if (Timer_9==100){dig_a=hour_a1;dig_b=mins_a1;dig_c=sec_a1;}if (Timer_9==200){dig_a=hour_a2;dig_b=mins_a2;dig_c=sec_a2;}if (Timer_9==300){dig_a=0;dig_b=0;dig_c=80;Timer_9=0;}//

Number[0] = dig_a;
Number[1] = dig_b;
Number[2] = dig_c;
Parts();
;}
//fade_d();
Dig_1();
Dig_2();
}

}
}