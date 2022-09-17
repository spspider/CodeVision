#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/pgmspace.h>   /* ����� ��� usbdrv.h */
#include "usbdrv.h"


struct dataexchange_t       // �������� ��������� ��� �������� ������
{
   uchar b1;        // � ����� ��� ������� �������� ��������� �� 3 �����.
   uchar b2;        // �� ������ ���� �������� ���� �� PORTB. ������� ���
   uchar b3;        // �� ����������� (����� �� 3 ���� �����).
};                  // �� � ����� ������������ � ����� ���.
                    // ��� ����������� ���������� �� ���������� � ��������� :)


struct dataexchange_t pdata = {0, 0, 0};


PROGMEM char usbHidReportDescriptor[22] = { // USB report descriptor         // ���������� ��������� ��������� ������ ������ ��� ������
    0x06, 0x00, 0xff,                       // USAGE_PAGE (Generic Desktop)
    0x09, 0x01,                             // USAGE (Vendor Usage 1)
    0xa1, 0x01,                             // COLLECTION (Application)
    0x15, 0x00,                             //    LOGICAL_MINIMUM (0)        // min. �������� ��� ������
    0x26, 0xff, 0x00,                       //    LOGICAL_MAXIMUM (255)      // max. �������� ��� ������, 255 ��� �� ��������, � ����� ��������� � 1 ����
    0x75, 0x08,                             //    REPORT_SIZE (8)            // ���������� ���������� ��������, ��� ������ ������ "�������" 8 ���
    0x95, sizeof(struct dataexchange_t),    //    REPORT_COUNT               // ���������� ������ (� ����� ������� = 3, ��������� ���� ��������� ���������� �� ��� �������)
    0x09, 0x00,                             //    USAGE (Undefined)
    0xb2, 0x02, 0x01,                       //    FEATURE (Data,Var,Abs,Buf)
    0xc0                                    // END_COLLECTION
};
/* ����� �� ������� ������ ���� report, ��-�� ���� �� ����� ������������ report-ID (�� ������ ���� ������ ������).
 * � ��� ������� ��������� 3 ����� ������ (������ ������ REPORT_SIZE = 8 ��� = 1 ����, �� ���������� REPORT_COUNT = 3).
 */


/* ��� ���������� ������ ������ ������� �������� */
static uchar    currentAddress;
static uchar    bytesRemaining;


/* usbFunctionRead() ���������� ����� ���� ����������� ������ ������ �� ����������
 * ��� �������������� ���������� ��. ������������ � usbdrv.h
 */
uchar   usbFunctionRead(uchar *data, uchar len)
{
    if(len > bytesRemaining)
        len = bytesRemaining;

    uchar *buffer = (uchar*)&pdata;

    if(!currentAddress)        // �� ���� ����� ������ ��� �� ��������.
    {                          // �������� ��������� ��� ��������
        if ( PINB & _BV(1) )
            pdata.b1 = 1;
        else
            pdata.b1 = 0;


        if ( PINB & _BV(2) )
            pdata.b2 = 1;
        else
            pdata.b2 = 0;


        if ( PINB & _BV(3) )
            pdata.b3 = 1;
        else
            pdata.b3 = 0;
    }

    uchar j;
    for(j=0; j<len; j++)
        data[j] = buffer[j+currentAddress];

    currentAddress += len;
    bytesRemaining -= len;
    return len;
}


/* usbFunctionWrite() ���������� ����� ���� ���������� ������ ������ � ����������
 * ��� �������������� ���������� ��. ������������ � usbdrv.h
 */
uchar   usbFunctionWrite(uchar *data, uchar len)
{
    if(bytesRemaining == 0)
        return 1;               /* ����� �������� */

    if(len > bytesRemaining)
        len = bytesRemaining;

    uchar *buffer = (uchar*)&pdata;
    
    uchar j;
    for(j=0; j<len; j++)
        buffer[j+currentAddress] = data[j];

    currentAddress += len;
    bytesRemaining -= len;

    if(bytesRemaining == 0)     // ��� ������ ��������
    {                           // �������� �������� �� PORTB
        if ( pdata.b1 )
            PORTB |= _BV(1);
        else
            PORTB &= ~_BV(1);


        if ( pdata.b2 )
            PORTB |= _BV(2);
        else
            PORTB &= ~_BV(2);


        if ( pdata.b3 )
            PORTB |= _BV(3);
        else
            PORTB &= ~_BV(3);
    }

    return bytesRemaining == 0; /* 0 ��������, ��� ���� ��� ������ */
}

/* ------------------------------------------------------------------------- */

usbMsgLen_t usbFunctionSetup(uchar data[8])
{
usbRequest_t    *rq = (void *)data;

    if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_CLASS){    /* HID ���������� */
        if(rq->bRequest == USBRQ_HID_GET_REPORT){  /* wValue: ReportType (highbyte), ReportID (lowbyte) */
            // � ��� ������ ���� ������������� �������, ����� ������������ report-ID
            bytesRemaining = sizeof(struct dataexchange_t);
            currentAddress = 0;
            return USB_NO_MSG;  // ���������� usbFunctionRead() ��� �������� ������ �����
        }else if(rq->bRequest == USBRQ_HID_SET_REPORT){
            // � ��� ������ ���� ������������� �������, ����� ������������ report-ID
            bytesRemaining = sizeof(struct dataexchange_t);
            currentAddress = 0;
            return USB_NO_MSG;  // ���������� usbFunctionWrite() ��� ��������� ������ �� �����
        }
    }else{
        /* ��������� ������� �� ������ ���������� */
    }
    return 0;
}
/* ------------------------------------------------------------------------- */

int main(void)
{
    DDRB = 0b00001110;      // PB1,PB2,PB3 - �����

    usbInit();
    usbDeviceDisconnect();  // ������������� ����������� �� �����, ��� ������ ����� ������ ��� ����������� �����������!
    
    uchar i = 0;
    while(--i){             // ����� > 250 ms
        _delay_ms(1);
    }
    
    usbDeviceConnect();     // ������������

    sei();                  // ��������� ����������

    for(;;){                // ������� ���� ���������
        usbPoll();          // ��� ������� ���� ��������� �������� � �������� �����, ������������ �������� ����� �������� - 50 ms
    }
    return 0;
}
/* ------------------------------------------------------------------------- */ 
