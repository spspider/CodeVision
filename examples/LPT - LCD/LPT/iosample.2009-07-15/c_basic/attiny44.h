#pragma once

//	ATtiny44 Special Function Registers

#ifndef _ATTINY44_
#define	_ATTINY44_

enum SFR {
	PRR		=	0x20,
	DIDR0,
	ADCSRB	=	0x23,
	ADCL,
	ADCH,
	ADCSRA,
	ADMUX,
	ACSR,

	PINA	=	0x39,
	DDRA,
	PORTA,

	EECR,
	EEDR,
	EEARL,
	EEARH,
	PCMSK1,
	WDTCSR,

	TCCR1C,
	GTCCR,
	ICR1L,
	ICR1H,
	CLKPR,
	DWDR,
	OCR1BL,
	OCR1BH,
	OCR1AL,
	OCR1AH,
	TCNT1L,
	TCNT1H,
	TCCR1B,
	TCCR1A,
	TCCR0A,
	OSCCAL,
	TCNT0,
	TCCR0B,
	MCUSR,
	MCUCR,
	OCR0A,
	SPMCSR,
	TIFR0,
	TIMSK0,
	GIFR,
	GIMSK,
	OCR0B,
	SPL,
	SPH,
	SREG
};

#endif

