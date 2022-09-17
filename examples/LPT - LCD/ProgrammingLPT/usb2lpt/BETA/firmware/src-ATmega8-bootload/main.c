/* Name: main.c
 * Project: AVR bootloader HID
 * Author: Christian Starkjohann
 * Creation Date: 2007-03-19
 * Tabsize: 8
 * Copyright: (c) 2007 by OBJECTIVE DEVELOPMENT Software GmbH
 * License: GNU GPL v2 (see License.txt)
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/wdt.h>
#include <avr/boot.h>
#include <string.h>
#include <util/delay.h>
#include <avr/eeprom.h>

// this routine is placed to address 0 so it can be called
void nullVector(void) __attribute__((noreturn,naked,section(".ctors")));
void nullVector(void) {		// this code is ATmega8 specific
 asm volatile(
"	.org	0x1800,0xFF\n"	// this address is the entry for boot loader (2KB)
"	ldi	r30,0x5F\n"	// initialize stack
"	ldi	r31,0x04\n"
"	out	0x3E,r31\n"	// SPH
"	out	0x3D,r30\n"	// SPL
"	rjmp	main\n"
"	rjmp	__vector_5\n");
}

void __do_copy_data(void) __attribute__((naked));
void __do_copy_data(void) {}	// no non-zero-initialized static data

void __do_clear_bss(void) __attribute__((naked));
void __do_clear_bss(void) {}	// no static data at all

static void leaveBootloader() __attribute__((__noreturn__));

#include "bootloaderconfig.h"
#include "usbdrv.c"

/* ------------------------------------------------------------------------ */

#ifndef ulong
#   define ulong    unsigned long
#endif
#ifndef uint
#   define uint     unsigned int
#endif

#if (FLASHEND) > 0xffff /* we need long addressing */
#   define addr_t           ulong
#else
#   define addr_t           uint
#endif

static addr_t           currentAddress; /* in bytes */
static uchar            offset;         /* data already processed in current transfer */
#if BOOTLOADER_CAN_EXIT
static uchar            exitMainloop;
#endif


PROGMEM char usbHidReportDescriptor[33] = {
    0x06, 0x00, 0xff,              // USAGE_PAGE (Generic Desktop)
    0x09, 0x01,                    // USAGE (Vendor Usage 1)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,              //   LOGICAL_MAXIMUM (255)
    0x75, 0x08,                    //   REPORT_SIZE (8)

    0x85, 0x01,                    //   REPORT_ID (1)
    0x95, 0x06,                    //   REPORT_COUNT (6)
    0x09, 0x00,                    //   USAGE (Undefined)
    0xb2, 0x02, 0x01,              //   FEATURE (Data,Var,Abs,Buf)

    0x85, 0x02,                    //   REPORT_ID (2)
    0x95, 0x83,                    //   REPORT_COUNT (131)
    0x09, 0x00,                    //   USAGE (Undefined)
    0xb2, 0x02, 0x01,              //   FEATURE (Data,Var,Abs,Buf)
    0xc0                           // END_COLLECTION
};

/* allow compatibility with avrusbboot's bootloaderconfig.h: */
#ifdef BOOTLOADER_INIT
#   define bootLoaderInit()         BOOTLOADER_INIT
#endif
#ifdef BOOTLOADER_CONDITION
#   define bootLoaderCondition()    BOOTLOADER_CONDITION
#endif

/* compatibility with ATMega88 and other new devices: */
#ifndef TCCR0
#define TCCR0   TCCR0B
#endif
#ifndef GICR
#define GICR    MCUCR
#endif

static void leaveBootloader()
{
    DBG1(0x01, 0, 0);
    cli();
    boot_rww_enable();
    USB_INTR_ENABLE = 0;
    USB_INTR_CFG = 0;       /* also reset config bits */
#if F_CPU == 12800000
    TCCR0 = 0;              /* default value */
#endif
    GICR = (1 << IVCE);     /* enable change of interrupt vectors */
    GICR = (0 << IVSEL);    /* move interrupts to application flash section */
/* We must go through a global function pointer variable instead of writing
 *  ((void (*)(void))0)();
 * because the compiler optimizes a constant 0 to "rcall 0" which is not
 * handled correctly by the assembler.
 */
    nullVector();
}

uchar   usbFunctionSetup(uchar data[8])
{
usbRequest_t    *rq = (void *)data;
static PROGMEM uchar    replyBuffer[7] = {
        1,                              /* report ID */
        SPM_PAGESIZE & 0xff,
        SPM_PAGESIZE >> 8,
        ((long)FLASHEND + 1) & 0xff,
        (((long)FLASHEND + 1) >> 8) & 0xff,
        (((long)FLASHEND + 1) >> 16) & 0xff,
        (((long)FLASHEND + 1) >> 24) & 0xff
    };

    if(rq->bRequest == USBRQ_HID_SET_REPORT){
        if(rq->wValue.bytes[0] == 2){
            offset = 0;
            return USB_NO_MSG;
        }
#if BOOTLOADER_CAN_EXIT
        else{
	 eeprom_write_byte(0,0xFF);
            exitMainloop = 1;
        }
#endif
    }else if(rq->bRequest == USBRQ_HID_GET_REPORT){
        usbMsgFlags = USB_FLG_MSGPTR_IS_ROM; 
        usbMsgPtr = (uchar*)replyBuffer;
        return 7;
    }
    return 0;
}

uchar usbFunctionWrite(uchar *data, uchar len)
{
union {
    addr_t  l;
    uint    s[sizeof(addr_t)/2];
    uchar   c[sizeof(addr_t)];
}       address;
uchar   isLast;

    address.l = currentAddress;
    if(offset == 0){
        DBG1(0x30, data, 3);
        address.c[0] = data[1];
        address.c[1] = data[2];
#if (FLASHEND) > 0xffff /* we need long addressing */
        address.c[2] = data[3];
        address.c[3] = 0;
#endif
        data += 4;
        len -= 4;
    }
    DBG1(0x31, (void *)&currentAddress, 4);
    offset += len;
    isLast = offset & 0x80; /* != 0 if last block received */
    do{
        addr_t prevAddr;
        DBG1(0x32, 0, 0);
        if((address.s[0] & (SPM_PAGESIZE - 1)) == 0){   /* if page start: erase */
            DBG1(0x33, 0, 0);
#ifndef TEST_MODE
            cli();
            boot_page_erase(address.l);     /* erase page */
            sei();
            boot_spm_busy_wait();           /* wait until page is erased */
#endif
        }
        cli();
        boot_page_fill(address.l, *(short *)data);
        sei();
        prevAddr = address.l;
        address.l += 2;
        data += 2;
        /* write page when we cross page boundary */
        if((address.s[0] & (SPM_PAGESIZE - 1)) == 0){
            DBG1(0x34, 0, 0);
#ifndef TEST_MODE
            cli();
            boot_page_write(prevAddr);
            sei();
            boot_spm_busy_wait();
#endif
        }
        len -= 2;
    }while(len);
    currentAddress = address.l;
    DBG1(0x35, (void *)&currentAddress, 4);
    return isLast;
}

static void initForUsbConnectivity(void)
{
uchar   i = 0;

#if F_CPU == 12800000
    TCCR0 = 3;          /* 1/64 prescaler */
#endif
    usbInit();
    /* enforce USB re-enumerate: */
    usbDeviceDisconnect();  /* do this while interrupts are disabled */
    do{             /* fake USB disconnect for > 250 ms */
        wdt_reset();
        _delay_ms(1);
    }while(--i);
    usbDeviceConnect();
    sei();
}

int main(void) __attribute__((noreturn,naked));
int main(void)
{
// continue initialization that does not fit into interrupt vector table
 asm volatile(
"	clr	r1\n"
"l1:	st	-Z,r1\n"	// clear entire BSS
"	cpi	r30,0x60\n"	// this code is ATmega8 specific
"	cpc	r31,r1\n"
"	brne	l1");
// initialize two bytes of data declared inside USBDRV.C,
// because there is no data copy routine (this here is shorter)
 usbTxLen = USBPID_NAK;	
 usbMsgLen = USB_NO_MSG;
    /* initialize hardware */
    bootLoaderInit();
    odDebugInit();
    DBG1(0x00, 0, 0);
    /* jump to application if jumper is set */
    if(bootLoaderCondition()){
#ifndef TEST_MODE
        GICR = (1 << IVCE);  /* enable change of interrupt vectors */
        GICR = (1 << IVSEL); /* move interrupts to boot flash section */
#endif
        initForUsbConnectivity();
        do{ /* main event loop */
            wdt_reset();
            usbPoll();
#if BOOTLOADER_CAN_EXIT
            if(exitMainloop){
#if F_CPU != 12800000   /* memory is tight at 12.8 MHz, save luxury stuff */
                static uint i;
                if(--i == 0)    /* delay 65k iterations to allow for USB reply to exit command */
#endif
                    break;
            }
#endif
        }while(bootLoaderCondition());
    }
    leaveBootloader();
}
