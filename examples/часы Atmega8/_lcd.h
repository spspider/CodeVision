/*
HiSER (c)2011 01
*/
#ifndef _lcd_h_
#define _lcd_h_

#include "mega8.h"
#include "_type.h"

#define LCD_RS PORTB.4
#define LCD_E PORTB.5
//#define LCD_DATA_H PORTB //PB.4-PB.7 high tetrad
#define LCD_DATA_L PORTB //PB.0-PB.3 low tetrad

//#define DEFAULT_ON //ON display at lcd_init()

#define LCD_CTR_BLINK 1
#define LCD_CTR_CURSOR 2
#define LCD_CTR_ON 4

void lcd_init();
void lcd_clear();
void lcd_put(byte b); //user char (0-7 or 8-15)
void lcd_putsf(flash byte *b);
void lcd_puts(byte *b);
void lcd_xy(byte x,byte y); //x 0-19, y 0-3
void lcd_ctr(byte b); //LCD_CTR_x
void lcd_userfont(byte addr,flash byte *b); //addr 0-7, font 5x8

#pragma library _lcd.c
#endif
