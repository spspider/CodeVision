
//if ((PINB.5==0)&&(BTN1_pressed==0)&&(BTN_pressed==0)){
if ((PINB.5==0)&&(BTN_pressed==0)){  //BTN+(sck)
if(heater_swither==1){if (PWM_setted[0]<10){PWM_setted[0]++;};show_lcd=2;}
if(heater_swither==2){if (PWM_setted[1]<10){PWM_setted[1]++;};show_lcd=2;}
if(heater_swither==3){start=1;buzz_freg=131;buzz_cont=50;}; 
if (heater_swither==4){start_BT=1;buzz_freg=131;buzz_cont=50;}
//if (heater_swither==5){show_lcd=0;if (set_tempU<200){set_tempU++;};}
if (heater_swither==8){show_lcd=5;if (set_now_rule<10){set_now_rule++;};}
if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]<2){Heat_rule[set_now_rule]++;};}
//if (heater_swither==10){show_lcd=5;if (Heat_time[set_now_rule]<30){Heat_time[set_now_rule]++;};}//Heat_time
if (heater_swither==10){show_lcd=5;if (Heat_speed_B<100){Heat_speed_B++;};}//Heat_speed_B
if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]++;}//Heat_speed
if (heater_swither==12){show_lcd=5;heater_swither=13;}//Heat_power_B
if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]<450){Heat_temp_U[set_now_rule]++;};}//Heat_temp_U
if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]<450){Heat_temp_B[set_now_rule]++;};}//Heat_temp_B

if (heater_swither==15){show_lcd=6;;}

//set_tempU_ee=set_tempU;
//set_tempB_ee=set_tempB;

lcd_freeze=5;
BTN1_pressed=1;
BTN_pressed=1;
}
//if(PINB.5==1){BTN1_pressed=0;}

if ((PINB.3==0)&&(BTN_pressed==0)){
if(heater_swither==1){if (PWM_setted[0]>0){PWM_setted[0]--;};show_lcd=2;}
if(heater_swither==2){if (PWM_setted[1]>0){PWM_setted[1]--;};show_lcd=2;}
if(heater_swither==3){start=0;buzz_freg=6;buzz_cont=100;};
if (heater_swither==4){start_BT=0;buzz_freg=131;buzz_cont=50;}
//if (heater_swither==5){show_lcd=0;if (set_tempU>0){set_tempU--;};}
if (heater_swither==8){show_lcd=5;if (set_now_rule>0){set_now_rule--;};}
if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]>0){Heat_rule[set_now_rule]--;}else{Heat_rule[set_now_rule]=0;};}
//if (heater_swither==10){show_lcd=5;if(Heat_time[set_now_rule]>0){Heat_time[set_now_rule]--;};}//Heat_time
if (heater_swither==10){show_lcd=5;if (Heat_speed_B>1){Heat_speed_B--;};}//Heat_speed_B
if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]--;}//Heat_power_U
if (heater_swither==12){heater_swither=13;}//Heat_power_B
if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]>0){Heat_temp_U[set_now_rule]--;};}//Heat_temp_U
if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]>0){Heat_temp_B[set_now_rule]--;};}//Heat_temp_B

if (heater_swither==15){show_lcd=6;;}

BTN_pressed=1;
lcd_freeze=5;


}
//show_lcd=6;
//if(PINB.3==1){BTN2_pressed=0;}

if ((PINB.4==0)&&(BTN3_pressed==0)&&(BTN_pressed==0)){

heater_swither++;
if (heater_swither>15){heater_swither=1;}

if (heater_swither==1){choose_v(1);show_lcd=2;} //меню PWM
if (heater_swither==2){choose_v(2);show_lcd=2;} //меню PWM
if (heater_swither==3){show_lcd=3;choose_v(0);} // меню старт стоп
if (heater_swither==4){show_lcd=3;choose_v(12);} // меню старт стоп
if (heater_swither==5){heater_swither=6;};
if (heater_swither==6){show_lcd=1;}//меню обратного отсчета
if (heater_swither==7){heater_swither=8;}
if (heater_swither==8){show_lcd=5;choose_v(5);if (start==1){set_now_rule=now_rule;};}//set_now_rule   //настройка правил
//if (heater_swither==9){show_lcd=5;choose_v(6);}//Heat_rule  //настройка правил
//if (heater_swither==10){show_lcd=5;choose_v(7);}//Heat_time   //настройка правил
if (heater_swither==8){heater_swither=10;}//пропуск с 8-го по 11
if (heater_swither==10){show_lcd=5;choose_v(9);}//Heat_speed_B    //настройка правил
if (heater_swither==11){show_lcd=5;choose_v(8);}//Heat_speed    //настройка правил
if (heater_swither==12){heater_swither=13;}
if (heater_swither==13){show_lcd=5;choose_v(10);}//Heat_temp_U   //настройка правил
if (heater_swither==14){show_lcd=5;choose_v(11);}//Heat_temp_B  //настройка правил
if (heater_swither==15){show_lcd=6;}//tcnt

for (i=0;i<4;i++){
Heat_temp_U_eeprom[i]=Heat_temp_U[i];
Heat_temp_B_eeprom[i]=Heat_temp_B[i];
Heat_speed_eeprom[i]=Heat_speed[i];
}
Heat_speed_B_eeprom = Heat_speed_B;

BTN3_pressed=1;
BTN_pressed=1;
lcd_freeze=5;

buzz_freg=131;buzz_cont=10;

}

if((PINB.4==1)&&(BTN3_pressed==1)){
BTN3_pressed=0;
//eeprom_write_byte(uint8_t * __p,0x55);

//eeprom_write_byte((uint8_t*)0,set_tempB);
}
//hjgkgmjhl.dddd890
//fgh87)-+|89****dgh+

//}
