


//PORTD^=0b00001000;
//???????????
//PORTC^=0b00000001;


    
if(sw==0){
if (pulse_ok==0){
//adc[0]=read_adc(0);//????????? ???????
delay_us(200);
itoa(adc[0], adc_c[0]);
delay_us(200);
//????????? IR ?????????
adc[2]=read_adc(2);//????????? ???????
delay_ms(200);
ready_adc_2=1;
//#include <add_this.c>
//delay_ms(200);


lcd_clear();

lcd_gotoxy(0, 0);
lcd_putsf("temp");
delay_us(100);
lcd_puts(adc_c[0]);
delay_us(200);//ms



itoa(adc[2], adc_c[2]);
delay_us(200);//
lcd_gotoxy(8, 0);
lcd_putsf("IR");
//itoa(adc[2], adc_c[2]);
delay_us(200);
lcd_puts(adc_c[2]);
delay_us(200);


itoa(adc[1], adc_c[1]);
delay_us(200);
lcd_gotoxy(0, 1);
delay_us(200);
lcd_putsf("int:");
delay_us(200);
lcd_puts(adc_c[1]);
delay_us(200);
}

}
