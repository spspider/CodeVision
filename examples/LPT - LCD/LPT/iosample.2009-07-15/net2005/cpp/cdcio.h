#pragma once

using namespace System;
using namespace System::Threading;
using namespace System::IO::Ports;
using namespace System::Text;
using namespace System::Globalization;


ref class CDCIO : public SerialPort
{
public:

	/*  Open COM device						*/
	bool Open( String ^num ) {
		PortName =  "COM" + num;
        ReadTimeout = 500;
        WriteTimeout = 500;
        try {
			Open();
		}
		catch (...) {
			return false;
		}
		return IsOpen;
	}

    /*	Obtain device name					*/
	String ^Who() {
		WriteLine( "@" );
		return ReadLine();
	}

    /*  Obtain SFR value					*/
	int Get( SFR addr ) {
		int		val;

		WriteLine( String::Format( "{0:x2} ?", (int)addr ) );
        try {
			val	= Int32::Parse(ReadLine(), NumberStyles::HexNumber);
		}
		catch (...) {
			return -1;
		}
		return val;
	}

    /*  Set value to SFR					*/
	void Set( SFR addr, int data ) {
		WriteLine( String::Format( "{0:x2} {1:x2} =", data&0xff, (int)addr ) );
		ReadLine();
	}

	void SetAnd( SFR addr, int data ) {
		WriteLine( String::Format( "{0:x2} {1:x2} &", data&0xff, (int)addr ) );
		ReadLine();
	}

	void SetOr( SFR addr, int data ) {
		WriteLine( String::Format( "{0:x2} {1:x2} |", data&0xff, (int)addr ) );
		ReadLine();
	}

	void SetXor( SFR addr, int data ) {
		WriteLine( String::Format( "{0:x2} {1:x2} ^", data&0xff, (int)addr ) );
		ReadLine();
	}

    /*  Set two values to the same SFR		*/
	void Set2( SFR addr, int data1, int data2 ) {
		WriteLine( String::Format( "{0:x2} {1:x2} {2:x2} $", data2&0xff, data1&0xff, (int)addr ) );
		Thread::Sleep( 3 );
		ReadLine();
	}
};
