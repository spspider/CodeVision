
'   CDC-IO Utility routines for Visual Basic

'       Osamu Tamura @ Recursion Co., Ltd.

Imports System
Imports System.IO.Ports
Imports System.Threading
Imports System.Text
Imports System.Globalization


Class CDCIO
    Inherits SerialPort

    '   Open COM device
    Public Overloads Function Open(ByVal num As String) As Boolean
        MyBase.PortName = "COM" + num
        MyBase.ReadTimeout = 500
        MyBase.WriteTimeout = 500
        Try
            MyBase.Open()
        Catch
            Return False
        End Try
        Return MyBase.IsOpen
    End Function

    '   Obtain device name
    Public Function Who() As String
        MyBase.WriteLine("@")
        Return MyBase.ReadLine()
    End Function

    '   Obtain SFR value
    Public Function GetValue(ByVal addr As AVRSFR) As Integer
        Dim s As String

        MyBase.WriteLine(String.Format("{0:x2} ?", CInt(addr)))
        Do
            s = ReadLine()
        Loop Until s.Length > 1
        Return Int32.Parse(s, NumberStyles.HexNumber)
    End Function

    '   Set value to SFR
    Public Function SetValue(ByVal addr As AVRSFR, ByVal data As Integer)
        MyBase.WriteLine(String.Format("{0:x2} {1:x2} =", data And &HFF, CInt(addr)))
        Return MyBase.ReadLine()
    End Function

    Public Function SetAnd(ByVal addr As AVRSFR, ByVal data As Integer)
        MyBase.WriteLine(String.Format("{0:x2} {1:x2} &", data And &HFF, CInt(addr)))
        Return MyBase.ReadLine()
    End Function

    Public Function SetOr(ByVal addr As AVRSFR, ByVal data As Integer)
        MyBase.WriteLine(String.Format("{0:x2} {1:x2} |", data And &HFF, CInt(addr)))
        Return MyBase.ReadLine()
    End Function

    Public Function SetXor(ByVal addr As AVRSFR, ByVal data As Integer)
        MyBase.WriteLine(String.Format("{0:x2} {1:x2} ^", data And &HFF, CInt(addr)))
        Return MyBase.ReadLine()
    End Function

    '   Set two values to the same SFR
    Public Function Set2(ByVal addr As AVRSFR, ByVal data1 As Integer, ByVal data2 As Integer)
        MyBase.WriteLine(String.Format("{0:x2} {1:x2} {2:x2} $", data2 And &HFF, data1 And &HFF, CInt(addr)))
        Thread.Sleep(3)
        Return MyBase.ReadLine()
    End Function

End Class

