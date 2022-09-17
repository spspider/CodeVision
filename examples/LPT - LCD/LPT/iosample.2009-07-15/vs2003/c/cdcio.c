
/*
	cdcio.c : CDC-IO utility routines

	O.Tamura @ Recursion Co., Ltd.
*/

#include "cdcio.h"


static void sfr_readline( void );


static HANDLE		hFile;
static DWORD		rwlen;
static char			buf[16];


int sfr_init( char *device )
{

	strcpy( buf, "\\.\\COM" );
	strcat( buf, device );
	hFile = CreateFile( buf, GENERIC_READ|GENERIC_WRITE,
					0, 0, OPEN_EXISTING, 0, 0 );

	return hFile!=INVALID_HANDLE_VALUE? 0:-1;
}

char *sfr_who( void )
{
	WriteFile( hFile, "@ ", 2, &rwlen, 0 );
	sfr_readline();
	return buf;
}

int sfr_get( int address )
{
	int len	= sprintf( buf, "%02x ? ", address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	sfr_readline();
	return (int)strtol( buf, NULL, 16 );
}

void sfr_set( int address, int data )
{
	int	len	= sprintf( buf, "%02x %02x = ", data&0xff, address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	sfr_readline();
}

void sfr_setAnd( int address, int data )
{
	int	len	= sprintf( buf, "%02x %02x & ", data&0xff, address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	sfr_readline();
}

void sfr_setOr( int address, int data )
{
	int	len	= sprintf( buf, "%02x %02x | ", data&0xff, address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	sfr_readline();
}

void sfr_setXor( int address, int data )
{
	int	len	= sprintf( buf, "%02x %02x ^ ", data&0xff, address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	sfr_readline();
}

void sfr_set2( int address, int data1, int data2 )
{
	int	len	= sprintf( buf, "%02x %02x %02x $ ", data2&0xff, data1&0xff, address );
	WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
	Sleep( 3 );
	sfr_readline();
}

void sfr_close( void )
{
	CloseHandle( hFile );
}


static void sfr_readline( void )
{
	DWORD		err;
	COMSTAT		fComStat;
	char		*ptr, *pend;

	/*	receive the response	*/
	ptr	= buf;
	pend	= buf + 16;
	do {
		do ClearCommError( hFile, &err, &fComStat);
		while( fComStat.cbInQue==0 );
		if( (ptr+fComStat.cbInQue)>=pend )
			break;
		ReadFile( hFile, ptr, fComStat.cbInQue, &rwlen, 0 );
		ptr	+= rwlen;
	} while( *(ptr-1)!=0x0a );
	for( ptr-=2; ptr>=buf && *ptr<=' '; )
		*ptr--	= 0;
}

