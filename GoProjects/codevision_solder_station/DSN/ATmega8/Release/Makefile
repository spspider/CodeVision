###############################################################################
# Makefile for project 
###############################################################################

## General options
PROJECT = 
MCU = ATmega8
COMPILER = "AVRASM (Proteus)"
TARGET = Release
SHELL = C:\Windows\system32\cmd.exe

## Tools general options
ASMFLAGS=-fO -i"C:\Program Files (x86)\Labcenter Electronics\Proteus 8 Professional\Tools\AVRASM\appnotes\m8def.inc" -e 123 -I d:\My Documents\Programming\Proteus\battarey_samsung rv513\codevision_solder_station\firmware\ -D d:\My Documents\Programming\Proteus\battarey_samsung rv513\codevision_solder_station\firmware\ -fI

## Processing Tools
ASM=avrasm2.exe
#  D:/My Documents/Programming/Proteus/battarey_samsung rv513/codevision_solder_station/DSN/ATmega8/Release/Release.hex: TOOL=ASM

# Build tree:
all:	Release

Release:	Release.hex
	cp "Release.hex" "../../ATmega8.hex"

Release.hex:	
	$(ASM) $(ASMFLAGS)  -o "Release.hex" -l Release.lst %INFILE_DOS_QUOTED%

# tidy - delete all temporary files which are not involved in the target generation
tidy:
	rm -rf Release.lst

# cleanup - delete all generated files
clean:	tidy

