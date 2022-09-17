
/*
	iodemo.c : CDC-IO demo for Macintosh

	Osamu Tamura @ Recursion Co., Ltd.
*/

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <unistd.h>
#include <fcntl.h> 
#include <termios.h>

#include "atmega48.h"
//#include "atmega8.h"

#define TEST		1


static char *usage = " usage: %s device_number\n        hit return to quit\n";

/*------------------------------------------------------------*/

/*  CDC-IO access utilities		*/

#define	sfr_get(x)			sfr_out('?',x,0,0)
#define	sfr_set(x,y)		sfr_out('=',x,y,0)
#define	sfr_setAnd(x,y)		sfr_out('&',x,y,0)
#define	sfr_setOr(x,y)		sfr_out('|',x,y,0)
#define	sfr_setXor(x,y)		sfr_out('^',x,y,0)
#define	sfr_set2(x,y,z)		sfr_out('$',x,y,z)

static struct termios	oldtio; 
static int				fd;
static char				buf[16];

static int sfr_init( char *device )
{
	struct termios		newtio; 

	/*  Open device		*/
	strcpy( buf, "/dev/tty.usbmodem" );
	strcat( buf, device );

	fd = open( buf, O_RDWR | O_NOCTTY ); 
	if (fd <0)
		return -1;

	tcgetattr(fd,&oldtio); /* backup the current settings   */ 

	memset(&newtio, 0, sizeof(newtio));

	newtio.c_iflag = IGNBRK | IGNPAR;
	newtio.c_oflag = 0;
	newtio.c_cflag = B9600 | CS8 | CREAD | CLOCAL;
	newtio.c_lflag = ICANON;
//	newtio.c_lflag = 0;

	newtio.c_cc[VTIME]		= 0;	/* no wait between characters   */ 
	newtio.c_cc[VMIN]		= 1;	/* blocking mode	*/ 
//	newtio.c_cc[VMIN]		= 0;	/* non-blocking mode	*/ 

	/*  clear modem and enable port settings	*/
	tcflush(fd, TCIFLUSH); 
	tcsetattr(fd,TCSANOW,&newtio);
	return 0;
}

static int sfr_read( void )
{
	int			len;

	/*	receive the response	*/
	len = read(fd, buf, sizeof(buf));
	if( len>0 ) {
		buf[len]	= 0;
		return len;
	}
//	putchar( '@' );
	return -1;
}

static int sfr_out( char command, int address, int data1, int data2 )
{
	int			rwlen, len;

	/*	Send command string		*/
	switch( command ) {
		case '?':	len	= sprintf( buf, "%02x %c ", address, command );			break;
		case '$':	len	= sprintf( buf, "%02x %02x %02x %c ",
									data2&0xff, data1&0xff, address, command );	break;
		default:	len	= sprintf( buf, "%02x %02x %c ",
									data1&0xff, address, command );
	}
	rwlen = write(fd, buf, len);

	if (rwlen >= len) {
		/*  Wait a while	*/
		usleep( 3000 );

		/*	Receive the response	*/
		len	= sfr_read();
		if( len>0 ) {
			return command=='?'? (int)strtol( buf, NULL, 16 ):0;
		}
	}
	return -1;
}

static void sfr_close( void )
{
	/*  Retrieve port settings		*/ 
	tcsetattr(fd,TCSANOW,&oldtio); 
}

/*------------------------------------------------------------*/

static int _kbhit( void )
{
	fd_set			readfds;
	struct timeval  timeout;

	FD_ZERO( &readfds );
	FD_SET( STDIN_FILENO , &readfds );  /*	add stdin		*/ 
	timeout.tv_sec  = 0;				/*  non-blocking	*/ 
	timeout.tv_usec = 10000;

	return select( STDIN_FILENO+1, &readfds , NULL , NULL , &timeout ); 
}

/*------------------------------------------------------------*/


#if TEST==1
int main(int argc, char *argv[]) 
{ 
	int			i, vc, vn, t;
	char		bar[80];

	if( argc<2 ) {
		fprintf( stderr, usage, argv[0] );
		return -1;
	}

	//	Open CDC device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " err: device [%s] is not available.\n", argv[1] );
		return -2;
	}

	printf( " CDC-IO: PORT, TIMER, ADC\n" );

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
	do {
		//	A/D Conversion
		sfr_setOr( ADCSRA, 0x40 );		//	Start conversion
		usleep( 10000 );				//	wait 10mSec
		vn	= sfr_get( ADCL );			//	Obtain the result
		vn	|= sfr_get( ADCH ) << 8;
		if( (vc-1)<=vn && vn<=(vc+1) ) {
			//	Flip LEDs if the ADC value is not changed
			vc	= vn;
			usleep( 300000 );
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

	} while( !_kbhit() );

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

	//	Close CDC device
	sfr_close();
	return 0;
}
#endif

#if TEST==2
//	Read/Write EEPROM data

#define EEP_MAX		256

int main(int argc, char *argv[]) 
{
	int			i;

	if( argc<2 ) {
		fprintf( stderr, usage, argv[0] );
		return -1;
	}

	//	Open CDC device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " err: device [%s] is not available.\n", argv[1] );
		return -2;
	}

	printf( " CDC-IO: EEPROM\n" );

	//	Write
	printf( "\n  EEPROM write" );
	sfr_set( EEARH, 0 );
	sfr_set( EECR, 0 );
#if 1
	{
		int		addr, data;
		
		addr	= 0x88;
		data	= 0x33;
		sfr_set( EEARL, addr );
		sfr_set( EEDR, data );
		sfr_set2( EECR, 4, 6 );
		while( sfr_get( EECR ) & 2 )
			usleep( 10000 );					//	wait 10mSec
		printf( "\n\t %03x : %02x\n", addr, data );
	}
#else
	//  this part needs some fix..
	//  should retry sfr_set2() when the response is none.
	//  (use timeout or non-blocking mode)
	for( i=0; i<EEP_MAX && !_kbhit(); i++ ) {
		if( (i&0x3f)==0 )
			printf( "\n\t" );

		sfr_set( EEARL, i );
//		sfr_set( EEDR, i );
		sfr_set( EEDR, ~i );
		sfr_set2( EECR, 4, 6 );
//		while( sfr_set2( EECR, 4, 6 )<=0 )
//			usleep( 10000 );					//	wait 10mSec
		while( sfr_get( EECR ) & 2 )
			usleep( 10000 );					//	wait 10mSec
		putchar( '.' );
	}
#endif
	//	Read
	printf( "\n  EEPROM read" );
	for( i=0; i<EEP_MAX && !_kbhit(); i++ ) {
		if( (i&0x0f)==0 )
			printf( "\n\t" );
		sfr_set( EEARL, i );
		sfr_set( EECR, 1 );
		printf( " %02x", sfr_get( EEDR ) );
	}
	putchar( '\n' );
	putchar( '\n' );

	//	Close CDC device
	sfr_close();
	return 0;
}
#endif

#if TEST==3
//	Report Interrupts
int main(int argc, char *argv[]) 
{

	if( argc<2 ) {
		fprintf( stderr, usage, argv[0] );
		return -1;
	}

	//	Open CDC device
	if( sfr_init( argv[1] )!=0 ) {
		fprintf( stderr, " err: device [%s] is not available.\n", argv[1] );
		return -2;
	}

	printf( " CDC-IO: Interrupt on TIMER (, PIN_CHANGE)\n" );

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

	do {		
		//	Open/Connect PB0/1 and Gnd here.

		//	Report interrupted number until ctrl-c
		if( sfr_read() && buf[0]=='\\' ) {
//			printf( " %s", buf );
			printf( " %d\n", (int)strtol( buf+1, NULL, 16 ) );
				//  '\n' in format required to flush
		}
	} while( !_kbhit() );

	//	Disable all interrupts
#ifdef _ATMEGA48_
	sfr_set( PCICR, 0 );
	sfr_set( PCMSK0, 0 );
	sfr_set( TIMSK1, 0 );
	printf( "\n Stop PCINT0/1 interrupt.\n" );
#else
	sfr_set( TIMSK, 0 );
#endif
	printf( " Stop Timer1 interrupt.\n" );

	//	Close CDC device
	sfr_close();
	return 0;
}
#endif

