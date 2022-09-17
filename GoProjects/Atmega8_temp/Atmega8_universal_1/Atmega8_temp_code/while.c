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
Temp=adc[0]/18.52631578947368;
}if(Timer_read_adc_2==22){
//adc[2]=read_adc(2);//чтение установленной температуры
Timer_read_adc_2=0;   // Выводим строку _str на дисплей ЖКИ 
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
sprintf(_Temp_min,"min:%.1f",Temp_min);

lcd_clear();
lcd_gotoxy(0,0);
lcd_puts(Temp_str);
lcd_puts(_NeedTemp);
lcd_gotoxy(0,1);
lcd_puts(_Time_hour);
lcd_puts(_Time_min);
lcd_puts(_Time_sec);
lcd_gotoxy(7,1);
lcd_puts(_Temp_min);

}
/////////////////////////////////////////////////////////////////////
if (LCD_switch==2){


      
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
if (LCD_switch==3){
       // uart_data[2]=120;
       // uart_data[3]=150;
      
      lcd_clear();
      lcd_gotoxy(0,0);
      sprintf(lcd_buffer,"D:%u",databits);
      lcd_puts(lcd_buffer);
      databits=0;
}
//////////////////////////////////////////////////////////////////////////////
//}
Timer_LCD=0;
}
