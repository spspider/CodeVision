#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/wdt.h>

#include "usbdrv.h"
#include "oddebug.h"
#include <util/delay.h>

static uchar ps2buffer[9]={0,0,0,0,0,0,0,0,0};
static uchar type=0;
static uchar type1=0; // 0=Normal digital, >200 = DDR Pad
static uchar type2=0;
static uchar outBuffer1[8];
static uchar outBuffer2[8];

/* ----------------------- hardware I/O abstraction ------------------------ */


/* ------------------------------------------------------------------------- */

static void hardwareInit(void)
{
uchar	i, j;

	DDRB = 0x2F;	// PORTB; everythin output, except MISO
	PORTB = 0x04;	// ATT lines, uses CS and another pin

    PORTC = 0;		// Don't need these atm.
    DDRC = 0;		// Don't need these atm.

    PORTD = 0xfa;   /* 1111 1010 bin: activate pull-ups except on USB lines */
    DDRD = 0x07;    /* 0000 0111 bin: all pins input except USB (-> USB reset) */
	j = 0;
	while(--j){     /* USB Reset by device only required on Watchdog Reset */
		i = 0;
		while(--i); /* delay >10ms for USB reset */
	}
    DDRD = 0x02;    /* 0000 0010 bin: remove USB reset condition */
}

/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ----------------------Atmega8 SPI, master, 93.75khz---------------------- */
/* ------------------------------------------------------------------------- */

void spi_mInit()
{
	// SPI, master, clock/128 = 93.75khz (187.5 didn't work...)
	SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0)|(1<<DORD)|(1<<CPHA)|(1<<CPOL);
}

unsigned char spi_mSend(unsigned char podatek)	//straight from documentation
{

	// Gets information, sends it, waits untill it's sent, then reads the same register (used for both Input and Output) and returns it

	/* Start transmission */
	SPDR = podatek;
	while(!(SPSR & (1<<SPIF)));

	return SPDR;
}

/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ----------------------------- USB interface ----------------------------- */
/* ------------------------------------------------------------------------- */

static uchar    reportBuffer[8];    /* buffer for HID reports */
static uchar    idleRate; // Unused

PROGMEM char usbHidReportDescriptor[USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH] = { /* USB report descriptor */

    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x04,                    // USAGE (Joystick)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x09, 0x01,                    //   USAGE (Pointer)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x85, 0x01,                    //     REPORT_ID (1)
    0x09, 0x30,                    //     USAGE (X)
    0x09, 0x31,                    //     USAGE (Y)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x25, 0x0f,                    //     LOGICAL_MAXIMUM (15)
    0x75, 0x04,                    //     REPORT_SIZE (4)
    0x95, 0x02,                    //     REPORT_COUNT (2)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x32,                    //     USAGE (Z)
    0x09, 0x33,                    //     USAGE (Rx)
    0x09, 0x34,                    //     USAGE (Ry)
    0x09, 0x35,                    //     USAGE (Rz)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,              //     LOGICAL_MAXIMUM (255)
    0x75, 0x08,                    //     REPORT_SIZE (8)
    0x95, 0x04,                    //     REPORT_COUNT (4)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x05, 0x09,                    //     USAGE_PAGE (Button)
    0x19, 0x01,                    //     USAGE_MINIMUM (Button 1)
    0x29, 0x10,                    //     USAGE_MAXIMUM (Button 16)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
    0x75, 0x01,                    //     REPORT_SIZE (1)
    0x95, 0x10,                    //     REPORT_COUNT (16)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //     END_COLLECTION
    0xc0,                          // END_COLLECTION

    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x04,                    // USAGE (Joystick)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x09, 0x01,                    //   USAGE (Pointer)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x85, 0x02,                    //     REPORT_ID (1)
    0x09, 0x30,                    //     USAGE (X)
    0x09, 0x31,                    //     USAGE (Y)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x25, 0x0f,                    //     LOGICAL_MAXIMUM (15)
    0x75, 0x04,                    //     REPORT_SIZE (4)
    0x95, 0x02,                    //     REPORT_COUNT (2)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x09, 0x32,                    //     USAGE (Z)
    0x09, 0x33,                    //     USAGE (Rx)
    0x09, 0x34,                    //     USAGE (Ry)
    0x09, 0x35,                    //     USAGE (Rz)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,              //     LOGICAL_MAXIMUM (255)
    0x75, 0x08,                    //     REPORT_SIZE (8)
    0x95, 0x04,                    //     REPORT_COUNT (4)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x05, 0x09,                    //     USAGE_PAGE (Button)
    0x19, 0x01,                    //     USAGE_MINIMUM (Button 1)
    0x29, 0x10,                    //     USAGE_MAXIMUM (Button 16)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
    0x75, 0x01,                    //     REPORT_SIZE (1)
    0x95, 0x10,                    //     REPORT_COUNT (16)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //     END_COLLECTION
    0xc0,                           // END_COLLECTION

};

/* ------------------------------------------------------------------------- */

// Delays


void wait100us(){
	_delay_us(100);
}


/* ------------------------------------------------------------------------- */
/* ------------------------------- Get data! ------------------------------- */
/* ------------------------------------------------------------------------- */

void get_data(int c) {

		if (c==0){
			PORTB=0x02;
		}
		else if(c==1){
			PORTB=0x04;
		}

		_delay_ms(1);
		ps2buffer[0]=spi_mSend(0x01);	// We want data!
		wait100us();		
		ps2buffer[1]=spi_mSend(0x42);	// What's your model? (use later)
		wait100us();	

		if (ps2buffer[1]==0x41){		// Digital pad, possibly DDR Pad

		ps2buffer[2]=spi_mSend(0x00);
		wait100us();	
		ps2buffer[3]=spi_mSend(0x00);
		wait100us();			
		ps2buffer[4]=spi_mSend(0x00);
		wait100us();
		ps2buffer[5]=spi_mSend(0x00);
		wait100us();
		ps2buffer[6]=spi_mSend(0x00);
		wait100us();
		ps2buffer[7]=spi_mSend(0x00);
		wait100us();
		ps2buffer[8]=spi_mSend(0x00);
		

		} else if (ps2buffer[1]==0x73){// Standard Analog pad in RED mode	

		ps2buffer[2]=spi_mSend(0x00);
		wait100us();	
		ps2buffer[3]=spi_mSend(0x00);
		wait100us();			
		ps2buffer[4]=spi_mSend(0x00);
		wait100us();	
		ps2buffer[5]=spi_mSend(0x00);
		wait100us();	
		ps2buffer[6]=spi_mSend(0x00);
		wait100us();			
		ps2buffer[7]=spi_mSend(0x00);
		wait100us();			
		ps2buffer[8]=spi_mSend(0x00);

		} else {

		ps2buffer[2]=0;
		ps2buffer[3]=0;		
		ps2buffer[4]=0;	
		ps2buffer[5]=0;
		ps2buffer[6]=0;
		ps2buffer[7]=0;			
		ps2buffer[8]=0;

		}
	
		PORTB = 0x06;
		_delay_ms(1);

}

/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ----------------------- Make sense from the data! ----------------------- */
/* ------------------------------------------------------------------------- */

// Is the controller digital, analog, dance pad,...

void make_sense(int t) {

	if (t==0){
		type=type1;
	}
	else if (t==1){
		type=type2;
	}

	int temp1=255-ps2buffer[3];
	int temp2=255-ps2buffer[4];

	if (ps2buffer[1]==0x41){		// Digital pad
		
		// Zero the unused axes
		reportBuffer[2]=0x80;
		reportBuffer[3]=0x80;
		reportBuffer[4]=0x80;
		reportBuffer[5]=0x80;

		// Buttons!
		reportBuffer[6]=((temp1 & 0x01) << 0) | ((temp1 & 0x08) >> 2) | ((temp2 & 0x01) << 2) | ((temp2 & 0x02) << 2) | ((temp2 & 0x04) << 2) | ((temp2 & 0x08) << 2) | ((temp2 & 0x10) << 2) | ((temp2 & 0x20) << 2);
		
		reportBuffer[7]=((temp2 & 0x40) >> 6) | ((temp2 & 0x80) >> 6) | ((temp1 & 0x02) << 1)  | ((temp1 & 0x04) << 1);

		

		if (type < 200){		
	
		// Up, Down - Y! Axis
			if (temp1 & 0x10){
				reportBuffer[1]=0x00;
			}
			else if (temp1 & 0x40){
				reportBuffer[1]=0xF0;
			}
			else {
				reportBuffer[1]=0x80;
			}	
	
			// Right, Left - X! Axis

			if (temp1 & 0x20){
				reportBuffer[1]=reportBuffer[1]+0x0F;
			}
			else if (temp1 & 0x80){
				reportBuffer[1]=reportBuffer[1]+0x00;
			}
			else {
				reportBuffer[1]=reportBuffer[1]+0x08;
			}
			
			reportBuffer[7] &= ~0x10 | ~0x20 | ~0x40 | ~0x80;

		} else {	

			reportBuffer[7] = ((temp2 & 0x40) >> 6) | ((temp2 & 0x80) >> 6) | ((temp1 & 0x02) << 1)  | ((temp1 & 0x04) << 1) | (temp1 & 0x10) | (temp1 & 0x20) |(temp1 & 0x40) | (temp1 & 0x80);
			reportBuffer[1]=0x88;
		
			type = 222;

		}

		if ((temp1 & 0x01) && (temp1 & 0x08) &&  (temp1 & 0x10) ){
			type++;
			if (t==0){
				type1=type;
			}	
			else if (t==1){
				type2=type;
			}
		}

	}

	else if (ps2buffer[1]==0x73){		// Decode analog pad
		
		// Right stick, X axis
		reportBuffer[2]=ps2buffer[5];
		// Right stick, Y axis
		reportBuffer[3]=ps2buffer[6];
		// Left stick,  X axis
		reportBuffer[4]=ps2buffer[7];
		// Left stick,  Y axis
		reportBuffer[5]=ps2buffer[8];

		//Buttons, buttons, so many buttons!

		// Up, Down - Y! Axis
		if (temp1 & 0x10){
			reportBuffer[1]=0x00;
		}
		else if (temp1 & 0x40){
			reportBuffer[1]=0xF0;
		}
		else {
			reportBuffer[1]=0x80;
		}

		// Right, Left - X! Axis

		if (temp1 & 0x20){
			reportBuffer[1]=reportBuffer[1]+0x0F;
		}
		else if (temp1 & 0x80){
			reportBuffer[1]=reportBuffer[1]+0x00;
		}
		else {
			reportBuffer[1]=reportBuffer[1]+0x08;
		}
		
		reportBuffer[6]=((temp1 & 0x01) << 0) | ((temp1 & 0x08) >> 2) | ((temp2 & 0x01) << 2) | ((temp2 & 0x02) << 2) | ((temp2 & 0x04) << 2) | ((temp2 & 0x08) << 2) | ((temp2 & 0x10) << 2) | ((temp2 & 0x20) << 2);
		
		reportBuffer[7]=((temp2 & 0x40) >> 6) | ((temp2 & 0x80) >> 6) | ((temp1 & 0x02) << 1)  | ((temp1 & 0x04) << 1);

		reportBuffer[7] &= ~0x10 | ~0x20 | ~0x40 | ~0x80;


	} else { // If there isn't a pad connected, or if it is an unsupported one, zero the axes and the buttons

		reportBuffer[1]= 0x88;
		reportBuffer[2]= 0x80;
		reportBuffer[3]= 0x80;
		reportBuffer[4]= 0x80;
		reportBuffer[5]= 0x80;
		reportBuffer[6]= 0;
		reportBuffer[7]= 0;
	}

}

/* ------------------------------------------------------------------------- */

uchar	usbFunctionSetup(uchar data[8])
{
usbRequest_t    *rq = (void *)data;

    		
    if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_CLASS){    /* class request type */
        if(rq->bRequest == USBRQ_HID_GET_REPORT){  /* wValue: ReportType (highbyte), ReportID (lowbyte) */


		reportBuffer[0]= 0;
		reportBuffer[1]= 0;
		reportBuffer[2]= 0;
		reportBuffer[3]= 0;
		reportBuffer[4]= 0;
		reportBuffer[5]= 0;
		reportBuffer[6]= 0;
		reportBuffer[7]= 0;

		usbMsgPtr = reportBuffer;

 		return sizeof (reportBuffer);

        }else if(rq->bRequest == USBRQ_HID_GET_IDLE){
            usbMsgPtr = &idleRate;
            return 1;
        }else if(rq->bRequest == USBRQ_HID_SET_IDLE){
            idleRate = rq->wValue.bytes[1];
        }
    }else{
        /* no vendor specific requests implemented */
    }
	return 0;
}

/* ------------------------------------------------------------------------- */

int	main(void)
{
uchar   idleCounter = 0;

	wdt_enable(WDTO_2S);
    hardwareInit();
	odDebugInit();
	usbInit();
	sei();
	
	spi_mInit();	// SPI

	int x=0;
	int changed=0;

		// Tell the computer we're here, make prerequisites for later
		
		// 1st gamepad
		wdt_reset();
		usbPoll();
		get_data(0);
		make_sense(0);
		reportBuffer[0]= 0x01;

		for (x=0; x<8; x++) {
	  	  outBuffer1[x]=reportBuffer[x];
		}

		while (!usbInterruptIsReady()) { wdt_reset(); usbPoll(); }	

		usbSetInterrupt(reportBuffer, sizeof(reportBuffer));


		// 2nd gamepad
		get_data(1);
		make_sense(1);
		reportBuffer[0]= 0x02;
		for (x=0; x<8; x++) {
	  	  outBuffer2[x]=reportBuffer[x];
		}
		while (!usbInterruptIsReady()) { wdt_reset(); usbPoll(); }	

		usbSetInterrupt(reportBuffer, sizeof(reportBuffer));


		changed=0;

	// Main loop
	// This loop checks one gamepad, if the state of buttons changed, it waits untill it can send the data and then send it,
	// otherwise it checks the other gamepad and does the same thing (this approach saves time)  
	for(;;){	
	
		// 1st gamepad
		wdt_reset();
		usbPoll();

		get_data(0);
		make_sense(0);
		reportBuffer[0]= 0x01;
	
		for (x=0; x<8; x++) {
	  		if (outBuffer1[x]!=reportBuffer[x]){
				changed=1;
			}
		}

		if (changed==1){
		while (!usbInterruptIsReady()) { wdt_reset(); usbPoll(); }
		usbSetInterrupt(reportBuffer, sizeof(reportBuffer));

		for (x=0; x<8; x++) {
	  	  outBuffer1[x]=reportBuffer[x];
		}
		
		changed=0;

		}


		// 2nd gamepad
		wdt_reset();
		usbPoll();
		get_data(1);
		make_sense(1);
		reportBuffer[0]= 0x02;

		for (x=0; x<8; x++) {
	  		if (outBuffer2[x]!=reportBuffer[x]){
				changed=1;
			}
		}

		if (changed==1){
		while (!usbInterruptIsReady()) { wdt_reset(); usbPoll(); }
		usbSetInterrupt(reportBuffer, sizeof(reportBuffer));

		for (x=0; x<8; x++) {
	  	  outBuffer2[x]=reportBuffer[x];
		}

		changed=0;
		}
		wdt_reset();
		usbPoll();		
		
		
	}
	return 0;
}

/* ------------------------------------------------------------------------- */
