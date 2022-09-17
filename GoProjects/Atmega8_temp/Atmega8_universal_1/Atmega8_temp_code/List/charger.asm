
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
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

	#pragma AVRPART ADMIN PART_NAME ATmega8
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
	.DEF _EEPromOut=R5
	.DEF _EEPromIn=R4
	.DEF _i=R6
	.DEF _j=R8
	.DEF _databits=R10
	.DEF _lcd_can_clear=R13
	.DEF _status_usart=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_comp_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP _timer1_compb_isr
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0xCD,0xCC,0xC7,0x42
_0x4:
	.DB  0xCD,0xCC,0xC7,0x42
_0x18:
	.DB  0x1
_0x42:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x54,0x3A,0x25,0x2E,0x31,0x66,0x0,0x20
	.DB  0x53,0x54,0x3A,0x25,0x2E,0x31,0x66,0x0
	.DB  0x20,0x74,0x69,0x6D,0x65,0x3A,0x25,0x64
	.DB  0x0,0x25,0x64,0x3A,0x0,0x6D,0x69,0x6E
	.DB  0x3A,0x25,0x2E,0x31,0x66,0x0,0x25,0x63
	.DB  0x0,0x44,0x3A,0x25,0x75,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x202005F:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _Temp
	.DW  _0x3*2

	.DW  0x04
	.DW  _Temp_min
	.DW  _0x4*2

	.DW  0x01
	.DW  _LCD_switch
	.DW  _0x18*2

	.DW  0x08
	.DW  0x06
	.DW  _0x42*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x202005F*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

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
;Date    : 26.11.2013
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
;*****************************************************/
;
;
;#include <stdio.h>
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
;#include <stdlib.h>
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 001F #endasm
;#include <lcd.h>
;
;#include <delay.h>
;#include <spi.h>
;#define ADC_VREF_TYPE 0x00
;#include <bcd.h>
;
;eeprom signed int STempEE;
;float Temp=99.9,STemp,Temp_min=99.9;

	.DSEG
;char EEPromOut,EEPromIn;
;
;#include <USART.c>
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;char lcd_buffer[32];
;char uart_data[16];
;int i=0,j=0;
;unsigned int databits=0;
;unsigned char lcd_can_clear=0,status_usart,now_set;
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 32
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;void clear_usart(){
; 0000 002B void clear_usart(){

	.CSEG
;while(i<13)
;    {
;    uart_data[i]=0;
;    i++;
;    }
;    i=0;
;}
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
;{
_usart_rx_isr:
	RCALL SUBOPT_0x0
;char status,data;
;status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
;data=UDR;
	IN   R16,12
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R26,R17
	RCALL SUBOPT_0x1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	RCALL SUBOPT_0x2
	BRNE _0x8
;   {
;   rx_buffer[rx_wr_index]=data;
	LDS  R30,_rx_wr_index
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x20)
	BRNE _0x9
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;   if (++rx_counter == RX_BUFFER_SIZE)
_0x9:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x20)
	BRNE _0xA
;      {
;      rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
;      rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      };
_0xA:
;   now_set=0;
	LDI  R30,LOW(0)
	STS  _now_set,R30
;   };
_0x8:
;  uart_data[i]=data;
	MOVW R30,R6
	SUBI R30,LOW(-_uart_data)
	SBCI R31,HIGH(-_uart_data)
	ST   Z,R16
;  status_usart=UCSRA;
	IN   R12,11
;  i++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
;  if(UCSRA==48)
	IN   R30,0xB
	CPI  R30,LOW(0x30)
	BRNE _0xB
;  {
;  //clear_uart();
;  i=0;
	CLR  R6
	CLR  R7
;  //data_recived=0;
;  PORTD&=~0b00001000;
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0xFFF7)
	OUT  0x12,R30
;  }
; ///////////////////////////////////////////////
;if ((status_usart==48)&&(now_set==0)){
_0xB:
	LDI  R30,LOW(48)
	CP   R30,R12
	BRNE _0xD
	LDS  R26,_now_set
	CPI  R26,LOW(0x0)
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;      uart_data[10]=uart_data[2] ^ uart_data[3];
	__GETB2MN _uart_data,2
	CLR  R27
	__GETB1MN _uart_data,3
	RCALL SUBOPT_0x5
	__PUTB1MN _uart_data,10
;      uart_data[11]=uart_data[4] ^ uart_data[5] ;
	__GETB2MN _uart_data,4
	CLR  R27
	__GETB1MN _uart_data,5
	RCALL SUBOPT_0x5
	__PUTB1MN _uart_data,11
;      uart_data[12]=uart_data[6] ^ uart_data[7];
	__GETB2MN _uart_data,6
	CLR  R27
	__GETB1MN _uart_data,7
	RCALL SUBOPT_0x5
	__PUTB1MN _uart_data,12
;      uart_data[13]=uart_data[12] ^ uart_data[11];
	__GETB2MN _uart_data,12
	CLR  R27
	__GETB1MN _uart_data,11
	RCALL SUBOPT_0x5
	__PUTB1MN _uart_data,13
;      databits=uart_data[13];
	__GETBRMN 10,_uart_data,13
	CLR  R11
;      databits<<=8;
	MOV  R11,R10
	CLR  R10
;      databits|=uart_data[11];
	__GETB1MN _uart_data,11
	RCALL SUBOPT_0x3
	__ORWRR 10,11,30,31
;
;   //if {
;        if (databits==43648){
	LDI  R30,LOW(43648)
	LDI  R31,HIGH(43648)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xF
;        STemp+=0.1;
	RCALL SUBOPT_0x6
	__GETD2N 0x3DCCCCCD
	RCALL __ADDF12
	RCALL SUBOPT_0x7
;        }
;        if (databits==8352){
_0xF:
	LDI  R30,LOW(8352)
	LDI  R31,HIGH(8352)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x10
;        STemp-=0.1;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x7
;        }
;        EEPromIn=1;
_0x10:
	LDI  R30,LOW(1)
	MOV  R4,R30
;        //clear_usart();
;        //STempEE=STemp*100.00;
;        now_set=1;
	STS  _now_set,R30
;
;      }
;   // }
;
;      //////////////////////////////////
;}
_0xC:
	RCALL __LOADLOCR2P
	RJMP _0x41
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter==0);
;	data -> R17
;data=rx_buffer[rx_rd_index];
;if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;#asm("cli")
;--rx_counter;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;/////////////////////////////////////
;
;
;////////////////////////////////////////
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0032 {
_read_adc:
; 0000 0033 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	RCALL SUBOPT_0xB
	OUT  0x7,R30
; 0000 0034 // Delay needed for the stabilization of the ADC input voltage
; 0000 0035 delay_us(500);
	__DELAY_USW 1000
; 0000 0036 // Start the AD conversion
; 0000 0037 ADCSRA|=0x40;
	IN   R30,0x6
	RCALL SUBOPT_0x3
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 0038 // Wait for the AD conversion to complete
; 0000 0039 while ((ADCSRA & 0x10)==0);
_0x15:
	IN   R30,0x6
	RCALL SUBOPT_0x3
	ANDI R30,LOW(0x10)
	BREQ _0x15
; 0000 003A ADCSRA|=0x10;
	IN   R30,0x6
	RCALL SUBOPT_0x3
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 003B return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2100002
; 0000 003C }
;unsigned char on[6],nowPORT[6];
;
;#include <allPWM.c>
;void allPWM(){
; 0000 003F void allPWM(){
;///////////////////////////////////////
;//PWM
;nowPORT[2] = 0b00000100;
;nowPORT[3] = 0b00001000;
;nowPORT[4] = 0b00010000;
;nowPORT[5] = 0b00100000;
;
;
;on[2]=4;
;on[3]=4;
;on[4]=4;
;on[5]=4;
;
;/*
;for (n=2;n<6;n++) {
;off[n]=on[n]+1;
;if (PWM[n]==on[n]){PORTD|=nowPORT[n];}
;if (PWM[n]==off[n]){PORTD&=~nowPORT[n] ;}
;if (PWM[n]>=PWMmax){PORTD|=nowPORT[n];PWM[n]=0;}
;PWM[n]++;
;};
;
;*/
;
;///////////////////////////////////////
;}
;#include <interrupt.c>
;//unsigned char Dig[20],DisOther,Num3,Num2,Disp6,Disp7,Timer_3;
;// Timer 0 overflow interrupt service routine
;unsigned char Timer_read_adc_1,Timer_read_adc_2,Timer_buzzer_active,Timer_buzzer_signal,Timer_buzzer_silence,Timer_buzzer_silence_1,Timer_buzzer_active_1,Timer_buzzer_active,LCD_switch=1,Timer_LCD,Time_one_sec;

	.DSEG
;unsigned int adc[6];
;
;//float Voltage2_old,Time;
;char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20];
;
;unsigned char delay_start,delay_start_timer;
;unsigned int Time_sec_all,Time,Time_sec,Time_min,Time_hour;
;
;//for IR
;unsigned char Startsomedelay,delayneed,Timer_IR,Timer_IR_Start,count1bit,devider,start_devider;
;unsigned int databits,show_data;
;#include <buzzer.c>
;void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){
; 0000 0040 void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){

	.CSEG
;if (time>0){
;	time -> Y+2
;	freq -> Y+1
;	repeat -> Y+0
;Timer_buzzer_active_1++;
;if (Timer_buzzer_active_1>250){//длинна бузера
;Timer_buzzer_active++;
;Timer_buzzer_active_1=0;
;}
;
;if(Timer_buzzer_active<time){
;    Timer_buzzer_signal++;
;    if (Timer_buzzer_signal==freq){//частота бузера
;    PORTB^=0b00001000;
;    Timer_buzzer_signal=0;
;    }
;Timer_buzzer_silence=0;
;}
;if(Timer_buzzer_active>time){
;    Timer_buzzer_silence_1++;
;    if(Timer_buzzer_silence_1>250){
;    Timer_buzzer_silence_1=0;
;    Timer_buzzer_silence++;
;    }
;    PORTB&=~0b00001000;
;        if(Timer_buzzer_silence>time){
;            if (repeat>0){
;            Timer_buzzer_active=0;
;            }
;            repeat--;
;            if (repeat==0){
;            time=0;freq=0;
;            }
;        }
;    }
;}
;}
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
;{
_timer1_compb_isr:
;// Place your code here
;
;}
	RETI
;// Timer 2 overflow interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
;{
_timer2_comp_isr:
	ST   -Y,R30
;// Place your code here
;ASSR=0x00;
	RCALL SUBOPT_0xC
;TCCR2=0x01;
;TCNT2=0x00;
;OCR2=0x22;
;
;}
	LD   R30,Y+
	RETI
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void){
_timer1_compa_isr:
	RCALL SUBOPT_0x0
;TCCR1A=0x00;
	RCALL SUBOPT_0xD
;TCCR1B=0x05;
;TCNT1H=0x00;
;TCNT1L=0x00;
;ICR1H=0x00;
;ICR1L=0x00;
;OCR1AH=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2B,R30
;OCR1AL=0x42;
	LDI  R30,LOW(66)
	RCALL SUBOPT_0xE
;OCR1BH=0x00;
;OCR1BL=0x00;
;
;PORTD^=0b00001000;
	RCALL SUBOPT_0x4
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
;
;if (Temp<STemp){
	RCALL SUBOPT_0xF
	BRSH _0x22
;PORTD|=0b00100000;
	RCALL SUBOPT_0x4
	ORI  R30,0x20
	OUT  0x12,R30
;}
;if (Temp>STemp){
_0x22:
	RCALL SUBOPT_0xF
	BREQ PC+2
	BRCC PC+2
	RJMP _0x23
;PORTD&=~0b00100000;
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0xFFDF)
	OUT  0x12,R30
;}
;
;if (EEPromIn==1){
_0x23:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x24
;STempEE=STemp*100.00;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x10
	RCALL __MULF12
	RCALL SUBOPT_0x11
	RCALL __CFD1
	RCALL __EEPROMWRW
;EEPromIn=0;
	CLR  R4
;}
;
;// Place your code here
;if (PIND.5==1){
_0x24:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x25
;Time_one_sec++;
	LDS  R30,_Time_one_sec
	SUBI R30,-LOW(1)
	STS  _Time_one_sec,R30
;    if (Time_one_sec==2){
	LDS  R26,_Time_one_sec
	CPI  R26,LOW(0x2)
	BRNE _0x26
;    Time_sec_all++;
	LDI  R26,LOW(_Time_sec_all)
	LDI  R27,HIGH(_Time_sec_all)
	RCALL SUBOPT_0x12
;    Time_one_sec=0;
	LDI  R30,LOW(0)
	STS  _Time_one_sec,R30
;    }
;}
_0x26:
;
;  //ststus lamp
;
;}
_0x25:
_0x41:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;{
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;//TCNT0=0x00;
;//#include <IR.c>
;//allPWM();
;#include <lcd.c>
;
;Timer_LCD++;
	LDS  R30,_Timer_LCD
	SUBI R30,-LOW(1)
	STS  _Timer_LCD,R30
;Timer_read_adc_1++;
	LDS  R30,_Timer_read_adc_1
	SUBI R30,-LOW(1)
	STS  _Timer_read_adc_1,R30
;if(Timer_read_adc_1==50){
	LDS  R26,_Timer_read_adc_1
	CPI  R26,LOW(0x32)
	BRNE _0x27
;Timer_read_adc_2++;
	LDS  R30,_Timer_read_adc_2
	SUBI R30,-LOW(1)
	STS  _Timer_read_adc_2,R30
;Timer_read_adc_1=0;
	LDI  R30,LOW(0)
	STS  _Timer_read_adc_1,R30
;}
;
;
;}
_0x27:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 0045 {
_main:
; 0000 0046 // Declare your local variables here
; 0000 0047 
; 0000 0048 // Input/Output Ports initialization
; 0000 0049 // Port B initialization
; 0000 004A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004C PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 004D DDRB=0b00001000;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 004E 
; 0000 004F // Port C initialization
; 0000 0050 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0051 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0052 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0053 DDRC=0b00000000;
	OUT  0x14,R30
; 0000 0054 
; 0000 0055 // Port D initialization
; 0000 0056 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0057 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0058 PORTD=0b00010100;
	LDI  R30,LOW(20)
	OUT  0x12,R30
; 0000 0059 DDRD=0b00101000;//5-реле,3-лампочка
	LDI  R30,LOW(40)
	OUT  0x11,R30
; 0000 005A 
; 0000 005B // Timer/Counter 0 initialization
; 0000 005C // Clock source: System Clock
; 0000 005D // Clock value: 8000,000 kHz
; 0000 005E TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 005F TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0060 
; 0000 0061 // Timer/Counter 1 initialization
; 0000 0062 // Clock source: System Clock
; 0000 0063 // Clock value: 7,813 kHz
; 0000 0064 // Mode: Normal top=FFFFh
; 0000 0065 // OC1A output: Discon.
; 0000 0066 // OC1B output: Discon.
; 0000 0067 // Noise Canceler: Off
; 0000 0068 // Input Capture on Falling Edge
; 0000 0069 // Timer 1 Overflow Interrupt: Off
; 0000 006A // Input Capture Interrupt: Off
; 0000 006B // Compare A Match Interrupt: On
; 0000 006C // Compare B Match Interrupt: Off
; 0000 006D TCCR1A=0x00;
	RCALL SUBOPT_0xD
; 0000 006E TCCR1B=0x05;
; 0000 006F TCNT1H=0x00;
; 0000 0070 TCNT1L=0x00;
; 0000 0071 ICR1H=0x00;
; 0000 0072 ICR1L=0x00;
; 0000 0073 OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
; 0000 0074 OCR1AL=0x85;
	LDI  R30,LOW(133)
	RCALL SUBOPT_0xE
; 0000 0075 OCR1BH=0x00;
; 0000 0076 OCR1BL=0x00;
; 0000 0077 
; 0000 0078 
; 0000 0079 // Timer/Counter 2 initialization
; 0000 007A // Clock source: System Clock
; 0000 007B // Clock value: 8000,000 kHz
; 0000 007C // Mode: Normal top=FFh
; 0000 007D // OC2 output: Disconnected
; 0000 007E ASSR=0x00;
	RCALL SUBOPT_0xC
; 0000 007F TCCR2=0x01;
; 0000 0080 TCNT2=0x00;
; 0000 0081 OCR2=0x22;
; 0000 0082 
; 0000 0083 // External Interrupt(s) initialization
; 0000 0084 // INT0: Off
; 0000 0085 // INT1: Off
; 0000 0086 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0087 
; 0000 0088 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0089 TIMSK=0x91;
	LDI  R30,LOW(145)
	OUT  0x39,R30
; 0000 008A 
; 0000 008B 
; 0000 008C 
; 0000 008D 
; 0000 008E // USART initialization
; 0000 008F // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0090 // USART Receiver: On
; 0000 0091 // USART Transmitter: Off
; 0000 0092 // USART Mode: Asynchronous
; 0000 0093 // USART Baud Rate: 1786
; 0000 0094 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0095 UCSRB=0x90;
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 0096 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0097 UBRRH=0x01;
	LDI  R30,LOW(1)
	OUT  0x20,R30
; 0000 0098 UBRRL=0x17;
	LDI  R30,LOW(23)
	OUT  0x9,R30
; 0000 0099 
; 0000 009A 
; 0000 009B // Analog Comparator initialization
; 0000 009C // Analog Comparator: Off
; 0000 009D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 009E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 009F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A0 
; 0000 00A1 SPCR=0x00;
	OUT  0xD,R30
; 0000 00A2 SPSR=0x00;
	OUT  0xE,R30
; 0000 00A3 
; 0000 00A4 // ADC initialization
; 0000 00A5 // ADC Clock frequency: 1000,000 kHz
; 0000 00A6 // ADC Voltage Reference: AREF pin
; 0000 00A7 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00A8 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00A9 
; 0000 00AA // LCD module initialization
; 0000 00AB lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00AC 
; 0000 00AD // Global enable interrupts
; 0000 00AE #asm("sei")
	sei
; 0000 00AF 
; 0000 00B0 while (1)
_0x28:
; 0000 00B1       {
; 0000 00B2       // Place your code here
; 0000 00B3       #include <while.c>
;//////////////////////////////////////////////////////////////////
;  //show_data=getchar();
;if ((STempEE!=32767)&&(EEPromOut==0)){
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	BREQ _0x2C
	LDI  R30,LOW(0)
	CP   R30,R5
	BREQ _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
;STemp = STempEE/100.00;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x10
	RCALL __DIVF21
	RCALL SUBOPT_0x7
;EEPromOut=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;}
;if ((STemp<-5.00)||(STempEE<-500)){STemp=-5.00;STempEE=-500;}
_0x2B:
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x17
	RCALL __CMPF12
	BRLO _0x2F
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0xFE0C)
	LDI  R26,HIGH(0xFE0C)
	CPC  R31,R26
	BRGE _0x2E
_0x2F:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
	LDI  R30,LOW(65036)
	LDI  R31,HIGH(65036)
	RCALL __EEPROMWRW
;if ((STemp>30.00)||(STempEE>3000)){STemp=30.00;STempEE=30000;}
_0x2E:
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x18
	RCALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x32
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0xBB9)
	LDI  R26,HIGH(0xBB9)
	CPC  R31,R26
	BRLT _0x31
_0x32:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
	LDI  R30,LOW(30000)
	LDI  R31,HIGH(30000)
	RCALL __EEPROMWRW
;
;
;
;if ((Temp<Temp_min)&&(Temp!=0.00)){
_0x31:
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL __CMPF12
	BRSH _0x35
	RCALL SUBOPT_0x1A
	RCALL __CPD02
	BRNE _0x36
_0x35:
	RJMP _0x34
_0x36:
;Temp_min=Temp;
	RCALL SUBOPT_0x1B
	STS  _Temp_min,R30
	STS  _Temp_min+1,R31
	STS  _Temp_min+2,R22
	STS  _Temp_min+3,R23
;}
;
;
;//берем параметры
;if(Timer_read_adc_2==20){
_0x34:
	LDS  R26,_Timer_read_adc_2
	CPI  R26,LOW(0x14)
	BRNE _0x37
;adc[0]=read_adc(0);//чтение температуры
	RCALL SUBOPT_0x1C
	RCALL _read_adc
	STS  _adc,R30
	STS  _adc+1,R31
;Temp=adc[0]/18.52631578947368;
	RCALL SUBOPT_0x1D
	__GETD1N 0x419435E5
	RCALL __DIVF21
	STS  _Temp,R30
	STS  _Temp+1,R31
	STS  _Temp+2,R22
	STS  _Temp+3,R23
;}if(Timer_read_adc_2==22){
_0x37:
	LDS  R26,_Timer_read_adc_2
	CPI  R26,LOW(0x16)
	BRNE _0x38
;//adc[2]=read_adc(2);//чтение установленной температуры
;Timer_read_adc_2=0;   // Выводим строку _str на дисплей ЖКИ
	LDI  R30,LOW(0)
	STS  _Timer_read_adc_2,R30
;}
;
;
;//STemp=adc[2]/42.625;
;
;
;
;
;
;
;if (Timer_LCD==250){
_0x38:
	LDS  R26,_Timer_LCD
	CPI  R26,LOW(0xFA)
	BREQ PC+2
	RJMP _0x39
;//отображение
;
;
;if (LCD_switch==1){
	LDS  R26,_LCD_switch
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x3A
;
;
;    Time_hour=Time_sec_all/60.0/60.0;
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1F
	LDI  R26,LOW(_Time_hour)
	LDI  R27,HIGH(_Time_hour)
	RCALL SUBOPT_0x20
;    Time_min=((Time_sec_all/60.0)-(Time_hour*60.0));
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_Time_min)
	LDI  R27,HIGH(_Time_min)
	RCALL SUBOPT_0x20
;    Time_sec=((Time_sec_all)-((Time_min*60.0)+(Time_hour*60.0*60.0)));
	RCALL SUBOPT_0x22
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	LDS  R26,_Time_sec_all
	LDS  R27,_Time_sec_all+1
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_Time_sec)
	LDI  R27,HIGH(_Time_sec)
	RCALL SUBOPT_0x20
;
;sprintf(Temp_str, "T:%.1f", Temp);
	RCALL SUBOPT_0x24
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x26
;sprintf(_NeedTemp," ST:%.1f",STemp);
	LDI  R30,LOW(__NeedTemp)
	LDI  R31,HIGH(__NeedTemp)
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,7
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x26
;sprintf(Time_str," time:%d",Time);
	LDI  R30,LOW(_Time_str)
	LDI  R31,HIGH(_Time_str)
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,16
	RCALL SUBOPT_0x25
	LDS  R30,_Time
	LDS  R31,_Time+1
	RCALL SUBOPT_0x27
;sprintf(_Time_hour,"%d:",Time_hour);
	LDI  R30,LOW(__Time_hour)
	LDI  R31,HIGH(__Time_hour)
	RCALL SUBOPT_0x28
	LDS  R30,_Time_hour
	LDS  R31,_Time_hour+1
	RCALL SUBOPT_0x27
;sprintf(_Time_min,"%d:",Time_min);
	LDI  R30,LOW(__Time_min)
	LDI  R31,HIGH(__Time_min)
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x27
;sprintf(_Time_sec,"%d",Time_sec);
	LDI  R30,LOW(__Time_sec)
	LDI  R31,HIGH(__Time_sec)
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,22
	RCALL SUBOPT_0x25
	LDS  R30,_Time_sec
	LDS  R31,_Time_sec+1
	RCALL SUBOPT_0x27
;sprintf(_Temp_min,"min:%.1f",Temp_min);
	LDI  R30,LOW(__Temp_min)
	LDI  R31,HIGH(__Temp_min)
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,29
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x26
;
;lcd_clear();
	RCALL _lcd_clear
;lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1C
	RCALL _lcd_gotoxy
;lcd_puts(Temp_str);
	RCALL SUBOPT_0x24
	RCALL _lcd_puts
;lcd_puts(_NeedTemp);
	LDI  R30,LOW(__NeedTemp)
	LDI  R31,HIGH(__NeedTemp)
	RCALL SUBOPT_0x29
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;lcd_puts(_Time_hour);
	LDI  R30,LOW(__Time_hour)
	LDI  R31,HIGH(__Time_hour)
	RCALL SUBOPT_0x29
;lcd_puts(_Time_min);
	LDI  R30,LOW(__Time_min)
	LDI  R31,HIGH(__Time_min)
	RCALL SUBOPT_0x29
;lcd_puts(_Time_sec);
	LDI  R30,LOW(__Time_sec)
	LDI  R31,HIGH(__Time_sec)
	RCALL SUBOPT_0x29
;lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;lcd_puts(_Temp_min);
	LDI  R30,LOW(__Temp_min)
	LDI  R31,HIGH(__Temp_min)
	RCALL SUBOPT_0x29
;
;}
;/////////////////////////////////////////////////////////////////////
;if (LCD_switch==2){
_0x3A:
	LDS  R26,_LCD_switch
	CPI  R26,LOW(0x2)
	BRNE _0x3B
;
;
;
;      while(j<12)
_0x3C:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x3E
;      {
;      lcd_gotoxy(j,0);
	ST   -Y,R8
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x2A
;      sprintf(lcd_buffer,"%c",uart_data[j]);
	__POINTW1FN _0x0,38
	RCALL SUBOPT_0x25
	LDI  R26,LOW(_uart_data)
	LDI  R27,HIGH(_uart_data)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x26
;      lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	RCALL SUBOPT_0x29
;      j++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;      }
	RJMP _0x3C
_0x3E:
;      j=0;
	CLR  R8
	CLR  R9
;
;      };
_0x3B:
;//////////////////////////////////////////////////////////////////////////////
;if (LCD_switch==3){
	LDS  R26,_LCD_switch
	CPI  R26,LOW(0x3)
	BRNE _0x3F
;       // uart_data[2]=120;
;       // uart_data[3]=150;
;
;      lcd_clear();
	RCALL _lcd_clear
;      lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x2A
;      sprintf(lcd_buffer,"D:%u",databits);
	__POINTW1FN _0x0,41
	RCALL SUBOPT_0x25
	MOVW R30,R10
	RCALL SUBOPT_0x27
;      lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	RCALL SUBOPT_0x29
;      databits=0;
	CLR  R10
	CLR  R11
;}
;//////////////////////////////////////////////////////////////////////////////
;//}
;Timer_LCD=0;
_0x3F:
	LDI  R30,LOW(0)
	STS  _Timer_LCD,R30
;}
; 0000 00B4 
; 0000 00B5       };
_0x39:
	RJMP _0x28
; 0000 00B6 }
_0x40:
	RJMP _0x40
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
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	RJMP _0x2100002
__put_G100:
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2000012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x12
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2000013:
	RJMP _0x2000014
_0x2000010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2000014:
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
__ftoe_G100:
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x25
	__POINTW1FN _0x2000000,0
	RCALL SUBOPT_0x2C
	RJMP _0x2100005
_0x2000018:
	RCALL SUBOPT_0x14
	BRNE _0x2000017
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x25
	__POINTW1FN _0x2000000,1
	RCALL SUBOPT_0x2C
	RJMP _0x2100005
_0x2000017:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001A
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001A:
	LDD  R17,Y+11
_0x200001B:
	RCALL SUBOPT_0x2E
	BREQ _0x200001D
	RCALL SUBOPT_0x2F
	RJMP _0x200001B
_0x200001D:
	RCALL SUBOPT_0x30
	RCALL __CPD10
	BRNE _0x200001E
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x2F
	RJMP _0x200001F
_0x200001E:
	LDD  R19,Y+11
	RCALL SUBOPT_0x31
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000020
	RCALL SUBOPT_0x2F
_0x2000021:
	RCALL SUBOPT_0x31
	BRLO _0x2000023
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RJMP _0x2000021
_0x2000023:
	RJMP _0x2000024
_0x2000020:
_0x2000025:
	RCALL SUBOPT_0x31
	BRSH _0x2000027
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	SUBI R19,LOW(1)
	RJMP _0x2000025
_0x2000027:
	RCALL SUBOPT_0x2F
_0x2000024:
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x31
	BRLO _0x2000028
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
_0x2000028:
_0x200001F:
	LDI  R17,LOW(0)
_0x2000029:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002B
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x9
	RCALL __MULF12
	RCALL SUBOPT_0x36
	RCALL __PUTPARD1
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x32
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	ADIW R30,48
	ST   X,R30
	MOV  R30,R16
	RCALL __CBD1
	RCALL __CDF1
	RCALL SUBOPT_0x37
	RCALL __MULF12
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x35
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000029
	RCALL SUBOPT_0x38
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000029
_0x200002B:
	RCALL SUBOPT_0x3A
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002D
	RCALL SUBOPT_0x38
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x200002D:
	CPI  R19,10
	BRLT _0x200002E
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
	RCALL __DIVW21
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
_0x200002E:
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
	RCALL __MODW21
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100005:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,15
	RCALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 84
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x200002F:
	MOVW R26,R28
	SUBI R26,LOW(-(90))
	SBCI R27,HIGH(-(90))
	RCALL SUBOPT_0x12
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000031
	MOV  R30,R17
	RCALL SUBOPT_0x3
	SBIW R30,0
	BRNE _0x2000035
	CPI  R18,37
	BRNE _0x2000036
	LDI  R17,LOW(1)
	RJMP _0x2000037
_0x2000036:
	RCALL SUBOPT_0x3C
_0x2000037:
	RJMP _0x2000034
_0x2000035:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000038
	CPI  R18,37
	BRNE _0x2000039
	RCALL SUBOPT_0x3C
	RJMP _0x2000101
_0x2000039:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+19,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003A
	LDI  R16,LOW(1)
	RJMP _0x2000034
_0x200003A:
	CPI  R18,43
	BRNE _0x200003B
	LDI  R30,LOW(43)
	STD  Y+19,R30
	RJMP _0x2000034
_0x200003B:
	CPI  R18,32
	BRNE _0x200003C
	LDI  R30,LOW(32)
	STD  Y+19,R30
	RJMP _0x2000034
_0x200003C:
	RJMP _0x200003D
_0x2000038:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x200003E
_0x200003D:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200003F
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	RJMP _0x2000034
_0x200003F:
	RJMP _0x2000040
_0x200003E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2000041
_0x2000040:
	CPI  R18,48
	BRLO _0x2000043
	CPI  R18,58
	BRLO _0x2000044
_0x2000043:
	RJMP _0x2000042
_0x2000044:
	MOV  R26,R21
	RCALL SUBOPT_0x40
	MOV  R21,R30
	MOV  R22,R21
	RCALL SUBOPT_0x41
	MOV  R21,R30
	RJMP _0x2000034
_0x2000042:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000045
	LDI  R17,LOW(4)
	RJMP _0x2000034
_0x2000045:
	RJMP _0x2000046
_0x2000041:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2000048
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0x3F
	MOV  R26,R20
	RCALL SUBOPT_0x40
	MOV  R20,R30
	MOV  R22,R20
	RCALL SUBOPT_0x41
	MOV  R20,R30
	RJMP _0x2000034
_0x2000049:
_0x2000046:
	CPI  R18,108
	BRNE _0x200004C
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x3F
	LDI  R17,LOW(5)
	RJMP _0x2000034
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2000034
_0x200004D:
	RCALL SUBOPT_0x43
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x2000052
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x44
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x46
	RJMP _0x2000053
_0x2000052:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BREQ _0x2000056
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x2000059
_0x2000058:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	RCALL __GETD1P
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	LDD  R26,Y+9
	TST  R26
	BRMI _0x200005A
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x200005C
	RJMP _0x200005D
_0x200005A:
	RCALL SUBOPT_0x4B
	RCALL __ANEGF1
	RCALL SUBOPT_0x49
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x200005C:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2
	BREQ _0x200005E
	LDD  R30,Y+19
	ST   -Y,R30
	RCALL SUBOPT_0x46
	RJMP _0x200005F
_0x200005E:
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4D
	LDD  R26,Y+19
	STD  Z+0,R26
_0x200005F:
_0x200005D:
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0x2
	BRNE _0x2000060
	LDI  R20,LOW(6)
_0x2000060:
	CPI  R18,102
	BRNE _0x2000061
	RCALL SUBOPT_0x4B
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x25
	RCALL _ftoa
	RJMP _0x2000062
_0x2000061:
	RCALL SUBOPT_0x4B
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RCALL SUBOPT_0x25
	RCALL __ftoe_G100
_0x2000062:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x4E
	RJMP _0x2000063
_0x2000059:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2000065
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x4E
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2000068
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x25
	RCALL _strlenf
	MOV  R17,R30
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x3F
_0x2000066:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x50
	CPI  R20,0
	BREQ _0x200006A
	CP   R20,R17
	BRLO _0x200006B
_0x200006A:
	RJMP _0x2000069
_0x200006B:
	MOV  R17,R20
_0x2000069:
_0x2000063:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R19,LOW(0)
	RJMP _0x200006C
_0x2000068:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x200006F
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2000070
_0x200006F:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x3F
	RJMP _0x2000071
_0x2000070:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x2000072
_0x2000071:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x2
	BREQ _0x2000073
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x35
	LDI  R17,LOW(10)
	RJMP _0x2000074
_0x2000073:
	__GETD1N 0x2710
	RCALL SUBOPT_0x35
	LDI  R17,LOW(5)
	RJMP _0x2000074
_0x2000072:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x2000076
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x3F
	RJMP _0x2000077
_0x2000076:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x20000B5
_0x2000077:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x2
	BREQ _0x2000079
	__GETD1N 0x10000000
	RCALL SUBOPT_0x35
	LDI  R17,LOW(8)
	RJMP _0x2000074
_0x2000079:
	__GETD1N 0x1000
	RCALL SUBOPT_0x35
	LDI  R17,LOW(4)
_0x2000074:
	CPI  R20,0
	BREQ _0x200007A
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x50
	RJMP _0x200007B
_0x200007A:
	LDI  R20,LOW(1)
_0x200007B:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x2
	BREQ _0x200007C
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2000102
_0x200007C:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x52
	BREQ _0x200007E
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	ADIW R26,4
	RCALL __GETW1P
	RCALL __CWD1
	RJMP _0x2000102
_0x200007E:
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	ADIW R26,4
	RCALL __GETW1P
	CLR  R22
	CLR  R23
_0x2000102:
	__PUTD1S 6
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x52
	BREQ _0x2000080
	LDD  R26,Y+9
	TST  R26
	BRPL _0x2000081
	RCALL SUBOPT_0x4B
	RCALL __ANEGD1
	RCALL SUBOPT_0x49
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x2000081:
	LDD  R30,Y+19
	CPI  R30,0
	BREQ _0x2000082
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000083
_0x2000082:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x53
_0x2000083:
_0x2000080:
	MOV  R19,R20
_0x200006C:
	RCALL SUBOPT_0x39
	ANDI R30,LOW(0x1)
	BRNE _0x2000084
_0x2000085:
	CP   R17,R21
	BRSH _0x2000088
	CP   R19,R21
	BRLO _0x2000089
_0x2000088:
	RJMP _0x2000087
_0x2000089:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2
	BREQ _0x200008A
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x52
	BREQ _0x200008B
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x53
	LDD  R18,Y+19
	SUBI R17,LOW(1)
	RJMP _0x200008C
_0x200008B:
	LDI  R18,LOW(48)
_0x200008C:
	RJMP _0x200008D
_0x200008A:
	LDI  R18,LOW(32)
_0x200008D:
	RCALL SUBOPT_0x3C
	SUBI R21,LOW(1)
	RJMP _0x2000085
_0x2000087:
_0x2000084:
_0x200008E:
	CP   R17,R20
	BRSH _0x2000090
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x52
	BREQ _0x2000091
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	BREQ _0x2000092
	SUBI R21,LOW(1)
_0x2000092:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000091:
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R20,LOW(1)
	RJMP _0x200008E
_0x2000090:
	MOV  R19,R17
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x2000094
_0x2000095:
	CPI  R19,0
	BREQ _0x2000097
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x2
	BREQ _0x2000098
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4D
	LPM  R30,Z
	RJMP _0x2000103
_0x2000098:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x2000103:
	ST   -Y,R30
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x200009A
	SUBI R21,LOW(1)
_0x200009A:
	SUBI R19,LOW(1)
	RJMP _0x2000095
_0x2000097:
	RJMP _0x200009B
_0x2000094:
_0x200009D:
	RCALL SUBOPT_0x56
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x200009F
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x2
	BREQ _0x20000A0
	RCALL SUBOPT_0x43
	ADIW R30,55
	RJMP _0x2000104
_0x20000A0:
	RCALL SUBOPT_0x43
	SUBI R30,LOW(-87)
	SBCI R31,HIGH(-87)
_0x2000104:
	MOV  R18,R30
	RJMP _0x20000A2
_0x200009F:
	RCALL SUBOPT_0x43
	ADIW R30,48
	MOV  R18,R30
_0x20000A2:
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x2
	BRNE _0x20000A4
	CPI  R18,49
	BRSH _0x20000A6
	RCALL SUBOPT_0x32
	__CPD2N 0x1
	BRNE _0x20000A5
_0x20000A6:
	RJMP _0x20000A8
_0x20000A5:
	CP   R20,R19
	BRSH _0x2000105
	CP   R21,R19
	BRLO _0x20000AB
	RCALL SUBOPT_0x39
	ANDI R30,LOW(0x1)
	BREQ _0x20000AC
_0x20000AB:
	RJMP _0x20000AA
_0x20000AC:
	LDI  R18,LOW(32)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2
	BREQ _0x20000AD
_0x2000105:
	LDI  R18,LOW(48)
_0x20000A8:
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x52
	BREQ _0x20000AE
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	BREQ _0x20000AF
	SUBI R21,LOW(1)
_0x20000AF:
_0x20000AE:
_0x20000AD:
_0x20000A4:
	RCALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AA:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x56
	RCALL __MODD21U
	RCALL SUBOPT_0x49
	LDD  R30,Y+18
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x32
	RCALL __CWD1
	RCALL __DIVD21U
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x30
	RCALL __CPD10
	BREQ _0x200009E
	RJMP _0x200009D
_0x200009E:
_0x200009B:
	RCALL SUBOPT_0x39
	ANDI R30,LOW(0x1)
	BREQ _0x20000B1
_0x20000B2:
	CPI  R21,0
	BREQ _0x20000B4
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x46
	RJMP _0x20000B2
_0x20000B4:
_0x20000B1:
_0x20000B5:
_0x2000053:
_0x2000101:
	LDI  R17,LOW(0)
_0x2000034:
	RJMP _0x200002F
_0x2000031:
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,29
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	RCALL __SAVELOCR2
	MOVW R26,R28
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	RCALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x25
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x25
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x25
	RCALL __print_G100
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL __LOADLOCR2
	ADIW R28,4
	POP  R15
	RET

	.CSEG
_ftoa:
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x25
	__POINTW1FN _0x2020000,0
	RCALL SUBOPT_0x2C
	RJMP _0x2100004
_0x202000D:
	RCALL SUBOPT_0x14
	BRNE _0x202000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x25
	__POINTW1FN _0x2020000,1
	RCALL SUBOPT_0x2C
	RJMP _0x2100004
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	RCALL SUBOPT_0x57
	RCALL __ANEGF1
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x59
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	RCALL SUBOPT_0x2E
	BREQ _0x2020013
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x9
	RCALL __MULF12
	RCALL SUBOPT_0x5B
	RJMP _0x2020011
_0x2020013:
	RCALL SUBOPT_0x5C
	RCALL __ADDF12
	RCALL SUBOPT_0x58
	LDI  R17,LOW(0)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5B
_0x2020014:
	RCALL SUBOPT_0x5C
	RCALL __CMPF12
	BRLO _0x2020016
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x5B
	SUBI R17,-LOW(1)
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020017
	RCALL SUBOPT_0x59
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020018
_0x2020017:
_0x2020019:
	RCALL SUBOPT_0x2E
	BREQ _0x202001B
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x9
	RCALL __MULF12
	RCALL SUBOPT_0x36
	RCALL __PUTPARD1
	RCALL _floor
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5C
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x39
	ADIW R30,48
	ST   X,R30
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x15
	RCALL __MULF12
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x58
	RJMP _0x2020019
_0x202001B:
_0x2020018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100003
	RCALL SUBOPT_0x59
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x202001F
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x57
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x39
	ADIW R30,48
	ST   X,R30
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x58
	RJMP _0x202001D
_0x202001F:
_0x2100003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100004:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G102:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G102:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G102
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2100002
__lcd_read_nibble_G102:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
    andi  r30,0xf0
	RET
_lcd_read_byte0_G102:
	RCALL __lcd_delay_G102
	RCALL __lcd_read_nibble_G102
    mov   r26,r30
	RCALL __lcd_read_nibble_G102
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	RCALL SUBOPT_0xB
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	RCALL SUBOPT_0x3
	MOVW R26,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x5F
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x5F
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x5F
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x5F
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x2040004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	RCALL SUBOPT_0x1C
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2040004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	RJMP _0x2100002
_lcd_puts:
	ST   -Y,R17
_0x2040005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040005
_0x2040007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G102:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G102:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2100002
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	RCALL SUBOPT_0xB
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G102,2
	RCALL SUBOPT_0xB
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G102,3
	RCALL __long_delay_G102
	RCALL SUBOPT_0x55
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	RCALL SUBOPT_0x55
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	RCALL SUBOPT_0x55
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x5F
	RCALL __long_delay_G102
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x5F
	RCALL __long_delay_G102
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x5F
	RCALL __long_delay_G102
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G102
	CPI  R30,LOW(0x5)
	BREQ _0x204000B
	LDI  R30,LOW(0)
	RJMP _0x2100002
_0x204000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x5F
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x2100002:
	ADIW R28,1
	RET
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

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL SUBOPT_0x60
	RCALL __PUTPARD1
	RCALL _ftrunc
	__PUTD1S 0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x60
	RJMP _0x2100001
__floor1:
    brtc __floor0
	__GETD2S 0
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0xA
_0x2100001:
	ADIW R28,4
	RET

	.ESEG
_STempEE:
	.BYTE 0x2

	.DSEG
_Temp:
	.BYTE 0x4
_STemp:
	.BYTE 0x4
_Temp_min:
	.BYTE 0x4
_lcd_buffer:
	.BYTE 0x20
_uart_data:
	.BYTE 0x10
_now_set:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0x20
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_on:
	.BYTE 0x6
_nowPORT:
	.BYTE 0x6
_Timer_read_adc_1:
	.BYTE 0x1
_Timer_read_adc_2:
	.BYTE 0x1
_Timer_buzzer_active:
	.BYTE 0x1
_Timer_buzzer_signal:
	.BYTE 0x1
_Timer_buzzer_silence:
	.BYTE 0x1
_Timer_buzzer_silence_1:
	.BYTE 0x1
_Timer_buzzer_active_1:
	.BYTE 0x1
_LCD_switch:
	.BYTE 0x1
_Timer_LCD:
	.BYTE 0x1
_Time_one_sec:
	.BYTE 0x1
_adc:
	.BYTE 0xC
_Temp_str:
	.BYTE 0x14
_Time_str:
	.BYTE 0x14
__NeedTemp:
	.BYTE 0x14
__Time_sec:
	.BYTE 0x14
__Time_min:
	.BYTE 0x14
__Time_hour:
	.BYTE 0x14
__Temp_min:
	.BYTE 0x14
_Time_sec_all:
	.BYTE 0x2
_Time:
	.BYTE 0x2
_Time_sec:
	.BYTE 0x2
_Time_min:
	.BYTE 0x2
_Time_hour:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1060024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:64 WORDS
SUBOPT_0x1:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x2:
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	IN   R30,0x12
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x3
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
	LDS  R30,_STemp
	LDS  R31,_STemp+1
	LDS  R22,_STemp+2
	LDS  R23,_STemp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x7:
	STS  _STemp,R30
	STS  _STemp+1,R31
	STS  _STemp+2,R22
	STS  _STemp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x8:
	LDS  R26,_STemp
	LDS  R27,_STemp+1
	LDS  R24,_STemp+2
	LDS  R25,_STemp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LD   R30,Y
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	OUT  0x22,R30
	LDI  R30,LOW(1)
	OUT  0x25,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	LDI  R30,LOW(34)
	OUT  0x23,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(5)
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
	OUT  0x26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x6
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	LDS  R24,_Temp+2
	LDS  R25,_Temp+3
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__GETD1N 0x42C80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_STempEE)
	LDI  R27,HIGH(_STempEE)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD1N 0xC0A00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETD1N 0x41F00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDS  R30,_Temp_min
	LDS  R31,_Temp_min+1
	LDS  R22,_Temp_min+2
	LDS  R23,_Temp_min+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	LDS  R24,_Temp+2
	LDS  R25,_Temp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDS  R30,_Temp
	LDS  R31,_Temp+1
	LDS  R22,_Temp+2
	LDS  R23,_Temp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDS  R30,_Time_sec_all
	LDS  R31,_Time_sec_all+1
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	__GETD1N 0x42700000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	RCALL __CFD1U
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LDS  R30,_Time_hour
	LDS  R31,_Time_hour+1
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x42700000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDS  R30,_Time_min
	LDS  R31,_Time_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	__GETD2N 0x42700000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(_Temp_str)
	LDI  R31,HIGH(_Temp_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 62 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x26:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,25
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0x25
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x25
	RJMP _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x2F:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x30:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x31:
	__GETD1S 4
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x32:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x9
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x35:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x38:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	MOV  R30,R16
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x2D
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	MOVW R22,R30
	MOV  R26,R19
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3C:
	ST   -Y,R18
	__GETW1SX 87
	RCALL SUBOPT_0x25
	MOVW R30,R28
	ADIW R30,19
	RCALL SUBOPT_0x25
	RJMP __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x3D:
	MOV  R26,R16
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	OR   R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x41:
	CLR  R23
	MOV  R26,R18
	RCALL SUBOPT_0x1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOV  R30,R18
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x44:
	__GETW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x45:
	SBIW R30,4
	__PUTW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x46:
	__GETW1SX 87
	RCALL SUBOPT_0x25
	MOVW R30,R28
	ADIW R30,19
	RCALL SUBOPT_0x25
	RJMP __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x48:
	__GETW2SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x44
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x25
	RCALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x48
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(65407)
	LDI  R31,HIGH(65407)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x52:
	RCALL SUBOPT_0x51
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x54:
	LDD  R30,Y+19
	ST   -Y,R30
	__GETW1SX 87
	RCALL SUBOPT_0x25
	MOVW R30,R28
	SUBI R30,LOW(-(87))
	SBCI R31,HIGH(-(87))
	RCALL SUBOPT_0x25
	RCALL __put_G100
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x30
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x58:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x59:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5E:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__GETD1S 0
	RET


	.CSEG
__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
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
