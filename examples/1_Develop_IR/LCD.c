 #include <avr/io.h>    

extern unsigned char cellCount;
extern void LCDInitialize();
extern void LCDWriteChar(unsigned char letter);
extern void TriggerE(unsigned int delayTime);
extern void delay(unsigned int time);

int main()
{
      LCDInitialize();
      while(1)
         LCDWriteChar('a');

   return 0;
}
//-----------------------------------------LCD helper file---------------------------------------
#include <avr/io.h>

/*
Painfully rough and poor code to institute a 4 wire LCD using an ATmega8
*/

/* Useful functions to your main code:
extern unsigned char cellCount;
extern void LCDInitialize();
extern void LCDWriteChar(unsigned char letter);
*/
#define E = (1<<PC5)   // E = PC5
#define RS = (1<<PC4)      // RS = PC4
 
unsigned char cellCount;
void LCDInitialize();
void LCDWriteChar(unsigned char letter);
void TriggerE(unsigned int delayTime);
void delay(unsigned long time);
void LCDResetCursor();
void SetRS(unsigned char val);
void SetE(unsigned char val);
void OutputVal(unsigned char val);

void SetE(unsigned char val)
{
   if(val == 1)
      PORTC |=  (1<<PC5);   //Set the RS pin to 1
   else
      PORTC &= ~(1<<PC5);  //set the RS pin to 0
}

void OutputVal(unsigned char val)
{
   PORTC &= 0xF0; //set the lower four bits to a 0, for consistancy sake
   //output the first part of the value:
   PORTC |= ((0xF0 & val)>>4);  //display the top part as the lower 4 bits
   TriggerE(1000);
   delay(100);
   PORTC &= 0xF0; //set the lower four bits to a 0, for consistancy sake
   PORTC |= (0x0F & val);  //display the top part as the lower 4 bits
   TriggerE(1000);
}


void SetRS(unsigned char val)
{
   if(val == 1)
      PORTC |= (1<<PC4);   //Set the RS pin to 1
   else
      PORTC &= ~(1<<PC4);  //set the RS pin to 0
}



//reset cursor to the beginning
void LCDResetCursor()
{
    SetRS(0);
    cellCount = 0;
    //set cursor to home
    OutputVal(0x03);
    TriggerE(1000);
    delay(1000);   
}
//initialize LCD routine
void LCDInitialize()
{
    cellCount = 0;
    DDRC = 0xFF;  //set PORTC as output port
    SetRS(0);
    OutputVal(0x00);     //clear buffer
    delay(11500);   //delay for about 15 milliseconds
   
    OutputVal(0x20); //function set: 4 bit mode
    TriggerE(1000);
    delay(3124);    //need to delay for more than 4.1 ms       
  
  //  OutputVal(0x28); //For some reason, it treats this LCD as a 8x2 array, instead of a 16x1. Uncomment this line and you will see that each cell is used
    TriggerE(1000);
    delay(1000);


    OutputVal(0x06);    //cursor move right, no shift display
    TriggerE(100);
    delay(1000);

    OutputVal(0x0f);    //display on blinker, ect
    TriggerE(100);
    delay(1000);

    OutputVal(0x01);    //set cursor to home and clear the cursor
    TriggerE(100);
    delay(100);
}


void LCDWriteChar(unsigned char letter)
{  
    unsigned int i;

    //skip to the next row
    if(cellCount == 16)
    {
        for(i = 0; i < 24; i++)
        {
            SetRS(1);
            OutputVal(letter);
            TriggerE(1);
            delay(100);
        }
    }
    //clear the screen and jump to the first line
    else if(cellCount == 33)
    {
        for(i = 0; i < 104; i++)
        {
            OutputVal(0x20);
            TriggerE(1);
            delay(100);
            cellCount = 1;
        }
    }

    //output the values

    SetRS(1);

    OutputVal(letter);
    TriggerE(100);
    delay(100);
//   OutputVal(0xFF);
}



void delay(unsigned long time)
{

//The FOR loop runs 14 assembly instructions.
//each assembly instruction takes approximately 3 clock cycles per instruction.
//meaning each iteration takes about 3*14= 42 clock cycles.
//Since I am using a 16 MHz clock, each clock cycle takes 1/16000000 seconds, or 62.5 nanoseconds.
// 62.5 ns * 42 = 2.625 microseconds per loop.

//1 second should be 380952 loops
//to test, run delay at 65535 for 5.8129 times
//or 20000 for 19 times.

//After testing, it looks like it is closer to 40000 for 19 times, implying that it is 1 to 2 clock cycles per instruction.
//also implying that it is 1.3125 microseconds per loop  

    unsigned int i;
    for(i = 0; i < time; i++);
}

//delayTime = time required to keep e high
void TriggerE(unsigned int delayTime)
{
   SetE(1);
   delay(delayTime);
   SetE(0);
}