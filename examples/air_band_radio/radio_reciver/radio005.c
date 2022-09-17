// Программа для прошивки PIC контроллера P16F84A для компилатора C2C
//
// Разработанный мною приемник авиационного диапазона позволяет принимать 
// FM диапазон от 88 мГц до 107.975 мГц, 
// а также авиационный AM диапазон от 108 мГц до 136 мГц. 
// Автоматически перестраивается из AM в FM при переходе на 
// соответствующий диапазон. Главная цель создания подобного приемника 
// заключалась в возможности получать информацию ATIS и прослушивать информацию 
// с близлежайшего аэропорта и бортов с целью обеспечения безопасности 
// полета на СЛА не оборудованных авиационными радиостанциями вследствии 
// проблем с регистрацей подобных устройств в нашей стране.
// Приемник может также использоваться в аэроклубах для контроля переговоров. 
// При отсутствии необходимости прослушивать авиационный диапазон можно 
// использовать FM диапазон и наслаждаться музыкой (что бывает приятно в полете).
// К сожалению весь FM диапазон не "уместился" и был немного "обрезан" для 
// получения возможности работы во всём авиационном диапазоне.

// Приемник содержит вращающуюся ручку для настройки частоты, 
// регулятор громкости и регулятор шумоподавителя. 
// При включении питания настраивается на границу 
// между двумя диапазонами = 108 мГц.

// При постановке задачи преследовалось простое управление и индикация 
// без сложных настроек и минимальная стоимость элементной базы и 
// готового изделия.

// Условия распостранения данной программы: - бесплатное
// Автор   Шаповалов Дмитрий
// e-mail  shapovalov@windows.ru 
// WEB     http://www.windows.ru/velocity
// Версия  1.005 от 12/11/2004
// Изменения в версии:
// Изменен принцип настройки частоты


#define START_FREQ 4320  // 108.0 мГц  Стартовая частота

#define TIMER_DIV        255 
#define TIMER_PRESCALER  1
#define T0IF_BIT         2

char LOAD_FREQ;      // 1 - загрузить частоту в синтезатор
char SET_DISPLAY;    // 1 - загрузить частоту на дисплей
char LOAD_STEP;      // Шаг программы загрузки частоты синтезатора
char LOAD_DISPLAY;   // Шаг программы загрузки частоты LCD дисплея
char OUT_PORT_A;     // Переменная для вывода в порт A
char OUT_PORT_B;     // Переменная для вывода в порт B
long FREQ_FULL;      // Частота настройки
long FREQ_LO;        // Переменная частоты для настройки синтезатора
long FREQ_DISPLAY;   // Переменная частоты для отображения на LCD дисплее
char FREQ_XX;        // Константа настройки шага синтезатора и его параметров
char NUM_BIT;        // Счетчик битов
char SW001;          // Ключ 1/0
char SIGN;           // Указатель массива символов для вывода на дисплей LCD
char BITS;           // Счетчик
char SWKEY_UP;       // Кнопка нажата
char SWKEY_MH;       // Кнопка нажата
long WSX;            // Счетчик задержки обновления LCD дисплея
char WS3;            // Ключ
char D[11];          // Массив данных символов для LCD дисплея

char MH_KH;          // Переключатель мГц - кГц
char PREV;
char CURR;

asm{ __config _CP_ON & _WDT_OFF & _RC_OSC }

void process(void)
{
//############ Загрузка частоты ##############################################

  if(LOAD_FREQ == 1) {  // = 1 Загрузить частоту в синтезатор

   switch(LOAD_STEP)
   {
     case 0:        // Разрешаем запись в регистры синтезатора и готовим данные
       OUT_PORT_A=(OUT_PORT_A&0xF8)+0x2;
       NUM_BIT=0;
       SW001=0;
       FREQ_LO = FREQ_FULL+0x1AC;
       if (FREQ_FULL>=4320) {FREQ_XX = 0xA4;} else {FREQ_XX = 0xA1;}
       LOAD_STEP++;
     break;

     case 1:        // Загружаем частоту настройки синтезатора 16 бит
       if(NUM_BIT<16) {
        if(SW001==0) {

         SW001=1;
        } else {
         FREQ_LO=FREQ_LO>>1;
         SW001=0;
         NUM_BIT++;
        }
        OUT_PORT_A=(OUT_PORT_A&0xFA)+SW001+((FREQ_LO&0x1)<<2);
       } else {
         NUM_BIT=0;
         LOAD_STEP++;

       }
     break;         //-------------------------------------

     case 2:        // Загружаем данные настройки синтезатора 8 бит
       if(NUM_BIT<8) {
        if(SW001==0) {

         SW001=1;
        } else {
         FREQ_XX=FREQ_XX>>1;
         SW001=0;
         NUM_BIT++;
        }
        OUT_PORT_A=(OUT_PORT_A&0xFA)+SW001+((FREQ_XX&0x1)<<2);
       } else {
         NUM_BIT=0;
         LOAD_STEP++;

       }
     break;         //-------------------------------------

     case 3:        // Запрещаем запись в регистры синтезатора
       OUT_PORT_A=OUT_PORT_A&0xF8;
       LOAD_FREQ = 0;   // Запрет загрузки частоты
       LOAD_STEP = 0;
     break;

   }   // Конец case LOAD_STEP

  }  // Конец проверки разрешения записи частоты 

//############ Дисплей #######################################################

  if(SET_DISPLAY==1) {
  if(WS3>0) {
    OUT_PORT_B=(OUT_PORT_B&0xDF);        // Подать синхро (логический 0)
    WS3--;
    if(WS3==0) {
      OUT_PORT_B=(OUT_PORT_B&0xDF)+0x20; // Убрать синхро (логическая 1)
    }
  } else {
   switch(LOAD_DISPLAY)
   {
     case 0:   // Декодируем частоту и подготавливаем формат данных
       FREQ_DISPLAY  =FREQ_FULL;
       if(FREQ_DISPLAY>=4000) {D[2]=1; FREQ_DISPLAY=FREQ_DISPLAY-4000;} else {D[2]=0;}
       if(FREQ_DISPLAY>=400) {  // Десятки мГц
         D[3]=0;
         while (FREQ_DISPLAY>=400) {
          FREQ_DISPLAY=FREQ_DISPLAY-400;
          D[3]=D[3]+1;
         }
       } else {D[3]=0xA;}
       if(FREQ_DISPLAY>=40) {   // Единицы мГц
         D[4]=0;
         while (FREQ_DISPLAY>=40) {
          FREQ_DISPLAY=FREQ_DISPLAY-40;
          D[4]=D[4]+1;
         }
       } else {D[4]=0xA;}
       if(FREQ_DISPLAY>=4) {    // Сотни кГц
         D[6]=0;
         while (FREQ_DISPLAY>=4) {
          FREQ_DISPLAY=FREQ_DISPLAY-4;
          D[6]=D[6]+1;
         }
       } else {D[6]=0xA;}
       if(FREQ_DISPLAY==0) {D[7]=0xA;D[8]=0xA;} // Десятки и единицы кГц
       if(FREQ_DISPLAY==1) {D[7]=2;D[8]=5;}
       if(FREQ_DISPLAY==2) {D[7]=5;D[8]=0xA;}
       if(FREQ_DISPLAY==3) {D[7]=7;D[8]=5;}
       D[5]=0xF; // Минус между мГц и кГц
       if(MH_KH==0) {D[1]=0;D[10]=12;} else {D[1]=13;D[10]=0;}
       SIGN=1;
       BITS=0;
       OUT_PORT_B=(OUT_PORT_B&0xDF)+0x20;
       LOAD_DISPLAY++;
     break;

     case 1:   // Посылаем частоту на дисплей
       if(SIGN<=10) {
        if (BITS<4) {
          D[0]=((D[SIGN]>>3)&1);
          D[SIGN]=D[SIGN]<<1;
          BITS++;
          OUT_PORT_B=(OUT_PORT_B&0x9F)+(D[0]<<6)+0x20;
          WS3=2;
        } else {
          BITS=0;
          SIGN++;
        }
       } else {
         LOAD_DISPLAY++;
       }
     break;
     case 2:   // Посылаем частоту на дисплей
       LOAD_DISPLAY=0;
       SET_DISPLAY=0;
     break;
   }
  }
  }

//############ AM / FM #######################################################

    if(FREQ_FULL>=4320) {                 // Автоматическое распознавание AM/FM
      OUT_PORT_A=(OUT_PORT_A&0xEF);       // AM
    } else {
      OUT_PORT_A=(OUT_PORT_A&0xEF)+0x10;  // FM
    }

//############ Кнопки ########################################################

//    if((input_port_b()&0x1)!=0) {                        // Частоту вверх
//      if(SWKEY_UP<5) SWKEY_UP++;
//    } else {
//      if(SWKEY_UP==5) { // Поднять частоту
//        if (MH_KH==0) {
//         if (FREQ_FULL<5440) { FREQ_FULL++;}             // Частоту вверх 25 кГц
//        } else {
//         if (FREQ_FULL<=5400) { FREQ_FULL=FREQ_FULL+40;} // Частоту вверх  1 мГц
//        }
//        LOAD_FREQ = 1;   // Загрузить частоту
//        SET_DISPLAY= 1;
//      }
//      SWKEY_UP=0;
//    }

//    if((input_port_b()&0x2)!=0) {                        // Частоту вниз
//      if(SWKEY_UP<5) SWKEY_UP++;
//    } else {
//      if(SWKEY_UP==5) { // Опустить частоту
//        if (MH_KH==0) {
//         if (FREQ_FULL>3520) { FREQ_FULL--;}             // Частоту вниз 25 кГц
//        } else {
//         if (FREQ_FULL>=3560) { FREQ_FULL=FREQ_FULL-40;} // Частоту вниз  1 мГц
//        }
//        LOAD_FREQ = 1;   // Загрузить частоту
//        SET_DISPLAY= 1;
//      }
//      SWKEY_UP=0;
//    }



//----
     CURR=(input_port_b()&0x3);
     if(PREV==3) {
      if (CURR==2) {
        if (MH_KH==0) {
         if (FREQ_FULL<5440) { FREQ_FULL++;}             // Частоту вверх 25 кГц
        } else {
         if (FREQ_FULL<=5400) { FREQ_FULL=FREQ_FULL+40;} // Частоту вверх  1 мГц
        }
        LOAD_FREQ = 1;   // Загрузить частоту
        SET_DISPLAY= 1;
        PREV=4;
      }
      if (CURR==1) {
        if (MH_KH==0) {
         if (FREQ_FULL>3520) { FREQ_FULL--;}             // Частоту вниз 25 кГц
        } else {
         if (FREQ_FULL>=3560) { FREQ_FULL=FREQ_FULL-40;} // Частоту вниз  1 мГц
        }
        LOAD_FREQ = 1;   // Загрузить частоту
        SET_DISPLAY= 1;
        PREV=4;
      }
     }
     if(CURR==3) {
      if(SWKEY_UP<10) SWKEY_UP++;
     } else {
      if(SWKEY_UP>0) SWKEY_UP--;
     }
     if(SWKEY_UP== 10) PREV=3;
     if(SWKEY_UP==  0) PREV=4;

//----
    if((input_port_b()&0x4)==0) {  // Переключение шага изменения частот
      if(SWKEY_MH<10) SWKEY_MH++;
    } else {
      if(SWKEY_MH==10) { // Поднять частоту
       if (MH_KH==0) {MH_KH=1;} else {MH_KH=0;} // Переключение режима кГц - мГц
        SET_DISPLAY= 1;
      }
      SWKEY_MH=0;
    }


}

//############ Прерывание по таймеру #########################################

void interrupt( void )
{
   if(INTCON & (1<<T0IF_BIT)){
     TMR0= TIMER_DIV;
     clear_bit(INTCON,T0IF_BIT); 
     process();                  // Вызов процедуры обработки
     output_port_a(OUT_PORT_A);  // Вывод в порт A
     output_port_b(OUT_PORT_B);  // Вывод в порт B
     if (WSX>0) {WSX--;} else { WSX=35000; SET_DISPLAY =1; } // Задержка между выводом на LCD
   }
}

//############ Первичная инициализация и запуск программы ####################

void main( void )
{
  INTCON= 0;
  set_bit(STATUS,RP0);
  set_option(TIMER_PRESCALER); 
  clear_bit(STATUS,RP0);
  output_port_a(0); 
  output_port_b(0x20); 
  set_bit(STATUS,RP0);
  set_tris_b(0x1F); 
  set_tris_a(0); 
  clear_bit(STATUS,RP0);
  TMR0= TIMER_DIV;

  SWKEY_UP=0;             // Защита кнопок от дребезга
  OUT_PORT_A = 0;         // Инициализация данных порта A
  OUT_PORT_B = 0x20;      // Инициализация данных порта B
  FREQ_FULL=START_FREQ;   // Проинициализировать стартовую частоту
  LOAD_DISPLAY = 0;       // Указатель загрузки дисплея в начало
  LOAD_STEP    = 0;       // Указатель загрузки частоты в начало
  SET_DISPLAY  = 1;       // Загрузить дисплей
  LOAD_FREQ    = 1;       // Загрузить частоту
  WSX=4000;               // Первичная задержка перед выводом на LCD
  MH_KH=0;

  enable_interrupt(T0IE); // Запустить прерывание по таймеру
  enable_interrupt(GIE);
  for(;;){ }
}
