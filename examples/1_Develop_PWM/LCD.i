
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
PORTC |=  (1<<PC5);   
else
PORTC &= ~(1<<PC5);  
}

void OutputVal(unsigned char val)
{
PORTC &= 0xF0; 

PORTC |= ((0xF0 & val)>>4);  
TriggerE(1000);
delay(100);
PORTC &= 0xF0; 
PORTC |= (0x0F & val);  
TriggerE(1000);
}

void SetRS(unsigned char val)
{
if(val == 1)
PORTC |= (1<<PC4);   
else
PORTC &= ~(1<<PC4);  
}

void LCDResetCursor()
{
SetRS(0);
cellCount = 0;

OutputVal(0x03);
TriggerE(1000);
delay(1000);   
}

void LCDInitialize()
{
cellCount = 0;
DDRC = 0xFF;  
SetRS(0);
OutputVal(0x00);     
delay(11500);   

OutputVal(0x20); 
TriggerE(1000);
delay(3124);    

TriggerE(1000);
delay(1000);

OutputVal(0x06);    
TriggerE(100);
delay(1000);

OutputVal(0x0f);    
TriggerE(100);
delay(1000);

OutputVal(0x01);    
TriggerE(100);
delay(100);
}

void LCDWriteChar(unsigned char letter)
{  
unsigned int i;

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

SetRS(1);

OutputVal(letter);
TriggerE(100);
delay(100);

}

void delay(unsigned long time)
{

unsigned int i;
for(i = 0; i < time; i++);
}

void TriggerE(unsigned int delayTime)
{
SetE(1);
delay(delayTime);
SetE(0);
}
