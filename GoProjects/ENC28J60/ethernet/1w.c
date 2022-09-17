// ���������� 1-Wire ���������� (�������� �������������� ���� ������-�� �� ���������)
#define F_CPU 12000000
#include <avr/io.h>

#include <util/delay.h>
#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/crc16.h>
#include "1w.h"
#include <avr/interrupt.h>

#define ow_delay _delay_us(10) /* �������� ����� */
#define wire_0 OW_DDR |= (1<<OW_P)     // ���� �� �����
#define wire_1 OW_DDR &= ~(1<<OW_P)    // ���� �� ����

/*-----------------------------------------------------------------------------
 * ��������� 1-Wire reset, ���������� 0 ���� presense �� ���������,
 * ���������� 1 ���� presense ���������.
 */
 
uint8_t ow_reset(void) {
  cli();
	uint8_t result = 1;
	OW_PORT &= ~(1 << OW_P);	// 0 � ���� ��� "��������" � ����
	wire_0;						// �������� "��������"
    _delay_us(500);				// RESET Pulse
	wire_1;						// ��������� ��������
	_delay_us(100);
	if (OW_PIN & (1 << OW_P)) result = 0;
	_delay_us(400);				// �������� ����� � �����
	sei();
	return result;
} 
/*-----------------------------------------------------------------------------
 �������� ���� �� ���� 
 */
void ow_put_bit(uint8_t bit){
  cli();
    ow_delay;			         // ???
    cli ();                     // ��������� ����������
	wire_0;                    // ���� �� �����
	_delay_us(6);	           // ������ ����-�����
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
 *  ��������� ��� � ����
 */
uint8_t ow_get_bit(void) {
  cli();
    uint8_t result;
	ow_delay;			// ???
	cli();
	wire_0;
	_delay_us(6);		// ������ ����-�����
	wire_1;
	_delay_us(7);		// ����� �� 14-� ������������
	result = (OW_PIN >> OW_P) & 1; // ������� � result
	sei();

	_delay_us(90);
	sei();
    return result;     // ���������� �������� 
}

/*-----------------------------------------------------------------------------
 �������� ����� ������� (���������� ������� ow_put_bit)
 */
void ow_write_byte(uint8_t data) {
  cli();
    uint8_t i;
 for (i = 0; i < 8; i++) {                 // ���� �������� ������
		ow_put_bit(data & 0x01);           // �������� ���� � ����
		data >>= 1;                        // ��������� ���
    }
	sei();
}

  /*-----------------------------------------------------------------------------
 *  ������ ������ ������� ���������� ����������� ���� 
 */
uint8_t ow_read_byte(void) {
  cli();
    uint8_t i, result = 0;

    for (i = 0; i < 8; i++) {         // ���������� ����
		result >>= 1;
	    result |= ow_get_bit()<<7;    // ��������� ������� 
    }
	sei();
    return result;    
}


