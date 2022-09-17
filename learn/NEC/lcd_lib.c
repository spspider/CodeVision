#include "lcd_lib.h"

//макросы для работы с битами
#define ClearBit(reg, bit)       reg &= (~(1<<(bit)))
#define SetBit(reg, bit)         reg |= (1<<(bit))	

#define FLAG_BF 7

unsigned char __swap_nibbles(unsigned char data)
{
 #asm
 ld r30, Y
 swap r30 
 #endasm
}

void LCD_WriteComInit(unsigned char data)
{
  unsigned char tmp; 
  delay_us(40);
  ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
#ifdef BUS_4BIT
  tmp  = PORT_DATA & 0x0f;
  tmp |= (data & 0xf0);
  PORT_DATA = tmp;		//вывод старшей тетрады 
#else
  PORT_DATA = data;		//вывод данных на шину индикатора 
#endif  
  SetBit(PORT_SIG, EN);	        //установка E в 1
  delay_us(2);
  ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
}


inline static void LCD_CommonFunc(unsigned char data)
{
#ifdef BUS_4BIT  
  unsigned char tmp; 
  tmp  = PORT_DATA & 0x0f;
  tmp |= (data & 0xf0);

  PORT_DATA = tmp;		//вывод старшей тетрады 
  SetBit(PORT_SIG, EN);	        
  delay_us(2);
  ClearBit(PORT_SIG, EN);	

  data = __swap_nibbles(data);
  tmp  = PORT_DATA & 0x0f;
  tmp |= (data & 0xf0);
 
  PORT_DATA = tmp;		//вывод младшей тетрады 
  SetBit(PORT_SIG, EN);	        
  delay_us(2);
  ClearBit(PORT_SIG, EN);	 
#else 
  PORT_DATA = data;		//вывод данных на шину индикатора 
  SetBit(PORT_SIG, EN);	        //установка E в 1
  delay_us(2);
  ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
#endif
}

inline static void LCD_Wait(void)
{
#ifdef CHECK_FLAG_BF
  #ifdef BUS_4BIT
  
  unsigned char data;
  DDRX_DATA &= 0x0f;            //конфигурируем порт на вход
  PORT_DATA |= 0xf0;	        //включаем pull-up резисторы
  SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
  ClearBit(PORT_SIG, RS);	//RS в 0 команды
  do{
    SetBit(PORT_SIG, EN);	
    delay_us(2);
    data = PIN_DATA & 0xf0;      //чтение данных с порта
    ClearBit(PORT_SIG, EN);
    data = __swap_nibbles(data);
    SetBit(PORT_SIG, EN);	
    delay_us(2);
    data |= PIN_DATA & 0xf0;      //чтение данных с порта
    ClearBit(PORT_SIG, EN);
    data = __swap_nibbles(data);
  }while((data & (1<<FLAG_BF))!= 0 );
  ClearBit(PORT_SIG, RW);
  DDRX_DATA |= 0xf0; 
  
  #else
  unsigned char data;
  DDRX_DATA = 0;                //конфигурируем порт на вход
  PORT_DATA = 0xff;	        //включаем pull-up резисторы
  SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
  ClearBit(PORT_SIG, RS);	//RS в 0 команды
  do{
    SetBit(PORT_SIG, EN);	
    delay_us(2);
    data = PIN_DATA;            //чтение данных с порта
    ClearBit(PORT_SIG, EN);	
  }while((data & (1<<FLAG_BF))!= 0 );
  ClearBit(PORT_SIG, RW);
  DDRX_DATA = 0xff; 
  #endif    
#else
  delay_us(40);
#endif  
}

//функция записи команды 
void LCD_WriteCom(unsigned char data)
{
  LCD_Wait();
  ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
  LCD_CommonFunc(data);
}

//функция записи данных
void LCD_WriteData(unsigned char data)
{
  LCD_Wait();
  SetBit(PORT_SIG, RS);	        //установка RS в 1 - данные
  LCD_CommonFunc(data);
}

//функция инициализации
void LCD_Init(void)
{
#ifdef BUS_4BIT
  DDRX_DATA |= 0xf0;
  PORT_DATA |= 0xf0; 
#else  
  DDRX_DATA |= 0xff;
  PORT_DATA |= 0xff;
#endif
  
  DDRX_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
  PORT_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
  ClearBit(PORT_SIG, RW);
  delay_ms(40);
  
#ifdef HD44780  
  LCD_WriteComInit(0x30); 
  delay_ms(10);
  LCD_WriteComInit(0x30);
  delay_ms(1);
  LCD_WriteComInit(0x30);
#endif
  
#ifdef BUS_4BIT  
  LCD_WriteComInit(0x20); //4-ми разрядная шина
  LCD_WriteCom(0x28); //4-ми разрядная шина, 2 - строки
#else
  LCD_WriteCom(0x38); //8-ми разрядная шина, 2 - строки
#endif
  LCD_WriteCom(0x08);
  LCD_WriteCom(0x0c);  //0b00001111 - дисплей вкл, курсор и мерцание выключены
  LCD_WriteCom(0x01);  //0b00000001 - очистка дисплея
  delay_ms(2);
  LCD_WriteCom(0x06);  //0b00000110 - курсор движется вправо, сдвига нет
}

//функция вывода строки из флэш памяти
void LCD_SendStringFlash(char __flash *str)
{
  unsigned char data;			
  while (*str)
  {
    data = *str++;
    LCD_WriteData(data);
  }
}

//функция вывда строки из ОЗУ
void LCD_SendString(char *str)
{
  unsigned char data;
  while (*str)
  {
    data = *str++;
    LCD_WriteData(data);
  }
}

void LCD_Clear(void)
{
  LCD_WriteCom(0x01);
  delay_ms(2);
}