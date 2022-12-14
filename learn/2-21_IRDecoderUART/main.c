/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
? Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 21.12.2013
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
// Standard Input/Output functions
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <delay.h>

#define F_CPU           8000000L
#define IR_FRAME_US     560
#define IR_BAUD_SETTING ((((( F_CPU * IR_FRAME_US /  16000000 ) * 2 ) + 1 ) >> 1 ) - 1)

#define CMDBYTES    12

uint8_t s_CMDBuffer[ CMDBYTES ];
uint8_t s_cmdBufferIndex;

//==================================================
//==================================================
#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)      
{
    /* Wait for empty transmit buffer */
    while ( !( UCSRA & (1<<UDRE)) );
    /* Put data into into buffer, sends the data */
    UDR = c;
}
#pragma used-
#endif

//================================================
//================================================
void connfigureUARTStd9600()
{
    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSRA=0x00;
    UCSRB=0x18;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=0x33;
}

//================================================
//================================================
void connfigureUARTIR()
{
    // USART initialization
    // Communication Parameters: 7 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 1000000 / 560 = 1786 
    UCSRA=0x00;
    UCSRB=0x18;
    UCSRC=0x84;
    //UBRRH=IR_BAUD_SETTING >> 8;
    //UBRRL=IR_BAUD_SETTING & 0xff;
    UBRRH=1;
    UBRRL=0x17;
}

//================================================
//================================================
uint8_t readCMDBuffer( uint8_t _index )
{
    if ( _index >= CMDBYTES )
    {
        _index -= CMDBYTES; 
    }                     
    
    return s_CMDBuffer[ _index ];
} 

//================================================
//================================================
void clearCmdBuffer()
{
    uint8_t i;
    
    for ( i = 0; i < CMDBYTES; i++ )
    {
        s_CMDBuffer[ i ] = 0xff;
    }
}

//================================================
//================================================
bool haveValidCommand()
{
    if (
            ( readCMDBuffer( s_cmdBufferIndex ) == 0 ) 
#if 1
            &&
            ( readCMDBuffer( s_cmdBufferIndex + 1 ) == 0x55 ) &&
            ( readCMDBuffer( s_cmdBufferIndex + 2 ) == 0xD5 ) &&
            ( readCMDBuffer( s_cmdBufferIndex + 3 ) == 0x77 ) &&
            ( readCMDBuffer( s_cmdBufferIndex + 4 ) == 0x77 ) 
#endif            
    )
    {
        return true; 
    }
    
    
    return false;
}

//================================================
//================================================
void printBits( uint8_t _value )
{
    uint8_t j;
               
    //start bit is drop from 1 to 0
    printf( "\\" );

    for ( j = 0; j < 8; j++ )
    {
        if ( _value & ( 1 << j ) )
        {
            printf( "-" );
        }
        else
        {
            printf( "_" );
        }
    }
}


//================================================
//================================================
uint32_t calcCommandCRC( uint8_t _index ) 
{                                           
    uint32_t crc;   
    uint8_t i,j;
    
    crc = 0;
     
    for ( i = 0 ; i < CMDBYTES; i++ ) 
    { 
      crc = crc ^ readCMDBuffer( _index + i ); 
      for ( j = 0; j < 8; j++ ) 
      { 
         if (crc & 1) 
            crc = (crc>>1) ^ 0xEDB88320; 
         else 
            crc = crc >>1 ; 
      } 
    } 
   return crc ; 
} 

//================================================
//================================================
void main(void)
{
    uint8_t i,j;                 
    uint32_t crc;
    
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=P 
PORTD=0x01;
DDRD=0xFE;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;


// LCD module initialization
lcd_init(16);
// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

    connfigureUARTStd9600();    
    printf( "Ready\n" );

    delay_ms( 100 );

    s_cmdBufferIndex = 0;
    clearCmdBuffer();

    connfigureUARTIR();
    
while (1)
      {                                                 
      
        delay_ms( 4 );
        
        if  ( (UCSRA & (1<<RXC)) )
        {
            //has data         
            if ( (UCSRA & (1<<FE)) ) 
            {
                //stop bit was 0
                s_CMDBuffer[ s_cmdBufferIndex ] = UDR;
            }
            else
            {
                s_CMDBuffer[ s_cmdBufferIndex ] = UDR | 0x80;
            }              
            
            s_cmdBufferIndex++;
            if ( s_cmdBufferIndex == CMDBYTES )
            {
                s_cmdBufferIndex = 0;
            }          
            
                         
            if ( haveValidCommand() == true )
            {                     
                delay_ms( 100 );
                
                connfigureUARTStd9600();
                 
                crc = calcCommandCRC( s_cmdBufferIndex );         
                printf( "%04X%04X ", (uint16_t)(crc >> 16), (uint16_t)(crc & 0xffff) );
                
                for ( j = 0; j < CMDBYTES; j++ )
                {
                    printf( "%02X", readCMDBuffer( s_cmdBufferIndex + j ) );
                } 
                
                printf( "    " );
                                              
                for ( j = 0; j < CMDBYTES; j++ )
                {
                    printBits( readCMDBuffer( s_cmdBufferIndex + j ) );
                }

                printf( "\n" );
                
                delay_ms( 100 );
                
                connfigureUARTIR();
                
            }
            
        }    
        
        
      }
}
