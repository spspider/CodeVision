
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 1,000000 MHz
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
	.DEF _disable_count=R5
	.DEF _mini_stand_by=R4
	.DEF _Count=R7
	.DEF _alarm=R6
	.DEF _Timer_1=R9
	.DEF _Timer_2=R8
	.DEF _Count_1=R11
	.DEF _pressed=R10
	.DEF _Timer_wrong_pressed_enable=R13
	.DEF _Timer_3=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
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

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3)
_0x3F:
	.DB  0x0,0x0,0x0
_0x0:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x03
	.DW  0x05
	.DW  _0x3F*2

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
;Date    : 18.04.2013
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
;//#include <stdio.h>
;////////
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
;//#include <sleep.h>
;#include <adc.c>
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;/*
;unsigned int read_adc(unsigned char adc_input)
;{
;ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;// Delay needed for the stabilization of the ADC input voltage
;//delay_us(10);
;// Start the AD conversion
;ADCSRA|=0x40;
;// Wait for the AD conversion to complete
;while ((ADCSRA & 0x10)==0);
;ADCSRA|=0x10;
;return ADCW;
;}
;*/
;//#include <lcd.h>
;#include <interrupt.c>
;unsigned char disable_count=0,mini_stand_by,Count=0,alarm=0,Timer_1,Timer_2,Count_1,
;pressed,Timer_wrong_pressed_enable,Timer_3,Timer_6,delay_after_alarm,Timer_4_ext,Timer_4,
;shadow=0,Timer_signal_sinus,Timer_signal_sinus_enabled,alarm_recieved,
;Count_this_event=0;
;unsigned int stand_by=0, Timer_wrong_pressed,Timer_if_long_pressed;
;//unsigned int voltage,Show_voltage;
;//unsigned char Show_voltage_start,Timer_end_show_voltage;
;//unsigned char U1,U3,U2[2],current_level[2],Timer_4;
;
;unsigned char already_enabled=0,Prev_Timer_signal_sinus=0;
;char *word="";

	.DSEG
_0x3:
	.BYTE 0x1
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 001E {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;//PORTD=0b00010000;
;
;if ((disable_count==0)&&(alarm==0)&&(Count==0)&&(stand_by==0)&&(Timer_wrong_pressed_enable==0)){  //если ничего нет, то
	LDI  R30,LOW(0)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x6
	CP   R30,R6
	BREQ PC+2
	RJMP _0x6
	CP   R30,R7
	BREQ PC+2
	RJMP _0x6
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x6
	LDI  R30,LOW(0)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x6
	RJMP _0x7
_0x6:
	RJMP _0x5
_0x7:
;Timer_4_ext++;
	LDS  R30,_Timer_4_ext
	SUBI R30,-LOW(1)
	STS  _Timer_4_ext,R30
;if (Timer_4_ext==200){
	LDS  R26,_Timer_4_ext
	CPI  R26,LOW(0xC8)
	BREQ PC+2
	RJMP _0x8
;Timer_4++;}
	LDS  R30,_Timer_4
	SUBI R30,-LOW(1)
	STS  _Timer_4,R30
;if (Timer_4>=10){
_0x8:
	LDS  R26,_Timer_4
	CPI  R26,LOW(0xA)
	BRSH PC+2
	RJMP _0x9
;    PORTD^=0b00100001;//то мигаем
	RCALL SUBOPT_0x1
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	RCALL SUBOPT_0x2
;    Timer_4=0;
	LDI  R30,LOW(0)
	STS  _Timer_4,R30
;
;}
;
;//пропадание питания на ножке PIND.3
;if ((PIND.3==0)&&(stand_by==0)&&(Count_this_event<3)){  //на ножке ноль, не активно, и счет не больше 2х
_0x9:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ PC+2
	RJMP _0xB
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0xB
	LDS  R26,_Count_this_event
	CPI  R26,LOW(0x3)
	BRLO PC+2
	RJMP _0xB
	RJMP _0xC
_0xB:
	RJMP _0xA
_0xC:
;Count_this_event++;//считаем сколько раз мы уже пропадание мигали, что бы не заходил в цикл
	LDS  R30,_Count_this_event
	SUBI R30,-LOW(1)
	STS  _Count_this_event,R30
;alarm=1;       //сигнал
	LDI  R30,LOW(1)
	MOV  R6,R30
;shadow=1;
	STS  _shadow,R30
;Count=0;
	CLR  R7
;stand_by=20000;//ожидание
	LDI  R30,LOW(20000)
	LDI  R31,HIGH(20000)
	RCALL SUBOPT_0x3
;//power off
;}
;if ((Count_this_event>=2)&&(PIND.3==1)){
_0xA:
	LDS  R26,_Count_this_event
	CPI  R26,LOW(0x2)
	BRSH PC+2
	RJMP _0xE
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xE
	RJMP _0xF
_0xE:
	RJMP _0xD
_0xF:
;shadow=0;
	LDI  R30,LOW(0)
	STS  _shadow,R30
;Count_this_event=0;}
	STS  _Count_this_event,R30
;
;}
_0xD:
;
;
;
;
;
;if ((Timer_wrong_pressed>6000)&&(stand_by==0)){//если срабатывали другие нажатия
_0x5:
	LDS  R26,_Timer_wrong_pressed
	LDS  R27,_Timer_wrong_pressed+1
	CPI  R26,LOW(0x1771)
	LDI  R30,HIGH(0x1771)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x11
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x11
	RJMP _0x12
_0x11:
	RJMP _0x10
_0x12:
;PORTD&=~0b00100000;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xFFDF)
	OUT  0x12,R30
;
;disable_count=Count=Timer_wrong_pressed=0;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	MOV  R7,R30
	MOV  R5,R30
;Timer_wrong_pressed_enable=0;
	CLR  R13
;}
;
;if (Timer_wrong_pressed_enable==1){
_0x10:
	LDI  R30,LOW(1)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x13
;Timer_wrong_pressed++;
	LDI  R26,LOW(_Timer_wrong_pressed)
	LDI  R27,HIGH(_Timer_wrong_pressed)
	RCALL SUBOPT_0x6
;}
;////////////////////
;
;//PORTD^=0b00000001;
;////////////////////
;if (PIND.2==1){
_0x13:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x14
;
;    if (already_enabled==0){
	LDS  R30,_already_enabled
	CPI  R30,0
	BREQ PC+2
	RJMP _0x15
;    //if (Prev_Timer_signal_sinus!=0){
;    //printf("%u-%u \n",Timer_signal_sinus,Prev_Timer_signal_sinus);
;        if(Prev_Timer_signal_sinus-Timer_signal_sinus>20){
	LDS  R26,_Prev_Timer_signal_sinus
	CLR  R27
	LDS  R30,_Timer_signal_sinus
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	SBIW R26,21
	BRGE PC+2
	RJMP _0x16
;            alarm_recieved=1;
	LDI  R30,LOW(1)
	STS  _alarm_recieved,R30
;            disable_count=0;
	CLR  R5
;            //stand_by=10;
;            //printf("  #######");
;            //printf("%u-%u \n",Timer_signal_sinus,Prev_Timer_signal_sinus);
;            Timer_if_long_pressed=0;
	RCALL SUBOPT_0x7
;            Timer_signal_sinus=0;
	LDI  R30,LOW(0)
	STS  _Timer_signal_sinus,R30
;        //}
;
;        }
;    //if(Timer_signal_sinus!=0){
;    Prev_Timer_signal_sinus=Timer_signal_sinus;Timer_signal_sinus=0;
_0x16:
	LDS  R30,_Timer_signal_sinus
	STS  _Prev_Timer_signal_sinus,R30
	LDI  R30,LOW(0)
	STS  _Timer_signal_sinus,R30
;    //}
;
;
;    Timer_signal_sinus_enabled=1;
	LDI  R30,LOW(1)
	STS  _Timer_signal_sinus_enabled,R30
;    already_enabled=1;
	STS  _already_enabled,R30
;    }
;
;Timer_signal_sinus_enabled=1;
_0x15:
	LDI  R30,LOW(1)
	STS  _Timer_signal_sinus_enabled,R30
;
;
;if ((alarm==0)&&(stand_by==0)){
	LDI  R30,LOW(0)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x18
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x18
	RJMP _0x19
_0x18:
	RJMP _0x17
_0x19:
;    Timer_if_long_pressed++;
	LDI  R26,LOW(_Timer_if_long_pressed)
	LDI  R27,HIGH(_Timer_if_long_pressed)
	RCALL SUBOPT_0x6
;        if (Timer_if_long_pressed>2000){//если зарегестрированно более 2000 прерываний
	LDS  R26,_Timer_if_long_pressed
	LDS  R27,_Timer_if_long_pressed+1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x1A
;        PORTD|=0b00100000;
	RCALL SUBOPT_0x1
	ORI  R30,0x20
	OUT  0x12,R30
;        Count=0;
	CLR  R7
;        alarm=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;        stand_by=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x3
;        }
;    }
_0x1A:
;}
_0x17:
;
;//if(Timer_signal_sinus_enabled==1){
;if (Timer_signal_sinus<254){
_0x14:
	LDS  R26,_Timer_signal_sinus
	CPI  R26,LOW(0xFE)
	BRLO PC+2
	RJMP _0x1B
;Timer_signal_sinus++;}
	LDS  R30,_Timer_signal_sinus
	SUBI R30,-LOW(1)
	STS  _Timer_signal_sinus,R30
;//}
;//if (Timer_signal_sinus>250){Timer_signal_sinus=0;alarm_recieved=0;Timer_signal_sinus_enabled=0;}
;/*
;if (PIND.2==0){
;
;    if (Timer_signal_sinus>40){//40 - пауза после появления нуля, чем больше, тем меньше интервал между паузами
;    alarm_recieved=1;
;
;    disable_count=0;
;    Timer_if_long_pressed=0;
;
;    }
;    if (Timer_signal_sinus>41){//далее обнуляем, что бы симмулировать счет
;    alarm_recieved=0;
;    Timer_signal_sinus_enabled=0;
;    Timer_signal_sinus=0;
;
;
;    }
;
;}
;*/
;///////
;if (PIND.2==0){
_0x1B:
	SBIC 0x10,2
	RJMP _0x1C
;already_enabled=0;
	LDI  R30,LOW(0)
	STS  _already_enabled,R30
;Timer_if_long_pressed=0;
	RCALL SUBOPT_0x7
;disable_count=0;
	CLR  R5
;}
;///////
;
;if ((alarm_recieved==1)&&(alarm==0)&&(stand_by==0)) {//если есть сигнал, сигнал еще не срабатывал, сигналка не включена
_0x1C:
	LDS  R26,_alarm_recieved
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x1E
	LDI  R30,LOW(0)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x1E
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x1E
	RJMP _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
;alarm_recieved=0;
	LDI  R30,LOW(0)
	STS  _alarm_recieved,R30
;if (disable_count==0){
	TST  R5
	BREQ PC+2
	RJMP _0x20
;    disable_count=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;    Timer_wrong_pressed_enable=1;
	MOV  R13,R30
;    Timer_wrong_pressed=0;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
;    PORTD|=0b00100000;
	RCALL SUBOPT_0x1
	ORI  R30,0x20
	OUT  0x12,R30
;
;    //lcd_gotoxy(0, 0); // Переводим курсор на первый символ первой строки
;    //lcd_clear();
;    //lcd_puts(word);
;
;     //показывает найденное напряжение//   PORTD|=0b00100000;
;    Count++;
	INC  R7
;    stand_by=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x3
;        if (Count==5){
	LDI  R30,LOW(5)
	CP   R30,R7
	BREQ PC+2
	RJMP _0x21
;        Count=0;
	CLR  R7
;        alarm=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;        }
;}
_0x21:
;
;
;}
_0x20:
;
;
;if((PIND.2==0)&&(stand_by==0)){
_0x1D:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ PC+2
	RJMP _0x23
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x23
	RJMP _0x24
_0x23:
	RJMP _0x22
_0x24:
;
;}
;
;if (alarm==1){ //сигнализация сработала
_0x22:
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x25
;Timer_1++;
	INC  R9
;if (pressed==0){
	TST  R10
	BREQ PC+2
	RJMP _0x26
;if (shadow==0){
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x27
;PORTD|=0b10010000;
	RCALL SUBOPT_0x1
	ORI  R30,LOW(0x90)
	OUT  0x12,R30
;PORTC|=0b00000100;//запись видеорегистратора
	IN   R30,0x15
	LDI  R31,0
	ORI  R30,4
	OUT  0x15,R30
;}
;else{
	RJMP _0x28
_0x27:
;PORTD|=0b00010000;
	RCALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x12,R30
;}
_0x28:
;//DDRD|=0b00010000;
;pressed=1;}
	LDI  R30,LOW(1)
	MOV  R10,R30
;
;
;if (Timer_1>250){
_0x26:
	LDI  R30,LOW(250)
	CP   R30,R9
	BRLO PC+2
	RJMP _0x29
;Timer_2++;
	INC  R8
;Timer_1=0;
	CLR  R9
;}
;
;if (Timer_2>10){
_0x29:
	LDI  R30,LOW(10)
	CP   R30,R8
	BRLO PC+2
	RJMP _0x2A
;
;if (shadow==0){
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x2B
;    PORTD^=0b10010000;//включаем второе нажатие
	RCALL SUBOPT_0x1
	LDI  R26,LOW(144)
	LDI  R27,HIGH(144)
	RCALL SUBOPT_0x2
;    }
;    else{
	RJMP _0x2C
_0x2B:
;    PORTD^=0b00010000;//включаем второе нажатие
	RCALL SUBOPT_0x1
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RCALL SUBOPT_0x2
;    }
_0x2C:
;    //DDRD^=0b00010000;
;    Timer_2=0;
	CLR  R8
;    Count_1++;
	INC  R11
;}
;if (Count_1>2){
_0x2A:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRLO PC+2
	RJMP _0x2D
;if (shadow==0){
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x2E
;PORTD&=~0b10010000;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xFF6F)
	OUT  0x12,R30
;}
;else{
	RJMP _0x2F
_0x2E:
;PORTD&=~0b00010000;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xFFEF)
	OUT  0x12,R30
;}
_0x2F:
;//DDRD&=~0b00001000;
;Count_1=0;
	CLR  R11
;pressed=0;
	CLR  R10
;
;//stand_by=20000;
;alarm=0;
	CLR  R6
;delay_after_alarm=1;
	LDI  R30,LOW(1)
	STS  _delay_after_alarm,R30
;}
;
;
;}
_0x2D:
;if (mini_stand_by>0){
_0x25:
	LDI  R30,LOW(0)
	CP   R30,R4
	BRLO PC+2
	RJMP _0x30
;mini_stand_by--;
	DEC  R4
;}
;if (mini_stand_by==2){
_0x30:
	LDI  R30,LOW(2)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x31
;stand_by=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x3
;}
;if (stand_by>0){
_0x31:
	LDS  R26,_stand_by
	LDS  R27,_stand_by+1
	RCALL __CPW02
	BRLO PC+2
	RJMP _0x32
;Timer_3++;
	INC  R12
;    if (Timer_3>5){
	LDI  R30,LOW(5)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x33
;        if (delay_after_alarm==1){
	LDS  R26,_delay_after_alarm
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x34
;        Timer_6++;
	LDS  R30,_Timer_6
	SUBI R30,-LOW(1)
	STS  _Timer_6,R30
;            if (Timer_6==20){
	LDS  R26,_Timer_6
	CPI  R26,LOW(0x14)
	BREQ PC+2
	RJMP _0x35
;            PORTD^=0b00100000;
	RCALL SUBOPT_0x1
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RCALL SUBOPT_0x2
;            Timer_6=0;
	LDI  R30,LOW(0)
	STS  _Timer_6,R30
;            }
;        }
_0x35:
;    stand_by--;
_0x34:
	LDI  R26,LOW(_stand_by)
	LDI  R27,HIGH(_stand_by)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
;    Timer_3=0;
	CLR  R12
;    }
;   }
_0x33:
;if ((stand_by==0)&&(delay_after_alarm==1)){
_0x32:
	RCALL SUBOPT_0x0
	BREQ PC+2
	RJMP _0x37
	LDS  R26,_delay_after_alarm
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x37
	RJMP _0x38
_0x37:
	RJMP _0x36
_0x38:
;delay_after_alarm=0;
	LDI  R30,LOW(0)
	STS  _delay_after_alarm,R30
;}
;
;// Place your code here
;
;}
_0x36:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;#asm

   .equ __lcd_port=0x18 ;PORTB

; 0000 0027 #endasm  // Инициализируем PORTB как порт ЖКИ
;
;//////
;// Timer 0 overflow interrupt service routine
;
;
;// Declare your global variables here
;// Выход из спящего режима и обработка внешнего прерывания INT0
; interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0030  {
_ext_int0_isr:
; 0000 0031  //MCUCR&=~0b00001000;
; 0000 0032  //sleep_disable();
; 0000 0033  }
	RETI
;
;void main(void)
; 0000 0036 {
_main:
; 0000 0037 // Declare your local variables here
; 0000 0038 
; 0000 0039 // Input/Output Ports initialization
; 0000 003A // Port B initialization
; 0000 003B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 003C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 003D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 003E DDRB=0b00000000;
	OUT  0x17,R30
; 0000 003F 
; 0000 0040 // Port C initialization
; 0000 0041 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0042 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0043 PORTC=0x00;
	OUT  0x15,R30
; 0000 0044 DDRC=0b10000111;
	LDI  R30,LOW(135)
	OUT  0x14,R30
; 0000 0045 
; 0000 0046 // Port D initialization
; 0000 0047 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0048 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0049 PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 004A DDRD=0b10111101;//0,1 - передача, примем; 2-вход поворотника;3-выход на зарядку;4-кнопка ганритуры(нв ноль) 5- светодиод статуса,7- светодиод включения звонка
	LDI  R30,LOW(189)
	OUT  0x11,R30
; 0000 004B 
; 0000 004C // Timer/Counter 0 initialization
; 0000 004D // Clock source: System Clock
; 0000 004E // Clock value: 8000,000 kHz
; 0000 004F TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0050 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0051 
; 0000 0052 // Timer/Counter 1 initialization
; 0000 0053 // Clock source: System Clock
; 0000 0054 // Clock value: Timer 1 Stopped
; 0000 0055 // Mode: Normal top=FFFFh
; 0000 0056 // OC1A output: Discon.
; 0000 0057 // OC1B output: Discon.
; 0000 0058 // Noise Canceler: Off
; 0000 0059 // Input Capture on Falling Edge
; 0000 005A // Timer 1 Overflow Interrupt: Off
; 0000 005B // Input Capture Interrupt: Off
; 0000 005C // Compare A Match Interrupt: Off
; 0000 005D // Compare B Match Interrupt: Off
; 0000 005E TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 005F TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0060 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0061 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0062 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0063 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0064 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0065 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0066 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0067 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0068 
; 0000 0069 // Timer/Counter 2 initialization
; 0000 006A // Clock source: System Clock
; 0000 006B // Clock value: Timer 2 Stopped
; 0000 006C // Mode: Normal top=FFh
; 0000 006D // OC2 output: Disconnected
; 0000 006E ASSR=0x00;
	OUT  0x22,R30
; 0000 006F TCCR2=0x00;
	OUT  0x25,R30
; 0000 0070 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0071 OCR2=0x00;
	OUT  0x23,R30
; 0000 0072 
; 0000 0073 // External Interrupt(s) initialization
; 0000 0074 // INT0: Off
; 0000 0075 // INT1: Off
; 0000 0076 //MCUCR=0x00;
; 0000 0077 
; 0000 0078 //GICR|=0x40;
; 0000 0079 MCUCR=0x30;
	LDI  R30,LOW(48)
	OUT  0x35,R30
; 0000 007A //GIFR=0x40;
; 0000 007B 
; 0000 007C 
; 0000 007D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 007E TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 007F 
; 0000 0080 
; 0000 0081 
; 0000 0082 // USART initialization
; 0000 0083 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0084 // USART Receiver: Off
; 0000 0085 // USART Transmitter: On
; 0000 0086 // USART Mode: Asynchronous
; 0000 0087 // USART Baud Rate: 110
; 0000 0088 /*
; 0000 0089 UCSRA=0x00;
; 0000 008A UCSRB=0x08;
; 0000 008B UCSRC=0x86;
; 0000 008C UBRRH=0x02;
; 0000 008D UBRRL=0x37;
; 0000 008E */
; 0000 008F 
; 0000 0090 //UCSRA=0x00;
; 0000 0091 //UCSRB=0x18;
; 0000 0092 //UCSRC=0x86;
; 0000 0093 //UBRRH=0x00;
; 0000 0094 //UBRRL=0x0C;
; 0000 0095 
; 0000 0096 
; 0000 0097 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0098 DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0099 PORTD.0=1;
	SBI  0x12,0
; 0000 009A //////////////////////
; 0000 009B 
; 0000 009C 
; 0000 009D //lcd_init(16); // Инициализация ЖКИ на 16 символов
; 0000 009E // Analog Comparator initialization
; 0000 009F // Analog Comparator: Off
; 0000 00A0 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00A1 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A2 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A3 // ADC initialization
; 0000 00A4 // ADC Clock frequency: 500,000 kHz
; 0000 00A5 // ADC Voltage Reference: AREF pin
; 0000 00A6 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00A7 ADCSRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 00A8 // Global enable interrupts
; 0000 00A9 #asm("sei")
	sei
; 0000 00AA #asm("sleep")
	sleep
; 0000 00AB while (1)
_0x3B:
; 0000 00AC       {
; 0000 00AD       #include <while.c>
; 0000 00AE 
; 0000 00AF 
; 0000 00B0       // Place your code here
; 0000 00B1 
; 0000 00B2       };
	RJMP _0x3B
_0x3D:
; 0000 00B3 }
_0x3E:
	RJMP _0x3E

	.DSEG
_Timer_6:
	.BYTE 0x1
_delay_after_alarm:
	.BYTE 0x1
_Timer_4_ext:
	.BYTE 0x1
_Timer_4:
	.BYTE 0x1
_shadow:
	.BYTE 0x1
_Timer_signal_sinus:
	.BYTE 0x1
_Timer_signal_sinus_enabled:
	.BYTE 0x1
_alarm_recieved:
	.BYTE 0x1
_Count_this_event:
	.BYTE 0x1
_stand_by:
	.BYTE 0x2
_Timer_wrong_pressed:
	.BYTE 0x2
_Timer_if_long_pressed:
	.BYTE 0x2
_already_enabled:
	.BYTE 0x1
_Prev_Timer_signal_sinus:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
	LDS  R26,_stand_by
	LDS  R27,_stand_by+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1:
	IN   R30,0x12
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	EOR  R30,R26
	EOR  R31,R27
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	STS  _stand_by,R30
	STS  _stand_by+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _Timer_wrong_pressed,R30
	STS  _Timer_wrong_pressed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x4
	STS  _Timer_if_long_pressed,R30
	STS  _Timer_if_long_pressed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDS  R30,_shadow
	CPI  R30,0
	RET


	.CSEG
__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
