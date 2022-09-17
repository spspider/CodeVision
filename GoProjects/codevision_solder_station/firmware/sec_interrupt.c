
Timer_1++;
//Timer_0=0;

if (buzz_cont>0){
buzz_cont--;
}
if (BTN_pressed==1){
Timer_BTN_Pressed++;
    if (Timer_BTN_Pressed>20){
    Timer_BTN_Pressed=0;
    BTN_pressed=0;
    } 
}


//if (lcd_freeze<1){lcd_switcher++;}else{lcd_freeze--;}
Timer_1sec++;
if (Timer_1sec>100){


if (t_sec==59){

    if (Heat_time_timer_enabler==1){
    Heat_time_timer++;
    }
    else{
    Heat_time_timer=0;
    }

t_min++;t_sec=0;}
if (t_min>60){t_hour++;t_min=0;}
Timer_1sec=0;

if (start==0){
lcd_stateU=*"_";heater_on[0]=0;now_rule=0;
now_tempU_prev=now_tempU;

sec_profile[0]=t_sec=0;
rule_end=0;
sec_profile_off[0]=0;

now_tempU_prev=now_tempU;
now_tempU_calc=now_tempU;

}
PWM_setted_eeprom[0]=PWM_setted[0];
PWM_setted_eeprom[1]=PWM_setted[1];
//heat_koeff_U=((5-1)/2);
if (start==1){
//t_sec++;

if (heat_approved[0]==0){now_tempU_calc=now_tempU;sec_start_heat[0]=0;}
if (heat_approved[0]==1){sec_start_heat[0]++;}
//sec_start_heat[0]=sec_profile[0];
////////////////////////////////////////////////////////////////////////
heat_koeff_U=((now_tempU-now_tempU_calc)*1.00)/(sec_start_heat[0]*1.00);//через 5 сек
PWM_koeff[0]=heat_koeff_U*1.00/(Heat_speed[now_rule]*1.0/10.0);
if (sec_start_heat[0]>2){
if (PWM_koeff[0]<0.5){ if (PWM_setted[0]<10){PWM_setted[0]++;};}}
if (PWM_koeff[0]>1.5){ if (PWM_setted[0]>0) {PWM_setted[0]--;};}
/////////////////////////////////////////////////////////////////////////////
///if ()
if (forecast_temp_U<=(now_tempU+30)){
if (forecast_temp_U<Heat_temp_U[now_rule]){
if (now_tempU<Heat_temp_U[now_rule]){
sec_profile[0]++;
}
}
}
if (forecast_temp_U>=(now_tempU+30)){
//float sec_calc=0.0;
//sec_calc=(now_tempU*1.0/(Heat_speed[now_rule]*1.00/10.00));
sec_profile[0]=(now_tempU*1.0/(Heat_speed[now_rule]*1.00/10.00))-now_tempU_prev;
now_tempU_prev=now_tempU;
now_tempU_calc=now_tempU;
}
//sec_start_heat[0]=sec_profile[0];


if (forecast_temp_U<Heat_temp_U[now_rule]){
forecast_temp_U=now_tempU_prev+sec_profile[0]*(Heat_speed[now_rule]*1.00/10.00);;
}
else{
//sec_profile[1]=0;
forecast_temp_U=Heat_temp_U[now_rule];
}




if ((now_tempU==Heat_temp_U[now_rule])&&compliteU==0){compliteU=1;buzz_freg=50;buzz_cont=10;now_tempU_calc=now_tempU;}  

if (forecast_temp_U<=now_tempU){//текущая температура больше расчитанной

    heat_approved[0]=0;
    t_power_change_up[0]=0;
    t_power_change_down[0]++;
    lcd_stateU=*"|";
    heater_on[0]=0;
    sec_heat[0]=0;
     
;}
if (forecast_temp_U>now_tempU){//текущая температура маеньше.
if (Heat_temp_U[now_rule]>now_tempU){ 
    heat_approved[0]=1;
    heater_on[0]=1;lcd_stateU=*"H";
    t_power_change_up[0]++;
    t_power_change_down[0]=0;
    if (PWM_setted[0]<1){PWM_setted[0]=1;}
;}
;}








}
if (start_BT==0){
now_tempB_prev=now_tempB;
lcd_stateB=*"_";heater_on[1]=0;
now_tempB_prev=now_tempB;
sec_profile[1]=0;sec_profile_off[1]=0;
PORTB.1=0;
sec_profile[1]=0;
now_tempB_prev=now_tempB;
now_tempB_calc=now_tempB;
//learn_pwm_B[0]=0;
}
if (start_BT==1){
//if (now_tempB_start==0){now_tempB_start=now_tempB;}//установка начальной темп при старте
//if (Heat_temp_B[now_rule]!=Heat_temp_B_start[now_rule])
if (heat_approved[1]==0){now_tempB_calc=now_tempB;sec_start_heat[1]=0;}
if (heat_approved[1]==1){sec_start_heat[1]++;}

//////////////////////////////////////////////////////////////////////
//sec_start_heat[1]=sec_profile[1];
heat_koeff_B=(now_tempB-now_tempB_calc)/sec_start_heat[1];//через 5 сек
PWM_koeff[1]=heat_koeff_B*1.00/(Heat_speed_B*1.0/10.0);
if (sec_start_heat[1]>2){
if (PWM_koeff[1]<0.5){ if (PWM_setted[1]<10){PWM_setted[1]++;};}}
if (PWM_koeff[1]>1.5){ if (PWM_setted[1]>0) {PWM_setted[1]--;};}
/////////////////////////////////////////////////////////////////////
//learn_pwm_B[0]+=PWM_setted[1];
//float PWM_setted_float[1]=learn_pwm_B[1]/sec_profile[1];
//PWM_setted[1]=PWM_setted_float[1];   

if (forecast_temp_B<Heat_temp_B[now_rule]){
forecast_temp_B=now_tempB_prev+sec_profile[1]*Heat_speed_B*1.00/10.0;
}
else{
//sec_profile[1]=0;
forecast_temp_B=Heat_temp_B[now_rule];
}

if (forecast_temp_B<=(now_tempB+30)){
if (forecast_temp_B<=Heat_temp_B[now_rule]){
if (now_tempB<=Heat_temp_B[now_rule]){
sec_profile[1]++ 
 ;}
 ;}
 ;} 
if (forecast_temp_B>=(now_tempB+30)){

sec_profile[1]=(now_tempB*1.0/(Heat_speed_B*1.00/10.00))-now_tempB_prev;
now_tempB_prev=now_tempB;
now_tempB_calc=now_tempB;
}

if ((now_tempB==Heat_temp_B[now_rule])&&compliteB==0){compliteB=1;buzz_freg=50;buzz_cont=10;}


if (forecast_temp_B>now_tempB){  
if (Heat_temp_B[now_rule]>now_tempB){  
    heat_approved[1]=1;
    heater_on[1]=1;lcd_stateB=*"H";
    t_power_change_up[1]++;
    t_power_change_down[1]=0;
    if (PWM_setted[1]<1){PWM_setted[1]=1;}

}
}
if (forecast_temp_B<now_tempB){       

    heat_approved[1]=0;
    lcd_stateB=*"|";
    heater_on[1]=0;
    sec_heat[1]=0;
    t_power_change_up[1]=0;
    t_power_change_down[1]++;
           
}
 
}
//heat_koeff=0.54;






}

