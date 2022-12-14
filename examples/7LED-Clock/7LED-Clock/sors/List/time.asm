
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
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
	.DEF _sek=R5
	.DEF _min=R4
	.DEF _hour=R7
	.DEF _Disp6=R6
	.DEF _Disp7=R9

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
;#include <delay.h>        // ?????????? ?????????? ????????
;
; unsigned char sek;        // ?????????? ???.
; unsigned char min;        // ?????????? ???.
; unsigned char hour;       // ?????????? ?????
; unsigned char Dig[10];
; char Disp6, Disp7;
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)  // ?????? ????????? ?? ??????? 1 ??
; 0000 000C {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 000D // Place your code here
; 0000 000E        TCNT1H=0;
	RCALL SUBOPT_0x0
; 0000 000F        TCNT1L=0;
; 0000 0010        sek++;                // ?????????????? ???????
	INC  R5
; 0000 0011        PORTD=128;
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 0012        PORTB=253;         // ??????? ?????
	LDI  R30,LOW(253)
	OUT  0x18,R30
; 0000 0013 
; 0000 0014       // ???????? ? ????????
; 0000 0015   if (PINC.0==0) // ???? ?????? ?????? ??????
	SBIS 0x13,0
; 0000 0016   {
; 0000 0017   hour++; // ? ???????? ???? ????????? ???????
	INC  R7
; 0000 0018   }
; 0000 0019   if (PINC.1==0) // ???? ?????? ?????? ??????
	SBIS 0x13,1
; 0000 001A   {
; 0000 001B   hour--; // ? ???????? ???? ???????? ??????? ?
	DEC  R7
; 0000 001C   }
; 0000 001D   if (PINC.2==0) // ???? ?????? ?????? ??????
	SBIS 0x13,2
; 0000 001E   {
; 0000 001F   min++; // ? ???????? ?????? ????????? ???????
	INC  R4
; 0000 0020   }
; 0000 0021   if (PINC.3==0) // ???? ?????? ????????? ??????
	SBIS 0x13,3
; 0000 0022   {
; 0000 0023   min--; // ? ???????? ?????? ???????? ???????
	DEC  R4
; 0000 0024   }
; 0000 0025   if (PINC.4==0) // ?????? RESET
	SBIS 0x13,4
; 0000 0026   {
; 0000 0027   sek=0;
	CLR  R5
; 0000 0028   }
; 0000 0029 
; 0000 002A 
; 0000 002B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;
;void Display (unsigned int Number) //?-??? ??? ?????????? ??????????? ?????
; 0000 0030 {
_Display:
; 0000 0031   unsigned char Num2, Num3;
; 0000 0032   Num2=0;
	RCALL __SAVELOCR2
;	Number -> Y+2
;	Num2 -> R17
;	Num3 -> R16
	LDI  R17,LOW(0)
; 0000 0033   while (Number >= 10)   //??????????
_0x8:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,10
	BRLO _0xA
; 0000 0034   {
; 0000 0035     Number -= 10;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,10
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0036     Num2++;
	SUBI R17,-1
; 0000 0037   }
	RJMP _0x8
_0xA:
; 0000 0038   Num3 = Number;    //???????
	LDD  R16,Y+2
; 0000 0039   Disp6 = Dig[Num2];
	MOV  R30,R17
	RCALL SUBOPT_0x1
	LD   R6,Z
; 0000 003A   Disp7 = Dig[Num3];
	MOV  R30,R16
	RCALL SUBOPT_0x1
	LD   R9,Z
; 0000 003B }
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
;void Dig_init() //?????? ??? ??????????? ???? ?? ?????????????? ??????????
; 0000 003D {
_Dig_init:
; 0000 003E   Dig[0] = 95;   // ?????? ? ??? ????? ? ????? ???????
	LDI  R30,LOW(95)
	STS  _Dig,R30
; 0000 003F   Dig[1] = 24;
	LDI  R30,LOW(24)
	__PUTB1MN _Dig,1
; 0000 0040   Dig[2] = 109;
	LDI  R30,LOW(109)
	__PUTB1MN _Dig,2
; 0000 0041   Dig[3] = 124;
	LDI  R30,LOW(124)
	__PUTB1MN _Dig,3
; 0000 0042   Dig[4] = 58;
	LDI  R30,LOW(58)
	__PUTB1MN _Dig,4
; 0000 0043   Dig[5] = 118;
	LDI  R30,LOW(118)
	__PUTB1MN _Dig,5
; 0000 0044   Dig[6] = 119;
	LDI  R30,LOW(119)
	__PUTB1MN _Dig,6
; 0000 0045   Dig[7] = 28;
	LDI  R30,LOW(28)
	__PUTB1MN _Dig,7
; 0000 0046   Dig[8] = 127;
	LDI  R30,LOW(127)
	__PUTB1MN _Dig,8
; 0000 0047   Dig[9] = 126;
	LDI  R30,LOW(126)
	__PUTB1MN _Dig,9
; 0000 0048 }
	RET
;
;void main(void)
; 0000 004B {
_main:
; 0000 004C // Declare your local variables here
; 0000 004D 
; 0000 004E // Input/Output Ports initialization
; 0000 004F // Port B initialization
; 0000 0050 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0051 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0052 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0053 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0054 
; 0000 0055 // Port C initialization
; 0000 0056 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0057 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0058 PORTC=0xFF;
	OUT  0x15,R30
; 0000 0059 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 005A 
; 0000 005B // Port D initialization
; 0000 005C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005E PORTD=0x00;
	OUT  0x12,R30
; 0000 005F DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0060 
; 0000 0061 // Timer/Counter 0 initialization
; 0000 0062 // Clock source: System Clock
; 0000 0063 // Clock value: Timer 0 Stopped
; 0000 0064 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0065 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 1 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: 7,813 kHz
; 0000 006A // Mode: Normal top=FFFFh
; 0000 006B // OC1A output: Discon.
; 0000 006C // OC1B output: Discon.
; 0000 006D // Noise Canceler: Off
; 0000 006E // Input Capture on Falling Edge
; 0000 006F // Timer 1 Overflow Interrupt: Off
; 0000 0070 // Input Capture Interrupt: Off
; 0000 0071 // Compare A Match Interrupt: On
; 0000 0072 // Compare B Match Interrupt: Off
; 0000 0073 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0074 TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0075 TCNT1H=0x00;
	RCALL SUBOPT_0x0
; 0000 0076 TCNT1L=0x00;
; 0000 0077 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0078 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0079 OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
; 0000 007A OCR1AL=0x85;
	LDI  R30,LOW(133)
	OUT  0x2A,R30
; 0000 007B OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 007C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 007D 
; 0000 007E // Timer/Counter 2 initialization
; 0000 007F // Clock source: System Clock
; 0000 0080 // Clock value: Timer 2 Stopped
; 0000 0081 // Mode: Normal top=FFh
; 0000 0082 // OC2 output: Disconnected
; 0000 0083 ASSR=0x00;
	OUT  0x22,R30
; 0000 0084 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0085 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0086 OCR2=0x00;
	OUT  0x23,R30
; 0000 0087 
; 0000 0088 // External Interrupt(s) initialization
; 0000 0089 // INT0: Off
; 0000 008A // INT1: Off
; 0000 008B MCUCR=0x00;
	OUT  0x35,R30
; 0000 008C 
; 0000 008D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 008E TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 008F 
; 0000 0090 // Analog Comparator initialization
; 0000 0091 // Analog Comparator: Off
; 0000 0092 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0093 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0094 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0095 
; 0000 0096 // LCD module initialization
; 0000 0097 
; 0000 0098 
; 0000 0099 // Global enable interrupts
; 0000 009A #asm("sei")
	sei
; 0000 009B Dig_init(); //????????????? ??????? ? ???????? ?????
	RCALL _Dig_init
; 0000 009C while (1)
_0xB:
; 0000 009D       {///// ??????? ?????.
; 0000 009E        if(sek==60)          // ???? ??? = 60
	LDI  R30,LOW(60)
	CP   R30,R5
	BRNE _0xE
; 0000 009F        {
; 0000 00A0        min++;              // ????????? 1 ? ?????????? "??????"
	INC  R4
; 0000 00A1        sek=0;              // ???????? ?????????? "???????"
	CLR  R5
; 0000 00A2        }
; 0000 00A3        if(min==60)         // ???? ??? = 60
_0xE:
	LDI  R30,LOW(60)
	CP   R30,R4
	BRNE _0xF
; 0000 00A4        {
; 0000 00A5        hour++;             // ????????? 1 ? ?????????? "???"
	INC  R7
; 0000 00A6        min=0;              // ???????? ?????????? "??????"
	CLR  R4
; 0000 00A7        }
; 0000 00A8        if (hour==24)        // ??? ??? ? ??? ???? ????? 24 ??????? ??????
_0xF:
	LDI  R30,LOW(24)
	CP   R30,R7
	BRNE _0x10
; 0000 00A9        {                    // ??? ?????????? 24 ?????, ????????? ??? ??????????.
; 0000 00AA        hour=0;
	CLR  R7
; 0000 00AB        min=0;
	CLR  R4
; 0000 00AC        sek=0;
	CLR  R5
; 0000 00AD        }
; 0000 00AE          // ?????? ???????????? ??????????, ??? ????? ??? ???? ????? ? ???????? ????? ????? ?? ?????????? ? ?????.
; 0000 00AF   if (hour==255)
_0x10:
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x11
; 0000 00B0   hour=0;
	CLR  R7
; 0000 00B1   if (min==255)
_0x11:
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x12
; 0000 00B2   min=0;
	CLR  R4
; 0000 00B3          // ??????? ?????????? (?????????????)
; 0000 00B4         Display(hour); //????????? "????" ?? 2 ????? ? ?????????? ?? ???????
_0x12:
	MOV  R30,R7
	RCALL SUBOPT_0x2
; 0000 00B5          PORTB=254;    //???? ??? 0 ??? ?????? 1 ???????
	LDI  R30,LOW(254)
	RCALL SUBOPT_0x3
; 0000 00B6          PORTD=Disp6;  //1 ?????
; 0000 00B7         delay_ms(5);
; 0000 00B8          PORTB=253;    //???? ??? 0 ??? ?????? 2 ???????
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x4
; 0000 00B9         PORTD=Disp7;   //2 ?????
; 0000 00BA         delay_ms(5);
; 0000 00BB          Display(min);  //????????? "??????" ?? 2 ????? ? ?????????? ?? ???????
	MOV  R30,R4
	RCALL SUBOPT_0x2
; 0000 00BC         PORTB=251;      //???? ??? 0 ??? ?????? 3 ???????
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x3
; 0000 00BD         PORTD=Disp6;  //3 ?????
; 0000 00BE         delay_ms(5);
; 0000 00BF          PORTB=247;    //???? ??? 0 ??? ?????? 4 ???????
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x4
; 0000 00C0         PORTD=Disp7;   //4...
; 0000 00C1         delay_ms(5);
; 0000 00C2       };
	RJMP _0xB
; 0000 00C3 }
_0x13:
	RJMP _0x13

	.DSEG
_Dig:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R31,0
	SUBI R30,LOW(-_Dig)
	SBCI R31,HIGH(-_Dig)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP _Display

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	OUT  0x18,R30
	OUT  0x12,R6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	OUT  0x18,R30
	OUT  0x12,R9
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms


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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
