
/*
	iodemo.cs : CDC-IO demo

	O.Tamura @ Recursion Co., Ltd.
*/

using System;
using System.IO.Ports;
using System.Threading;
using System.Text;
using System.Globalization;


namespace iodemo
{
    class Program
    {
        public static int Main(string[] args)
        {
            CDCIO sfr;
            int vc, vn, t;
            const string bar = "************************************************************************";


            if (args.Length == 0)
            {
                Console.WriteLine("Available Ports:");
                foreach (string s in SerialPort.GetPortNames())
                    Console.WriteLine("   {0}", s);
                Console.WriteLine(" usage: sfrdemo COM_port_number");
                return -1;
            }

            //	Open COM device
            sfr = new CDCIO();
            if (!sfr.Open(args[0]))
            {
                Console.WriteLine(" COM{0} is not available.", args[0]);
                return -2;
            }

            Console.WriteLine(sfr.Who());

            //	Initialize AVR peripherals
            sfr.Set(SFR.PORTB, 0);
            sfr.Set(SFR.DDRB, 0x04);		//	OUT: PB2
            sfr.Set(SFR.PORTC, 0);
            sfr.Set(SFR.DDRC, 0x0f);		//	OUT: PC3-0, IN: PC4

            sfr.Set(SFR.TCCR1A, 0x10);
            sfr.Set(SFR.DIDR0, 0x10);   //  ** ATmega8 :: REMOVE this line **
            sfr.Set(SFR.ADMUX, 0x04);
            sfr.Set(SFR.ADCSRB, 0);     //  ** ATmega8 :: REMOVE this line **
            sfr.Set(SFR.ADCSRA, 0x87);

            vc = 0;
 	        while( !Console.KeyAvailable ) {

		        //	A/D Conversion
                sfr.SetOr(SFR.ADCSRA, 0x40);		//	Start conversion
		        Thread.Sleep( 10 );			        //	wait 10mSec
                vn = sfr.Get(SFR.ADCL);			    //	Obtain the result
                vn |= sfr.Get(SFR.ADCH) << 8;
		        if( (vc-1)<=vn && vn<=(vc+1) ) {
			        //	Flip LEDs if the ADC value is not changed
			        vc	= vn;
			        Thread.Sleep( 300 );
                    sfr.SetXor(SFR.PORTC, 0x0f);
                    sfr.Set(SFR.TCCR1B, 0);
			        continue;
		        }
		        vc	= vn;

		        //	Light LEDs with the ADC value
                sfr.Set(SFR.PORTC, 8 >> (vc >> 8));

		        //	Change buzzer tone with the ADC value
		        t	= ( vc + 0x100 ) << 4;
                sfr.Set(SFR.OCR1AH, t >> 8);
                sfr.Set(SFR.OCR1AL, t);
                sfr.Set(SFR.TCCR1B, 0x09);

		        //	Display the scale with the ADC value
		        Console.WriteLine( String.Format("{0,6:d}  {1}", vc, bar.Substring(0,vc>>4) ) );

		        Thread.Sleep( 20 );
            }

            //	Reset AVR peripherals
            sfr.Set(SFR.ADCSRA, 0);
            sfr.Set(SFR.DIDR0, 0);      //  ** ATmega8 :: REMOVE this line **
            sfr.Set(SFR.TCCR1A, 0);
            sfr.Set(SFR.TCCR1B, 0);
            sfr.Set(SFR.PORTC, 0);
            sfr.Set(SFR.DDRC, 0);
            sfr.Set(SFR.PORTB, 0);
            sfr.Set(SFR.DDRB, 0);

            sfr.Close();
            return 0;
        }
    }
}


