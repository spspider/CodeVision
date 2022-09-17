if (Timer_2==5){  //*Timer_1=20 = 100
now_tempU=512-read_adc(0)/2;
now_tempB=512-read_adc(1)/2;
Timer_2=0;
}
if (Timer_1==20){
//первый ADC
lcd_clear(); 
if (show_lcd!=5){
//sprintf(lcd_buffer,"%cB:%0.1f%cU:%0.1f",lcd_stateB,now_tempB,lcd_stateU,now_tempU);
sprintf(lcd_buffer,"%c%3d%c%3dT%3d-%3d",lcd_stateU,now_tempU,lcd_stateB,now_tempB,forecast_temp_U,forecast_temp_B);

//lcd_clear();        /* очистка дисплея */
lcd_gotoxy(0,0);        /* верхняя строка, 4 позиция */
lcd_puts(lcd_buffer);


}
if (lcd_freeze==0){
if(lcd_switcher==0){show_lcd=0;}//показываем установленную температуру
if(lcd_switcher==4){show_lcd=2;}//мощность нагр
if(lcd_switcher==6){show_lcd=4;}//вкл. и выкл. нагревателей
if(lcd_switcher>8){lcd_switcher=0;}
}
//show_lcd=4;
//set_tempB=read_adc(2)/4;
//set_tempU=read_adc(3)/4;



if ((show_lcd==0)||(show_lcd==1)){//меню обратного отсчета
//sprintf(lcd_buffer,"%cSB:%d%cSU:%d",choose[3],set_tempB,choose[4],set_tempU);
lcd_gotoxy(0,1);
heat_k_B_int= (int)(PWM_koeff[1]*10.0);
heat_k_U_int= (int)(PWM_koeff[0]*10.0);
if (heat_k_U_int>99){heat_k_U_int=99;}
if (heat_k_U_int<-99){heat_k_U_int=-9;}
if (heat_k_B_int>99){heat_k_B_int=99;}
if (heat_k_B_int<-99){heat_k_B_int=-9;}
//t_min_least=Heat_time_timer;
sprintf(lcd_buffer,"%2dU%2dR%1dP%d-%d",heat_k_B_int,heat_k_U_int,now_rule,PWM_setted[0],PWM_setted[1]);
lcd_puts(lcd_buffer);

}
if (show_lcd==2){ //меню PWM
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cPmU:%d%cPmB:%d",choose[1],PWM_setted[0],choose[2],PWM_setted[1]);
lcd_puts(lcd_buffer);
}
if (show_lcd==3){// меню старт стоп
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cst_U:%d%cst_B:%d",choose[0],start,choose[12],start_BT);
lcd_puts(lcd_buffer);
}
if (show_lcd==5){//настройка правил
lcd_gotoxy(0,0);
//sprintf(lcd_buffer,"%cR%d%cH%d%cT%d%",choose[5],set_now_rule,choose[6],Heat_rule[set_now_rule],choose[7],Heat_time[set_now_rule]);
sprintf(lcd_buffer,"%cSb%d",choose[9],Heat_speed_B);

lcd_puts(lcd_buffer);
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cSp%d%cU%d%cB%d",choose[8],Heat_speed[set_now_rule],choose[10],Heat_temp_U[set_now_rule],choose[11],Heat_temp_B[set_now_rule]);
lcd_puts(lcd_buffer);
}
/////////////////////////////////////////////
if (show_lcd==6){
lcd_gotoxy(0,1);
//unsigned int koeff_b_int=0;
//heat_koeff_B=0.123456;
koeff_b_int=(int)(heat_koeff_B*100.0);
koeff_u_int=(int)(heat_koeff_U*100.0);
sprintf(lcd_buffer,"kB:%dkU:%d",koeff_b_int,koeff_u_int);
lcd_puts(lcd_buffer);
//TCnt_0=(100.0/freq)*78.125;
////////////////////////////////////////////
}
Timer_1=0;
Timer_2++;
}


//if (set_tempB!=set_tempB_prev){show_lcd=0;lcd_freeze=5;set_tempB_prev=set_tempB;}
//if (set_tempU!=set_tempU_prev){show_lcd=0;lcd_freeze=5;set_tempU_prev=set_tempU;}