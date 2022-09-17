#pragma once

//	ATtiny44 Special Function Registers

#ifndef _ATTINY45_
#define	_ATTINY45_

enum SFR {
	ADCSRB	= 0x23,
	ADCL,
	ADCH,
	ADCSRA,
	ADMUX,
	ACSR,

	USICR	= 0x2d,
	USISR,
	USIDR,
	USIBR,
	GPIOR0,
	GPIOR1,
	GPIOR2,
	DIDR0,
	PCMSK,
	PINB,
	DDRB,
	PORTB,

	EECR	= 0x3c,
	EEDR,
	EEARL,
	EEARH,
	PRR,
	WDTCSR,
	DWDR,
	DTPS1,
	DT1B,
	DT1A,
	CLKPR,
	PLLCSR,
	OCR0B,
	OCR0A,
	TCCR0A,
	OCR1B,
	GTCCR,
	OCR1C,
	OCR1A,
	TCNT1,
	TCCR1,
	OSCCAL,
	TCNT0,
	TCCR0B,
	MCUSR,
	MCUCR,

	SPMCSR	= 0x57,
	TIFR,
	TIMSK,
	GIFR,
	GIMSK,

	SPL		= 0x5d,
	SPH,
	SREG
};

#endif
