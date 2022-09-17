
#pragma once
#include <windows.h>


class CDCIO
{
public:
	CDCIO(void) {
		hFile	= INVALID_HANDLE_VALUE;
	}

	~CDCIO(void)
	{
		if( hFile!=INVALID_HANDLE_VALUE )
			Close();
	}

	/*  Open COM device						*/
	bool Open( char *device )
	{
		if( hFile!=INVALID_HANDLE_VALUE )
			Close();
		strcpy( buf, "\\.\\COM" );
		strcat( buf, device );
		hFile = CreateFile( buf, GENERIC_READ|GENERIC_WRITE,
						0, 0, OPEN_EXISTING, 0, 0 );
		return hFile!=INVALID_HANDLE_VALUE;
	}

	/*	Obtain device name					*/
	char *Who( void )
	{
		WriteFile( hFile, "@ ", 2, &rwlen, 0 );
		ReadLine();
		return buf;
	}

	/*  Obtain SFR value					*/
	int Get( int address )
	{
		int len	= sprintf( buf, "%02x ? ", address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		ReadLine();
		return (int)strtol( buf, NULL, 16 );
	}

	/*  Set value to SFR					*/
	void Set( int address, int data )
	{
		int	len	= sprintf( buf, "%02x %02x = ", data&0xff, address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		ReadLine();
	}

	void SetAnd( int address, int data )
	{
		int	len	= sprintf( buf, "%02x %02x & ", data&0xff, address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		ReadLine();
	}

	void SetOr( int address, int data )
	{
		int	len	= sprintf( buf, "%02x %02x | ", data&0xff, address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		ReadLine();
	}

	void SetXor( int address, int data )
	{
		int	len	= sprintf( buf, "%02x %02x ^ ", data&0xff, address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		ReadLine();
	}

	/*  Set two values to the same SFR		*/
	void Set2( int address, int data1, int data2 )
	{
		int	len	= sprintf( buf, "%02x %02x %02x $ ", data2&0xff, data1&0xff, address );
		WriteFile( hFile, buf, (DWORD)len, &rwlen, 0 );
		Sleep( 3 );
		ReadLine();
	}

	/*	Close COM device					*/
	void Close( void )
	{
		CloseHandle( hFile );
		hFile	= INVALID_HANDLE_VALUE;
	}

private:
	void ReadLine( void )
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

private:
	HANDLE		hFile;
	DWORD		rwlen;
	char		buf[16];
};
