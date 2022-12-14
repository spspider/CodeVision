

//	ATmega48/88/168 Special Function Registers

public enum SFR
{
    PINB	= 0x23,
	DDRB,
	PORTB,
	PINC,
	DDRC,
	PORTC,
	PIND,
	DDRD,
	PORTD,
	TIFR0	= 0x35,
	TIFR1,
	TIFR2,
	PCIFR	= 0x3b,
	EIFR,
	EIMSK,
	GPIOR0,
	EECR,
	EEDR,
	EEARL,
	EEARH,
	GTCCR,
	TCCR0A,
	TCCR0B,
	TCNT0,
	OCR0A,
	OCR0B,
	GPIOR1	= 0x4a,
	GPIOR2,
	SPCR,
	SPSR,
	SPDR,
	ACSR	= 0x50,
	SMCR	= 0x53,
	MCUSR,
	MCUCR,
	SPMCSR	= 0x57,
	SPL		= 0x5d,
	SPH,
	SREG,
	WDTCSR,
	CLKPR,
	PRR		= 0x64,
	OSCCAL	= 0x66,
	PCICR	= 0x68,
	EICRA,
	PCMSK0	= 0x6b,
	PCMSK1,
	PCMSK2,
	TIMSK0,
	TIMSK1,
	TIMSK2,
	ADCL	= 0x78,
	ADCH,
	ADCSRA,
	ADCSRB,
	ADMUX,
	DIDR0	= 0x7e,
	DIDR1,
	TCCR1A,
	TCCR1B,
	TCCR1C,
	TCNT1L	= 0x84,
	TCNT1H,
	ICR1L,
	ICR1H,
	OCR1AL,
	OCR1AH,
	OCR1BL,
	OCR1BH,
	TCCR2A	= 0xb0,
	TCCR2B,
	TCNT2,
	OCR2A,
	OCR2B,
	ASSR	= 0xb6,
	TWBR	= 0xb8,
	TWSR,
	TWAR,
	TWDR,
	TWCR,
	TWAMR,
	UCSR0A	= 0xc0,
	UCSR0B,
	UCSR0C,
	UBRR0L	= 0xc4,
	UBRR0H,
	UDR0
};

