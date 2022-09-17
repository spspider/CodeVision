# Makefile zur Erzeugung der Treiberdateien für USB2LPT
# Für Microsoft NMAKE.EXE (Borland MAKE macht keine ANSI-OEM-Konvertierung)
# Alle Targets sind – wie immer – ohne Laufzeitbibliothek.
# Um nur für eine bestimmte Sprache zu erstellen, Option "L=<sprachkürzel>" verwenden!
# heha, 090628

VER_DLL=1,4,2009,1113
VER_SYS=1,9,2009,1113
VER_INF=1,2,2009,1113

##############################
# Pfade und Compilerschalter #
##############################

# Dieses Makefile benötigt (Gnu-)SED und Gnu-AWK für die Modifikation von Textdateien.
SED=sed -e
AWK=gawk -f
RM=del

# Hilfe-Compiler sowie Vorfilterung, weil ich immer noch Word 2.0 (reicht!) benutze
RTFMOD=rtfmod -x -e -q
HC=c:\Programme\msvc\Common\Tools\hcrtf -x

#### Für Windows 98 und Me wird für die Eigenschaftsseiten im Geräte-Manager
#### allen Ernstes ein 16-Bit-Compiler benötigt! Damit entstehen 16-Bit-DLLs.

# Benötigt Borland C++ 3.1, Turbo- oder MS-Assembler sowie Win98-DDK
SDK16=e:\BC
DDK16=c:\progra~1\msvc\98DDK

#Die beiden Assembler unterscheiden sich in ihrer Kode-Generierung beim Befehl "cmp al,bl".
#ASM16=f:\PROGRAMS\TASM5\BIN\TASM.EXE -m5 -jMASM51 -jQUIRKS
ASM16=$(DDK16)\bin\win98\ML.EXE /c

#FASTCALL (-pr) macht den Kode größer und nicht wirklich schneller.
#Microsoft C ist wegen _ss-Zeigern nicht unmittelbar einsetzbar.
#Borland C++ 4.0 erzeugt rätselhafterweise deutlich größeren Kode und wurde verworfen.
CC16=$(SDK16)\bin\bcc -c
CC16OPT=-3 -d -ms! -a -H- -k- -O1 -p -w -tWDE -po -I$(DDK16)\inc\win98\inc16;$(SDK16)\include

#RC16=$(SDK16)\bin\brc -r -k #-- unbrauchbar, verschluckt sich an DBCS!!
#RC16=c:\progra~1\msvc\w2k3sddk\bin\bin16\rc -ic:\progra~1\msvc\w2k3sddk\inc\inc16 -r #-- unbrauchbar, hackt Strings mit Nullen ab!!
RC16=$(DDK16)\bin\win98\bin16\RC.EXE -i$(SDK16)\INCLUDE -r

#Auch der BorlandC-Linker verschluckt sich an bestimmten DBCS aus der .DEF-Datei.
#Andere Linker wurden nicht probiert, um Problemen (Compiler vs. Linker) aus dem Weg zu gehen.
LINK16=$(SDK16)\bin\tlink.exe /Twd /x /L$(SDK16)\lib
# /Lc:\progra~1\msvc\w2k3sddk\lib\lib16
#LINK16=$(DDK32)\bin\bin16\link /Lc:\progra~1\msvc\w2k3sddk\lib\lib16 /NOLOGO

RL16=$(SDK16)\bin\rlink.exe -31 -t -k
#RL16=c:\progra~1\msvc\w2k3sddk\bin\bin16\rc -k -t -31

#### Für alles andere werden 32-Bit-Compiler benötigt.

# Benötigt (für Teletubbie-Optik) mindestens WinXP-DDK
DDK32=c:\programme\msvc\w2k3sddk
INC32=/I$(DDK32)\inc\wxp /I$(DDK32)\inc\crt
CC32=$(DDK32)\bin\x86\cl /nologo /W3 /O1 /GF /Zd /DWIN32 /DUNICODE $(INC32) /c
RC32=$(DDK32)\bin\x86\rc /i $(DDK32)\inc\wxp /d WINVER=0x0500
USERLIBS=kernel32.lib user32.lib gdi32.lib comdlg32.lib advapi32.lib shell32.lib comctl32.lib setupapi.lib shlwapi.lib cfgmgr32.lib
LINK32=$(DDK32)\bin\x86\link /LIBPATH:$(DDK32)\lib\wxp\i386 $(USERLIBS) /nologo /opt:nowin98 /mapinfo:lines /release /nod

CC64=$(DDK32)\bin\win64\x86\amd64\cl /DWIN32 /DUNICODE /D_WIN64 /nologo /W3 /O1 /GF /GS- /Zd /c
ASM64=$(DDK32)\bin\win64\x86\amd64\ml64 /c /nologo
LINK64=$(DDK32)\bin\win64\x86\amd64\link /LIBPATH:$(DDK32)\lib\wnet\amd64 /nologo /mapinfo:lines /release /nod 

#############
# Rekursion #
#############
!IFNDEF L
all:
	@echo Ressourcen für alle 10 Sprachen anhängen und in die 10 Setup-Verzeichnisse stellen ...
	@$(MAKE) /NOLOGO L=de
	@$(MAKE) /NOLOGO L=en
	@$(MAKE) /NOLOGO L=fr H=en
	@$(MAKE) /NOLOGO L=it H=en
	@$(MAKE) /NOLOGO L=es H=en
	@$(MAKE) /NOLOGO L=cn CP=936 H=en
	@$(MAKE) /NOLOGO L=jp CP=932 H=en
	@$(MAKE) /NOLOGO L=ru CP=1251 H=en
	@$(MAKE) /NOLOGO L=cz CP=1250 H=en
	@$(MAKE) /NOLOGO L=tr CP=1254 H=en

clean:
#Alle temporären Dateien landen neben dem Makefile
	-$(RM) *.obj
	-$(RM) *.res
	-$(RM) *.map
	-$(RM) prop??.dll
!ELSE
############
# Aktionen #
############

!IFDEF H
all: 9x 32 64 inf
!ELSE
all: 9x 32 64 help inf
!ENDIF
#sign
	@echo Sprache »$L« komplett.
	
dirs:
	mkdir ..\$L

###########
# Win9xMe #
###########

!IFNDEF CP
CP=1252
#	Keine typografischen ... (Ellipse) bei Win16
#	Gegeben als CP1252 - so funktioniert's nur mit nmake!!
FILTER=| $(SED) "s/…/.../g;s/–/-/g;s/„/»/g;s/“/«/g"
!ENDIF


9x: ..\$L\usb2lpt.dll ..\$L\usb2lpt.sys

### PropertySheet-Provider ###

# Assembler-Stub, um die Laufzeitbibliothek von Borland C++ wegzulassen
ul_c0ds.obj: dll\ul_c0ds.asm
	$(ASM16) $**

# Gemeinsamer Quelltext
prop16.obj: dll\prop.cpp dll\prop.h sys\usb2lpt.h dll\thunk16.h
	$(CC16) @<< -Idll -Isys -oprop16.obj dll\prop.cpp
$(CC16OPT)
<<

mon16.obj: dll\mon.cpp dll\prop.h sys\usb2lpt.h
	$(CC16) @<< -Idll -Isys -omon16.obj dll\mon.cpp
$(CC16OPT)
<<

# Stub-DLL ohne Ressourcen
prop16.dll: ul_c0ds.obj prop16.obj mon16.obj dll\prop16.def
	$(LINK16) ul_c0ds.obj prop16.obj mon16.obj,$@,prop16.map,import.lib,dll\prop16.def
	exechain $@

#Einsprachige 16-bit-Ressourcen
prop16$L.res: dll\prop.rc dll\prop.ico dll\$L.inc dll\FilterInc.awk
	$(AWK) dll\FilterInc.awk -v VER=$(VER_DLL) -v VP=$(VER_INF) -v CP=$(CP) dll\$L.inc >tmp.inc
	transcode $(CP) tmp.inc $(FILTER) >tmp.rc
	transcode $(CP) dll\prop.rc >>tmp.rc
	$(RC16) -idll -fo$@ tmp.rc
	$(RM) tmp.rc tmp.inc

# Sprachspezifische DLL
..\$L\usb2lpt.dll: prop16$L.res prop16.dll
	$(RL16) -fe $@ $**


### Treiber ###

usb2lpt.obj: sys\usb2lpt.c sys\usb2lpt.h sys\w2k.h
	$(CC32) /Fo$@ sys\usb2lpt.c /Gz /I c:\programme\msvc\98DDK\inc\win98 /D _X86_ /D DRIVER

vlpt.obj: sys\vlpt.c sys\usb2lpt.h
	$(CC32) /Fo$@ sys\vlpt.c /Gz /I c:\programme\msvc\98DDK\inc\win98 /D _X86_ /D DRIVER

w2k.obj: sys\w2k.c sys\w2k.h
	$(CC32) /Fo$@ sys\w2k.c /Gz /I c:\programme\msvc\98DDK\inc\win98 /D _X86_ /D DRIVER

usb2lpt$L.res: sys\usb2lpt.rc dll\$L.inc
	$(AWK) dll\FilterInc.awk -v VER=$(VER_SYS) -v VP=$(VER_INF) -v CP=1200 dll\$L.inc >tmp.inc
	transcode 1200 tmp.inc >tmp.rc
	transcode 1200 sys\usb2lpt.rc >>tmp.rc
	$(RC32) -fo$@ tmp.rc
	$(RM) tmp.rc tmp.inc

..\$L\usb2lpt.sys: usb2lpt.obj vlpt.obj w2k.obj usb2lpt$L.res
	$(LINK32) ntoskrnl.lib hal.lib USBD.LIB /entry:DriverEntry /out:$@ $** /libpath:"c:\programme\msvc\98DDK\lib\i386\free" /subsystem:NATIVE /driver /map:usb2lpt.sys.map

###########
# WinNt32 #
###########

32: ..\$L\usb2lpt.ntx86.dll ..\$L\usb2lpt.ntx86.sys

### PropertySheet-Provider ###

# Library-Stub, um eine Bindung nach Name nach msports.dll:ParallelPortPropPageProvider hinzubekommen
# Und LoadLibrary/GetProcAddress bläht Kode auf, ist langweilig – und das kann ja jeder!
# ... Bibliothek ist im w2k3-DDK enthalten.
#msports32.lib: dll\msports.cpp dll\msports.h
#	$(CC32) /DMSPORTS_EXPORTS dll\msports.cpp
#	$(LINK32) /dll /out:msports.dll msports.obj /export:ParallelPortPropPageProvider
#	$(RM) msports.obj msports.dll msports.exp

# Gemeinsamer Quelltext
prop32.obj: dll\prop.cpp dll\prop.h sys\usb2lpt.h dll\msports.h
	$(CC32) -Isys /Fo$@ dll\prop.cpp /Gr 
	
mon32.obj: dll\mon.cpp dll\prop.h sys\usb2lpt.h dll\msports.h
	$(CC32) -Isys /Fo$@ dll\mon.cpp /Gr

prop32$L.res: dll\prop.rc dll\prop.ico dll\prop.manifest dll\$L.inc dll\FilterInc.awk
	$(AWK) dll\FilterInc.awk -v VER=$(VER_DLL) -v VP=$(VER_INF) -v CP=1200 dll\$L.inc >tmp.inc
	transcode 1200 tmp.inc >tmp.rc
	transcode 1200 dll\prop.rc >>tmp.rc
	$(RC32) -I dll /d WIN32 -r -fo$@ tmp.rc
	$(RM) tmp.rc tmp.inc

# Stub-DLL ohne Ressourcen: Das geht nicht! Fehlt ein Ressource-Linker!
..\$L\usb2lpt.ntx86.dll: prop32.obj mon32.obj prop32$L.res
	$(LINK32) /dll /out:usb2lpt.dll $** msports.lib /subsystem:windows,5.0 /base:0x6abc0000 /version:1.2 /export:EnumPropPages /export:CoDeviceInstall /map:usb2lpt.ntx86.dll.map
	$(RM) usb2lpt.exp usb2lpt.lib
# Die DLL soll intern schön "usb2lpt.dll" heißen - so benennt sie der Installer um.
	move usb2lpt.dll $@

### Treiber ###

usb2lpt32.obj: sys\usb2lpt.c sys\usb2lpt.h
	$(CC32) /Fo$@ sys\usb2lpt.c /Gz /I $(DDK32)\inc\ddk\w2k /I $(DDK32)\inc\crt /I $(DDK32)\inc\w2k /I $(DDK32)\inc\ddk\wdm\w2k /D _X86_ /D DRIVER /D NTDDK

vlpt32.obj: sys\vlpt.c sys\usb2lpt.h
	$(CC32) /Fo$@ sys\vlpt.c /Gz /I $(DDK32)\inc\ddk\w2k /I $(DDK32)\inc\crt /I $(DDK32)\inc\w2k /I $(DDK32)\inc\ddk\wdm\w2k /D _X86_ /D DRIVER /D NTDDK

# Gleiche Ressource für alle Plattformen, usb2lpt$L.res siehe "Win9xMe"

..\$L\usb2lpt.ntx86.sys: usb2lpt32.obj vlpt32.obj usb2lpt$L.res
	$(LINK32) ntoskrnl.lib hal.lib USBD.LIB /entry:DriverEntry /out:usb2lpt.sys $** /libpath:$(DDK32)\lib\w2k\i386 /subsystem:NATIVE /driver /map:usb2lpt.ntx86.sys.map
	move usb2lpt.sys $@

###########
# WinNt64 #
###########

64: ..\$L\usb2lpt.ntamd64.dll ..\$L\usb2lpt.ntamd64.sys

### PropertySheet-Provider ###

prop64.obj: dll\prop.cpp dll\prop.h sys\usb2lpt.h dll\msports.h
	$(CC64) -Isys /Fo$@ dll\prop.cpp $(INC32)
	
mon64.obj: dll\mon.cpp dll\prop.h sys\usb2lpt.h dll\msports.h
	$(CC64) -Isys /Fo$@ dll\mon.cpp $(INC32)

..\$L\usb2lpt.ntamd64.dll: prop64.obj mon64.obj prop32$L.res 
	$(LINK64) /dll /out:usb2lpt.dll $(USERLIBS) msports.lib $** /export:EnumPropPages /export:CoDeviceInstall /map:usb2lpt.ntamd64.dll.map
	$(RM) usb2lpt.exp usb2lpt.lib
	move usb2lpt.dll $@


### Treiber ###

usb2lpt64.obj: sys\usb2lpt.c sys\usb2lpt.h
	$(CC64) /Fo$@ sys\usb2lpt.c /I $(DDK32)\inc\ddk\wnet /I $(DDK32)\inc\crt /I $(DDK32)\inc\wnet /I $(DDK32)\inc\ddk\wdm\wnet /D _AMD64_ /D DRIVER /D NTDDK

vlpt64.obj: sys\vlpt.c sys\usb2lpt.h
	$(CC64) /Fo$@ sys\vlpt.c /I $(DDK32)\inc\ddk\wnet /I $(DDK32)\inc\crt /I $(DDK32)\inc\wnet /I $(DDK32)\inc\ddk\wdm\wnet /D _AMD64_ /D DRIVER /D NTDDK

amd64.obj: sys\amd64.asm
	$(ASM64) /Fo$@ $**

..\$L\usb2lpt.ntamd64.sys: usb2lpt64.obj vlpt64.obj amd64.obj usb2lpt$L.res
	$(LINK64) ntoskrnl.lib hal.lib USBD.LIB /entry:DriverEntry /out:usb2lpt.sys $** /libpath:$(DDK32)\lib\wnet\amd64 /subsystem:NATIVE /driver /map:usb2lpt.ntamd64.sys.map
	move usb2lpt.sys $@

#########
# Hilfe #
#########

help: ..\$L\usb2lpt.hlp
..\$L\usb2lpt.hlp: hlp\$L.hpj hlp\$L.rtf
	cd hlp
	$(RTFMOD) $L.rtf
	$(HC) $L.hpj
	cd ..

inf: ..\$L\usb2lpt.inf Makefile

..\$L\usb2lpt.inf: inf\usb2lpt.inx inf\FilterInf.awk inf\FilterInc.awk dll\$L.inc
	$(AWK) inf\FilterInf.awk -v VER_INF=$(VER_INF) -v HLP_LNG=$H inf\usb2lpt.inx > $@
	transcode $(CP) dll\$L.inc | $(AWK) inf\FilterInc.awk >> $@

sign: ..\$L\usb2lpt.cat
	$(SIGN) ..\$L\usb2lpt.ntx86.sys ..\$L\usb2lpt.ntx86.dll ..\$L\usb2lpt.ntamd64.sys ..\$L\usb2lpt.ntamd64.dll

#..\$L\usb2lpt.cat: ..\$L\usb2lpt.inf
#	$(MAKECAT)

!ENDIF

######################################
# Hilfsziele zur Programmentwicklung #
######################################

# leer
