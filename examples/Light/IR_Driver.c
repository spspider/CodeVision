if (d3==832){PORTD^=0b00000100;Bee=7;}//принудительное включение выключателей. 
if (d3==864){PORTD^=0b00001000;Bee=7;} 
if (d3==840){L_ON^=1;Bee=10;}
/*
if (d3==633){Clock_Susp=1;Bee=20;U6=1;} 
if (d3==18832){Clock_Susp=1;Bee=20;U6=2;} 

if (d3==21872){Clock_Susp=0;putchar('C');Bee=30;TD=0;U6=0;} 


if (Clock_Susp==1){
if (d3==21160){U5=1;U7=1;Bee=5;} 
if (d3==21136){U5=2;U7=1;Bee=6;} 

if ((U7==1)&&(U6==1)){//установка времени
TD++;U7=0;
if (TD==1){hour=U5*10;}
if (TD==2){hour=hour+U5;}
if (TD==3){mins=U5*10;}
if (TD==4){mins=mins+U5;sec=TD=U6=0;
Clock_Susp=0;}
}
if ((U7==1)&&(U6==2)){//установка будильника
TD++;U7=0;
if (TD==1){hour_a1=U5*10;}
if (TD==2){hour_a1=hour_a1+U5;}
if (TD==3){mins_a1=U5*10;}
if (TD==4){mins_a1=mins_a1+U5;sec_a1=TD=U6=0;
Clock_Susp=0;}


}
}
*/