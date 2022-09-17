/*
HiSER (c)2011 01
*/
#include "delay.h"
#include "_lcd.h"

void lcd_send(byte v) {
#ifdef LCD_DATA_H
LCD_DATA_H&=0x0f;
LCD_DATA_H|=v&0xf0;
#else
LCD_DATA_L&=0xf0;
LCD_DATA_L|=v>>4;
#endif
delay_us(10);
LCD_E=1;
delay_us(10);
LCD_E=0;
#ifdef LCD_DATA_H
LCD_DATA_H&=0x0f;
LCD_DATA_H|=v<<4;
#else
LCD_DATA_L&=0xf0;
LCD_DATA_L|=v&0x0f;
#endif
delay_us(10);
LCD_E=1;
delay_us(10);
LCD_E=0;
}

void lcd_init() {
LCD_E=0;
LCD_RS=0;
#ifdef LCD_DATA_H
LCD_DATA_H&=0x0f;
LCD_DATA_H|=0x20;
#else
LCD_DATA_L&=0xf0;
LCD_DATA_L|=2;
#endif
delay_ms(20);
LCD_E=1;
delay_us(10);
LCD_E=0;
lcd_send(0x28);
delay_us(40);
#ifdef DEFAULT_ON
lcd_send(0x0c);
#else
lcd_send(8);
#endif
lcd_send(0x06);
delay_us(40);
lcd_send(0x10);
delay_us(40);
lcd_send(1);
delay_ms(2);
LCD_RS=1;
}

void lcd_ctr(byte b) {
LCD_RS=0;
lcd_send(8|b);
delay_us(40);
LCD_RS=1;
}

void lcd_clear() {
LCD_RS=0;
lcd_send(1);
delay_ms(2);
LCD_RS=1;
}

void lcd_put(byte b) {
lcd_send(b);
delay_us(50);
}

void lcd_putsf(flash byte *b) {
while(*b!=0) lcd_put(*b++);
}

void lcd_puts(byte *b) {
while(*b!=0) lcd_put(*b++);
}

void lcd_xy(byte x,byte y) {
LCD_RS=0;
switch (y) {
case 0:lcd_send(0x80+x);break;
case 1:lcd_send(0xc0+x);break;
case 2:lcd_send(0x94+x);break;
case 3:lcd_send(0xd4+x);break;
}
delay_us(40);
LCD_RS=1;
}

void lcd_userfont(byte addr,flash byte *b) {
byte i=8;
LCD_RS=0;
lcd_send(0x40|(addr<<3));
delay_us(40);
LCD_RS=1;
while (i>0) {
lcd_send(*b++);
delay_us(50);
i--;
}
LCD_RS=0;
lcd_send(0x80);
delay_us(40);
LCD_RS=1;
}
