interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
//#include <beep.c>
//Timer1++;    
Timer8++;  

/*  
  if (Timer1>=255){Timer1=0;Timer2++;Timer3++;Timer4++;
    }
  if(Timer3>=5){

  if((adc1[0]<300)&&(adc1[0]>=500)){PORTD^=0b10000000;Timer3=0;a1=1;}
  if((adc1[1]<300)&&(adc1[1]>=500)){PORTD^=0b00100000;Timer3=0;a1=1;}
  Timer3=0;
  }// мигание лампы акк разряжен
  
  if(Timer4>=10){
  if(adc1[0]<500){PORTD^=0b10000000;Timer4=0;}
  if(adc1[1]<500){PORTD^=0b00100000;Timer4=0;}
  Timer4=0;
  }// мигание лампы
  
  
  if(Timer2>=20){
  PORTB&=~0b00000011;
  }
  if(Timer2>=22){
  switch (bat){
  case 1: {bat=0;break;}
  case 0: {bat=1;break;}
  }
  //bat=1;
  c1=1;
  }
  if(Timer2>=25){
  if(adc1[0]<500){PORTB|=0b00000001;Timer2=0;}
  if(adc1[1]<500){PORTB|=0b00000010;Timer2=0;}
  
  if(adc1[0]>500){PORTB&=~0b00000001;PORTD|=0b10000000;Timer2=0;a1=2;aStop=1;}
  if(adc1[1]>500){PORTB&=~0b00000010;PORTD|=0b00100000;Timer2=0;a1=2;aStop=1;}
  Timer2=0;
  
  printf("bat0=%d bat1=%d#",adc1[0],adc1[1]);
  }
  */ 
}                  //заряд завершен - aStop=0;
