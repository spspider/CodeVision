// интерфейс 1-Wire

#ifndef _1_WIRE_H_
#define _1_WIRE_H_ 1



// Назначение порта и пина для подключения датчика
#define OW_PORT		PORTC	/* порт управления */
#define OW_DDR		DDRC	/* регистр направления порта */
#define OW_PIN		PINC    /* регистр пинов порта */
#define OW_P		2	    /* номер бита порта */
 
// прототипы функций низкого уровня
uint8_t		ow_reset(void);                 //сброс шины
void		ow_put_bit(uint8_t bit);        
uint8_t		ow_get_bit(void);
void		ow_write_byte(uint8_t data);    // запись байта
uint8_t		ow_read_byte(void);             // чтение байта


/* General 1 wire commands */              // команды шины
#define OW_OVRDRV_SKIP_CMD	0x3c
#define OW_SEARCH_ALRM_CMD	0xec
#define OW_SEARCH_ROM_CMD	0xf0
#define OW_READ_ROM_CMD		0x33
#define OW_MATCH_ROM_CMD	0x55
#define OW_SKIP_ROM_CMD		0xcc
#define DS18B20_9_BIT       0x00             // конфигурируем на 9 бит
#define Tl_user_byte        0x37  //нижний порог термометра
#define Th_user_byte        0x64  // верхний порог 
// команды датчиков
#define CMD_START_CONV		0x44
#define CMD_RD_SCRPAD		0xbe
#define CMD_WR_SCRPAD		0x4e
#define CMD_CPY_SCRPAD		0x48
#define CMD_RECALL			0xb8
#define CMD_RD_PSU			0xb4

/* Family codes */      // коды семейста
#define OW_FAMILY_ROM		0x09
#define OW_FAMILY_TEMP		0x10   // ds18b20

#endif
