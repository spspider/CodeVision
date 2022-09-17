
#pragma once

#include <stdio.h>
#include <windows.h>


/*  Open COM device						*/
extern int	sfr_init( char *device );
/*	Obtain device name					*/
extern char	*sfr_who( void );
/*  Obtain SFR value					*/
extern int	sfr_get( int address );
/*  Set value to SFR					*/
extern void	sfr_set( int address, int data );
extern void	sfr_setAnd( int address, int data );
extern void	sfr_setOr( int address, int data );
extern void	sfr_setXor( int address, int data );
/*  Set two values to the same SFR		*/
extern void	sfr_set2( int address, int data1, int data2 );
/*	Close COM device					*/
extern void	sfr_close( void );

