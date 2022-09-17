
/*
	iodemo.c : CDC-IO demo

	O.Tamura @ Recursion Co., Ltd.
*/

#include <conio.h>
#include "cdcio.h"

#include "atmega48.h"		//	ATmega48/88/168
//#include "atmega8.h"		//	ATmega8


#if 1
int main(int argc, char *argv[])
{
	int			i, vc, vn, t;
	char		bar[80];


	if( argc<2 ) {
		fprintf( stderr, " usage: %s COM_port_number\n", argv[0] );
		return -1;
	}
	//	Open COM device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " COM port [%s] is not available.\n", argv[1] );
		return -2;
	}

	memset( bar, '*', sizeof(bar) );

	puts( sfr_who() );

	//	Initialize AVR peripherals
	sfr_set( PORTB, 0 );
	sfr_set( DDRB, 0x04 );		//	OUT: PB2
	sfr_set( PORTC, 0 );
	sfr_set( DDRC, 0x0f );		//	OUT: PC3-0, IN: PC4

	sfr_set( TCCR1A, 0x10 );

#ifdef _ATMEGA48_
	sfr_set( DIDR0, 0x10 );
	sfr_set( ADCSRB, 0 );
#endif
	sfr_set( ADMUX, 0x04 );
	sfr_set( ADCSRA, 0x87 );

	i	= 0;
	vc	= 0;
	while( _kbhit()==0 ) {

		//	A/D Conversion
		sfr_setOr( ADCSRA, 0x40 );		//	Start conversion
		Sleep( 10 );					//	wait 10mSec
		vn	= sfr_get( ADCL );			//	Obtain the result
		vn	|= sfr_get( ADCH ) << 8;
		if( (vc-1)<=vn && vn<=(vc+1) ) {
			//	Flip LEDs if the ADC value is not changed
			vc	= vn;
			Sleep( 300 );
			sfr_setXor( PORTC, 0x0f );
			sfr_set( TCCR1B, 0 );
			continue;
		}
		vc	= vn;

		//	Light LEDs with the ADC value
		sfr_set( PORTC, 8>>(vc>>8) );

		//	Change buzzer tone with the ADC value
		t	= ( vc + 0x100 ) << 4;
		sfr_set( OCR1AH, t>>8 );
		sfr_set( OCR1AL, t );
		sfr_set( TCCR1B, 0x09 );

		//	Display the scale with the ADC value
		i	= vc >> 4;
		bar[i]	= 0;
		printf( "%6d  %s\n", vc, bar );
		bar[i]	= '*';

		Sleep( 20 );
	}
	//	Reset AVR peripherals
	sfr_set( ADCSRA, 0 );
#ifdef _ATMEGA48_
	sfr_set( DIDR0, 0 );
#endif
	sfr_set( TCCR1A, 0 );
	sfr_set( TCCR1B, 0 );
	sfr_set( PORTC, 0 );
	sfr_set( DDRC, 0 );
	sfr_set( PORTB, 0 );
	sfr_set( DDRB, 0 );

	sfr_close();
	return 0;
}
#else

//	Read/Write EEPROM data
int main(int argc, char *argv[])
{
	int			i;


	if( argc<2 ) {
		fprintf( stderr, " usage: %s COM_port_number\n", argv[0] );
		return -1;
	}
	//	Open COM device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " COM port [%s] is not available.\n", argv[1] );
		return -2;
	}

	puts( sfr_who() );

#if 1
	//	Write
	printf( "\n EEPROM write" );
	sfr_set( EECR, 0 );
	for( i=0; i<256; i++ ) {
		if( (i&0x3f)==0 )
			printf( "\n\t" );
		sfr_set( EEARL, i );
//		sfr_set( EEDR, i );
		sfr_set( EEDR, ~i );
		sfr_set2( EECR, 4, 6 );
		Sleep( 10 );					//	wait 10mSec
		putchar( '.' );
	}
#endif
	//	Read
	printf( "\n EEPROM read" );
	for( i=0; i<256; i++ ) {
		if( (i&0x0f)==0 )
			printf( "\n\t" );
		sfr_set( EEARL, i );
		sfr_set( EECR, 1 );
		printf( " %02x", sfr_get( EEDR ) );
	}
	putchar( '\n' );

	sfr_close();
	return 0;
}
#endif

