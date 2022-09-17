
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
;Promote char to int    : No
;char is unsigned       : Yes
;global const stored in FLASH  : Yes
;8 bit enums            : No
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
	.DEF _OVF_T0=R4
	.DEF _OVF_T1=R6
	.DEF _Ntakt=R8
	.DEF _Mx=R10

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_capt_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x38:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  _0x38*2

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
;Project :
;Version :
;Date    : 25.07.2009
;Author  : F4CG
;Company : F4CG
;Comments:
;
;
;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 8.000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega8.h>   //Подключение
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
;#include <stdio.h>   //           внешнх
;#include <delay.h>   //                  библиотек
;
;
;#define   ON_LED1      (PORTB = 0b00000010)
;#define   ON_LED2      (PORTB = 0b00000110)
;#define   ON_LED3      (PORTB = 0b00001110)
;#define   ON_LED4      (PORTB = 0b00011110)
;#define   ON_LED5      (PORTB = 0b00111110)
;//#define   ON_LED6      (PORTB = 0b01111110)
;//#define   ON_LED7      (PORTB = 0b11111110)
;
;#define   ON_LED6      (PORTB = 0b00111110) | (PORTC = 0b00000001)
;#define   ON_LED7      (PORTB = 0b00111110) | (PORTC = 0b00000011)
;#define   ON_LED8      (PORTB = 0b00111110) | (PORTC = 0b00000111)
;#define   ON_LED9      (PORTB = 0b00111110) | (PORTC = 0b00001111)
;#define   ON_LED10     (PORTB = 0b00111110) | (PORTC = 0b00011111)
;
;#define   ON_LED11     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000001)
;#define   ON_LED12     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000011)
;#define   ON_LED13     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00000111)
;#define   ON_LED14     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00001111)
;#define   ON_LED15     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b00101111)
;#define   ON_LED16     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b01101111)
;#define   ON_LED17     (PORTB = 0b00111110) | (PORTC = 0b00011111) | (PORTD = 0b11101111)
;
;#define   OFF_LEDS     (PORTB = 0) | (PORTC = 0) | (PORTD = 0)
;
;/***** Назначение портов ввода вывода ****************************
; ---------------------------------------------------------------------------------------------------
;  PORTB
;    PB0 (14) - Цифровой вход захвата ICP измеряемая частота
;    PB1 (15) - Цифровой выход на подсветку
;    PB2 (16) - Цифровой выход
;    PB3 (17) - Цифровой выход
;    PB4 (18) - Цифровой выход
;    PB5 (19) - Цифровой выход
;    PB6 (9)  - Для кварца
;    PB7 (10) - Для кварца
;  PORTC
;    PC0 (23) - Цифровой выход
;    PC1 (24) - Цифровой выход
;    PC2 (25) - Цифровой выход
;    PC3 (26) - Цифровой выход
;    PC4 (27) - Цифровой выход
;    PC5 (28) - Цифровой вход  измерения напряжения
;    PC6 (1)  -
;  PORTD
;    PD0 (2 ) - Цифровой выход
;    PD1 (3 ) - Цифровой выход
;    PD2 (4 ) - Цифровой выход
;    PD3 (5 ) - Цифровой выход
;    PD4 (6 ) - Цифровой вход измеряемая частота
;    PD5 (11) - Цифровой выход
;    PD6 (12) - Цифровой выход
;    PD7 (13) - Цифровой выход
;*************************************************************************/
;
;//Объвление переменных
;float Fx;
;
;unsigned long int N0, M0;
;
;unsigned long int N, M;                       // количество импульсов за время измерения
;
;unsigned int OVF_T0=0, OVF_T1=0;
;
;unsigned int Ntakt, Mx;                       // количество тиков тактовой и измеряемой частоты
;
;//Прерывание по переполнению Timer/Counter 0
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 005A {

	.CSEG
_timer0_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 005B OVF_T0++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 005C }
	RJMP _0x37
;
;//Прерывание по переполнению Timer/Counter 1
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0060 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 0061 OVF_T1++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0062 }
_0x37:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;//Прерывание по захвату Timer/Counter 1
;interrupt [TIM1_CAPT] void timer1_capt_isr(void)
; 0000 0066 {
_timer1_capt_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0067 Mx=TCNT0;                                     // Значение регистра TCNT0 переписывается в переменную
	IN   R10,50
	CLR  R11
; 0000 0068 
; 0000 0069 Ntakt=ICR1;                                   // Значение регистра ICR1 переписывается в переменную
	__INWR 8,9,38
; 0000 006A 
; 0000 006B TIMSK&=0xDF;                                  // Запрет прерывания по захвату
	IN   R30,0x39
	ANDI R30,0xDF
	OUT  0x39,R30
; 0000 006C   }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;
;/********************** Основная программа ******************************/
;
;void main(void)
; 0000 0072 {
_main:
; 0000 0073 
; 0000 0074 /************ Инициализация портов ввода-ввывода ***********************/
; 0000 0075 // Инициализация порта C
; 0000 0076 // выходы, кроме PC5
; 0000 0077 PORTC=0x00;
	RCALL SUBOPT_0x1
; 0000 0078 DDRC=0x00011111;
	__GETD1N 0x11111
	OUT  0x14,R30
; 0000 0079 
; 0000 007A // Инициализация порта B
; 0000 007B // выходы, кроме PB0, PB6, PB7
; 0000 007C PORTB=0x00;
	RCALL SUBOPT_0x2
; 0000 007D DDRB=0b00111110;
	LDI  R30,LOW(62)
	OUT  0x17,R30
; 0000 007E 
; 0000 007F // Инициализация порта D
; 0000 0080 // выходы, кроме PD4
; 0000 0081 PORTD=0x00;
	RCALL SUBOPT_0x3
; 0000 0082 DDRD=0b11101111;
	LDI  R30,LOW(239)
	OUT  0x11,R30
; 0000 0083 
; 0000 0084 /************ Инициализация таймеров-счетчиков *************************/
; 0000 0085 
; 0000 0086 //Инициализация Timer/Counter 0
; 0000 0087 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 0088 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0089 
; 0000 008A //Инициализация Timer/Counter 1
; 0000 008B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 008C TCCR1B=0x41;
	LDI  R30,LOW(65)
	OUT  0x2E,R30
; 0000 008D TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 008E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0090 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0091 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0092 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0093 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0094 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0095 
; 0000 0096 // Инициализация прерываний таймеров/счетчиков
; 0000 0097 TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0098 
; 0000 0099 /****************** Бесконечный цикл **********************************/
; 0000 009A while (1)
_0x3:
; 0000 009B {
; 0000 009C #asm("cli")
	cli
; 0000 009D 
; 0000 009E OVF_T1 = 0;
	CLR  R6
	CLR  R7
; 0000 009F 
; 0000 00A0 OVF_T0 = 0;
	CLR  R4
	CLR  R5
; 0000 00A1 
; 0000 00A2 Fx = 0;
	__GETD1N 0x0
	RCALL SUBOPT_0x4
; 0000 00A3 
; 0000 00A4 TCNT0 = TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	OUT  0x32,R30
; 0000 00A5 
; 0000 00A6 #asm("sei")                                   // Разрешения прерываний
	sei
; 0000 00A7 
; 0000 00A8 TIMSK|=0x20;                                  // Разрешили захват
	IN   R30,0x39
	ORI  R30,0x20
	OUT  0x39,R30
; 0000 00A9 
; 0000 00AA while ((TIMSK&0x20)==0x20){}                  // Ожидание прерывания по захвату
_0x6:
	IN   R30,0x39
	ANDI R30,LOW(0x20)
	CPI  R30,LOW(0x20)
	BREQ _0x6
; 0000 00AB 
; 0000 00AC N0=(((unsigned long int)(OVF_T1))<<16)+Ntakt; // Расчет общего количества тиков системной частоты
	RCALL SUBOPT_0x5
	STS  _N0,R30
	STS  _N0+1,R31
	STS  _N0+2,R22
	STS  _N0+3,R23
; 0000 00AD 
; 0000 00AE M0=(((unsigned long int)(OVF_T0))<<8)+Mx;     // Расчет общего количества тиков входной частоты
	RCALL SUBOPT_0x6
	STS  _M0,R30
	STS  _M0+1,R31
	STS  _M0+2,R22
	STS  _M0+3,R23
; 0000 00AF 
; 0000 00B0 delay_ms(500);                               // Задержка
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00B1 
; 0000 00B2 TIMSK|=0x20;                                  // Разрешили захват
	IN   R30,0x39
	ORI  R30,0x20
	OUT  0x39,R30
; 0000 00B3 
; 0000 00B4 while ((TIMSK&0x20)==0x20){}                  // Ожидание прерывания по захвату
_0x9:
	IN   R30,0x39
	ANDI R30,LOW(0x20)
	CPI  R30,LOW(0x20)
	BREQ _0x9
; 0000 00B5 
; 0000 00B6 N=(((unsigned long int)(OVF_T1))<<16)+Ntakt;  // Расчет общего количества тиков системной частоты
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
; 0000 00B7 
; 0000 00B8 M=(((unsigned long int)(OVF_T0))<<8)+Mx;      // Расчет общего количества тиков входной частоты
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x8
; 0000 00B9 
; 0000 00BA N=N-N0;                                       // Расчет количества тиков системной частоты за время измерения
	LDS  R26,_N0
	LDS  R27,_N0+1
	LDS  R24,_N0+2
	LDS  R25,_N0+3
	RCALL SUBOPT_0x9
	RCALL __SUBD12
	RCALL SUBOPT_0x7
; 0000 00BB 
; 0000 00BC M=M-M0;                                       // Расчет количества тиков входной частоты за время измерения
	LDS  R26,_M0
	LDS  R27,_M0+1
	LDS  R24,_M0+2
	LDS  R25,_M0+3
	RCALL SUBOPT_0xA
	RCALL __SUBD12
	RCALL SUBOPT_0x8
; 0000 00BD 
; 0000 00BE Fx=8000000.0*(float)M/(float)N;               // Вычисление частоты входного сигнала
	RCALL SUBOPT_0xA
	RCALL __CDF1
	__GETD2N 0x4AF42400
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x9
	RCALL __CDF1
	RCALL __DIVF21
	RCALL SUBOPT_0x4
; 0000 00BF 
; 0000 00C0 
; 0000 00C1 if (Fx >= 126.7)                              // 3800 об/мин 126.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42FD6666
	RCALL __CMPF12
	BRLO _0xC
; 0000 00C2 {
; 0000 00C3  OFF_LEDS;
	RJMP _0x34
; 0000 00C4 // ON_LED19;
; 0000 00C5  }
; 0000 00C6 else
_0xC:
; 0000 00C7 if (Fx >= 120)                                // 3600 об/мин 120 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42F00000
	RCALL __CMPF12
	BRLO _0xE
; 0000 00C8 {
; 0000 00C9  OFF_LEDS;
	RJMP _0x34
; 0000 00CA // ON_LED18;
; 0000 00CB  }
; 0000 00CC else
_0xE:
; 0000 00CD if (Fx >= 113.3)                              // 3400 об/мин 113.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42E2999A
	RCALL __CMPF12
	BRLO _0x10
; 0000 00CE {
; 0000 00CF  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00D0  ON_LED17;
	LDI  R30,LOW(239)
	RJMP _0x35
; 0000 00D1  }
; 0000 00D2 else
_0x10:
; 0000 00D3 if (Fx >= 106.7)                              // 3200 об/мин 106.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42D56666
	RCALL __CMPF12
	BRLO _0x12
; 0000 00D4 {
; 0000 00D5  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00D6  ON_LED16;
	LDI  R30,LOW(111)
	RJMP _0x35
; 0000 00D7  }
; 0000 00D8 else
_0x12:
; 0000 00D9 if (Fx >= 100)                                // 3000 об/мин 100 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42C80000
	RCALL __CMPF12
	BRLO _0x14
; 0000 00DA {
; 0000 00DB  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00DC  ON_LED15;
	LDI  R30,LOW(47)
	RJMP _0x35
; 0000 00DD  }
; 0000 00DE else
_0x14:
; 0000 00DF if (Fx >= 93.3)                               // 2800 об/мин 93.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42BA999A
	RCALL __CMPF12
	BRLO _0x16
; 0000 00E0 {
; 0000 00E1  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00E2  ON_LED14;
	LDI  R30,LOW(15)
	RJMP _0x35
; 0000 00E3  }
; 0000 00E4 else
_0x16:
; 0000 00E5 if (Fx >= 86.7)                               // 2600 об/мин 86.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42AD6666
	RCALL __CMPF12
	BRLO _0x18
; 0000 00E6 {
; 0000 00E7  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00E8  ON_LED13;
	LDI  R30,LOW(7)
	RJMP _0x35
; 0000 00E9  }
; 0000 00EA else
_0x18:
; 0000 00EB if (Fx >= 80)                                 // 2400 об/мин 80 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42A00000
	RCALL __CMPF12
	BRLO _0x1A
; 0000 00EC {
; 0000 00ED  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00EE  ON_LED12;
	LDI  R30,LOW(3)
	RJMP _0x35
; 0000 00EF  }
; 0000 00F0 else
_0x1A:
; 0000 00F1 if (Fx >= 73.3)                               // 2200 об/мин 73.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x4292999A
	RCALL __CMPF12
	BRLO _0x1C
; 0000 00F2 {
; 0000 00F3  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xE
; 0000 00F4  ON_LED11;
	LDI  R30,LOW(1)
	RJMP _0x35
; 0000 00F5  }
; 0000 00F6 else
_0x1C:
; 0000 00F7 if (Fx >= 66.7)                               // 2000 об/мин 66.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42856666
	RCALL __CMPF12
	BRLO _0x1E
; 0000 00F8 {
; 0000 00F9  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
; 0000 00FA  ON_LED10;
	LDI  R30,LOW(31)
	OUT  0x15,R30
	RJMP _0x36
; 0000 00FB  }
; 0000 00FC else
_0x1E:
; 0000 00FD if (Fx >= 60)                                 // 1800 об/мин 60 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42700000
	RCALL __CMPF12
	BRLO _0x20
; 0000 00FE {
; 0000 00FF  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
; 0000 0100  ON_LED9;
	LDI  R30,LOW(15)
	OUT  0x15,R30
	RJMP _0x36
; 0000 0101  }
; 0000 0102 else
_0x20:
; 0000 0103 if (Fx >= 53.3)                               // 1600 об/мин 53.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42553333
	RCALL __CMPF12
	BRLO _0x22
; 0000 0104 {
; 0000 0105  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
; 0000 0106  ON_LED8;
	LDI  R30,LOW(7)
	OUT  0x15,R30
	RJMP _0x36
; 0000 0107  }
; 0000 0108 else
_0x22:
; 0000 0109 if (Fx >= 46.7)                               // 1400 об/мин 46.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x423ACCCD
	RCALL __CMPF12
	BRLO _0x24
; 0000 010A {
; 0000 010B  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
; 0000 010C  ON_LED7;
	LDI  R30,LOW(3)
	OUT  0x15,R30
	RJMP _0x36
; 0000 010D  }
; 0000 010E else
_0x24:
; 0000 010F if (Fx >= 40)                                 // 1200 об/мин 40 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42200000
	RCALL __CMPF12
	BRLO _0x26
; 0000 0110 {
; 0000 0111  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
; 0000 0112  ON_LED6;
	LDI  R30,LOW(1)
	OUT  0x15,R30
	RJMP _0x36
; 0000 0113  }
; 0000 0114 else
_0x26:
; 0000 0115 if (Fx >= 33.3)                               // 1000 об/мин 33.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x42053333
	RCALL __CMPF12
	BRLO _0x28
; 0000 0116 {
; 0000 0117  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	OR   R30,R26
; 0000 0118  ON_LED5;
	LDI  R30,LOW(62)
	OUT  0x18,R30
; 0000 0119  }
; 0000 011A else
	RJMP _0x29
_0x28:
; 0000 011B if (Fx >= 26.7)                               // 800 об/мин 26.66666 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x41D5999A
	RCALL __CMPF12
	BRLO _0x2A
; 0000 011C {
; 0000 011D  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	OR   R30,R26
; 0000 011E  ON_LED4;
	LDI  R30,LOW(30)
	OUT  0x18,R30
; 0000 011F  }
; 0000 0120 else
	RJMP _0x2B
_0x2A:
; 0000 0121 if (Fx >= 20)                                 // 600 об/мин 20 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x41A00000
	RCALL __CMPF12
	BRLO _0x2C
; 0000 0122 {
; 0000 0123  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	OR   R30,R26
; 0000 0124  ON_LED3;
	LDI  R30,LOW(14)
	OUT  0x18,R30
; 0000 0125  }
; 0000 0126 else
	RJMP _0x2D
_0x2C:
; 0000 0127 if (Fx >= 13.3)                               // 400 об/мин 13.33333 имп/с
	RCALL SUBOPT_0xB
	__GETD1N 0x4154CCCD
	RCALL __CMPF12
	BRLO _0x2E
; 0000 0128 {
; 0000 0129  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	OR   R30,R26
; 0000 012A  ON_LED2;
	LDI  R30,LOW(6)
	OUT  0x18,R30
; 0000 012B  }
; 0000 012C else
	RJMP _0x2F
_0x2E:
; 0000 012D if (Fx >= 6.7)                                // 200 об/мин 6.66666 имп/с
	RCALL SUBOPT_0x10
	BRLO _0x30
; 0000 012E {
; 0000 012F  OFF_LEDS;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x3
	OR   R30,R26
; 0000 0130  ON_LED1;
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 0131  }
; 0000 0132 else
	RJMP _0x31
_0x30:
; 0000 0133 if (Fx < 6.7)
	RCALL SUBOPT_0x10
	BRSH _0x32
; 0000 0134 {
; 0000 0135  OFF_LEDS;
_0x34:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	LDI  R30,LOW(0)
_0x35:
	OUT  0x12,R30
_0x36:
	OR   R30,R26
; 0000 0136  }
; 0000 0137  } // конец бесконечного цикла
_0x32:
_0x31:
_0x2F:
_0x2D:
_0x2B:
_0x29:
	RJMP _0x3
; 0000 0138 
; 0000 0139 }
_0x33:
	RJMP _0x33
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
_Fx:
	.BYTE 0x4
_N0:
	.BYTE 0x4
_M0:
	.BYTE 0x4
_N:
	.BYTE 0x4
_M:
	.BYTE 0x4
_p_S1020024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	STS  _Fx,R30
	STS  _Fx+1,R31
	STS  _Fx+2,R22
	STS  _Fx+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	MOVW R30,R6
	CLR  R22
	CLR  R23
	RCALL __LSLD16
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R8
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	MOVW R30,R4
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	RCALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R10
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	STS  _N,R30
	STS  _N+1,R31
	STS  _N+2,R22
	STS  _N+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	STS  _M,R30
	STS  _M+1,R31
	STS  _M+2,R22
	STS  _M+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDS  R30,_N
	LDS  R31,_N+1
	LDS  R22,_N+2
	LDS  R23,_N+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDS  R30,_M
	LDS  R31,_M+1
	LDS  R22,_M+2
	LDS  R23,_M+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:131 WORDS
SUBOPT_0xB:
	LDS  R26,_Fx
	LDS  R27,_Fx+1
	LDS  R24,_Fx+2
	LDS  R25,_Fx+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xC:
	MOV  R26,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xD:
	OR   R30,R26
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0xE:
	OR   R30,R26
	LDI  R30,LOW(62)
	OUT  0x18,R30
	MOV  R26,R30
	LDI  R30,LOW(31)
	OUT  0x15,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xF:
	OR   R30,R26
	LDI  R30,LOW(62)
	OUT  0x18,R30
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xB
	__GETD1N 0x40D66666
	RCALL __CMPF12
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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
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

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
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

;END OF CODE MARKER
__END_OF_CODE:
