unsigned char Disp6,Disp7,Timer_5,TimeHW=10,Timer_7,Dis1,Dis2,Timer_9,Timer_10,Timer_3,Timer_2,Timer_8,Timer_11,Timer_4,Timer_6,Timer_12;
  
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

#include <checkp.c>

if (HW==1){Timer_7++;Timer_8++;
HW_1=1;
if (Timer_7==TimeHW){PORTC^=0b00000001;Timer_7=0;}
if (Timer_8==250){Timer_10++;Dis2=Dig[16];}
if (Timer_10==12){TimeHW=5;}
if (Timer_10==20){TimeHW=10;Timer_8=0;Timer_10=0;Timer_9++;}
if (Timer_9==10){BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}}//количество циклов HW
//if ((HW==0)&&(HW_1==1)){
//HW_1=0;BipL=500;Bip=1;Timer_9=0;Dis2=0;Num2=11;Num3=11;Timer_7=0;Timer_8=0;
//}

Timer_2++;
Timer_3++;
if (INJ==1){//включение работы инжектора
INJ_1=1;
Timer_11++;
if(cycleL>=cycleN){INJ=0;PORTC&=~0b00000010;Dis1=0;BipL=5;Bip=1;cycleL=0;DisOther=1;Num2=11;Num3=10;}
if (Timer_11==250){Timer_4++;;}
if (Timer_4==4){PORTC&=~0b00000010;Dis1=0;}
if (Timer_4>=MS+2){PORTC|=0b00000010;cycleL++;Timer_4=0;Dis1=Dig[16];}

}
//if ((INJ==0)&&(INJ_1==1)){
//INJ=0;PORTC&=~0b00000010;Dis1=0;BipL=500;Bip=1;cycleL=0;DisOther=1;Num2=11;Num3=10;INJ_1=0;
//} 
//BIP
if (Bip==1){Timer_5++;
if (Timer_5==5){//динамик частота
PORTD^=0b00001000;
//PORTD&=~0b00001000;
Timer_5=0;
Timer_6++;
if (Timer_6==100){Timer_12++;}
if (Timer_12==BipL){Timer_12=0;Timer_6=0;BipL=1;
Bip=0;}
}
}

// end bip

//if(Timer_8==100){
//Timer_8=0;
//DisOther=1;
//}



if (Timer_3==1){//первая цифра
PORTC&=~0b00000100;
PORTC|=0b00001000;
PORTB=Disp6-Dis1;}
if (Timer_3==100){//вторая цифра
PORTC&=~0b00001000;
PORTC|=0b00000100;
PORTB=Disp7-Dis2;
}
if (Timer_3==200){Timer_3=0;}
//Timer_8++;
}

void Dig_init() //Массив для отображения цифр на семисегментном индикаторе
{          //ABCDEFG DP
  Dig[0] = 0b00000011;
  Dig[1] = 0b10011111;
  Dig[2] = 0b00100101;
  Dig[3] = 0b00001101;
  Dig[4] = 0b10011001;
  Dig[5] = 0b01001001;
  Dig[6] = 0b01000011;
  Dig[7] = 0b00011111;
  Dig[8] = 0b00000001;
  Dig[9] = 0b00001001;
  Dig[10]= 0b01001001;//s
  Dig[11]= 0b00110001;//p
  Dig[12]= 0b01100011;//C
  Dig[13]= 0b00001111;//C
  Dig[14]= 0b11001111;//u
  Dig[15]= 0b11100111;//u
  Dig[16]= 0b00000001;//.
}
void Display (unsigned int Number) //Ф-ция для разложения десятичного цисла
{
if (DisOther==0){
  Num2=0, Num3=0;
    while (Number >= 10)
  {
    Number -= 10;  
    Num3++; 
  }
  Num2 = Number;
 }

  Disp6 = Dig[Num3];
  Disp7 = Dig[Num2];
}