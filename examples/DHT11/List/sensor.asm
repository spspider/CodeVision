
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny2313
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _bGlobalErr=R3
	.DEF _dht_in=R2
	.DEF _cyf=R5
	.DEF _des=R4
	.DEF _ed=R7
	.DEF _fase=R6

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_znak:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F,0x0,0x63,0x39,0x76
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

_0x5B:
	.DB  0x0,0x1,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  _0x5B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)
	LDI  R29,HIGH(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 29.07.2011
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATtiny2313
;Clock frequency     : 8,000000 MHz
;Memory model        : Tiny
;External RAM size   : 0
;Data Stack size     : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define dht_dpin 3
;char bGlobalErr;
;char dht_dat[5];
;char dht_in;
;flash char znak[]={63,6,91,79,102,109,125,7,127,111,0,99,57,118};
;char cyf=1;
;char out[]={0,0,0,0};
;char des=0, ed=0;
;char fase=0;
;
;void InitDHT(void);
;void ReadDHT(void);
;char read_dht_dat();
;char hex2dec(char);
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002B     {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002C         cyf=cyf*2;
	MOV  R26,R5
	RCALL SUBOPT_0x0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MULB12
	MOV  R5,R30
; 0000 002D         if (cyf==16) cyf=1;
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x3
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 002E         if (fase==0){
_0x3:
	TST  R6
	BRNE _0x4
; 0000 002F         switch (cyf)
	RCALL SUBOPT_0x1
; 0000 0030         {
; 0000 0031             case 1: PORTB=~znak[12]; PORTD.0=1; PORTD.3=0; break;
	BRNE _0x8
	__POINTW1FN _znak,12
	RCALL SUBOPT_0x2
	SBI  0x12,0
	CBI  0x12,3
	RJMP _0x7
; 0000 0032             case 2: PORTB=~znak[11]; PORTD.1=1; PORTD.0=0; break;
_0x8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD
	__POINTW1FN _znak,11
	RCALL SUBOPT_0x2
	SBI  0x12,1
	CBI  0x12,0
	RJMP _0x7
; 0000 0033             case 4: PORTB=~znak[out[2]]; PORTD.2=1; PORTD.1=0; break;
_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x12
	__GETB1MN _out,2
	RCALL SUBOPT_0x3
	SBI  0x12,2
	CBI  0x12,1
	RJMP _0x7
; 0000 0034             case 8: PORTB=~znak[out[3]]; PORTD.3=1; PORTD.2=0; break;
_0x12:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x7
	__GETB1MN _out,3
	RCALL SUBOPT_0x3
	SBI  0x12,3
	CBI  0x12,2
; 0000 0035         }
_0x7:
; 0000 0036         }
; 0000 0037         else
	RJMP _0x1C
_0x4:
; 0000 0038         {
; 0000 0039             switch (cyf)
	RCALL SUBOPT_0x1
; 0000 003A         {
; 0000 003B             case 1: PORTB=~znak[out[0]]; PORTD.0=1; PORTD.3=0; break;
	BRNE _0x20
	LDS  R30,_out
	RCALL SUBOPT_0x3
	SBI  0x12,0
	CBI  0x12,3
	RJMP _0x1F
; 0000 003C             case 2: PORTB=~znak[out[1]]; PORTD.1=1; PORTD.0=0; break;
_0x20:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x25
	__GETB1MN _out,1
	RCALL SUBOPT_0x3
	SBI  0x12,1
	CBI  0x12,0
	RJMP _0x1F
; 0000 003D             case 4: PORTB=~znak[10]; PORTD.2=1; PORTD.1=0; break;
_0x25:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A
	__POINTW1FN _znak,10
	RCALL SUBOPT_0x2
	SBI  0x12,2
	CBI  0x12,1
	RJMP _0x1F
; 0000 003E             case 8: PORTB=~znak[13]; PORTD.3=1; PORTD.2=0; break;
_0x2A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x1F
	__POINTW1FN _znak,13
	RCALL SUBOPT_0x2
	SBI  0x12,3
	CBI  0x12,2
; 0000 003F         }
_0x1F:
; 0000 0040         }
_0x1C:
; 0000 0041     }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 0049 {
_main:
; 0000 004A // Declare your local variables here
; 0000 004B 
; 0000 004C // Crystal Oscillator division factor: 1
; 0000 004D #pragma optsize-
; 0000 004E CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 004F CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0050 #ifdef _OPTIMIZE_SIZE_
; 0000 0051 #pragma optsize+
; 0000 0052 #endif
; 0000 0053 
; 0000 0054 PORTB=0x80;
	LDI  R30,LOW(128)
	OUT  0x18,R30
; 0000 0055 DDRB=0x7F;
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 0056 
; 0000 0057 PORTD=0x7F;
	OUT  0x12,R30
; 0000 0058 DDRD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0059 
; 0000 005A UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 005B UCSRB=0x00;
	OUT  0xA,R30
; 0000 005C UCSRC=0x00;
	OUT  0x3,R30
; 0000 005D UBRRH=0x00;
	OUT  0x2,R30
; 0000 005E UBRRL=0x00;
	OUT  0x9,R30
; 0000 005F 
; 0000 0060 TCCR0A=0x00;
	OUT  0x30,R30
; 0000 0061 TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0062 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0063 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0064 
; 0000 0065 #asm("sei")
	sei
; 0000 0066 
; 0000 0067 InitDHT();
	RCALL _InitDHT
; 0000 0068 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x4
; 0000 0069 
; 0000 006A while (1)
_0x34:
; 0000 006B     {
; 0000 006C         #asm("cli")
	cli
; 0000 006D         PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 006E         fase=1-fase;
	MOV  R30,R6
	RCALL SUBOPT_0x5
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __SWAPW12
	SUB  R30,R26
	MOV  R6,R30
; 0000 006F         ReadDHT();
	RCALL _ReadDHT
; 0000 0070         #asm("sei")
	sei
; 0000 0071         if (bGlobalErr==0)
	TST  R3
	BRNE _0x37
; 0000 0072             {
; 0000 0073                 hex2dec(dht_dat[2]);
	__GETB1MN _dht_dat,2
	ST   -Y,R30
	RCALL _hex2dec
; 0000 0074                 out[3]=des;
	__POINTB1MN _out,3
	ST   Z,R4
; 0000 0075                 out[2]=ed;
	__POINTB1MN _out,2
	ST   Z,R7
; 0000 0076                 hex2dec(dht_dat[0]);
	LDS  R30,_dht_dat
	ST   -Y,R30
	RCALL _hex2dec
; 0000 0077                 out[1]=des;
	__POINTB1MN _out,1
	ST   Z,R4
; 0000 0078                 out[0]=ed;
	STS  _out,R7
; 0000 0079             }
; 0000 007A         else
	RJMP _0x38
_0x37:
; 0000 007B             {
; 0000 007C                 out[0]=10;
	LDI  R30,LOW(10)
	STS  _out,R30
; 0000 007D                 out[1]=10;
	__PUTB1MN _out,1
; 0000 007E                 out[2]=10;
	__PUTB1MN _out,2
; 0000 007F                 out[3]=10;
	__PUTB1MN _out,3
; 0000 0080             }
_0x38:
; 0000 0081         delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RCALL SUBOPT_0x4
; 0000 0082     };
	RJMP _0x34
; 0000 0083 }
_0x39:
	RJMP _0x39
;
;void InitDHT(void)
; 0000 0086     {
_InitDHT:
; 0000 0087         DDRD.6=1;
	SBI  0x11,6
; 0000 0088         PORTD.6=1;
	SBI  0x12,6
; 0000 0089     }
	RET
;
;void ReadDHT(void)
; 0000 008C     {
_ReadDHT:
; 0000 008D         char dht_check_sum;
; 0000 008E         char i = 0;
; 0000 008F         bGlobalErr=0;
	RCALL __SAVELOCR2
;	dht_check_sum -> R17
;	i -> R16
	LDI  R16,0
	CLR  R3
; 0000 0090         PORTD.6=0;
	CBI  0x12,6
; 0000 0091         delay_ms(23);
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	RCALL SUBOPT_0x4
; 0000 0092         PORTD.6=1;
	SBI  0x12,6
; 0000 0093         delay_us(40);
	__DELAY_USB 107
; 0000 0094         DDRD.6=0;
	CBI  0x11,6
; 0000 0095         delay_us(40);
	__DELAY_USB 107
; 0000 0096 
; 0000 0097         dht_in=PIND.6;
	RCALL SUBOPT_0x6
; 0000 0098 
; 0000 0099         if(dht_in)
	BREQ _0x44
; 0000 009A             {
; 0000 009B                 bGlobalErr=1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 009C                 return;
	RJMP _0x2060001
; 0000 009D             }
; 0000 009E         delay_us(80);
_0x44:
	__DELAY_USB 213
; 0000 009F 
; 0000 00A0         dht_in=PIND.6;
	RCALL SUBOPT_0x6
; 0000 00A1 
; 0000 00A2         if(!dht_in)
	BRNE _0x45
; 0000 00A3             {
; 0000 00A4                 bGlobalErr=2;
	LDI  R30,LOW(2)
	MOV  R3,R30
; 0000 00A5                 return;
	RJMP _0x2060001
; 0000 00A6             }
; 0000 00A7 
; 0000 00A8         delay_us(80);
_0x45:
	__DELAY_USB 213
; 0000 00A9         for (i=0; i<5; i++)
	LDI  R16,LOW(0)
_0x47:
	CPI  R16,5
	BRSH _0x48
; 0000 00AA             dht_dat[i] = read_dht_dat();
	MOV  R30,R16
	SUBI R30,-LOW(_dht_dat)
	PUSH R30
	RCALL _read_dht_dat
	POP  R26
	ST   X,R30
	SUBI R16,-1
	RJMP _0x47
_0x48:
; 0000 00AB DDRD.6=1;
	SBI  0x11,6
; 0000 00AC         PORTD.6=1;
	SBI  0x12,6
; 0000 00AD         dht_check_sum = dht_dat[0]+dht_dat[1]+dht_dat[2]+dht_dat[3];
	LDS  R26,_dht_dat
	CLR  R27
	__GETB1MN _dht_dat,1
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _dht_dat,2
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _dht_dat,3
	RCALL SUBOPT_0x5
	ADD  R30,R26
	MOV  R17,R30
; 0000 00AE         if(dht_dat[4]!= dht_check_sum)
	__GETB2MN _dht_dat,4
	CP   R17,R26
	BREQ _0x4D
; 0000 00AF             {bGlobalErr=3;}
	LDI  R30,LOW(3)
	MOV  R3,R30
; 0000 00B0     };
_0x4D:
	RJMP _0x2060001
;
;char read_dht_dat()
; 0000 00B3     {
_read_dht_dat:
; 0000 00B4         char i = 0;
; 0000 00B5         char result=0;
; 0000 00B6         for(i=0; i< 8; i++)
	RCALL __SAVELOCR2
;	i -> R17
;	result -> R16
	LDI  R17,0
	LDI  R16,0
	LDI  R17,LOW(0)
_0x4F:
	CPI  R17,8
	BRSH _0x50
; 0000 00B7             {
; 0000 00B8                 while(PIND.6==0);
_0x51:
	SBIS 0x10,6
	RJMP _0x51
; 0000 00B9                 delay_us(30);
	__DELAY_USB 80
; 0000 00BA                 if (PIND.6==1) result |=(1<<(7-i));
	RCALL SUBOPT_0x7
	BRNE _0x54
	MOV  R22,R16
	CLR  R23
	MOV  R30,R17
	RCALL SUBOPT_0x5
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	MOVW R26,R22
	OR   R30,R26
	MOV  R16,R30
; 0000 00BB                 while (PIND.6==1);
_0x54:
_0x55:
	RCALL SUBOPT_0x7
	BREQ _0x55
; 0000 00BC             }
	SUBI R17,-1
	RJMP _0x4F
_0x50:
; 0000 00BD         return result;
	MOV  R30,R16
_0x2060001:
	RCALL __LOADLOCR2P
	RET
; 0000 00BE     }
;
;char hex2dec(char num)
; 0000 00C1     {
_hex2dec:
; 0000 00C2         char result=0;
; 0000 00C3         char hex=num;
; 0000 00C4         des=0;
	RCALL __SAVELOCR2
;	num -> Y+2
;	result -> R17
;	hex -> R16
	LDI  R17,0
	LDD  R16,Y+2
	CLR  R4
; 0000 00C5         ed=0;
	CLR  R7
; 0000 00C6         while (hex>9)
_0x58:
	CPI  R16,10
	BRLO _0x5A
; 0000 00C7             {
; 0000 00C8                 hex=hex-10;
	MOV  R26,R16
	RCALL SUBOPT_0x0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __SWAPW12
	SUB  R30,R26
	MOV  R16,R30
; 0000 00C9                 des=des+1;
	MOV  R30,R4
	RCALL SUBOPT_0x5
	ADIW R30,1
	MOV  R4,R30
; 0000 00CA             }
	RJMP _0x58
_0x5A:
; 0000 00CB         ed=hex;
	MOV  R7,R16
; 0000 00CC         result=((des<<4)|ed);
	MOV  R26,R4
	RCALL SUBOPT_0x0
	MOVW R30,R26
	RCALL __LSLW4
	MOVW R26,R30
	MOV  R30,R7
	RCALL SUBOPT_0x5
	OR   R30,R26
	MOV  R17,R30
; 0000 00CD         return result;
	MOV  R30,R17
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; 0000 00CE     }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_dht_dat:
	.BYTE 0x5
_out:
	.BYTE 0x4
_p_S1020024:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	MOV  R30,R5
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	LPM  R30,Z
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R31,0
	SUBI R30,LOW(-_znak*2)
	SBCI R31,HIGH(-_znak*2)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	MOV  R2,R30
	TST  R2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULB12U:
	MOV  R0,R26
	SUB  R26,R26
	LDI  R27,9
	RJMP __MULB12U1
__MULB12U3:
	BRCC __MULB12U2
	ADD  R26,R0
__MULB12U2:
	LSR  R26
__MULB12U1:
	ROR  R30
	DEC  R27
	BRNE __MULB12U3
	RET

__MULB12:
	RCALL __CHKSIGNB
	RCALL __MULB12U
	BRTC __MULB121
	NEG  R30
__MULB121:
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
