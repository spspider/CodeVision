//***************************************************************************
//  File........: main.c
//
//  Author(s)...: Pashgan    chipenable.ru
//
//  Target(s)...: ATMega...
//
//  Compiler....: CodeVision 2.04
//
//  Description.: Использование схемы захвата для декодирования сигналов ИК ПДУ
//
//  Data........: 18.04.11 
//
//***************************************************************************
#include <mega8535.h>
#include "lcd_lib.h"
#include "timer.h"

void main(void)
{
  LCD_Init();
  TIM_Init();
  LCD_SendString("test");
  #asm("sei");
  
  while(1){
     TIM_Handle();    
     TIM_Display();
  }
}
