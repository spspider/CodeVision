#pragma once
//  ATMega8 LED 
//
//  (C) 2009 Radu Motisan , radu.motisan@gmail.com
//  www.pocketmagic.net
//  All rights reserved.
//
//  LED.h: Definitions for LED usage
#include <avr/io.h>

#define LED_DDR DDRD
#define LED_PORT PORTD
#define LED_PIN PIND
//--define pin where LED sensor is connected
#define LED_DQ 7	//PB0
//--
#define LED_INPUT_MODE() LED_DDR&=~(1<<LED_DQ)
#define LED_OUTPUT_MODE() LED_DDR|=(1<<LED_DQ)
#define LED_LOW() LED_PORT&=~(1<<LED_DQ)
#define LED_HIGH() LED_PORT|=(1<<LED_DQ)


int LEDInit();
int LEDSet(int st);
void LEDToggle();