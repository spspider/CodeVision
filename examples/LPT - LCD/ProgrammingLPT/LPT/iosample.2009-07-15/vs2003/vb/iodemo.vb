
'   CDC-IO demo for Visual Basic

'       Osamu Tamura @ Recursion Co., Ltd.

Imports System
Imports System.Threading
Imports System.Text
Imports System.Globalization
Imports System.Runtime.InteropServices


Module iodemo
    Private _kbhit As Boolean

    Private Sub KeyEnter()
        Console.Read()
        _kbhit = True
    End Sub

    Sub Main(ByVal CmdArgs() As String)
        Dim Quit As Thread = New Thread(New ThreadStart(AddressOf KeyEnter))
        Dim sfr As CDCIO
        Dim s As String
        Dim vc, vn, t As Integer
        Dim bar = "************************************************************************"

        If CmdArgs.Length = 0 Then
            Console.WriteLine(" usage: usfrdemo COM_port_number")
            Return
        End If

        '	Open COM device
        sfr = New CDCIO
        If Not sfr.Open(CmdArgs(0)) Then
            Console.WriteLine(" COM{0} is not available.", CmdArgs(0))
            Return
        End If

        Console.WriteLine(sfr.Who())

        '	 Initialize AVR peripherals
        sfr.SetValue(AVRSFR.PORTB, 0)
        sfr.SetValue(AVRSFR.DDRB, &H4)      '	OUT: PB2
        sfr.SetValue(AVRSFR.PORTC, 0)
        sfr.SetValue(AVRSFR.DDRC, &HF)      '	OUT: PC3-0, IN: PC4

        sfr.SetValue(AVRSFR.TCCR1A, &H10)

        sfr.SetValue(AVRSFR.DIDR0, &H10)    '   ATmega8 :: REMOVE this line
        sfr.SetValue(AVRSFR.ADMUX, &H4)
        sfr.SetValue(AVRSFR.ADCSRB, 0)      '   ATmega8 :: REMOVE this line
        sfr.SetValue(AVRSFR.ADCSRA, &H87)

        vc = 0
        _kbhit = False
        Quit.IsBackground = True
        Quit.Start()
        While Not _kbhit
            '	A/D Conversion
            sfr.SetOr(AVRSFR.ADCSRA, &H40)  '  Start conversion
            Thread.Sleep(10)                '  wait 10mSec
            vn = sfr.GetValue(AVRSFR.ADCL)  '  Obtain the result
            vn = vn + (sfr.GetValue(AVRSFR.ADCH) << 8)
            If (vc - 1) <= vn And vn <= (vc + 1) Then
                '	Flip LEDs if the ADC value is not changed
                vc = vn
                Thread.Sleep(300)
                sfr.SetXor(AVRSFR.PORTC, &HF)
                sfr.SetValue(AVRSFR.TCCR1B, 0)
            Else
                vc = vn

                '	Light LEDs with the ADC value
                sfr.SetValue(AVRSFR.PORTC, 8 >> (vc >> 8))

                '	Change buzzer tone with the ADC value
                t = (vc + &H100) << 4
                sfr.SetValue(AVRSFR.OCR1AH, t >> 8)
                sfr.SetValue(AVRSFR.OCR1AL, t)
                sfr.SetValue(AVRSFR.TCCR1B, &H9)

                '	Display the scale with the ADC value
                Console.WriteLine(String.Format("{0,6:d}  {1}", vc, bar.Substring(0, vc >> 4)))

                Thread.Sleep(20)
            End If
        End While

        '	Reset AVR peripherals
        sfr.SetValue(AVRSFR.ADCSRA, 0)
        sfr.SetValue(AVRSFR.DIDR0, 0)       '   ATmega8 :: REMOVE this line
        sfr.SetValue(AVRSFR.TCCR1A, 0)
        sfr.SetValue(AVRSFR.TCCR1B, 0)
        sfr.SetValue(AVRSFR.PORTC, 0)
        sfr.SetValue(AVRSFR.DDRC, 0)
        sfr.SetValue(AVRSFR.PORTC, 0)
        sfr.SetValue(AVRSFR.DDRB, 0)
        sfr.SetValue(AVRSFR.PORTB, 0)

        sfr.Close()
    End Sub

End Module
