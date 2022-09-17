
/*
	iodemo.c : CDC-IO demo (simple)

	O.Tamura @ Recursion Co., Ltd.
*/

#include <windows.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>

#include "atmega48.h"		//	ATmega48/88/168
//#include "atmega8.h"		//	ATmega8

#define	TEST	2

#define	sfr_get(x)			sfr_out('?',x,0,0)
#define	sfr_set(x,y)		sfr_out('=',x,y,0)
#define	sfr_setAnd(x,y)		sfr_out('&',x,y,0)
#define	sfr_setOr(x,y)		sfr_out('|',x,y,0)
#define	sfr_setXor(x,y)		sfr_out('^',x,y,0)
#define	sfr_set2(x,y,z)		sfr_out('$',x,y,z)

static HANDLE		hFile;
static char			buf[16];

static int sfr_init( char *device )
{

	strcpy( buf, "\\.\\COM" );
	strcat( buf, device );
	hFile = CreateFile( buf, GENERIC_READ|GENERIC_WRITE,
					0, 0, OPEN_EXISTING, 0, 0 );

	return hFile!=INVALID_HANDLE_VALUE? 0:-1;
}

static int sfr_read( void )
{
	DWORD		rwlen, err;
	COMSTAT		fComStat;

	/*	receive the response	*/
	if( ClearCommError( hFile, &err, &fComStat) ) {
		if( fComStat.cbInQue>0 ) {
			rwlen	= min( 16, fComStat.cbInQue );
			if( ReadFile( hFile, buf, rwlen, &rwlen, 0 ) ) {
				buf[rwlen]	= 0;
				return (int)rwlen;
			}
		}
	}
	return -1;
}

static int sfr_out( char command, int address, int data1, int data2 )
{
	int			len;
	DWORD		rwlen;

	/*	send command string		*/
	switch( command ) {
		case '?':	len	= sprintf( buf, "%02x %c ", address, command );			break;
		case '$':	len	= sprintf( buf, "%02x %02x %02x %c ",
									data2&0xff, data1&0xff, address, command );	break;
		default:	len	= sprintf( buf, "%02x %02x %c ",
									data1&0xff, address, command );
	}
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );

	Sleep( 3 );

	/*	receive the response	*/
	len	= sfr_read();
	if( len>0 ) {
		return command=='?'? (int)strtol( buf, NULL, 16 ):0;
	}
	return -1;
}

static void sfr_close( void )
{

	CloseHandle( hFile );
}

/*------------------------------------------------------------*/

#if TEST==1
int main(int argc, char* argv[])
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

	//	Close COM device
	sfr_close();
	return 0;
}
#endif

#if TEST==2
//	Read/Write EEPROM data
int main(int argc, char* argv[])
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
#if 1
	//	Write
	printf( "\n EEPROM write" );
	sfr_set( EEARH, 0 );
	sfr_set( EECR, 0 );
	for( i=0; i<256; i++ ) {
		if( (i&0x3f)==0 )
			printf( "\n\t" );
		sfr_set( EEARL, i );
		sfr_set( EEDR, i );
//		sfr_set( EEDR, ~i );
		sfr_set2( EECR, 4, 6 );
		while( sfr_get(EECR)&2 )
			Sleep( 3 );					//	wait 10mSec
		putchar( '.' );
	}
#endif
	//	Read
	printf( "\n  EEPROM read" );
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

#if TEST==3
//	Report Interrupts
int main(int argc, char* argv[])
{

	if( argc<2 ) {
		fprintf( stderr, " usage: %s COM_port_number\n", argv[0] );
		return -1;
	}
	//	Open COM device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " COM port [%s] is not available.\n", argv[1] );
		return -2;
	}

#define	INTERVAL	3			// Seconds

#define	F_CPU		12000000	// Hz
#define	OCRVAL		((INTERVAL*F_CPU/1024)-1)

	//	Initialize Timer1
	sfr_set( TCCR1B, 0x0d );	// CTC, clk=1/1024
	sfr_set( OCR1AH, OCRVAL>>8 );
	sfr_set( OCR1AL, OCRVAL&0xff );
#ifdef _ATMEGA48_
	sfr_set( TIMSK1, 1<<1 );	// enable OCIE1A interrupt
#else
	sfr_set( TIMSK, 1<<4 );		// enable OCIE1A interrupt
#endif
	printf( "\n Start Timer1 interrupt (#12).\n" );

#ifdef _ATMEGA48_
	//	Initialize Pin Change Interrupt
	sfr_set( DDRB, 0x00 );		// set PB0 & PB1 as input
	sfr_set( PORTB, 0xff );		// pull-up PB0 & PB1
	sfr_set( PCMSK0, 0x03 );	// enable PCINT0 & PCINT1
	sfr_set( PCICR, 1<<0 );		// enable PCIE0 interrupt
	sfr_set( PCIFR, 1<<0 );		// clear PCIF0
	printf( " Start PCINT0/1 interrupt (#4).\n" );
#endif

	while( _kbhit()==0 ) {
		//	Open/Connect PB0/1 and Gnd here.
		Sleep( 10 );					//	wait 10mSec

		//	Report interrupted number until hit any key
		if( sfr_read()==5 && buf[0]=='\\' ) {
//			printf( " %s", buf );
			printf( " %d", (int)strtol( buf+1, NULL, 16 ) );
		}
	}

	//	Disable all interrupts
#ifdef _ATMEGA48_
	sfr_set( PCICR, 0 );
	sfr_set( PCMSK0, 0 );
	sfr_set( TIMSK1, 0 );
#else
	sfr_set( TIMSK, 0 );
#endif
	printf( "\n Stop PCINT0/1 interrupt.\n" );
	printf( " Stop Timer1 interrupt.\n" );

	//	Close COM device
	sfr_close();
	return 0;
}
#endif

