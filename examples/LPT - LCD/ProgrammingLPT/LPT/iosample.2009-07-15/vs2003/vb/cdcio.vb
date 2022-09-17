
'   CDC-IO Utility routines for Visual Basic

'       Osamu Tamura @ Recursion Co., Ltd.

Imports System
Imports System.Threading
Imports System.Text
Imports System.Globalization
Imports System.Runtime.InteropServices


Class CDCIO
    Structure DCB
        Public DCBlength As Integer
        Public BaudRate As Integer
        Public fBitFields As Integer
        Public wReserved As Short
        Public XonLim As Short
        Public XoffLim As Short
        Public ByteSize As Byte
        Public Parity As Byte
        Public StopBits As Byte
        Public XonChar As Byte
        Public XoffChar As Byte
        Public ErrorChar As Byte
        Public EofChar As Byte
        Public EvtChar As Byte
        Public wReserved1 As Short
    End Structure

    Structure COMSTAT
        Public fBitFields As Integer
        Public cbInQue As Integer
        Public cbOutQue As Integer
    End Structure

    Public Declare Function _
        CreateFile Lib "kernel32" Alias "CreateFileA" ( _
            ByVal lpFileName As String, _
            ByVal dwDesiredAccess As Integer, _
            ByVal dwShareMode As Integer, _
            ByVal lpSecurityAttributes As Integer, _
            ByVal dwCreationDisposition As Integer, _
            ByVal dwFlagsAndAttributes As Integer, _
            ByVal hTemplateFile As Integer) _
    As Integer

    Public Const INVALID_HANDLE_VALUE = -1
    Public Const GENERIC_READ = &H80000000
    Public Const GENERIC_WRITE = &H40000000
    Public Const OPEN_EXISTING = 3

    Public Declare Function _
        CloseHandle Lib "kernel32" ( _
            ByVal hObject As Long) _
    As Integer

    Public Declare Function ReadFile Lib "kernel32" ( _
       ByVal hFile As Integer, _
       ByVal lpBuffer() As Byte, _
       ByVal nNumberOfBytesToRead As Integer, _
       ByRef lecActiveOfBytesRead As Integer, _
       ByVal lpOverlapped As Integer) _
    As Integer

    Declare Function WriteFile Lib "kernel32" ( _
         ByVal hFile As Integer, _
         ByVal lpBuffer() As Byte, _
         ByVal nNumberOfBytesToWrite As Integer, _
         ByRef lpNumberOfBytesWritten As Integer, _
         ByVal lpOverlapped As Integer) _
    As Integer

    Public Declare Function _
        ClearCommError Lib "kernel32" ( _
            ByVal hFile As Integer, _
            ByRef lpErrors As Integer, _
            ByRef lpStat As COMSTAT) _
    As Integer

    Public Declare Function _
         SetCommState Lib "kernel32" ( _
             ByVal hCommDev As Integer, _
             ByRef lfDCB As DCB) _
    As Integer

    Private hFile As Integer
    Private rwlen As Integer
    Private buf(16) As Byte


    '   Open COM device
    Public Function Open(ByVal num As String) As Boolean
        Dim PortName As String
        Dim fDCB As DCB

        If hFile <> INVALID_HANDLE_VALUE Then
            Close()
        End If
        PortName = "\\.\COM" & num
        hFile = CreateFile(PortName, GENERIC_READ Or GENERIC_WRITE, _
                        0&, 0&, OPEN_EXISTING, 0&, 0&)
        If hFile <> INVALID_HANDLE_VALUE Then
            fDCB.DCBlength = Marshal.SizeOf(fDCB)
            fDCB.BaudRate = 9600
            fDCB.fBitFields = &H1
            fDCB.ByteSize = 8
            fDCB.Parity = 0
            fDCB.StopBits = 0
            If SetCommState(hFile, fDCB) = 0 Then
                hFile = INVALID_HANDLE_VALUE
            End If
        End If
        Return hFile <> INVALID_HANDLE_VALUE
    End Function

    '   Obtain device name
    Public Function Who() As String
        WriteLine("@")
        Return ReadLine()
    End Function

    '   Obtain SFR value
    Public Function GetValue(ByVal addr As AVRSFR) As Integer
        Dim s As String

        WriteLine(String.Format("{0:x2} ?", CInt(addr)))
        Do
            s = ReadLine()
        Loop Until s.Length > 1
        Return Int32.Parse(s, NumberStyles.HexNumber)
    End Function

    '   Set value to SFR
    Public Function SetValue(ByVal addr As AVRSFR, ByVal data As Integer)
        WriteLine(String.Format("{0:x2} {1:x2} =", data And &HFF, CInt(addr)))
        Return ReadLine()
    End Function

    Public Function SetAnd(ByVal addr As AVRSFR, ByVal data As Integer)
        WriteLine(String.Format("{0:x2} {1:x2} &", data And &HFF, CInt(addr)))
        Return ReadLine()
    End Function

    Public Function SetOr(ByVal addr As AVRSFR, ByVal data As Integer)
        WriteLine(String.Format("{0:x2} {1:x2} |", data And &HFF, CInt(addr)))
        Return ReadLine()
    End Function

    Public Function SetXor(ByVal addr As AVRSFR, ByVal data As Integer)
        WriteLine(String.Format("{0:x2} {1:x2} ^", data And &HFF, CInt(addr)))
        Return ReadLine()
    End Function

    '   Set two values to the same SFR
    Public Function Set2(ByVal addr As AVRSFR, ByVal data1 As Integer, ByVal data2 As Integer)
        WriteLine(String.Format("{0:x2} {1:x2} {2:x2} $", data2 And &HFF, data1 And &HFF, CInt(addr)))
        Thread.Sleep(3)
        Return ReadLine()
    End Function

    '	Close COM device
    Public Function Close()
        CloseHandle(hFile)
        hFile = INVALID_HANDLE_VALUE
    End Function


    Private Function ReadLine() As String
        Dim Err As Integer
        Dim fComStat As COMSTAT
        Dim utf8 As New UTF8Encoding

        Do
            Thread.Sleep(1)
            If ClearCommError(hFile, Err, fComStat) = 0 Then
                Return ""
            End If
        Loop Until fComStat.cbInQue >= 2
        If ReadFile(hFile, buf, fComStat.cbInQue, rwlen, 0&) = 0 Then
            Return ""
        End If
        Do
            rwlen = rwlen - 1
            If rwlen < 0 Then
                Return ""
            End If
        Loop While buf(rwlen) <= &H20
        Return utf8.GetString(buf, 0, rwlen + 1)
    End Function

    Private Function WriteLine(ByVal s As String)
        Dim ascii As New ASCIIEncoding
        Dim byteCount As Integer

        s = s + " "
        byteCount = ascii.GetByteCount(s)
        ascii.GetBytes(s, 0, byteCount, buf, 0)
        WriteFile(hFile, buf, byteCount, rwlen, 0&)
    End Function

End Class

