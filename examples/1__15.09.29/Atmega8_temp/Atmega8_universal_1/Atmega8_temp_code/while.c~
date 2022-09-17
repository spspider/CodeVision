//////////////////////////////////////////////////////////////////
  //show_data=getchar();
if ((STempEE!=32767)&&(EEPromOut==0)){
STemp = STempEE/100.00;
EEPromOut=1;
}  
if ((STemp<-5.00)||(STempEE<-500)){STemp=-5.00;STempEE=-500;}  
if ((STemp>30.00)||(STempEE>3000)){STemp=30.00;STempEE=30000;}  
  
  

if ((Temp<Temp_min)&&(Temp!=0.00)){
Temp_min=Temp;
}


//берем параметры
if(Timer_read_adc_2==20){
adc[0]=read_adc(0);//чтение температуры
Temp=adc[0]/18.52631578;
}
if(Timer_read_adc_2==22){
adc[1]=read_adc(1);//чтение CO
CO_sensor=adc[1];
}           
if(Timer_read_adc_2==44){
Timer_read_adc_2=0;   // обнуляем 
}   

//STemp=adc[2]/42.625;






if (Timer_LCD==250){
//отображение


if (LCD_switch==1){


    Time_hour=Time_sec_all/60.0/60.0;
    Time_min=((Time_sec_all/60.0)-(Time_hour*60.0));
    Time_sec=((Time_sec_all)-((Time_min*60.0)+(Time_hour*60.0*60.0)));

sprintf(Temp_str, "T:%.1f", Temp);
sprintf(_NeedTemp," ST:%.1f",STemp);
sprintf(Time_str," time:%d",Time);
sprintf(_Time_hour,"%d:",Time_hour);
sprintf(_Time_min,"%d:",Time_min);
sprintf(_Time_sec,"%d",Time_sec);
//sprintf(_Temp_min,"min:%.1f",Temp_min);
sprintf(_CO_sensor,"CO:%.1f",CO_sensor);

lcd_clear();
lcd_gotoxy(0,0);
lcd_puts(Temp_str);
lcd_puts(_NeedTemp);
lcd_gotoxy(0,1);
lcd_puts(_Time_hour);
lcd_puts(_Time_min);
lcd_puts(_Time_sec);
lcd_gotoxy(7,1);
//lcd_puts(_Temp_min);
lcd_puts(_CO_sensor);
}
/////////////////////////////////////////////////////////////////////
if (LCD_switch==200){
   
      while(j<12)
      {                  
      lcd_gotoxy(j,0);
      sprintf(lcd_buffer,"%c",uart_data[j]);
      lcd_puts(lcd_buffer);
      j++;
      }
      j=0;

      };
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//}
Timer_LCD=0;
}
