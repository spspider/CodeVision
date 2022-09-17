if ((PINC.5==0)&&(PINC5==0)){PINC5=1;MS=MS+5;;DisOther=0;Bip=1;}
if (PINC.5==1){PINC5=0;}
if ((PINC.4==0)&&(PINC4==0)){PINC4=1;MS=MS-5;DisOther=0;Bip=1;}

if (PINC.4==1){PINC4=0;}

if ((PIND.7==0)&&(PIND7==0)){PIND7=1;DisOther=0;HW=1;Bip=1;}
if (PIND.7==1){PIND7=0;}

if ((PIND.4==0)&&(PIND4==0)){PIND4=1;HW=0;BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}
if (PIND.4==1){PIND4=0;}

if ((PIND.0==0)&&(PIND0==0)){PIND0=1;PIND01=0;Bip=1;cycleN=5;PORTD|=0b00000100;PORTD&=~0b00000010;DisOther=1;Num2=0;Num3=5;}
if ((PIND.0==1)&&(PIND01==0)){PIND0=0;PIND01=1;Bip=1;cycleN=10;PORTD|=0b00000010;PORTD&=~0b00000100;DisOther=1;Num2=0;Num3=1;}


if (PIND.5==0){Bip=1;INJ=1;DisOther=0;}
if (PIND.6==0){Bip=1;INJ=0;Num2=11;Num3=10;DisOther=1;PORTC&=~0b00000010;Dis1=0;}

