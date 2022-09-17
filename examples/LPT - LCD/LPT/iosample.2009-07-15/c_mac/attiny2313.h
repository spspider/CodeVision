#pragma once

//	ATtiny2313 Special Function Registers

#ifndef _ATTINY2313_
#define	_ATTINY2313_

enum SFR {
	DIDR	= 0x21,
	UBRRH,
	UCSRC,

	ACSR	= 0x28,
	UBRRL,
	UCSRB,
	UCSRA,
	UDR,
	USICR,
	USISR,
	USIDR,
	PIND,
	DDRD,
	PORTD,
	GPIOR0,
	GPIOR1,
	GPIOR2,
	PINB,
	DDRB,
	PORTB,
	PINA,
	DDRA,
	PORTA,
	EECR,
	EEDR,
	EEAR,

	PCMSK	= 0x40,
	WDTCSR,
	TCCR1C,
	GTCCR,
	ICR1L,
	ICR1H,
	CLKPR,

	OCR1BL	= 0x48,
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
	TIFR,
	TIMSK,
	EIFR,
	GIMSK,
	OCR0B,
	SPL,

	SREG	= 0x5f
};

#endif

