void Time(){

Timer_3++;

if (Timer_3==10000){U2[0]=1;}
if (Timer_3==20000){U2[1]=1;}
if (Timer_3==30000){U2[2]=1;}
if (Timer_3==40000){U2[3]=1;}
if (Timer_3==50000){U2[4]=1;}
if (Timer_3==60000){U2[5]=1;}
if (Timer_3==70000){U2[6]=1;}
if (Timer_3==80000){U2[7]=1;}
if (Timer_3==90000){for (U3=0;U3<8;U3++){U2[U3]=0;};Timer_3=0;}
} 
