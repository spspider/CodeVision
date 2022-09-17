
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _adc=R5
	.DEF _cycleL=R4
	.DEF _MS=R7
	.DEF _cycleN=R6
	.DEF _Disp6=R9
	.DEF _Disp7=R8
	.DEF _Other=R11
	.DEF _Num2=R10
	.DEF _Num3=R13
	.DEF _BipL=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x6:
	.DB  0xA
_0x3C:
	.DB  0x5,0x0,0x0,0x0,0x0,0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _TimeHW
	.DW  _0x6*2

	.DW  0x06
	.DW  0x07
	.DW  _0x3C*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

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
;Date    : 08.10.2011
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega8L
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;unsigned char adc;
;unsigned char cycleL;
;unsigned char MS=5,cycleN;
;unsigned char Disp6,Disp7,Other;
;unsigned char Num2, Num3,Dig[17],BipL=1;
;bit PINC5,PINC4,PIND7,PIND4,PIND0,PIND01,DisOther,Bip,HW=0,INJ=0,cycle,HW_1,INJ_1;
;#include <ADC.c>
;#define ADC_VREF_TYPE 0x00
;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0023 {

	.CSEG
;ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
;// Delay needed for the stabilization of the ADC input voltage
;delay_us(10);
;// Start the AD conversion
;ADCSRA|=0x40;
;// Wait for the AD conversion to complete
;while ((ADCSRA & 0x10)==0);
;ADCSRA|=0x10;
;return ADCW;
;}
;#include <interrupt.c>
;unsigned char Disp6,Disp7,Timer_5,TimeHW=10,Timer_7,Dis1,Dis2,Timer_9,Timer_10,Timer_3,Timer_2,Timer_8,Timer_11,Timer_4,Timer_6,Timer_12;

	.DSEG
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0024 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;
;#include <checkp.c>
;if ((PINC.5==0)&&(PINC5==0)){PINC5=1;MS=MS+5;;DisOther=0;Bip=1;}
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x8
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
	SET
	BLD  R2,0
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,5
	MOV  R7,R30
	CLT
	BLD  R2,6
	SET
	BLD  R2,7
;if (PINC.5==1){PINC5=0;}
_0x7:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xA
	CLT
	BLD  R2,0
;if ((PINC.4==0)&&(PINC4==0)){PINC4=1;MS=MS-5;DisOther=0;Bip=1;}
_0xA:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xC
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xD
_0xC:
	RJMP _0xB
_0xD:
	SET
	BLD  R2,1
	MOV  R26,R7
	LDI  R27,0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL __SWAPW12
	SUB  R30,R26
	MOV  R7,R30
	CLT
	BLD  R2,6
	SET
	BLD  R2,7
;
;if (PINC.4==1){PINC4=0;}
_0xB:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xE
	CLT
	BLD  R2,1
;
;if ((PIND.7==0)&&(PIND7==0)){PIND7=1;DisOther=0;HW=1;Bip=1;}
_0xE:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x10
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
	SET
	BLD  R2,2
	CLT
	BLD  R2,6
	SET
	BLD  R3,0
	BLD  R2,7
;if (PIND.7==1){PIND7=0;}
_0xF:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x12
	CLT
	BLD  R2,2
;
;if ((PIND.4==0)&&(PIND4==0)){PIND4=1;HW=0;BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}
_0x12:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x14
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x15
_0x14:
	RJMP _0x13
_0x15:
	SET
	BLD  R2,3
	CLT
	BLD  R3,0
	LDI  R30,LOW(5)
	MOV  R12,R30
	SET
	BLD  R2,7
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFE)
	OUT  0x15,R30
	CLT
	BLD  R3,0
	LDI  R30,LOW(0)
	STS  _Timer_9,R30
	STS  _Dis2,R30
	SET
	BLD  R2,6
	LDI  R30,LOW(11)
	MOV  R10,R30
	MOV  R13,R30
;if (PIND.4==1){PIND4=0;}
_0x13:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x16
	CLT
	BLD  R2,3
;
;if ((PIND.0==0)&&(PIND0==0)){PIND0=1;PIND01=0;Bip=1;cycleN=5;PORTD|=0b00000100;PORTD&=~0b00000010;DisOther=1;Num2=0;Num3=5;}
_0x16:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x18
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x19
_0x18:
	RJMP _0x17
_0x19:
	SET
	BLD  R2,4
	CLT
	BLD  R2,5
	SET
	BLD  R2,7
	LDI  R30,LOW(5)
	MOV  R6,R30
	IN   R30,0x12
	LDI  R31,0
	ORI  R30,4
	OUT  0x12,R30
	IN   R30,0x12
	LDI  R31,0
	ANDI R30,LOW(0xFFFD)
	OUT  0x12,R30
	BLD  R2,6
	CLR  R10
	LDI  R30,LOW(5)
	MOV  R13,R30
;if ((PIND.0==1)&&(PIND01==0)){PIND0=0;PIND01=1;Bip=1;cycleN=10;PORTD|=0b00000010;PORTD&=~0b00000100;DisOther=1;Num2=0;Num3=1;}
_0x17:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x1B
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
	CLT
	BLD  R2,4
	SET
	BLD  R2,5
	BLD  R2,7
	LDI  R30,LOW(10)
	MOV  R6,R30
	IN   R30,0x12
	LDI  R31,0
	ORI  R30,2
	OUT  0x12,R30
	IN   R30,0x12
	LDI  R31,0
	ANDI R30,LOW(0xFFFB)
	OUT  0x12,R30
	BLD  R2,6
	CLR  R10
	LDI  R30,LOW(1)
	MOV  R13,R30
;
;
;if (PIND.5==0){Bip=1;INJ=1;DisOther=0;}
_0x1A:
	SBIC 0x10,5
	RJMP _0x1D
	SET
	BLD  R2,7
	BLD  R3,1
	CLT
	BLD  R2,6
;if (PIND.6==0){Bip=1;INJ=0;Num2=11;Num3=10;DisOther=1;PORTC&=~0b00000010;Dis1=0;}
_0x1D:
	SBIC 0x10,6
	RJMP _0x1E
	SET
	BLD  R2,7
	CLT
	BLD  R3,1
	LDI  R30,LOW(11)
	MOV  R10,R30
	LDI  R30,LOW(10)
	MOV  R13,R30
	SET
	BLD  R2,6
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFD)
	OUT  0x15,R30
	LDI  R30,LOW(0)
	STS  _Dis1,R30
;
;
;if (HW==1){Timer_7++;Timer_8++;
_0x1E:
	LDI  R26,0
	SBRC R3,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x1F
	LDS  R30,_Timer_7
	SUBI R30,-LOW(1)
	STS  _Timer_7,R30
	LDS  R30,_Timer_8
	SUBI R30,-LOW(1)
	STS  _Timer_8,R30
;HW_1=1;
	SET
	BLD  R3,3
;if (Timer_7==TimeHW){PORTC^=0b00000001;Timer_7=0;}
	LDS  R30,_TimeHW
	LDS  R26,_Timer_7
	CP   R30,R26
	BRNE _0x20
	IN   R30,0x15
	LDI  R31,0
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x15,R30
	LDI  R30,LOW(0)
	STS  _Timer_7,R30
;if (Timer_8==250){Timer_10++;Dis2=Dig[16];}
_0x20:
	LDS  R26,_Timer_8
	CPI  R26,LOW(0xFA)
	BRNE _0x21
	LDS  R30,_Timer_10
	SUBI R30,-LOW(1)
	STS  _Timer_10,R30
	__GETB1MN _Dig,16
	STS  _Dis2,R30
;if (Timer_10==12){TimeHW=5;}
_0x21:
	LDS  R26,_Timer_10
	CPI  R26,LOW(0xC)
	BRNE _0x22
	LDI  R30,LOW(5)
	STS  _TimeHW,R30
;if (Timer_10==20){TimeHW=10;Timer_8=0;Timer_10=0;Timer_9++;}
_0x22:
	LDS  R26,_Timer_10
	CPI  R26,LOW(0x14)
	BRNE _0x23
	LDI  R30,LOW(10)
	STS  _TimeHW,R30
	LDI  R30,LOW(0)
	STS  _Timer_8,R30
	STS  _Timer_10,R30
	LDS  R30,_Timer_9
	SUBI R30,-LOW(1)
	STS  _Timer_9,R30
;if (Timer_9==10){BipL=5;Bip=1;PORTC&=~0b00000001;HW=0;Timer_9=0;Dis2=0;DisOther=1;Num2=11;Num3=11;}}//количество циклов HW
_0x23:
	LDS  R26,_Timer_9
	CPI  R26,LOW(0xA)
	BRNE _0x24
	LDI  R30,LOW(5)
	MOV  R12,R30
	SET
	BLD  R2,7
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFE)
	OUT  0x15,R30
	CLT
	BLD  R3,0
	LDI  R30,LOW(0)
	STS  _Timer_9,R30
	STS  _Dis2,R30
	SET
	BLD  R2,6
	LDI  R30,LOW(11)
	MOV  R10,R30
	MOV  R13,R30
_0x24:
;//if ((HW==0)&&(HW_1==1)){
;//HW_1=0;BipL=500;Bip=1;Timer_9=0;Dis2=0;Num2=11;Num3=11;Timer_7=0;Timer_8=0;
;//}
;
;Timer_2++;
_0x1F:
	LDS  R30,_Timer_2
	SUBI R30,-LOW(1)
	STS  _Timer_2,R30
;Timer_3++;
	LDS  R30,_Timer_3
	SUBI R30,-LOW(1)
	STS  _Timer_3,R30
;if (INJ==1){//включение работы инжектора
	LDI  R26,0
	SBRC R3,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x25
;INJ_1=1;
	SET
	BLD  R3,4
;Timer_11++;
	LDS  R30,_Timer_11
	SUBI R30,-LOW(1)
	STS  _Timer_11,R30
;if(cycleL>=cycleN){INJ=0;PORTC&=~0b00000010;Dis1=0;BipL=5;Bip=1;cycleL=0;DisOther=1;Num2=11;Num3=10;}
	CP   R4,R6
	BRLO _0x26
	CLT
	BLD  R3,1
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFD)
	OUT  0x15,R30
	LDI  R30,LOW(0)
	STS  _Dis1,R30
	LDI  R30,LOW(5)
	MOV  R12,R30
	SET
	BLD  R2,7
	CLR  R4
	BLD  R2,6
	LDI  R30,LOW(11)
	MOV  R10,R30
	LDI  R30,LOW(10)
	MOV  R13,R30
;if (Timer_11==250){Timer_4++;;}
_0x26:
	LDS  R26,_Timer_11
	CPI  R26,LOW(0xFA)
	BRNE _0x27
	LDS  R30,_Timer_4
	SUBI R30,-LOW(1)
	STS  _Timer_4,R30
;if (Timer_4==4){PORTC&=~0b00000010;Dis1=0;}
_0x27:
	LDS  R26,_Timer_4
	CPI  R26,LOW(0x4)
	BRNE _0x28
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFD)
	OUT  0x15,R30
	LDI  R30,LOW(0)
	STS  _Dis1,R30
;if (Timer_4>=MS+2){PORTC|=0b00000010;cycleL++;Timer_4=0;Dis1=Dig[16];}
_0x28:
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,2
	LDS  R26,_Timer_4
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x29
	IN   R30,0x15
	LDI  R31,0
	ORI  R30,2
	OUT  0x15,R30
	INC  R4
	LDI  R30,LOW(0)
	STS  _Timer_4,R30
	__GETB1MN _Dig,16
	STS  _Dis1,R30
;
;}
_0x29:
;//if ((INJ==0)&&(INJ_1==1)){
;//INJ=0;PORTC&=~0b00000010;Dis1=0;BipL=500;Bip=1;cycleL=0;DisOther=1;Num2=11;Num3=10;INJ_1=0;
;//}
;//BIP
;if (Bip==1){Timer_5++;
_0x25:
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x2A
	LDS  R30,_Timer_5
	SUBI R30,-LOW(1)
	STS  _Timer_5,R30
;if (Timer_5==5){//динамик частота
	LDS  R26,_Timer_5
	CPI  R26,LOW(0x5)
	BRNE _0x2B
;PORTD^=0b00001000;
	IN   R30,0x12
	LDI  R31,0
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
;//PORTD&=~0b00001000;
;Timer_5=0;
	LDI  R30,LOW(0)
	STS  _Timer_5,R30
;Timer_6++;
	LDS  R30,_Timer_6
	SUBI R30,-LOW(1)
	STS  _Timer_6,R30
;if (Timer_6==100){Timer_12++;}
	LDS  R26,_Timer_6
	CPI  R26,LOW(0x64)
	BRNE _0x2C
	LDS  R30,_Timer_12
	SUBI R30,-LOW(1)
	STS  _Timer_12,R30
;if (Timer_12==BipL){Timer_12=0;Timer_6=0;BipL=1;
_0x2C:
	LDS  R26,_Timer_12
	CP   R12,R26
	BRNE _0x2D
	LDI  R30,LOW(0)
	STS  _Timer_12,R30
	STS  _Timer_6,R30
	LDI  R30,LOW(1)
	MOV  R12,R30
;Bip=0;}
	CLT
	BLD  R2,7
;}
_0x2D:
;}
_0x2B:
;
;// end bip
;
;//if(Timer_8==100){
;//Timer_8=0;
;//DisOther=1;
;//}
;
;
;
;if (Timer_3==1){//первая цифра
_0x2A:
	LDS  R26,_Timer_3
	CPI  R26,LOW(0x1)
	BRNE _0x2E
;PORTC&=~0b00000100;
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFB)
	OUT  0x15,R30
;PORTC|=0b00001000;
	IN   R30,0x15
	LDI  R31,0
	ORI  R30,8
	OUT  0x15,R30
;PORTB=Disp6-Dis1;}
	MOV  R26,R9
	CLR  R27
	LDS  R30,_Dis1
	LDI  R31,0
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	OUT  0x18,R30
;if (Timer_3==100){//вторая цифра
_0x2E:
	LDS  R26,_Timer_3
	CPI  R26,LOW(0x64)
	BRNE _0x2F
;PORTC&=~0b00001000;
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFF7)
	OUT  0x15,R30
;PORTC|=0b00000100;
	IN   R30,0x15
	LDI  R31,0
	ORI  R30,4
	OUT  0x15,R30
;PORTB=Disp7-Dis2;
	MOV  R26,R8
	CLR  R27
	LDS  R30,_Dis2
	LDI  R31,0
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	OUT  0x18,R30
;}
;if (Timer_3==200){Timer_3=0;}
_0x2F:
	LDS  R26,_Timer_3
	CPI  R26,LOW(0xC8)
	BRNE _0x30
	LDI  R30,LOW(0)
	STS  _Timer_3,R30
;//Timer_8++;
;}
_0x30:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	RETI
;
;void Dig_init() //Массив для отображения цифр на семисегментном индикаторе
;{          //ABCDEFG DP
_Dig_init:
;  Dig[0] = 0b00000011;
	LDI  R30,LOW(3)
	STS  _Dig,R30
;  Dig[1] = 0b10011111;
	LDI  R30,LOW(159)
	__PUTB1MN _Dig,1
;  Dig[2] = 0b00100101;
	LDI  R30,LOW(37)
	__PUTB1MN _Dig,2
;  Dig[3] = 0b00001101;
	LDI  R30,LOW(13)
	__PUTB1MN _Dig,3
;  Dig[4] = 0b10011001;
	LDI  R30,LOW(153)
	__PUTB1MN _Dig,4
;  Dig[5] = 0b01001001;
	LDI  R30,LOW(73)
	__PUTB1MN _Dig,5
;  Dig[6] = 0b01000011;
	LDI  R30,LOW(67)
	__PUTB1MN _Dig,6
;  Dig[7] = 0b00011111;
	LDI  R30,LOW(31)
	__PUTB1MN _Dig,7
;  Dig[8] = 0b00000001;
	LDI  R30,LOW(1)
	__PUTB1MN _Dig,8
;  Dig[9] = 0b00001001;
	LDI  R30,LOW(9)
	__PUTB1MN _Dig,9
;  Dig[10]= 0b01001001;//s
	LDI  R30,LOW(73)
	__PUTB1MN _Dig,10
;  Dig[11]= 0b00110001;//p
	LDI  R30,LOW(49)
	__PUTB1MN _Dig,11
;  Dig[12]= 0b01100011;//C
	LDI  R30,LOW(99)
	__PUTB1MN _Dig,12
;  Dig[13]= 0b00001111;//C
	LDI  R30,LOW(15)
	__PUTB1MN _Dig,13
;  Dig[14]= 0b11001111;//u
	LDI  R30,LOW(207)
	__PUTB1MN _Dig,14
;  Dig[15]= 0b11100111;//u
	LDI  R30,LOW(231)
	__PUTB1MN _Dig,15
;  Dig[16]= 0b00000001;//.
	LDI  R30,LOW(1)
	__PUTB1MN _Dig,16
;}
	RET
;void Display (unsigned int Number) //Ф-ция для разложения десятичного цисла
;{
_Display:
;if (DisOther==0){
;	Number -> Y+0
	SBRC R2,6
	RJMP _0x31
;  Num2=0, Num3=0;
	CLR  R10
	CLR  R13
;    while (Number >= 10)
_0x32:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRLO _0x34
;  {
;    Number -= 10;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,10
	ST   Y,R30
	STD  Y+1,R31
;    Num3++;
	INC  R13
;  }
	RJMP _0x32
_0x34:
;  Num2 = Number;
	LDD  R10,Y+0
; }
;
;  Disp6 = Dig[Num3];
_0x31:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_Dig)
	SBCI R31,HIGH(-_Dig)
	LD   R9,Z
;  Disp7 = Dig[Num2];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_Dig)
	SBCI R31,HIGH(-_Dig)
	LD   R8,Z
;}
	ADIW R28,2
	RET
;
;// Timer 0 overflow interrupt service routine
;
;// Declare your global variables here
;
;void main(void)
; 0000 002B {
_main:
; 0000 002C // Declare your local variables here
; 0000 002D 
; 0000 002E // Input/Output Ports initialization
; 0000 002F // Port B initialization
; 0000 0030 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0031 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0032 PORTB=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0033 DDRB=0b11111111;
	OUT  0x17,R30
; 0000 0034 
; 0000 0035 // Port C initialization
; 0000 0036 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0037 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0038 PORTC=0b00111100;
	LDI  R30,LOW(60)
	OUT  0x15,R30
; 0000 0039 DDRC=0b00001111;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 003A 
; 0000 003B // Port D initialization
; 0000 003C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 003D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 003E PORTD=0b11110001;
	LDI  R30,LOW(241)
	OUT  0x12,R30
; 0000 003F DDRD=0b00001110;
	LDI  R30,LOW(14)
	OUT  0x11,R30
; 0000 0040 
; 0000 0041 // Timer/Counter 0 initialization
; 0000 0042 // Clock source: System Clock
; 0000 0043 // Clock value: 8000,000 kHz
; 0000 0044 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0045 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0046 
; 0000 0047 // Timer/Counter 1 initialization
; 0000 0048 // Clock source: System Clock
; 0000 0049 // Clock value: Timer 1 Stopped
; 0000 004A // Mode: Normal top=FFFFh
; 0000 004B // OC1A output: Discon.
; 0000 004C // OC1B output: Discon.
; 0000 004D // Noise Canceler: Off
; 0000 004E // Input Capture on Falling Edge
; 0000 004F // Timer 1 Overflow Interrupt: Off
; 0000 0050 // Input Capture Interrupt: Off
; 0000 0051 // Compare A Match Interrupt: Off
; 0000 0052 // Compare B Match Interrupt: Off
; 0000 0053 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0054 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0055 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0056 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0057 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0058 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0059 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 005A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 005B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 005C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 005D 
; 0000 005E // Timer/Counter 2 initialization
; 0000 005F // Clock source: System Clock
; 0000 0060 // Clock value: Timer 2 Stopped
; 0000 0061 // Mode: Normal top=FFh
; 0000 0062 // OC2 output: Disconnected
; 0000 0063 ASSR=0x00;
	OUT  0x22,R30
; 0000 0064 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0065 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0066 OCR2=0x00;
	OUT  0x23,R30
; 0000 0067 
; 0000 0068 // External Interrupt(s) initialization
; 0000 0069 // INT0: Off
; 0000 006A // INT1: Off
; 0000 006B MCUCR=0x00;
	OUT  0x35,R30
; 0000 006C 
; 0000 006D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 006E TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 006F 
; 0000 0070 // USART initialization
; 0000 0071 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0072 // USART Receiver: On
; 0000 0073 // USART Transmitter: On
; 0000 0074 // USART Mode: Asynchronous
; 0000 0075 // USART Baud Rate: 9600
; 0000 0076 
; 0000 0077 //UCSRA=0x00;
; 0000 0078 //UCSRB=0x18;
; 0000 0079 //UCSRC=0x86;
; 0000 007A //UBRRH=0x00;
; 0000 007B //UBRRL=0x33;
; 0000 007C 
; 0000 007D //UCSRA=0x00;
; 0000 007E //UCSRB=0x00;
; 0000 007F //UCSRC=0x00;
; 0000 0080 //UBRRH=0x00;
; 0000 0081 //UBRRL=0x00;
; 0000 0082 
; 0000 0083 // Analog Comparator initialization
; 0000 0084 // Analog Comparator: Off
; 0000 0085 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0086 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0087 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0088 
; 0000 0089 
; 0000 008A // ADC initialization
; 0000 008B // ADC Clock frequency: 1000,000 kHz
; 0000 008C // ADC Voltage Reference: AREF pin
; 0000 008D ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 008E ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 008F 
; 0000 0090 // Global enable interrupts
; 0000 0091 #asm("sei")
	sei
; 0000 0092 
; 0000 0093 while (1)
_0x35:
; 0000 0094       {
; 0000 0095 
; 0000 0096 
; 0000 0097 
; 0000 0098 if (Timer_2==200){
	LDS  R26,_Timer_2
	CPI  R26,LOW(0xC8)
	BRNE _0x38
; 0000 0099 Dig_init();
	RCALL _Dig_init
; 0000 009A if (DisOther==0){Display(MS);}
	SBRC R2,6
	RJMP _0x39
	MOV  R30,R7
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Display
; 0000 009B if (DisOther==1){Display(Other);}
_0x39:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x3A
	MOV  R30,R11
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Display
; 0000 009C 
; 0000 009D 
; 0000 009E       //PORTB|=0b11111100;
; 0000 009F 
; 0000 00A0       //adc=read_adc(0);
; 0000 00A1       //printf("%dms ",MS);
; 0000 00A2       //printf("%d#  ",adc);
; 0000 00A3 Timer_2=0;
_0x3A:
	LDI  R30,LOW(0)
	STS  _Timer_2,R30
; 0000 00A4 }
; 0000 00A5 
; 0000 00A6 }
_0x38:
	RJMP _0x35
; 0000 00A7 
; 0000 00A8 
; 0000 00A9 //
; 0000 00AA 
; 0000 00AB //
; 0000 00AC 
; 0000 00AD }
_0x3B:
	RJMP _0x3B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_Dig:
	.BYTE 0x11
_Timer_5:
	.BYTE 0x1
_TimeHW:
	.BYTE 0x1
_Timer_7:
	.BYTE 0x1
_Dis1:
	.BYTE 0x1
_Dis2:
	.BYTE 0x1
_Timer_9:
	.BYTE 0x1
_Timer_10:
	.BYTE 0x1
_Timer_3:
	.BYTE 0x1
_Timer_2:
	.BYTE 0x1
_Timer_8:
	.BYTE 0x1
_Timer_11:
	.BYTE 0x1
_Timer_4:
	.BYTE 0x1
_Timer_6:
	.BYTE 0x1
_Timer_12:
	.BYTE 0x1
_p_S1020024:
	.BYTE 0x2

	.CSEG

	.CSEG
__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
