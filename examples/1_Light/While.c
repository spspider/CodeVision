if ((U8==3)&&(U10==0)){
adc1 = 255-62-read_adc(1);
U10=1;
}

//adc1 = 255-read_adc(1);}

if ((PINC.0==0)&&(PWM_Susp==1)&&(IR_S==0))
{
IR_1=1;
//if(IR_Tr==0){IR_1=1;}
//if(IR_Tr==1){IR_2=1;}
}

