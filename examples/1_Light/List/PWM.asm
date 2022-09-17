
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
	.DEF _sec=R5
	.DEF _mins=R4
	.DEF _hour=R7
	.DEF _hour_a1=R6
	.DEF _mins_a1=R9
	.DEF _sec_a1=R8
	.DEF _hour_a2=R11
	.DEF _mins_a2=R10
	.DEF _sec_a2=R13
	.DEF _Timer1=R12

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

_0x3:
	.DB  0xA
_0x4:
	.DB  0xF
_0x5:
	.DB  0x10
_0x6:
	.DB  0x14
_0x7:
	.DB  0x15
_0x8:
	.DB  0x1A
_0x9:
	.DB  0x1F
_0xA:
	.DB  0x88,0x13
_0xB:
	.DB  0x5
_0xC:
	.DB  0x19
_0x200005F:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _adress2
	.DW  _0x3*2

	.DW  0x01
	.DW  _adress3
	.DW  _0x4*2

	.DW  0x01
	.DW  _adress4
	.DW  _0x5*2

	.DW  0x01
	.DW  _adress7
	.DW  _0x8*2

	.DW  0x01
	.DW  _FreqT
	.DW  _0x9*2

	.DW  0x02
	.DW  _Timefreq
	.DW  _0xA*2

	.DW  0x01
	.DW  _U9
	.DW  _0xB*2

	.DW  0x01
	.DW  _l_up
	.DW  _0xC*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x200005F*2

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
;#include <delay.h>
;//#include <stdio.h>
;#include <stdlib.h>
;
;unsigned char sec,mins,hour,hour_a1,mins_a1,sec_a1,hour_a2,mins_a2,sec_a2;
;//eeprom unsigned long int Push1=-19095,Push2=-19098;
;int d=0,d1=0,d2=0,d3=0;
;//unsigned char Timer1,bit1,bit0,bit01,bit10,shiftd,Check_1,adress2=5,adress3=9,adress4=11,adress5=15,adress6=17,adress7=26,FreqT=29;//частота приема ИК
;unsigned char Timer1,bit1,bit0,bit01,bit10,shiftd,Check_1,adress2=10,adress3=15,adress4=16,adress5=20,adress6=21,adress7=26,FreqT=31;//частота приема ИК

	.DSEG
;
;unsigned char U1=0,U2[8][4],sig1[8][4],U3=0; // для PWM
;int Timer_3,Timer_6,Timer_9,Number[3],Timefreq=5000;//частота времени
;unsigned char U4,bitEr1,bitEr0,Timer_1,Timer_2,Timer_4,Timer_7,Timer_8,TD=0,n,n1[255],n2,n3,IR_Tr=0;
;unsigned char PWM_Susp=0,Clock_Susp=0,U5,U6=0,U7=0,U8=0,U9=5,Bee,n2,Dig1,Dig2,Num2[3],l_up=25,l_dwn=0,dig_a,dig_b,dig_c;
;char adc1=0;
;bit U10=0,IR_1=0,IR_2=0,IR_S=0,L_ON;
;#include <LED-Driver.c>
;void PWM1(){
; 0000 0012 void PWM1(){

	.CSEG
_PWM1:
;
;Timer_1++;
	LDS  R30,_Timer_1
	SUBI R30,-LOW(1)
	STS  _Timer_1,R30
;
;if (Timer_1==17){Timer_1=1;Timer_2++;} //скорость обновления PWM модулирования, значение меняется с частотой
	LDS  R26,_Timer_1
	CPI  R26,LOW(0x11)
	BRNE _0xD
	LDI  R30,LOW(1)
	STS  _Timer_1,R30
	LDS  R30,_Timer_2
	SUBI R30,-LOW(1)
	STS  _Timer_2,R30
;
;if (Timer_1<sig1[0][n2]){U1=1;}else{U1=0;} // sig1 + задержка драйвер для лампы 0 - значение 1й переменной
_0xD:
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_sig1)
	SBCI R31,HIGH(-_sig1)
	LD   R30,Z
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0xE
	LDI  R30,LOW(1)
	RJMP _0xBB
_0xE:
	LDI  R30,LOW(0)
_0xBB:
	STS  _U1,R30
;if (U1==1){PORTB|=0b00000001;} //x3,y4
	LDS  R26,_U1
	CPI  R26,LOW(0x1)
	BRNE _0x10
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,1
	OUT  0x18,R30
;if (U1==0){PORTB&=~0b00000001;}
_0x10:
	LDS  R30,_U1
	CPI  R30,0
	BRNE _0x11
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFFE)
	OUT  0x18,R30
;
;if (Timer_1<sig1[1][n2]){U1=2;}else{U1=3;} // sig1 + задержка
_0x11:
	__POINTW2MN _sig1,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x12
	LDI  R30,LOW(2)
	RJMP _0xBC
_0x12:
	LDI  R30,LOW(3)
_0xBC:
	STS  _U1,R30
;if (U1==2){PORTB|=0b00000010;} //x3,y3
	LDS  R26,_U1
	CPI  R26,LOW(0x2)
	BRNE _0x14
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,2
	OUT  0x18,R30
;if (U1==3){PORTB&=~0b00000010;}
_0x14:
	LDS  R26,_U1
	CPI  R26,LOW(0x3)
	BRNE _0x15
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFFD)
	OUT  0x18,R30
;
;if (Timer_1<sig1[2][n2]){U1=4;}else{U1=5;} // sig1 + задержка
_0x15:
	__POINTW2MN _sig1,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x16
	LDI  R30,LOW(4)
	RJMP _0xBD
_0x16:
	LDI  R30,LOW(5)
_0xBD:
	STS  _U1,R30
;if (U1==4){PORTB|=0b00000100;} //x4,y2
	LDS  R26,_U1
	CPI  R26,LOW(0x4)
	BRNE _0x18
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,4
	OUT  0x18,R30
;if (U1==5){PORTB&=~0b00000100;}
_0x18:
	LDS  R26,_U1
	CPI  R26,LOW(0x5)
	BRNE _0x19
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFFB)
	OUT  0x18,R30
;
;if (Timer_1<sig1[3][n2]){U1=6;}else{U1=7;} // sig1 + задержка
_0x19:
	__POINTW2MN _sig1,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x1A
	LDI  R30,LOW(6)
	RJMP _0xBE
_0x1A:
	LDI  R30,LOW(7)
_0xBE:
	STS  _U1,R30
;if (U1==6){PORTB|=0b00010000;}  //x3,y1
	LDS  R26,_U1
	CPI  R26,LOW(0x6)
	BRNE _0x1C
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,0x10
	OUT  0x18,R30
;if (U1==7){PORTB&=~0b00010000;}
_0x1C:
	LDS  R26,_U1
	CPI  R26,LOW(0x7)
	BRNE _0x1D
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFEF)
	OUT  0x18,R30
;
;if (Timer_1<sig1[4][n2]){U1=8;}else{U1=9;} // sig1 + задержка
_0x1D:
	__POINTW2MN _sig1,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x1E
	LDI  R30,LOW(8)
	RJMP _0xBF
_0x1E:
	LDI  R30,LOW(9)
_0xBF:
	STS  _U1,R30
;if (U1==8){PORTB|=0b00100000;}  //x4,y1
	LDS  R26,_U1
	CPI  R26,LOW(0x8)
	BRNE _0x20
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,0x20
	OUT  0x18,R30
;if (U1==9){PORTB&=~0b00100000;}
_0x20:
	LDS  R26,_U1
	CPI  R26,LOW(0x9)
	BRNE _0x21
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFDF)
	OUT  0x18,R30
;
;if (Timer_1<sig1[5][n2]){U1=10;}else{U1=11;} // sig1 + задержка
_0x21:
	__POINTW2MN _sig1,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x22
	LDI  R30,LOW(10)
	RJMP _0xC0
_0x22:
	LDI  R30,LOW(11)
_0xC0:
	STS  _U1,R30
;if (U1==10){PORTB|=0b01000000;}  //x4,y4
	LDS  R26,_U1
	CPI  R26,LOW(0xA)
	BRNE _0x24
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,0x40
	OUT  0x18,R30
;if (U1==11){PORTB&=~0b01000000;}
_0x24:
	LDS  R26,_U1
	CPI  R26,LOW(0xB)
	BRNE _0x25
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFBF)
	OUT  0x18,R30
;
;if (Timer_1<sig1[6][n2]){U1=12;}else{U1=13;} // sig1 + задержка
_0x25:
	__POINTW2MN _sig1,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x26
	LDI  R30,LOW(12)
	RJMP _0xC1
_0x26:
	LDI  R30,LOW(13)
_0xC1:
	STS  _U1,R30
;if (U1==12){PORTB|=0b10000000;} //x3,y2
	LDS  R26,_U1
	CPI  R26,LOW(0xC)
	BRNE _0x28
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,0x80
	OUT  0x18,R30
;if (U1==13){PORTB&=~0b10000000;}
_0x28:
	LDS  R26,_U1
	CPI  R26,LOW(0xD)
	BRNE _0x29
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFF7F)
	OUT  0x18,R30
;
;if (Timer_1<sig1[7][n2]){U1=14;}else{U1=15;} // sig1 + задержка
_0x29:
	__POINTW2MN _sig1,28
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDS  R26,_Timer_1
	CP   R26,R30
	BRSH _0x2A
	LDI  R30,LOW(14)
	RJMP _0xC2
_0x2A:
	LDI  R30,LOW(15)
_0xC2:
	STS  _U1,R30
;if (U1==14){PORTB|=0b00001000;} //x4,y2
	LDS  R26,_U1
	CPI  R26,LOW(0xE)
	BRNE _0x2C
	IN   R30,0x18
	LDI  R31,0
	ORI  R30,8
	OUT  0x18,R30
;if (U1==15){PORTB&=~0b00001000;}
_0x2C:
	LDS  R26,_U1
	CPI  R26,LOW(0xF)
	BRNE _0x2D
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFFF7)
	OUT  0x18,R30
;
;
;if (Timer_2>=U9){ //скорость затухания
_0x2D:
	LDS  R30,_U9
	LDS  R26,_Timer_2
	CP   R26,R30
	BRSH PC+2
	RJMP _0x2E
;
;for (U3=0;U3<=7;U3++){
	LDI  R30,LOW(0)
	STS  _U3,R30
_0x30:
	LDS  R26,_U3
	CPI  R26,LOW(0x8)
	BRLO PC+2
	RJMP _0x31
;
;if (U2[U3][n2]==1) {if(sig1[U3][n2]<l_up){sig1[U3][n2]=sig1[U3][n2]+1;}}
	LDS  R30,_U3
	LDI  R26,LOW(_U2)
	LDI  R27,HIGH(_U2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x32
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	LDS  R30,_l_up
	CP   R26,R30
	BRSH _0x33
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R0
	ST   X,R30
_0x33:
;if (U2[U3][n2]==0) {if(sig1[U3][n2]>l_dwn){sig1[U3][n2]=sig1[U3][n2]-1;}else{sig1[U3][n2]=l_dwn;}}
_0x32:
	LDS  R30,_U3
	LDI  R26,LOW(_U2)
	LDI  R27,HIGH(_U2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ PC+2
	RJMP _0x34
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	LDS  R30,_l_dwn
	CP   R30,R26
	BRSH _0x35
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R0
	ST   X,R30
	RJMP _0x36
_0x35:
	LDS  R30,_U3
	LDI  R26,LOW(_sig1)
	LDI  R27,HIGH(_sig1)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_n2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_l_dwn
	STD  Z+0,R26
_0x36:
;//if (U2[U3][n2]==0) {if(sig1[U3][n2]>2){sig1[U3][n2]=sig1[U3][n2]-1;}else{sig1[U3][n2]=2;}}
;
;}
_0x34:
	LDS  R30,_U3
	SUBI R30,-LOW(1)
	STS  _U3,R30
	RJMP _0x30
_0x31:
;Timer_2=0;}
	LDI  R30,LOW(0)
	STS  _Timer_2,R30
;}
_0x2E:
	RET
;
;void Dig_1(){
_Dig_1:
;switch (Dig1){
	LDS  R30,_Dig1
	LDI  R31,0
;case 1: {U2[3][n2]=1;break;}
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3A
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 2: {U2[6][n2]=1;break;}
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
	__POINTW2MN _U2,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 3: {U2[6][n2]=1;U2[3][n2]=1;break;}
_0x3B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
	__POINTW2MN _U2,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 4: {U2[1][n2]=1;break;}
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3D
	__POINTW2MN _U2,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 5: {U2[1][n2]=1;U2[3][n2]=1;break;}
_0x3D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3E
	__POINTW2MN _U2,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 6: {U2[1][n2]=1;U2[6][n2]=1;break;}
_0x3E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3F
	__POINTW2MN _U2,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 7: {U2[1][n2]=1;U2[6][n2]=1;U2[3][n2]=1;break;}
_0x3F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40
	__POINTW2MN _U2,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 8: {U2[0][n2]=1;break;}
_0x40:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x41
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_U2)
	SBCI R31,HIGH(-_U2)
	LDI  R26,LOW(1)
	STD  Z+0,R26
	RJMP _0x39
;case 9: {U2[0][n2]=1;U2[3][n2]=1;break;}
_0x41:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x42
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_U2)
	SBCI R31,HIGH(-_U2)
	LDI  R26,LOW(1)
	STD  Z+0,R26
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x39
;case 10: {U2[0][n2]=1;U2[3][n2]=1;U2[6][n2]=1;U2[1][n2]=1;break;}
_0x42:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x44
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_U2)
	SBCI R31,HIGH(-_U2)
	LDI  R26,LOW(1)
	STD  Z+0,R26
	__POINTW2MN _U2,12
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,24
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,4
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
;default: ;
_0x44:
;}
_0x39:
;}
	RET
;void Dig_2(){
_Dig_2:
;switch (Dig2){
	LDS  R30,_Dig2
	LDI  R31,0
;case 1: {U2[4][n2]=1;break;}
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x48
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 2: {U2[2][n2]=1;break;}
_0x48:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x49
	__POINTW2MN _U2,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 3: {U2[4][n2]=1;U2[2][n2]=1;break;}
_0x49:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4A
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 4: {U2[5][n2]=1;break;}
_0x4A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4B
	__POINTW2MN _U2,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 5: {U2[5][n2]=1;U2[4][n2]=1;break;}
_0x4B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4C
	__POINTW2MN _U2,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 6: {U2[2][n2]=1;U2[5][n2]=1;break;}
_0x4C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4D
	__POINTW2MN _U2,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 7: {U2[2][n2]=1;U2[5][n2]=1;U2[4][n2]=1;break;}
_0x4D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x4E
	__POINTW2MN _U2,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 8: {U2[7][n2]=1;break;}
_0x4E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4F
	__POINTW2MN _U2,28
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 9: {U2[4][n2]=1;U2[7][n2]=1;break;}
_0x4F:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x50
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,28
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x47
;case 11: {U2[4][n2]=1;U2[7][n2]=1;{U2[5][n2]=1;U2[2][n2]=1;break;}}
_0x50:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x52
	__POINTW2MN _U2,16
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,28
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,20
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
	__POINTW2MN _U2,8
	LDS  R30,_n2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
;default: ;
_0x52:
;}
_0x47:
;}
	RET
;void Dig_0(){
_Dig_0:
;//for (n2=0;n2<=3;n2++){
;for (U3=0;U3<=7;U3++){U2[U3][0]=0;}
	LDI  R30,LOW(0)
	STS  _U3,R30
_0x54:
	LDS  R26,_U3
	CPI  R26,LOW(0x8)
	BRSH _0x55
	LDS  R30,_U3
	LDI  R26,LOW(_U2)
	LDI  R27,HIGH(_U2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	LDS  R30,_U3
	SUBI R30,-LOW(1)
	STS  _U3,R30
	RJMP _0x54
_0x55:
;for (U3=0;U3<=7;U3++){U2[U3][1]=0;}
	LDI  R30,LOW(0)
	STS  _U3,R30
_0x57:
	LDS  R26,_U3
	CPI  R26,LOW(0x8)
	BRSH _0x58
	LDS  R30,_U3
	LDI  R26,LOW(_U2)
	LDI  R27,HIGH(_U2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDS  R30,_U3
	SUBI R30,-LOW(1)
	STS  _U3,R30
	RJMP _0x57
_0x58:
;for (U3=0;U3<=7;U3++){U2[U3][2]=0;}
	LDI  R30,LOW(0)
	STS  _U3,R30
_0x5A:
	LDS  R26,_U3
	CPI  R26,LOW(0x8)
	BRSH _0x5B
	LDS  R30,_U3
	LDI  R26,LOW(_U2)
	LDI  R27,HIGH(_U2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,2
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDS  R30,_U3
	SUBI R30,-LOW(1)
	STS  _U3,R30
	RJMP _0x5A
_0x5B:
;PORTB&=~0b11111111;
	IN   R30,0x18
	LDI  R31,0
	ANDI R30,LOW(0xFF00)
	OUT  0x18,R30
;//DDRD|=0b00000000;DDRD&=~0b11100000;
;
;}
	RET
;
;void U4M()
;{
_U4M:
;if (U4==0){DDRD|=0b10000000;DDRD&=~0b01100000;}
	LDS  R30,_U4
	CPI  R30,0
	BRNE _0x5C
	IN   R30,0x11
	LDI  R31,0
	ORI  R30,0x80
	OUT  0x11,R30
	IN   R30,0x11
	LDI  R31,0
	ANDI R30,LOW(0xFF9F)
	OUT  0x11,R30
;if (U4==1){DDRD|=0b00100000;DDRD&=~0b11000000;}
_0x5C:
	LDS  R26,_U4
	CPI  R26,LOW(0x1)
	BRNE _0x5D
	IN   R30,0x11
	LDI  R31,0
	ORI  R30,0x20
	OUT  0x11,R30
	IN   R30,0x11
	LDI  R31,0
	ANDI R30,LOW(0xFF3F)
	OUT  0x11,R30
;if (U4==2){DDRD|=0b01000000;DDRD&=~0b10100000;}
_0x5D:
	LDS  R26,_U4
	CPI  R26,LOW(0x2)
	BRNE _0x5E
	IN   R30,0x11
	LDI  R31,0
	ORI  R30,0x40
	OUT  0x11,R30
	IN   R30,0x11
	LDI  R31,0
	ANDI R30,LOW(0xFF5F)
	OUT  0x11,R30
;}
_0x5E:
	RET
;
;
;void null(){
_null:
;dig_a=0,dig_b=0,dig_c=0,Timer_9=0;
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
	STS  _dig_c,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
;}
	RET
;
;void Parts(){
_Parts:
;Num2[n2]=0;
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_Num2)
	SBCI R31,HIGH(-_Num2)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;if(Number[n2]<0){Number[n2]*=-1;}
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	TST  R31
	BRPL _0x5F
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R30
	RCALL __GETW1P
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL __MULW12
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
;while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
_0x5F:
_0x60:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	SBIW R30,10
	BRLT _0x62
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	SBIW R30,10
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_n2
	LDI  R27,0
	SUBI R26,LOW(-_Num2)
	SBCI R27,HIGH(-_Num2)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RJMP _0x60
_0x62:
;  Dig1 = Number[n2];
	RJMP _0x2080002
;  Dig2 = Num2[n2];
;}
;void Parts1(){
_Parts1:
;Num2[n2]=0;
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_Num2)
	SBCI R31,HIGH(-_Num2)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;while (Number[n2] >= 10000){Number[n2] -= 10000;}
_0x63:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRLT _0x65
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	SUBI R30,LOW(10000)
	SBCI R31,HIGH(10000)
	ST   -X,R31
	ST   -X,R30
	RJMP _0x63
_0x65:
;while (Number[n2] >= 1000){Number[n2] -= 1000;}
_0x66:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRLT _0x68
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	SUBI R30,LOW(1000)
	SBCI R31,HIGH(1000)
	ST   -X,R31
	ST   -X,R30
	RJMP _0x66
_0x68:
;while (Number[n2] >= 100){Number[n2] -= 100;}
_0x69:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRLT _0x6B
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	ST   -X,R31
	ST   -X,R30
	RJMP _0x69
_0x6B:
;while (Number[n2] >= 10){Number[n2] -= 10;Num2[n2]++;}
_0x6C:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	SBIW R30,10
	BRLT _0x6E
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	SBIW R30,10
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_n2
	LDI  R27,0
	SUBI R26,LOW(-_Num2)
	SBCI R27,HIGH(-_Num2)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RJMP _0x6C
_0x6E:
;  Dig1 = Number[n2];
_0x2080002:
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  _Dig1,R30
;  Dig2 = Num2[n2];
	LDS  R30,_n2
	LDI  R31,0
	SUBI R30,LOW(-_Num2)
	SBCI R31,HIGH(-_Num2)
	LD   R30,Z
	STS  _Dig2,R30
;}
	RET
;
;void Dig(){
_Dig:
;if (PWM_Susp==0){
	LDS  R30,_PWM_Susp
	CPI  R30,0
	BREQ PC+2
	RJMP _0x6F
;PWM1();
	RCALL _PWM1
;Timer_4++;
	LDS  R30,_Timer_4
	SUBI R30,-LOW(1)
	STS  _Timer_4,R30
;if (Timer_4==20){U4++;Timer_4=0;
	LDS  R26,_Timer_4
	CPI  R26,LOW(0x14)
	BREQ PC+2
	RJMP _0x70
	LDS  R30,_U4
	SUBI R30,-LOW(1)
	STS  _U4,R30
	LDI  R30,LOW(0)
	STS  _Timer_4,R30
;//U4++;
;if (U4==3){U4=0;}
	LDS  R26,_U4
	CPI  R26,LOW(0x3)
	BRNE _0x71
	STS  _U4,R30
;
;
;Dig_0();
_0x71:
	RCALL _Dig_0
;n2=U4;
	LDS  R30,_U4
	STS  _n2,R30
;
;U4M();
	RCALL _U4M
;if (U8==0){ //Time
	LDS  R30,_U8
	CPI  R30,0
	BRNE _0x72
;Number[0] = hour;
	MOV  R30,R7
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = mins;
	__POINTW2MN _Number,2
	MOV  R30,R4
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = sec;
	__POINTW2MN _Number,4
	MOV  R30,R5
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;}
;if (U8==1){ //sp
_0x72:
	LDS  R26,_U8
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x73
;Timer_9++;if (Timer_9==1){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==300){dig_a=7,dig_b=17,dig_c=47;};if (Timer_9==600){dig_a=0,dig_b=0,dig_c=0;};if (Timer_9==1200){dig_a=7,dig_b=57,dig_c=11;}if (Timer_9==2200){dig_a=0,dig_b=0,dig_c=0;}if (Timer_9==2400){Timer_9=0;U8=4;U9=10;}
	LDI  R26,LOW(_Timer_9)
	LDI  R27,HIGH(_Timer_9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	SBIW R26,1
	BRNE _0x74
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
	STS  _dig_c,R30
_0x74:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRNE _0x75
	LDI  R30,LOW(7)
	STS  _dig_a,R30
	LDI  R30,LOW(17)
	STS  _dig_b,R30
	LDI  R30,LOW(47)
	STS  _dig_c,R30
_0x75:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRNE _0x76
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
	STS  _dig_c,R30
_0x76:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRNE _0x77
	LDI  R30,LOW(7)
	STS  _dig_a,R30
	LDI  R30,LOW(57)
	STS  _dig_b,R30
	LDI  R30,LOW(11)
	STS  _dig_c,R30
_0x77:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x898)
	LDI  R30,HIGH(0x898)
	CPC  R27,R30
	BRNE _0x78
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
	STS  _dig_c,R30
_0x78:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x960)
	LDI  R30,HIGH(0x960)
	CPC  R27,R30
	BRNE _0x79
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
	LDI  R30,LOW(4)
	STS  _U8,R30
	LDI  R30,LOW(10)
	STS  _U9,R30
;
;Number[0] = dig_a;
_0x79:
	LDS  R30,_dig_a
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = dig_b;
	__POINTW2MN _Number,2
	LDS  R30,_dig_b
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = dig_c;
	__POINTW2MN _Number,4
	LDS  R30,_dig_c
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;}
;if (U8==2){//off
_0x73:
	LDS  R26,_U8
	CPI  R26,LOW(0x2)
	BRNE _0x7A
;Number[n2]=Num2[n2]=0;
	LDS  R30,_n2
	LDI  R26,LOW(_Number)
	LDI  R27,HIGH(_Number)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R26,_n2
	LDI  R27,0
	SUBI R26,LOW(-_Num2)
	SBCI R27,HIGH(-_Num2)
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R26,R0
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;}
;if (U8==3){ //Temp
_0x7A:
	LDS  R26,_U8
	CPI  R26,LOW(0x3)
	BREQ PC+2
	RJMP _0x7B
;Timer_9++;if (Timer_9==300){dig_a=0,dig_b=0;}if (Timer_9==600){Timer_9=0;U10=0,dig_a=7,dig_b=50;}//если температура включена
	LDI  R26,LOW(_Timer_9)
	LDI  R27,HIGH(_Timer_9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRNE _0x7C
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
_0x7C:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRNE _0x7D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
	CLT
	BLD  R2,0
	LDI  R30,LOW(7)
	STS  _dig_a,R30
	LDI  R30,LOW(50)
	STS  _dig_b,R30
;//Num2[n2]=0;
;Number[0] = dig_a;
_0x7D:
	LDS  R30,_dig_a
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = dig_b;
	__POINTW2MN _Number,2
	LDS  R30,_dig_b
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = adc1;
	__POINTW2MN _Number,4
	LDS  R30,_adc1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;}
;if (U8==4){
_0x7B:
	LDS  R26,_U8
	CPI  R26,LOW(0x4)
	BREQ PC+2
	RJMP _0x7E
;//U9=15;
;Timer_9++;if (Timer_9==1){dig_a=rand();dig_b=rand();dig_c=rand();}if (Timer_9==300){Timer_9=0;}//
	LDI  R26,LOW(_Timer_9)
	LDI  R27,HIGH(_Timer_9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	SBIW R26,1
	BRNE _0x7F
	RCALL _rand
	STS  _dig_a,R30
	RCALL _rand
	STS  _dig_b,R30
	RCALL _rand
	STS  _dig_c,R30
_0x7F:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRNE _0x80
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
;Number[0] = dig_a;
_0x80:
	LDS  R30,_dig_a
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = dig_b;
	__POINTW2MN _Number,2
	LDS  R30,_dig_b
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = dig_c;
	__POINTW2MN _Number,4
	LDS  R30,_dig_c
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts1();
	RCALL _Parts1
;;}
;if (U8==5){
_0x7E:
	LDS  R26,_U8
	CPI  R26,LOW(0x5)
	BREQ PC+2
	RJMP _0x81
;//U9=15;
;Timer_9++;if (Timer_9==100){dig_a=07;dig_b=57;dig_c=57;}if (Timer_9==400){if (PIND.3==1){dig_b=77;}if (PIND.2==1){dig_c=77;}Timer_9=0;}//
	LDI  R26,LOW(_Timer_9)
	LDI  R27,HIGH(_Timer_9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x82
	LDI  R30,LOW(7)
	STS  _dig_a,R30
	LDI  R30,LOW(57)
	STS  _dig_b,R30
	STS  _dig_c,R30
_0x82:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRNE _0x83
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x84
	LDI  R30,LOW(77)
	STS  _dig_b,R30
_0x84:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x85
	LDI  R30,LOW(77)
	STS  _dig_c,R30
_0x85:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
;Number[0] = dig_a;
_0x83:
	LDS  R30,_dig_a
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = dig_b;
	__POINTW2MN _Number,2
	LDS  R30,_dig_b
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = dig_c;
	__POINTW2MN _Number,4
	LDS  R30,_dig_c
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;;}
;if (U8==6){
_0x81:
	LDS  R26,_U8
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x86
;//U9=15;
;//Timer_9++;if (Timer_9==1){dig_a=hour_a1;dig_b=mins_a1;dig_c=sec_a1;}if (Timer_9==100){dig_a=hour_a2;dig_b=mins_a2;dig_c=sec_a2;Timer_9=0;}if (Timer_9==200){dig_a=0;dig_b=0;dig_c=80;Timer_9=0;}//
;Timer_9++;if (Timer_9==100){dig_a=hour_a1;dig_b=mins_a1;dig_c=sec_a1;}if (Timer_9==200){dig_a=hour_a2;dig_b=mins_a2;dig_c=sec_a2;}if (Timer_9==300){dig_a=0;dig_b=0;dig_c=80;Timer_9=0;}//
	LDI  R26,LOW(_Timer_9)
	LDI  R27,HIGH(_Timer_9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x87
	STS  _dig_a,R6
	STS  _dig_b,R9
	STS  _dig_c,R8
_0x87:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRNE _0x88
	STS  _dig_a,R11
	STS  _dig_b,R10
	STS  _dig_c,R13
_0x88:
	LDS  R26,_Timer_9
	LDS  R27,_Timer_9+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRNE _0x89
	LDI  R30,LOW(0)
	STS  _dig_a,R30
	STS  _dig_b,R30
	LDI  R30,LOW(80)
	STS  _dig_c,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_9,R30
	STS  _Timer_9+1,R31
;
;Number[0] = dig_a;
_0x89:
	LDS  R30,_dig_a
	LDI  R31,0
	STS  _Number,R30
	STS  _Number+1,R31
;Number[1] = dig_b;
	__POINTW2MN _Number,2
	LDS  R30,_dig_b
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Number[2] = dig_c;
	__POINTW2MN _Number,4
	LDS  R30,_dig_c
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;Parts();
	RCALL _Parts
;;}
;//fade_d();
;Dig_1();
_0x86:
	RCALL _Dig_1
;Dig_2();
	RCALL _Dig_2
;}
;
;}
_0x70:
;}
_0x6F:
	RET
;#include <Time.c>
;void Time1(){
; 0000 0013 void Time1(){
_Time1:
;//Timer_5++;
;//if (Timer_5==3000){Timer_5=0;}
;
;//приостановка таймера, если услышан сигнал IR
;if (Clock_Susp==1){Check_1=0;}
	LDS  R26,_Clock_Susp
	CPI  R26,LOW(0x1)
	BRNE _0x8A
	LDI  R30,LOW(0)
	STS  _Check_1,R30
;if (Clock_Susp==0){Timer_3++;
_0x8A:
	LDS  R30,_Clock_Susp
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8B
	LDI  R26,LOW(_Timer_3)
	LDI  R27,HIGH(_Timer_3)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
;
;if (Timer_3==Timefreq){
	LDS  R30,_Timefreq
	LDS  R31,_Timefreq+1
	LDS  R26,_Timer_3
	LDS  R27,_Timer_3+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x8C
;if(L_ON==1){Check_1++;};
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x8D
	LDS  R30,_Check_1
	SUBI R30,-LOW(1)
	STS  _Check_1,R30
_0x8D:
;if(L_ON==0){Check_1=10;};
	SBRC R2,4
	RJMP _0x8E
	LDI  R30,LOW(10)
	STS  _Check_1,R30
_0x8E:
;Timer_3=0;}
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_3,R30
	STS  _Timer_3+1,R31
;
;
;if ((IR_S==1)&&(Timer_3==4000)){IR_S=0;}
_0x8C:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x90
	LDS  R26,_Timer_3
	LDS  R27,_Timer_3+1
	CPI  R26,LOW(0xFA0)
	LDI  R30,HIGH(0xFA0)
	CPC  R27,R30
	BREQ _0x91
_0x90:
	RJMP _0x8F
_0x91:
	CLT
	BLD  R2,3
;
;//U8=3;
;//if (Check_1==10){U8=1;U9=7;null();} // включение Sp, затем эффект U8=4
;//if (Check_1==45){U8=4;U9=15;null();} // включение ...
;if (Check_1==1){U8=5;U9=5;null();} // включение проверки выключателей
_0x8F:
	LDS  R26,_Check_1
	CPI  R26,LOW(0x1)
	BRNE _0x92
	LDI  R30,LOW(5)
	STS  _U8,R30
	STS  _U9,R30
	RCALL _null
;//if (Check_1==5){U8=6;U9=5;null();} // включение будильник
;//if (Check_1==15){U8=0;U9=5;null();} // включение времени
;if (Check_1==7){U8=2;U10=0;}//выключение ламп
_0x92:
	LDS  R26,_Check_1
	CPI  R26,LOW(0x7)
	BRNE _0x93
	LDI  R30,LOW(2)
	STS  _U8,R30
	CLT
	BLD  R2,0
;if (Check_1==10){PWM_Susp=1;U10=1;PORTD|=0b00010000;}// включение ИК
_0x93:
	LDS  R26,_Check_1
	CPI  R26,LOW(0xA)
	BRNE _0x94
	LDI  R30,LOW(1)
	STS  _PWM_Susp,R30
	SET
	BLD  R2,0
	IN   R30,0x12
	LDI  R31,0
	ORI  R30,0x10
	OUT  0x12,R30
;if (Check_1==40){PWM_Susp=0;U8=3;PORTD&=~0b00010000,U9=5;null();}// выключение ИК, включение температуры
_0x94:
	LDS  R26,_Check_1
	CPI  R26,LOW(0x28)
	BRNE _0x95
	LDI  R30,LOW(0)
	STS  _PWM_Susp,R30
	LDI  R30,LOW(3)
	STS  _U8,R30
	IN   R30,0x12
	LDI  R31,0
	ANDI R30,LOW(0xFFEF)
	OUT  0x12,R30
	LDI  R30,LOW(5)
	STS  _U9,R30
	RCALL _null
;if (Check_1==50){Check_1=0;}
_0x95:
	LDS  R26,_Check_1
	CPI  R26,LOW(0x32)
	BRNE _0x96
	LDI  R30,LOW(0)
	STS  _Check_1,R30
;
;/*
;if (sec==59){sec=0;mins++;}
;if (mins==59){mins=0;hour++;}
;if (hour>=23){hour=1;}
;
;if (hour>=22){l_up=10;}
;if ((hour>=11)&&(hour<22)){l_up=25;}
;*/
;}
_0x96:
;}
_0x8B:
	RET
;#include <ADC.c>
;#define ADC_VREF_TYPE 1
;
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0014 {
_read_adc:
;ADMUX=adc_input|ADC_VREF_TYPE;
;	adc_input -> Y+0
	LD   R30,Y
	LDI  R31,0
	ORI  R30,1
	OUT  0x7,R30
;// Start the AD conversion
;ADCSRA|=0x40;
	IN   R30,0x6
	LDI  R31,0
	ORI  R30,0x40
	OUT  0x6,R30
;// Wait for the AD conversion to complete
;while ((ADCSRA & 0x10)==0);
_0x97:
	IN   R30,0x6
	LDI  R31,0
	ANDI R30,LOW(0x10)
	BREQ _0x97
;ADCSRA|=0x10;
	IN   R30,0x6
	LDI  R31,0
	ORI  R30,0x10
	OUT  0x6,R30
;return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
;adc1 = ADCH;
;}
_0x2080001:
	ADIW R28,1
	RET
;
;/*
;interrupt [ADC_INT] void adc_isr(void){
;//if (U8==3){
;ADMUX=287+1; //287 - стандартное выражение, 1 - номер порта
;delay_us(20); //для стабилизации
;ADCSRA|=0b1100000;// включение непрерывного определения
;while ((ADCSRA & 0b1100000)==0);//ждем пока идет подсчет
;adc1 = ADCH;//заносим данные в f1
;//}
;}
;*/
;#include <IR.c>
;//interrupt [TIM2_OVF] void timer2_ovf_isr(void){
;
;void IR(){
; 0000 0015 void IR(){
_IR:
;PORTD&=~0b00010000;
	IN   R30,0x12
	LDI  R31,0
	ANDI R30,LOW(0xFFEF)
	OUT  0x12,R30
;if (IR_2==1){
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x9A
;Timer1++;
	INC  R12
;if (PINC.0==0) {bit1++;}// подсчет всех принятых бит
	SBIC 0x13,0
	RJMP _0x9B
	LDS  R30,_bit1
	SUBI R30,-LOW(1)
	STS  _bit1,R30
;if (PINC.0==1) {n++;n1[n]=bit1;Timer1=bit1=0;IR_2=0;} // как только сигнал пропадает, выводит результат подсчета.
_0x9B:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x9C
	LDS  R30,_n
	SUBI R30,-LOW(1)
	STS  _n,R30
	LDI  R31,0
	SUBI R30,LOW(-_n1)
	SBCI R31,HIGH(-_n1)
	LDS  R26,_bit1
	STD  Z+0,R26
	LDI  R30,LOW(0)
	STS  _bit1,R30
	MOV  R12,R30
	CLT
	BLD  R2,2
;//if (PINC.0==1) {printf("Timer=%d bit1=%d#",Timer1,bit1);Timer1=IR_2=bit1=0;IR_Tr=0;} // как только сигнал пропадает, выводит результат подсчета.
;if (n==2){//если проходит двойную проверку
_0x9C:
	LDS  R26,_n
	CPI  R26,LOW(0x2)
	BRNE _0x9D
;   if (n1[1]==n1[2]){//если значение равно следующему
	__GETB2MN _n1,1
	__GETB1MN _n1,2
	CP   R30,R26
	BREQ _0x9F
;   //FreqT=Timer1;IR_Tr=n=0;
;//   printf("bit1=%d#",n1[1]);IR_2=n=0;
;    }
;   else{
;   IR_2=0;IR_Tr=n=0;
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
	STS  _n,R30
	STS  _IR_Tr,R30
;   ;}}
_0x9F:
;
;   }
_0x9D:
;
;
;
;if (IR_1==1){
_0x9A:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xA0
;
;// Place your code here
;//PORTB^=0b00000100;
;Timer1++;
	INC  R12
;if (PINC.0==0) {bit1++;}
	SBIC 0x13,0
	RJMP _0xA1
	LDS  R30,_bit1
	SUBI R30,-LOW(1)
	STS  _bit1,R30
;if (PINC.0==1) {bit0++;}
_0xA1:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xA2
	LDS  R30,_bit0
	SUBI R30,-LOW(1)
	STS  _bit0,R30
;if (Timer1==FreqT){
_0xA2:
	LDS  R30,_FreqT
	CP   R30,R12
	BREQ PC+2
	RJMP _0xA3
;Timer1=0;
	CLR  R12
;if (bit1>bit0){// если все (25) битов были положительные, то добавляем 1
	LDS  R30,_bit0
	LDS  R26,_bit1
	CP   R30,R26
	BRSH _0xA4
;//if(bit1+1<FreqT){FreqT=bit1;IR_1=bit1=bit0=Timer1=0;IR_Tr=1;}else{IR_Tr=0;}// если было принято более 2-х нулей в еденицах
;//if(bit1==FreqT){FreqT++;}
;bit1=bit0=0;
	LDI  R30,LOW(0)
	STS  _bit0,R30
	STS  _bit1,R30
;//bit01=0;
;//bit10++;
;d=d<<1; //сдвигаем переменную для битов
	LDS  R30,_d
	LDS  R31,_d+1
	LSL  R30
	ROL  R31
	STS  _d,R30
	STS  _d+1,R31
;d|=1;//добавляем в конец строки положительный бит
	ORI  R30,1
	STS  _d,R30
	STS  _d+1,R31
;//putchar('1');
;}
;if (bit0>bit1){
_0xA4:
	LDS  R30,_bit1
	LDS  R26,_bit0
	CP   R30,R26
	BRSH _0xA5
;//if(bit0+1<FreqT){FreqT=bit0;IR_1=bit1=bit0=Timer1=0;IR_Tr=1;}else{IR_Tr=0;}// если был принят 0 в еденицах
;bit0=bit1=0;
	LDI  R30,LOW(0)
	STS  _bit1,R30
	STS  _bit0,R30
;//bit01++;
;//bit10=0;
;d=d<<1; //сдвигаем переменную для битов
	LDS  R30,_d
	LDS  R31,_d+1
	LSL  R30
	ROL  R31
	STS  _d,R30
	STS  _d+1,R31
;d&=~1;//добавляем в конец строки нулевой бит
	ANDI R30,LOW(0xFFFE)
	STS  _d,R30
	STS  _d+1,R31
;//putchar('0');
;}
;shiftd++;
_0xA5:
	LDS  R30,_shiftd
	SUBI R30,-LOW(1)
	STS  _shiftd,R30
;////////////////////////////
;//if ((bit01>=5)||(bit10>=5)){d=d1=d2=d3=shiftd=0;bit10=bit01=0;putchar('n');IR_1=0;bitEr1=bitEr0=0;IR_Tr=1;};//FreqT--;если принято 4-е нуля подряд то таймер останавливается.
;if ((shiftd==adress2)){d = 0;}       //9
	LDS  R30,_adress2
	LDS  R26,_shiftd
	CP   R30,R26
	BRNE _0xA6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _d,R30
	STS  _d+1,R31
;if ((shiftd==adress3)){d1 = d;d=0;}//15
_0xA6:
	LDS  R30,_adress3
	LDS  R26,_shiftd
	CP   R30,R26
	BRNE _0xA7
	LDS  R30,_d
	LDS  R31,_d+1
	STS  _d1,R30
	STS  _d1+1,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _d,R30
	STS  _d+1,R31
;if ((shiftd==adress4)){d = 0;}//16
_0xA7:
	LDS  R30,_adress4
	LDS  R26,_shiftd
	CP   R30,R26
	BRNE _0xA8
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _d,R30
	STS  _d+1,R31
;//if ((shiftd==adress5)){d2 = d;d=0;}//20
;//if ((shiftd==adress6)){d = 0;}     //21
;if ((shiftd>=adress7)){d3=d1+d2+d;   //26
_0xA8:
	LDS  R30,_adress7
	LDS  R26,_shiftd
	CP   R26,R30
	BRSH PC+2
	RJMP _0xA9
	LDS  R30,_d2
	LDS  R31,_d2+1
	LDS  R26,_d1
	LDS  R27,_d1+1
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_d
	LDS  R27,_d+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _d3,R30
	STS  _d3+1,R31
;
;//putchar('#');
;//printf("#d1=%d d2=%d d3=%d#FreqT=%d IR_Tr=%d#",d1,d2,d3,FreqT,IR_Tr);
;//printf("#d=%d#",d3);
;
;IR_1=0;
	CLT
	BLD  R2,1
;//printf("#d3=%d FreqT=%d",FreqT);
;//putchar('#');
;
;//if (((d3==-19095)||(d3==23188))&&(Timer2==0)){PORTD^=0b00000100;putchar('A');}
;//if (((d3==-19098)||(d3==23187))&&(Timer2==0)){PORTD^=0b00001000;putchar('B');}
;
;
;
;#include <IR_Driver.c>
;if (d3==832){PORTD^=0b00000100;Bee=7;}//принудительное включение выключателей.
	LDS  R26,_d3
	LDS  R27,_d3+1
	CPI  R26,LOW(0x340)
	LDI  R30,HIGH(0x340)
	CPC  R27,R30
	BRNE _0xAA
	IN   R30,0x12
	LDI  R31,0
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
	LDI  R30,LOW(7)
	STS  _Bee,R30
;if (d3==864){PORTD^=0b00001000;Bee=7;}
_0xAA:
	LDS  R26,_d3
	LDS  R27,_d3+1
	CPI  R26,LOW(0x360)
	LDI  R30,HIGH(0x360)
	CPC  R27,R30
	BRNE _0xAB
	IN   R30,0x12
	LDI  R31,0
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
	LDI  R30,LOW(7)
	STS  _Bee,R30
;if (d3==840){L_ON^=1;Bee=10;}
_0xAB:
	LDS  R26,_d3
	LDS  R27,_d3+1
	CPI  R26,LOW(0x348)
	LDI  R30,HIGH(0x348)
	CPC  R27,R30
	BRNE _0xAC
	LDI  R30,0
	SBRC R2,4
	LDI  R30,1
	LDI  R31,0
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	EOR  R30,R26
	EOR  R31,R27
	RCALL __BSTB1
	BLD  R2,4
	LDI  R30,LOW(10)
	STS  _Bee,R30
;/*
;if (d3==633){Clock_Susp=1;Bee=20;U6=1;}
;if (d3==18832){Clock_Susp=1;Bee=20;U6=2;}
;
;if (d3==21872){Clock_Susp=0;putchar('C');Bee=30;TD=0;U6=0;}
;
;
;if (Clock_Susp==1){
;if (d3==21160){U5=1;U7=1;Bee=5;}
;if (d3==21136){U5=2;U7=1;Bee=6;}
;
;if ((U7==1)&&(U6==1)){//установка времени
;TD++;U7=0;
;if (TD==1){hour=U5*10;}
;if (TD==2){hour=hour+U5;}
;if (TD==3){mins=U5*10;}
;if (TD==4){mins=mins+U5;sec=TD=U6=0;
;Clock_Susp=0;}
;}
;if ((U7==1)&&(U6==2)){//установка будильника
;TD++;U7=0;
;if (TD==1){hour_a1=U5*10;}
;if (TD==2){hour_a1=hour_a1+U5;}
;if (TD==3){mins_a1=U5*10;}
;if (TD==4){mins_a1=mins_a1+U5;sec_a1=TD=U6=0;
;Clock_Susp=0;}
;
;
;}
;}
;*/
;
;
;d=d1=d2=d3=shiftd=bitEr0=bitEr1=0;
_0xAC:
	LDI  R30,LOW(0)
	STS  _bitEr1,R30
	STS  _bitEr0,R30
	STS  _shiftd,R30
	LDI  R31,0
	STS  _d3,R30
	STS  _d3+1,R31
	STS  _d2,R30
	STS  _d2+1,R31
	STS  _d1,R30
	STS  _d1+1,R31
	STS  _d,R30
	STS  _d+1,R31
;//TCCR2&=~0x01;
;PORTD|=0b00010000;
	IN   R30,0x12
	LDI  R31,0
	ORI  R30,0x10
	OUT  0x12,R30
;//TCCR0|=0x01;
;IR_S=1;
	SET
	BLD  R2,3
;}
;}
_0xA9:
;}
_0xA3:
;}
_0xA0:
	RET
;#include <Beep.c>
;void Beep (){
; 0000 0016 void Beep (){
_Beep:
;if (Bee>1){
	LDS  R26,_Bee
	CPI  R26,LOW(0x2)
	BRLO _0xAD
;Timer_7++;
	LDS  R30,_Timer_7
	SUBI R30,-LOW(1)
	STS  _Timer_7,R30
;if (Timer_7>=Bee){
	LDS  R30,_Bee
	LDS  R26,_Timer_7
	CP   R26,R30
	BRLO _0xAE
;Timer_7=0;
	LDI  R30,LOW(0)
	STS  _Timer_7,R30
;Timer_8++;
	LDS  R30,_Timer_8
	SUBI R30,-LOW(1)
	STS  _Timer_8,R30
;PORTC^=0b00000100;
	IN   R30,0x15
	LDI  R31,0
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x15,R30
;}
;if (Timer_8>120){
_0xAE:
	LDS  R26,_Timer_8
	CPI  R26,LOW(0x79)
	BRLO _0xAF
;Timer_8=Bee=0;
	LDI  R30,LOW(0)
	STS  _Bee,R30
	STS  _Timer_8,R30
;PORTC&=~0b00000100;
	IN   R30,0x15
	LDI  R31,0
	ANDI R30,LOW(0xFFFB)
	OUT  0x15,R30
;}
;}
_0xAF:
;}
_0xAD:
	RET
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0018 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
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
; 0000 0019 IR();
	RCALL _IR
; 0000 001A if (IR_1==0){
	SBRC R2,1
	RJMP _0xB0
; 0000 001B Dig();
	RCALL _Dig
; 0000 001C Time1();
	RCALL _Time1
; 0000 001D Beep();
	RCALL _Beep
; 0000 001E }
; 0000 001F }
_0xB0:
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
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0021 {
_timer1_ovf_isr:
; 0000 0022 
; 0000 0023 
; 0000 0024 }
	RETI
;
;// Declare your global variables here
;void main(void)   // в этом проэкте  PB - "+", PD 7,6,5 - "-", PC0 - IR, PC1 - Temp;PD2,3 -EL;
; 0000 0028 {
_main:
; 0000 0029 
; 0000 002A PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 002B DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 002C PORTC=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002D DDRC=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 002E PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 002F DDRD=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 0030 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0031 
; 0000 0032 /*!!!!!!!!!!!!!!!!!!!!!!!!!!!
; 0000 0033 UCSRA=0x00;
; 0000 0034 UCSRB=0x18;
; 0000 0035 UCSRC=0x86;
; 0000 0036 UBRRH=0x00;
; 0000 0037 UBRRL=0x33;
; 0000 0038 */
; 0000 0039 
; 0000 003A TIMSK|=0x01; //Timer0
	IN   R30,0x39
	LDI  R31,0
	ORI  R30,1
	OUT  0x39,R30
; 0000 003B //TIMSK|=0x40; //Timer2
; 0000 003C //TIMSK|=0x04; //Timer1
; 0000 003D 
; 0000 003E 
; 0000 003F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0040 ADMUX=0b00000001;
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0041 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0042 
; 0000 0043 #asm("sei")
	sei
; 0000 0044 
; 0000 0045 while (1)
_0xB1:
; 0000 0046 {
; 0000 0047 
; 0000 0048 #include <While.c>
;if ((U8==3)&&(U10==0)){
	LDS  R26,_U8
	CPI  R26,LOW(0x3)
	BRNE _0xB5
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
;adc1 = 255-62-read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R31,0
	LDI  R26,LOW(193)
	LDI  R27,HIGH(193)
	RCALL __SWAPW12
	SUB  R30,R26
	STS  _adc1,R30
;U10=1;
	SET
	BLD  R2,0
;}
;
;//adc1 = 255-read_adc(1);}
;
;if ((PINC.0==0)&&(PWM_Susp==1)&&(IR_S==0))
_0xB4:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB8
	LDS  R26,_PWM_Susp
	CPI  R26,LOW(0x1)
	BRNE _0xB8
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
;{
;IR_1=1;
	SET
	BLD  R2,1
;//if(IR_Tr==0){IR_1=1;}
;//if(IR_Tr==1){IR_2=1;}
;}
;
; 0000 0049 
; 0000 004A }
_0xB7:
	RJMP _0xB1
; 0000 004B }
_0xBA:
	RJMP _0xBA

	.CSEG

	.DSEG

	.CSEG
_rand:
	LDS  R30,__seed_G100
	LDS  R31,__seed_G100+1
	LDS  R22,__seed_G100+2
	LDS  R23,__seed_G100+3
	__GETD2N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G100,R30
	STS  __seed_G100+1,R31
	STS  __seed_G100+2,R22
	STS  __seed_G100+3,R23
	movw r30,r22
	andi r31,0x7F
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_d:
	.BYTE 0x2
_d1:
	.BYTE 0x2
_d2:
	.BYTE 0x2
_d3:
	.BYTE 0x2
_bit1:
	.BYTE 0x1
_bit0:
	.BYTE 0x1
_shiftd:
	.BYTE 0x1
_Check_1:
	.BYTE 0x1
_adress2:
	.BYTE 0x1
_adress3:
	.BYTE 0x1
_adress4:
	.BYTE 0x1
_adress7:
	.BYTE 0x1
_FreqT:
	.BYTE 0x1
_U1:
	.BYTE 0x1
_U2:
	.BYTE 0x20
_sig1:
	.BYTE 0x20
_U3:
	.BYTE 0x1
_Timer_3:
	.BYTE 0x2
_Timer_9:
	.BYTE 0x2
_Number:
	.BYTE 0x6
_Timefreq:
	.BYTE 0x2
_U4:
	.BYTE 0x1
_bitEr1:
	.BYTE 0x1
_bitEr0:
	.BYTE 0x1
_Timer_1:
	.BYTE 0x1
_Timer_2:
	.BYTE 0x1
_Timer_4:
	.BYTE 0x1
_Timer_7:
	.BYTE 0x1
_Timer_8:
	.BYTE 0x1
_n:
	.BYTE 0x1
_n1:
	.BYTE 0xFF
_n2:
	.BYTE 0x1
_IR_Tr:
	.BYTE 0x1
_PWM_Susp:
	.BYTE 0x1
_Clock_Susp:
	.BYTE 0x1
_U8:
	.BYTE 0x1
_U9:
	.BYTE 0x1
_Bee:
	.BYTE 0x1
_Dig1:
	.BYTE 0x1
_Dig2:
	.BYTE 0x1
_Num2:
	.BYTE 0x3
_l_up:
	.BYTE 0x1
_l_dwn:
	.BYTE 0x1
_dig_a:
	.BYTE 0x1
_dig_b:
	.BYTE 0x1
_dig_c:
	.BYTE 0x1
_adc1:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
_p_S1030024:
	.BYTE 0x2

	.CSEG

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

;END OF CODE MARKER
__END_OF_CODE:
