These files are modified files out of actual bootloadHID project
that supports 12.8 MHz RC oscillator and fits into 2 KB boot space.
It's specifically for the USB2LPT project that connects
USB D- to B0 (interrupt source = Input Capture) and USB D+ to B1.

[The reason for not using usual D2=INT0 and D3=INT1 was to have
a true 8-bit parallel port "D" for LPT data port simulation.
Now, with no need for a crystal, it's kept for PCB compatibility
while another full 8-bit port "B" is available.]

Reasons for changing:
Makefile	support altenative interrupt vector with interrupts.S
		change linker script to ldscripts/avr4.x
		fuse setting changed
		clock frequency changed

main.c		function main() attribute "noreturn" set
		slightly shorter but no perfect code to jump to address 0

usbconfig.h	see "Optional MCU Description" section

bootloaderconfig.h	regulary to be changed by design

New files:
interrupt.S	shorten interrupt table with hard-coded string between
		as in "usbload" example

ldscripts/avr4.x	changed linker script to link interrupt.S code first
			and omit standard interrupt vector table

The directory "usbdrv" and not-changed files are omitted here; refer to
directory up one level.
