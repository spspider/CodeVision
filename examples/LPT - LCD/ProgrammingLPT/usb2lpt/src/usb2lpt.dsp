# Microsoft Developer Studio Project File - Name="usb2lpt" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** NICHT BEARBEITEN **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=usb2lpt - Win32 Debug
!MESSAGE Dies ist kein gültiges Makefile. Zum Erstellen dieses Projekts mit NMAKE
!MESSAGE verwenden Sie den Befehl "Makefile exportieren" und führen Sie den Befehl
!MESSAGE 
!MESSAGE NMAKE /f "usb2lpt.mak".
!MESSAGE 
!MESSAGE Sie können beim Ausführen von NMAKE eine Konfiguration angeben
!MESSAGE durch Definieren des Makros CFG in der Befehlszeile. Zum Beispiel:
!MESSAGE 
!MESSAGE NMAKE /f "usb2lpt.mak" CFG="usb2lpt - Win32 Debug"
!MESSAGE 
!MESSAGE Für die Konfiguration stehen zur Auswahl:
!MESSAGE 
!MESSAGE "usb2lpt - Win32 Release" (basierend auf  "Win32 (x86) External Target")
!MESSAGE "usb2lpt - Win32 Debug" (basierend auf  "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""

!IF  "$(CFG)" == "usb2lpt - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Cmd_Line "NMAKE /f usb2lpt.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "usb2lpt.exe"
# PROP BASE Bsc_Name "usb2lpt.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "objfre_wxp_x86\i386"
# PROP Intermediate_Dir "objfre_wxp_x86\i386"
# PROP Cmd_Line "cmd.exe /c cd && pushd . && C:\PROGRA~1\msvc\DDK\bin\setenv.bat C:\PROGRA~1\msvc\DDK fre W2K && popd && nmake /NOLOGO"
# PROP Rebuild_Opt "/a"
# PROP Target_File "usb2lpt.sys"
# PROP Bsc_Name "lib\i386\usb2lpt.bsc"
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "usb2lpt - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Cmd_Line "NMAKE /f usb2lpt.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "usb2lpt.exe"
# PROP BASE Bsc_Name "usb2lpt.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "objchk_wxp_x86\i386"
# PROP Intermediate_Dir "objchk_wxp_x86\i386"
# PROP Cmd_Line "cmd.exe /c cd && pushd . && C:\PROGRA~1\msvc\DDK\bin\setenv.bat C:\PROGRA~1\msvc\DDK chk W2K && popd && nmake /NOLOGO"
# PROP Rebuild_Opt "/a"
# PROP Target_File "usb2lpt.sys"
# PROP Bsc_Name "lib\i386\usb2lpt.bsc"
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "usb2lpt - Win32 Release"
# Name "usb2lpt - Win32 Debug"

!IF  "$(CFG)" == "usb2lpt - Win32 Release"

!ELSEIF  "$(CFG)" == "usb2lpt - Win32 Debug"

!ENDIF 

# Begin Group "Quellcodedateien"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\usb2lpt.c
# End Source File
# Begin Source File

SOURCE=.\vlpt.c
# End Source File
# End Group
# Begin Group "Header-Dateien"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\usb2lpt.h
# End Source File
# End Group
# Begin Group "Ressourcendateien"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\usb2lpt.rc
# End Source File
# End Group
# Begin Source File

SOURCE=.\Sources
# End Source File
# End Target
# End Project
