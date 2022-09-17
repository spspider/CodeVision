//***************************************************************************
//  File........: lcd_lib.h
//
//  Author(s)...: Pashgan    chipenable.ru
//
//  Target(s)...: ATMega...
//
//  Compiler....: CodeVision
//
//  Description.: Драйвер знакосинтезирующего жк дисплея
//
//  Data........: 28.10.09  
//
//***************************************************************************
#ifndef LCD_LIB_H
#define LCD_LIB_H

#include <mega8535.h>
#include <delay.h>

//порт к которому подключена шина данных ЖКД
#define PORT_DATA PORTC
#define PIN_DATA  PINC
#define DDRX_DATA DDRC

//порт к которому подключены управляющие выводы ЖКД
#define PORT_SIG PORTC
#define PIN_SIG  PINC
#define DDRX_SIG DDRC

//Номера выводов к которым подключены управляющие выводы ЖКД 
#define RS 2
#define RW 1
#define EN 0

#define F_CPU 16000000

//#define CHECK_FLAG_BF
#define BUS_4BIT
#define HD44780
//******************************************************************************
//макросы

/*позиционирование курсора*/
#define LCD_Goto(x,y) LCD_WriteCom(((((y)& 1)*0x40)+((x)& 15))|128) 


//прототипы функций
void LCD_Init(void);//инициализация портов и жкд
void LCD_Clear(void);//очистка жкд
void LCD_WriteData(unsigned char data); //выводит байт данных на жкд
void LCD_WriteCom(unsigned char data); //посылает команду жкд
void LCD_SendStringFlash(char __flash *str); //выводит строку из флэш памяти
void LCD_SendString(char *str); //выводит строку из ОЗУ
#endif