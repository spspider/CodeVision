
/*
	iodemo.cpp : CDC-IO demo

	O.Tamura @ Recursion Co., Ltd.
*/

#include "atmega48.h"		//	ATmega48/88/168
//#include "atmega8.h"		//	ATmega8

#include "cdcio.h"


#if 1
int main(array<System::String ^> ^args)
{
	CDCIO		sfr;
	int			i, vc, vn, t;
	String		^bar = "**********************************************************************";


	if( args->Length==0 ) {
		Console::WriteLine( " usage: iodemo COM_port_number" );
		return -1;
	}
	//	Open COM device
	if( !sfr.Open( args[0] ) ) {
		Console::WriteLine( " COM{0} is not available.", args[0] );
		return -2;
	}

    Console::WriteLine( sfr.Who() );

	//	Initialize AVR peripherals
	sfr.Set( PORTB, 0 );
	sfr.Set( DDRB, 0x04 );		//	OUT: PB2
	sfr.Set( PORTC, 0 );
	sfr.Set( DDRC, 0x0f );		//	OUT: PC3-0, IN: PC4

	sfr.Set( TCCR1A, 0x10 );

#ifdef _ATMEGA48_
	sfr.Set( DIDR0, 0x10 );
	sfr.Set( ADCSRB, 0 );
#endif
	sfr.Set( ADMUX, 0x04 );
	sfr.Set( ADCSRA, 0x87 );

	i	= 0;
	vc	= 0;
	while( !Console::KeyAvailable ) {

		//	A/D Conversion
		sfr.SetOr( ADCSRA, 0x40 );		//	Start conversion
		Thread::Sleep( 10 );			//	wait 10mSec
		vn	= sfr.Get( ADCL );			//	Obtain the result
		vn	|= sfr.Get( ADCH ) << 8;
		if( (vc-1)<=vn && vn<=(vc+1) ) {
			//	Flip LEDs if the ADC value is not changed
			vc	= vn;
			Thread::Sleep( 300 );
			sfr.SetXor( PORTC, 0x0f );
			sfr.Set( TCCR1B, 0 );
			continue;
		}
		vc	= vn;

		//	Light LEDs with the ADC value
		sfr.Set( PORTC, 8>>(vc>>8) );

		//	Change buzzer tone with the ADC value
		t	= ( vc + 0x100 ) << 4;
		sfr.Set( OCR1AH, t>>8 );
		sfr.Set( OCR1AL, t );
		sfr.Set( TCCR1B, 0x09 );

		//	Display the scale with the ADC value
		Console::WriteLine( String::Format("{0,6:d}  {1}", vc, bar->Substring(0,vc>>4) ) );

		Thread::Sleep( 20 );
	}

	//	Reset AVR peripherals
	sfr.Set( ADCSRA, 0 );
#ifdef _ATMEGA48_
	sfr.Set( DIDR0, 0 );
#endif
	sfr.Set( TCCR1A, 0 );
	sfr.Set( TCCR1B, 0 );
	sfr.Set( PORTC, 0 );
	sfr.Set( DDRC, 0 );
	sfr.Set( PORTB, 0 );
	sfr.Set( DDRB, 0 );

	sfr.Close();
    return 0;
}

#else
//	Read/Write EEPROM data
int main(array<System::String ^> ^args)
{
	CDCIO		sfr;
	int			i;


	if( args->Length==0 ) {
		Console::WriteLine( " usage: sfrdemo COM_port_number" );
		return -1;
	}
	//	Open COM device
	if( !sfr.Open( args[0] ) ) {
		Console::WriteLine( " COM{0} is not available.", args[0] );
		return -2;
	}

    Console::WriteLine( sfr.Who() );

#if 1
	//	Write
    Console::Write( "\n EEPROM write" );
	sfr.Set( EECR, 0 );
	for( i=0; i<256; i++ ) {
		if( (i&0x3f)==0 )
			Console::Write( "\n\t" );
		sfr.Set( EEARL, i );
//		sfr.Set( EEDR, i );
		sfr.Set( EEDR, ~i );
		sfr.Set2( EECR, 4, 6 );
		Thread::Sleep( 10 );			//	wait 10mSec
		Console::Write( "." );
	}
#endif
	//	Read
    Console::Write( "\n EEPROM read" );
	for( i=0; i<256; i++ ) {
		if( (i&0x0f)==0 )
			Console::Write( "\n\t" );
		sfr.Set( EEARL, i );
		sfr.Set( EECR, 1 );
		Console::Write( " {0:x2}", sfr.Get( EEDR ) );
	}
	Console::WriteLine( "" );

	sfr.Close();
	return 0;
}
#endif
