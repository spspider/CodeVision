#pragma once

//	ATtiny461 Special Function Registers

#ifndef _ATTINY461_
#define	_ATTINY461_

enum SFR {
	TCCR1E	= 0x20,
	DIDR0,
	DIDR1,
	ADCSRB,
	ADCL,
	ADCH,
	ADCSRA,
	ADMUX,
	ACSRA,
	ACSRB,
	GPIOR0,
	GPIOR1,
	GPIOR2,
	USICR,
	USISR,
	USIDR,

	USIBR,
	USIPP,
	OCR0B,
	OCR0A,
	TCNT0H,
	TCCR0A,
	PINB,
	DDRB,
	PORTB,
	PINA,
	DDRA,
	PORTA,
	EECR,
	EEDR,
	EEARL,
	EEARH,

	DWDR,
	WDTCR,
	PCMSK1,
	PCMSK0,
	DT1,
	TC1H,
	TCCR1D,
	TCCR1C,
	CLKPR,
	PLLCSR,
	OCR1D,
	OCR1C,
	OCR1B,
	OCR1A,
	TCNT1,
	TCCR1B,

	TCCR1A,
	OSCCAL,
	TCNT0L,
	TCCR0B,
	MCUSR,
	MCUCR,
	PRR,
	SPMCSR,
	TIFR,
	TIMSK,
	GIFR,
	GIMSK,

	SPL		= 0x5d,
	SPH,
	SREG
};

#endif

