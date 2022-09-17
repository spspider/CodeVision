// реализация 1-Wire программно (частично заимствованный файл откуда-то из интернета)
#define F_CPU 12000000
#include <avr/io.h>

#include <util/delay.h>
#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/crc16.h>
#include "1w.h"
#include <avr/interrupt.h>

#define ow_delay _delay_us(10) /* защитная пауза */
#define wire_0 OW_DDR |= (1<<OW_P)     // порт на выход
#define wire_1 OW_DDR &= ~(1<<OW_P)    // порт на вход

/*-----------------------------------------------------------------------------
 * Формируем 1-Wire reset, возвращаем 0 если presense не обнаружен,
 * возвращаем 1 если presense обнаружен.
 */
 
uint8_t ow_reset(void) {
  cli();
	uint8_t result = 1;
	OW_PORT &= ~(1 << OW_P);	// 0 в порт для "просадки" в ноль
	wire_0;						// включаем "просадку"
    _delay_us(500);				// RESET Pulse
	wire_1;						// отключаем просадку
	_delay_us(100);
	if (OW_PIN & (1 << OW_P)) result = 0;
	_delay_us(400);				// защитная пауза в конце
	sei();
	return result;
} 
/*-----------------------------------------------------------------------------
 передача бита на шину 
 */
void ow_put_bit(uint8_t bit){
  cli();
    ow_delay;			         // ???
    cli ();                     // запрещаем прерывания
	wire_0;                    // порт на выход
	_delay_us(6);	           // начало тайм-слота
	sei();
    if (bit){ 
		wire_1;               
		_delay_us(90);
    } else {
		_delay_us(90);
		wire_1;          
	}
	ow_delay;			// ???
	sei();
}

/*-----------------------------------------------------------------------------
 *  принимаем бит с шины
 */
uint8_t ow_get_bit(void) {
  cli();
    uint8_t result;
	ow_delay;			// ???
	cli();
	wire_0;
	_delay_us(6);		// начало тайм-слота
	wire_1;
	_delay_us(7);		// опрос на 14-й микросекунде
	result = (OW_PIN >> OW_P) & 1; // ринятое в result
	sei();

	_delay_us(90);
	sei();
    return result;     // возвращаем значение 
}

/*-----------------------------------------------------------------------------
 передаем байты датчику (используем функцию ow_put_bit)
 */
void ow_write_byte(uint8_t data) {
  cli();
    uint8_t i;
 for (i = 0; i < 8; i++) {                 // цикл передачи байтов
		ow_put_bit(data & 0x01);           // передача бита в порт
		data >>= 1;                        // следующий бит
    }
	sei();
}

  /*-----------------------------------------------------------------------------
 *  чтение данных датчика возвращает прочитанный байт 
 */
uint8_t ow_read_byte(void) {
  cli();
    uint8_t i, result = 0;

    for (i = 0; i < 8; i++) {         // ОРГАНИЗУЕМ ЦИКЛ
		result >>= 1;
	    result |= ow_get_bit()<<7;    // заполняем данными 
    }
	sei();
    return result;    
}


