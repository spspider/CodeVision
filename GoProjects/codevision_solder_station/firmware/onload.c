//heater_on[0]=1;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//heater_on[1]=1;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
lcd_gotoxy(0,0);
lcd_putsf("Loading");
buzz_freg=178;buzz_cont=20;

lcd_stateU=*" ";
lcd_stateB=*" ";

    for (k=0;k<13;k++){
    choose[k]=*" ";
    }
    for (k=0;k<5;k++){
    //rule_end[k]=0;
    }
choose_v(0);

Heat_rule[0]=3;//2-по достижению температуры 3- конец правил 1 - по времени
Heat_time[0]=2;//общее время секунд, греть
Heat_temp_U[0]=240;//температура режима
Heat_temp_B[0]=160;//температура режима
Heat_speed[0]=10;//температура режима(heatspeed/10=1sek 2градус в 1 сек.
Heat_speed_B=10;
sec_profile[0]=10;

Heat_rule[1]=0;//1-по достижению времени
Heat_time[1]=1;//общее время секунд, греть
Heat_temp_U[1]=150;//температура режима
Heat_temp_B[1]=150;//температура режима
Heat_speed[1]=10;

Heat_rule[2]=0;//2-по достижению температуры
Heat_temp_U[2]=230;//температура режима
Heat_temp_B[2]=150;//температура режима
Heat_speed[2]=10;

Heat_rule[3]=0;//конец правил
Heat_temp_U[3]=230;//температура режима
Heat_temp_B[3]=150;//температура режима
Heat_speed[3]=8;

//Heat_rule[3]=0;//2-по достижению температуры
if ((PWM_setted_eeprom[0]>0)&&(PWM_setted_eeprom[0]<11)){PWM_setted[0]=PWM_setted_eeprom[0];}
if ((PWM_setted_eeprom[1]>0)&&(PWM_setted_eeprom[1]<11)){PWM_setted[1]=PWM_setted_eeprom[1];}
if ((Heat_speed_B_eeprom>0)&&(Heat_speed_B_eeprom<50)){Heat_speed_B=Heat_speed_B_eeprom;}
for (i=0;i<4;i++){
if ((Heat_temp_U_eeprom[i]>0)&&(Heat_temp_U_eeprom[i]<255)){Heat_temp_U[i]=Heat_temp_U_eeprom[i];}
if ((Heat_temp_B_eeprom[i]>0)&&(Heat_temp_B_eeprom[i]<255)){Heat_temp_B[i]=Heat_temp_B_eeprom[i];}
if ((Heat_speed_eeprom[i]>0)&&(Heat_speed_eeprom[i]<255)){Heat_speed[i]=Heat_speed_eeprom[i];}

}
count_rules=2;
//TCnt_0=(100.0/freq)*78.125;
//TCnt_float=70.0;