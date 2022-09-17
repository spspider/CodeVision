void allPWM(){
///////////////////////////////////////
//PWM
nowPORT[2] = 0b00000100;
nowPORT[3] = 0b00001000;
nowPORT[4] = 0b00010000;
nowPORT[5] = 0b00100000;


on[2]=4;
on[3]=4;
on[4]=4;
on[5]=4;

/*
for (n=2;n<6;n++) {
off[n]=on[n]+1;
if (PWM[n]==on[n]){PORTD|=nowPORT[n];}
if (PWM[n]==off[n]){PORTD&=~nowPORT[n] ;}
if (PWM[n]>=PWMmax){PORTD|=nowPORT[n];PWM[n]=0;}
PWM[n]++;
};

*/

///////////////////////////////////////
}