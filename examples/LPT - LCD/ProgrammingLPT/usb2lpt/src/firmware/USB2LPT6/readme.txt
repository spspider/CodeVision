To put the new firmware into ATmega's flash ROM:

* Ensure that you have an ATmega8. ATmegaX8 currently will not work.

* This firmware has an adjanced bootloader so firmware updates
  don't require a parallel port with adapter or programming device.

* When you use PonyProg2000:
  - ensure that programmer settings are correct
    (Avr ISP I/O, no inversions), check connection with „Probe“
  - power the ATmega, e.g. by USB cable
    (the computer will detect a non-functional USB device)
  - load bootloadHID\main.hex as FLASH file, it will place at 1800h
  - load usb2lpt6.hex as FLASH file, it will place at 0000h
  - set the fuses as shown in „PonyProg Fuses.png“ picture
  - connect to target device and burn all (the fuses and the flash)
  - re-plug the USB cable, the h#s low-speed USB2LPT adapter should occur

* When you use avrdude (inside WinAVR):
  - adopt the ./bootloadHID/Makefile to match your programmer
  - connect to target device and power the ATmega chip
  - run „make flash fuse lock“ in directory ./bootloadHID
  - bridge pins 1 and 14 of SubD receptacle
  - plug the USB cable to PC's USB port (a HID device should occur)
  - run „make flash“ in directory . to burn the firmware
  - remove the bridge
  - unplug and re-plug USB cable, the h#s low-speed USB2LPT adapter
    should occur

Note that you don't need a crystal and you don't see any oscillations
on pin PB6 and PB7.

081103
