
DEVICE = atmega8
#DEVICE = atmega48
AVRDUDE = avrdude -c pony-stk200 -P lpt1 -p $(DEVICE) -E noreset
HIDPROG = ../bootloadHID/commandline/bootloadHID.exe -r

COMPILE = avr-gcc -Wall -Os -Iusbdrv -I. -mmcu=$(DEVICE) -D F_CPU=12800000

OBJECTS = usbdrv/usbdrv.o usbdrv/usbdrvasm.o usbdrv/oddebug.o usb2lpt6.o

# Implizite Regeln und symbolische Ziele:
all:	usb2lpt6.hex

disasm:	usb2lpt6.lst

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" erforderlich, falls unter Windows die Endung .S
# wegen irgendetwas ein Kleinbuchstabe wurde

.c.s:
	$(COMPILE) -S $< -o $@

flash:	all
#	$(AVRDUDE) -U flash:w:usb2lpt6.hex:i
	$(HIDPROG) usb2lpt6.hex


# ATmega8 fuses:
# Fuse high byte:
# 0x81 = 1 0 0 0   0 0 0 1 <-- BOOTRST (boot reset vector at 0x0000)
#        ^ ^ ^ ^   ^ ^ ^------ BOOTSZ0
#        | | | |   | +-------- BOOTSZ1
#        | | | |   +---------- EESAVE (preserve EEPROM over chip erase)
#        | | | +-------------- CKOPT (full output swing)
#        | | +---------------- SPIEN (allow serial programming)
#        | +------------------ WDTON (Watchdog immer EIN)
#        +-------------------- RSTDISBL (reset pin is enabled)
# Fuse low byte:
# 0x84 = 1 0 0 0   0 1 0 0
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL 3..0 (RC-Oszillator, 8 MHz)
#        | |  +--------------- SUT 1..0 (minimale Hochlaufzeit: 0,5 µs)
#        | +------------------ BODEN (BrownOut Detector enabled)
#        +-------------------- BODLEVEL (2.7V)

# ATmega48 fuses:
# Fuse high byte:
# 0xD5 = 1 1 0 1   0 1 0 1
#        ^ ^ ^ ^   ^ ^-^-^---- BODLEVEL	(2.7V)
#        | | | |   +---------- EESAVE	(don't preserve EEPROM over chip erase)
#        | | | +-------------- WDTON	(Watchdog Timer Always On)
#        | | +---------------- SPIEN	(Enable Serial Programming)
#        | +------------------ DWEN	(debugWIRE Enable)
#        +-------------------- RSTDISBL	(External Reset Disable)
# Fuse low byte:
# 0xEF = 1 1 1 0   1 1 1 1
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL
#        | |  +--------------- SUT	(Quartz crystal - 6 ms startup)
#        | +------------------ CKOUT	(no output)
#        +-------------------- CKDIV8	(no division)
ifeq ($(DEVICE),atmega8)
 HFUSE = 0x81
 LFUSE = 0x84
else
 HFUSE = 0xD5
 LFUSE = 0xEF!
endif
 
fuse:
	$(AVRDUDE) -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m
	
serial:
#	echo enter a command like "write eeprom 0x1FC 0xEC 0x03 0 0" for SN 1004
	$(AVRDUDE) -t

clean:
	rm -f usb2lpt6.hex usb2lpt6.lst usb2lpt6.bin *.o usbdrv/*.o

# Dateien:
usb2lpt6.bin:	$(OBJECTS)
	$(COMPILE) -o usb2lpt6.bin $(OBJECTS)

usb2lpt6.hex:	usb2lpt6.bin
	rm -f usb2lpt6.hex
	avr-objcopy -j .text -j .data -O ihex usb2lpt6.bin usb2lpt6.hex

usb2lpt6.lst:	usb2lpt6.bin
	avr-objdump -d usb2lpt6.bin > usb2lpt6.lst
