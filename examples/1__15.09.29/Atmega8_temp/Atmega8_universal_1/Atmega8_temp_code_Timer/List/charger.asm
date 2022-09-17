
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
	.DEF _Timer_read_adc_1=R5
	.DEF _Timer_read_adc_2=R4
	.DEF _Timer_buzzer_active=R7
	.DEF _Timer_buzzer_signal=R6
	.DEF _Timer_buzzer_silence=R9
	.DEF _Timer_buzzer_silence_1=R8
	.DEF _Timer_buzzer_active_1=R11
	.DEF _LCD_switch=R10
	.DEF _Timer_LCD=R13
	.DEF _Time_one_sec=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP _timer1_compb_isr
	RJMP _timer1_ovf_isr
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

_0x6:
	.DB  0xCD,0xCC,0xC7,0x42
_0x7:
	.DB  0xCD,0xCC,0xC7,0x42
_0x2F:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _Temp
	.DW  _0x6*2

	.DW  0x04
	.DW  _Temp_min
	.DW  _0x7*2

	.DW  0x01
	.DW  0x0A
	.DW  _0x2F*2

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
;//#include <stdio.h>
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
;//#include <stdlib.h>
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 001F #endasm
;//#include <lcd.h>
;
;#include <delay.h>
;#include <spi.h>
;#define ADC_VREF_TYPE 0x00
;#include <bcd.h>
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
; 0000 002A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(200);
; 0000 002D // Start the AD conversion
; 0000 002E ADCSRA|=0x40;
; 0000 002F // Wait for the AD conversion to complete
; 0000 0030 while ((ADCSRA & 0x10)==0);
; 0000 0031 ADCSRA|=0x10;
; 0000 0032 return ADCW;
; 0000 0033 }
;unsigned char on[6],nowPORT[6];
;
;#include <allPWM.c>
;void allPWM(){
; 0000 0036 void allPWM(){
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
;unsigned int adc[6];
;
;float Temp=99.9,STemp,Temp_min=99.9;

	.DSEG
;//float Voltage2_old,Time;
;char Temp_str[20],Time_str[20],_NeedTemp[20],_Time_sec[20],_Time_min[20],_Time_hour[20],_Temp_min[20],_show_data[20];
;
;//unsigned char now_is_charge,now_is_discharge;
;unsigned int Time_sec_all,Time,Time_sec,Time_min,Time_hour;
;
;//for IR
;unsigned char Startsomedelay,delayneed,Timer_IR,Timer_IR_Start,count1bit,devider,start_devider;
;unsigned int databits,show_data;
;#include <buzzer.c>
;void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){
; 0000 0037 void buzzer(unsigned char time,unsigned char freq,unsigned char repeat){

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
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
;
;
;
;
;// Place your code here
;if (PIND.5==1){
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x11
;Time_one_sec++;
	INC  R12
;    if (Time_one_sec==2){
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x12
;    Time_sec_all++;
	LDI  R26,LOW(_Time_sec_all)
	LDI  R27,HIGH(_Time_sec_all)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
;    Time_one_sec=0;
	CLR  R12
;    }
;}
_0x12:
;//
;}
_0x11:
	RJMP _0x2E
;interrupt [TIM1_COMPA] void timer1_compa_isr(void){
_timer1_compa_isr:
	RCALL SUBOPT_0x0
;//  TCNT1H=0;
;//  TCNT1L=0;
;
;//TCNT1H=0xE1;
;//TCNT1L=0x7A;
;
;TCNT1H=0xFF-0x1E;  //65536-32768 таймер начинает счет с половины. т.е. делит все пополам
	LDI  R30,LOW(225)
	OUT  0x2D,R30
;TCNT1L=0xFF-0x83;
	LDI  R30,LOW(124)
	OUT  0x2C,R30
;OCR1AH=0x1E;  //7813    когда таймер достчитает до до этой цифры, будет 1 сек
	LDI  R30,LOW(30)
	OUT  0x2B,R30
;OCR1AL=0x83;
	LDI  R30,LOW(131)
	OUT  0x2A,R30
;
;PORTD^=0b00001000;
	RCALL SUBOPT_0x1
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
;
;  //ststus lamp
;
;}
_0x2E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;{
_timer0_ovf_isr:
	ST   -Y,R0
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
;PORTD^=0b01000000;
	RCALL SUBOPT_0x1
	LDI  R26,LOW(64)
	LDI  R27,HIGH(64)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
;TCNT0=0x22;
	LDI  R30,LOW(34)
	OUT  0x32,R30
;#include <IR.c>
;//IR Driver
;
;if ((PIND.7==0)&&(Startsomedelay==0)){
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x14
	LDS  R26,_Startsomedelay
	CPI  R26,LOW(0x0)
	BREQ _0x15
_0x14:
	RJMP _0x13
_0x15:
;Timer_IR_Start=1;
	LDI  R30,LOW(1)
	STS  _Timer_IR_Start,R30
;//delay_start=1;
;//databits=0;
;count1bit=0;
	LDI  R30,LOW(0)
	STS  _count1bit,R30
;//start_devider=1;
;}
;//if(delay_start==1){
;//delay_start_timer++;
;   // if (delay_start_timer==1){
;   // delay_start_timer=0;
;   // delay_start=0;
;   // }
;//}
;
;
;if ((Timer_IR_Start==1)&&(Startsomedelay==0)){
_0x13:
	LDS  R26,_Timer_IR_Start
	CPI  R26,LOW(0x1)
	BRNE _0x17
	LDS  R26,_Startsomedelay
	CPI  R26,LOW(0x0)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
;if (Timer_IR==0){databits=0;}
	LDS  R30,_Timer_IR
	CPI  R30,0
	BRNE _0x19
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x2
;Timer_IR++;
_0x19:
	LDS  R30,_Timer_IR
	SUBI R30,-LOW(1)
	STS  _Timer_IR,R30
;    if (PIND.7==0){
	SBIC 0x10,7
	RJMP _0x1A
;    databits=databits<<1; //сдвигаем переменную для битов
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
;    //bincode*=bincode*+"1";
;    databits|=1;//добавляем в конец строки положительный бит
	ORI  R30,1
	RJMP _0x2D
;    }else{
_0x1A:
;    //if (PIND.7==1){
;    databits=databits<<1; //сдвигаем переменную для битов
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
;    databits&=~1;//добавляем в конец строки положительный бит
	ANDI R30,LOW(0xFFFE)
_0x2D:
	STS  _databits,R30
	STS  _databits+1,R31
;    }
;    if (Timer_IR==16){
	LDS  R26,_Timer_IR
	CPI  R26,LOW(0x10)
	BRNE _0x1C
;    Timer_IR_Start=0;
	LDI  R30,LOW(0)
	STS  _Timer_IR_Start,R30
;    Timer_IR=0;
	STS  _Timer_IR,R30
;    Startsomedelay=1;
	LDI  R30,LOW(1)
	STS  _Startsomedelay,R30
;    if(databits!=0){
	RCALL SUBOPT_0x3
	SBIW R30,0
	BREQ _0x1D
;    show_data=databits;
	RCALL SUBOPT_0x3
	STS  _show_data,R30
	STS  _show_data+1,R31
;    }
;    //databits=0;
;    }
_0x1D:
;
;devider=0;
_0x1C:
	LDI  R30,LOW(0)
	STS  _devider,R30
;}
;
;/*
;if ((PIND.7==1)&&(Timer_IR_Start==1)){
;count1bit++;
;    if (count1bit==10){
;    Timer_IR_Start=0;
;    Timer_IR=0;
;    Startsomedelay=1;
;    //show_data=databits;
;    count1bit=0;
;    }
;}
;*/
;if (Startsomedelay==1){
_0x16:
	LDS  R26,_Startsomedelay
	CPI  R26,LOW(0x1)
	BRNE _0x1E
;PORTD|=0b00001000;
	RCALL SUBOPT_0x1
	ORI  R30,8
	OUT  0x12,R30
;delayneed++;
	LDS  R30,_delayneed
	SUBI R30,-LOW(1)
	STS  _delayneed,R30
;    if (delayneed==255){
	LDS  R26,_delayneed
	CPI  R26,LOW(0xFF)
	BRNE _0x1F
;    PORTD&=~0b00001000;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xFFF7)
	OUT  0x12,R30
;    Timer_IR=0;
	LDI  R30,LOW(0)
	STS  _Timer_IR,R30
;    delayneed=Startsomedelay=0;
	STS  _Startsomedelay,R30
	STS  _delayneed,R30
;    //databits=0;
;    }
;}
_0x1F:
;//show_data=91;
;
;
;
;/*
;if(PIND.7==0){
;databits++;
;}
;if(PIND.7==1){
;
;if (databits!=0){
;show_data=databits;}
;databits=0;
;}
;*/
;//allPWM();
;
;
;
;
;
;
;
;
;
;Timer_LCD++;
_0x1E:
	INC  R13
;Timer_read_adc_1++;
	INC  R5
;if(Timer_read_adc_1==50){
	LDI  R30,LOW(50)
	CP   R30,R5
	BRNE _0x20
;Timer_read_adc_2++;
	INC  R4
;Timer_read_adc_1=0;
	CLR  R5
;}
;
;
;if (Temp<STemp){
_0x20:
	RCALL SUBOPT_0x5
	BRSH _0x21
;PORTD|=0b00100000;
	RCALL SUBOPT_0x1
	ORI  R30,0x20
	OUT  0x12,R30
;}
;if (Temp>STemp){
_0x21:
	RCALL SUBOPT_0x5
	BREQ PC+2
	BRCC PC+2
	RJMP _0x22
;PORTD&=~0b00100000;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xFFDF)
	OUT  0x12,R30
;}
;if ((Temp<Temp_min)&&(Temp!=0.00)){
_0x22:
	LDS  R30,_Temp_min
	LDS  R31,_Temp_min+1
	LDS  R22,_Temp_min+2
	LDS  R23,_Temp_min+3
	RCALL SUBOPT_0x6
	RCALL __CMPF12
	BRSH _0x24
	RCALL SUBOPT_0x6
	RCALL __CPD02
	BRNE _0x25
_0x24:
	RJMP _0x23
_0x25:
;Temp_min=Temp;
	LDS  R30,_Temp
	LDS  R31,_Temp+1
	LDS  R22,_Temp+2
	LDS  R23,_Temp+3
	STS  _Temp_min,R30
	STS  _Temp_min+1,R31
	STS  _Temp_min+2,R22
	STS  _Temp_min+3,R23
;}
;
;
;if (Timer_LCD==250){
_0x23:
	LDI  R30,LOW(250)
	CP   R30,R13
	BRNE _0x26
;//отображение
;
;
;if (LCD_switch==0){
;
;
;
;
;//lcd_puts(Time_str);
;}
;/////////////////////////////////////////////////////////////////////
;if (LCD_switch==1){
;
;
;
;}
;Timer_LCD=0;
	CLR  R13
;}
;}
_0x26:
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
	LD   R0,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 003C {
_main:
; 0000 003D // Declare your local variables here
; 0000 003E 
; 0000 003F // Input/Output Ports initialization
; 0000 0040 // Port B initialization
; 0000 0041 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0042 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0043 PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0044 DDRB=0b00001000;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 0045 
; 0000 0046 // Port C initialization
; 0000 0047 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0048 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0049 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 004A DDRC=0b00000000;
	OUT  0x14,R30
; 0000 004B 
; 0000 004C // Port D initialization
; 0000 004D // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004E // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004F PORTD=0b00011100;
	LDI  R30,LOW(28)
	OUT  0x12,R30
; 0000 0050 DDRD=0b01101000;
	LDI  R30,LOW(104)
	OUT  0x11,R30
; 0000 0051 
; 0000 0052 // Timer/Counter 0 initialization
; 0000 0053 // Clock source: System Clock
; 0000 0054 // Clock value: 8000,000 kHz
; 0000 0055 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0056 TCNT0=0x22;
	LDI  R30,LOW(34)
	OUT  0x32,R30
; 0000 0057 //TCNT0=0x00;
; 0000 0058 
; 0000 0059 // Timer/Counter 1 initialization
; 0000 005A // Clock source: System Clock
; 0000 005B // Clock value: Timer 1 Stopped
; 0000 005C // Mode: Normal top=FFFFh
; 0000 005D // OC1A output: Discon.
; 0000 005E // OC1B output: Discon.
; 0000 005F // Noise Canceler: Off
; 0000 0060 // Input Capture on Falling Edge
; 0000 0061 // Timer 1 Overflow Interrupt: Off
; 0000 0062 // Input Capture Interrupt: Off
; 0000 0063 // Compare A Match Interrupt: Off
; 0000 0064 // Compare B Match Interrupt: Off
; 0000 0065 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0066 TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0067 TCNT1H=0xE1;
	LDI  R30,LOW(225)
	OUT  0x2D,R30
; 0000 0068 TCNT1L=0x7A;
	LDI  R30,LOW(122)
	OUT  0x2C,R30
; 0000 0069 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 006A ICR1L=0x00;
	OUT  0x26,R30
; 0000 006B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 006C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 006D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 006E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 006F 
; 0000 0070 
; 0000 0071 // Timer/Counter 2 initialization
; 0000 0072 // Clock source: System Clock
; 0000 0073 // Clock value: Timer 2 Stopped
; 0000 0074 // Mode: Normal top=FFh
; 0000 0075 // OC2 output: Disconnected
; 0000 0076 ASSR=0x00;
	OUT  0x22,R30
; 0000 0077 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0078 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0079 OCR2=0x03;
	LDI  R30,LOW(3)
	OUT  0x23,R30
; 0000 007A 
; 0000 007B // External Interrupt(s) initialization
; 0000 007C // INT0: Off
; 0000 007D // INT1: Off
; 0000 007E MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 007F 
; 0000 0080 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0081 TIMSK=0x15;
	LDI  R30,LOW(21)
	OUT  0x39,R30
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
; 0000 0089 SPCR=0x00;
	OUT  0xD,R30
; 0000 008A SPSR=0x00;
	OUT  0xE,R30
; 0000 008B 
; 0000 008C // ADC initialization
; 0000 008D // ADC Clock frequency: 1000,000 kHz
; 0000 008E // ADC Voltage Reference: AREF pin
; 0000 008F ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0090 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0091 
; 0000 0092 // LCD module initialization
; 0000 0093 //lcd_init(16);
; 0000 0094 
; 0000 0095 // Global enable interrupts
; 0000 0096 #asm("sei")
	sei
; 0000 0097 
; 0000 0098 while (1)
_0x29:
; 0000 0099       {
; 0000 009A       // Place your code here
; 0000 009B       #include <while.c>
; 0000 009C 
; 0000 009D       };
	RJMP _0x29
; 0000 009E }
_0x2C:
	RJMP _0x2C
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

	.DSEG
_on:
	.BYTE 0x6
_nowPORT:
	.BYTE 0x6
_Temp:
	.BYTE 0x4
_STemp:
	.BYTE 0x4
_Temp_min:
	.BYTE 0x4
_Time_sec_all:
	.BYTE 0x2
_Startsomedelay:
	.BYTE 0x1
_delayneed:
	.BYTE 0x1
_Timer_IR:
	.BYTE 0x1
_Timer_IR_Start:
	.BYTE 0x1
_count1bit:
	.BYTE 0x1
_devider:
	.BYTE 0x1
_databits:
	.BYTE 0x2
_show_data:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	IN   R30,0x12
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	STS  _databits,R30
	STS  _databits+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDS  R30,_databits
	LDS  R31,_databits+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x2
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	LDS  R30,_STemp
	LDS  R31,_STemp+1
	LDS  R22,_STemp+2
	LDS  R23,_STemp+3
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	LDS  R24,_Temp+2
	LDS  R25,_Temp+3
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	LDS  R24,_Temp+2
	LDS  R25,_Temp+3
	RET


	.CSEG
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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
