
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	.DEF _freq=R4
	.DEF _freq_msb=R5
	.DEF _och=R6
	.DEF _och_msb=R7
	.DEF _PWM_width=R9
	.DEF _port=R8
	.DEF _Timer_2=R11
	.DEF _Timer_3=R10
	.DEF _PWM_wide=R13
	.DEF _PWM_max_voltage=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP _timer1_compa_isr
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x9B,0x0,0x0,0xA
	.DB  0x0,0x0,0xA,0xA

_0x3:
	.DB  0x6
_0x4:
	.DB  0x2
_0x5:
	.DB  0xA
_0x0:
	.DB  0x66,0x72,0x65,0x71,0x3A,0x0,0x25,0x20
	.DB  0x69,0x0,0x43,0x4F,0x32,0x3A,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _displace
	.DW  _0x3*2

	.DW  0x01
	.DW  _Width_C4
	.DW  _0x4*2

	.DW  0x01
	.DW  _PWM_width_c
	.DW  _0x5*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 29.09.2015
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
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
;#include <stdio.h>
;#include <delay.h>
;
;#define FIRST_ADC_INPUT 0
;#define LAST_ADC_INPUT 3
;unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
;#define ADC_VREF_TYPE 0x00
;
;unsigned char lcd_buffer[16];
;unsigned int adc[3];
;unsigned int freq,och=155;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 0028 #endasm
;#include <lcd.h>
;//#include <lcd_rus.h>
;//#include <flex_lcd.c>
;
;unsigned char PWM_width=10,PWM_width_now[6],port,Timer_2,Timer_3;
;unsigned char PWM_width_set[6]={0,0,0,0,0,0};//начало фазы сигнала
;unsigned char PWM_wide=10;
;
;unsigned char PWM_step[6]={0,0,0,0};
;unsigned char PWM_max_voltage=10;
;unsigned char period[6];
;unsigned char displace[3]={6,0,0};

	.DSEG
;unsigned char Width_C4=2,Width_C4_now,PWM_width_c=10;
;unsigned char Timer_nan_sec,Timer_sec,Timer_min,cycle;
;
;void Timer_reset(void){
; 0000 0038 void Timer_reset(void){

	.CSEG
_Timer_reset:
; .FSTART _Timer_reset
; 0000 0039 
; 0000 003A TCNT1H=0x00 >> 8;
	RCALL SUBOPT_0x0
; 0000 003B TCNT1L=0x00 & 0xff;
; 0000 003C OCR1AH=och >> 8;
	RCALL SUBOPT_0x1
	OUT  0x2B,R30
; 0000 003D OCR1AL=och & 0xff;
	MOV  R30,R6
	OUT  0x2A,R30
; 0000 003E }
	RET
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0041 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0042  TCNT0=131;//62.5 √ц
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0043  Timer_2++;
	INC  R11
; 0000 0044  //PORTD.7^=1;
; 0000 0045  Timer_nan_sec++;
	LDS  R30,_Timer_nan_sec
	SUBI R30,-LOW(1)
	STS  _Timer_nan_sec,R30
; 0000 0046  if(Timer_nan_sec==62){
	LDS  R26,_Timer_nan_sec
	CPI  R26,LOW(0x3E)
	BRNE _0x6
; 0000 0047  Timer_sec++;
	LDS  R30,_Timer_sec
	SUBI R30,-LOW(1)
	STS  _Timer_sec,R30
; 0000 0048  Timer_nan_sec=0;
	LDI  R30,LOW(0)
	STS  _Timer_nan_sec,R30
; 0000 0049  }
; 0000 004A  if ((Timer_sec==60)&&(cycle==0)){
_0x6:
	LDS  R26,_Timer_sec
	CPI  R26,LOW(0x3C)
	BRNE _0x8
	LDS  R26,_cycle
	CPI  R26,LOW(0x0)
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 004B  Timer_sec=0;
	LDI  R30,LOW(0)
	STS  _Timer_sec,R30
; 0000 004C  cycle=1;
	LDI  R30,LOW(1)
	STS  _cycle,R30
; 0000 004D  Width_C4=2;
	LDI  R30,LOW(2)
	STS  _Width_C4,R30
; 0000 004E  }
; 0000 004F  if ((Timer_sec==90)&&(cycle==1)){
_0x7:
	LDS  R26,_Timer_sec
	CPI  R26,LOW(0x5A)
	BRNE _0xB
	LDS  R26,_cycle
	CPI  R26,LOW(0x1)
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0050  Timer_sec=0;
	LDI  R30,LOW(0)
	STS  _Timer_sec,R30
; 0000 0051  cycle=0;
	STS  _cycle,R30
; 0000 0052   Width_C4=10;
	LDI  R30,LOW(10)
	STS  _Width_C4,R30
; 0000 0053  }
; 0000 0054 
; 0000 0055 
; 0000 0056 
; 0000 0057 }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0059 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
; 0000 005A  //TCNT0=0x01;
; 0000 005B // Reinitialize Timer1 value
; 0000 005C //TCNT1H=0xFF64 >> 8;
; 0000 005D //TCNT1L=0xFF64 & 0xff;
; 0000 005E // Place your code here
; 0000 005F //TCNT1H=0xffff >> 8;
; 0000 0060 //TCNT1L=0xffff & 0xff;
; 0000 0061 }
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0065 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0066 TCNT1H=0x00 >> 8;
	RCALL SUBOPT_0x0
; 0000 0067 TCNT1L=0x00 & 0xff;
; 0000 0068 //PORTD.6^=1;
; 0000 0069 
; 0000 006A if (Timer_3==(PWM_wide*2-1)){
	MOV  R26,R13
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	SBIW R30,1
	MOV  R26,R10
	RCALL SUBOPT_0x2
	BRNE _0xD
; 0000 006B PORTD.6^=1;
	LDI  R26,0
	SBIC 0x12,6
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0xE
	CBI  0x12,6
	RJMP _0xF
_0xE:
	SBI  0x12,6
_0xF:
; 0000 006C Timer_3=0;
	CLR  R10
; 0000 006D }
; 0000 006E Timer_3++;
_0xD:
	INC  R10
; 0000 006F PWM_max_voltage=PWM_wide/adc[2];
	RCALL SUBOPT_0x3
	__GETW1MN _adc,4
	RCALL __DIVW21U
	MOV  R12,R30
; 0000 0070 
; 0000 0071 
; 0000 0072 
; 0000 0073 
; 0000 0074 // Place your code here
; 0000 0075 //for (port_ph=0;port_ph<6;port_ph++;){
; 0000 0076 if((PWM_step[0]<=0)&&(period[0]==0)){period[0]=1;}   // 10<=0
	RCALL SUBOPT_0x4
	CPI  R26,0
	BRNE _0x11
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x0)
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
; 0000 0077 if((PWM_step[0]>=PWM_wide)&&(period[0]==1)){period[0]=2;}
_0x10:
	RCALL SUBOPT_0x4
	CP   R26,R13
	BRLO _0x14
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x1)
	BREQ _0x15
_0x14:
	RJMP _0x13
_0x15:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x6
; 0000 0078 if (period[0]==1){PWM_step[0]++;PWM_width_set[0]=PWM_step[0]/(PWM_max_voltage);}
_0x13:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x1)
	BRNE _0x16
	LDS  R30,_PWM_step
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x7
; 0000 0079 if (period[0]==2){PWM_step[0]--;PWM_width_set[0]=PWM_step[0]/(PWM_max_voltage);}
_0x16:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x2)
	BRNE _0x17
	LDS  R30,_PWM_step
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x7
; 0000 007A 
; 0000 007B if((PWM_step[0]<=0)&&(period[0]==2)){period[0]=3;PWM_step[0]=0;}
_0x17:
	RCALL SUBOPT_0x4
	CPI  R26,0
	BRNE _0x19
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x2)
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	STS  _PWM_step,R30
; 0000 007C if (period[0]==3){PWM_step[1]++;PWM_width_set[1]=PWM_step[1]/(PWM_max_voltage);}
_0x18:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x3)
	BRNE _0x1B
	__GETB1MN _PWM_step,1
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x8
; 0000 007D if((PWM_step[1]>=PWM_wide)&&(period[0]==3)){period[0]=4;}
_0x1B:
	__GETB2MN _PWM_step,1
	CP   R26,R13
	BRLO _0x1D
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x3)
	BREQ _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x6
; 0000 007E if (period[0]==4){PWM_step[1]--;PWM_width_set[1]=PWM_step[1]/(PWM_max_voltage);}
_0x1C:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x4)
	BRNE _0x1F
	__GETB1MN _PWM_step,1
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x8
; 0000 007F if((PWM_step[1]<=0)&&(period[0]==4)){period[0]=0;PWM_step[1]=0;}
_0x1F:
	__GETB2MN _PWM_step,1
	CPI  R26,0
	BRNE _0x21
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x4)
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	__PUTB1MN _PWM_step,1
; 0000 0080 
; 0000 0081 ////////////////////////////////////////////////////////////////////
; 0000 0082 
; 0000 0083 if((PWM_step[2]<=0+displace[0])&&(period[2]==0)){period[2]=1;}   // 10<=0
_0x20:
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	ADIW R30,0
	RCALL SUBOPT_0x2
	BRLT _0x24
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x0)
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xC
; 0000 0084 if((PWM_step[2]>=PWM_wide+displace[0])&&(period[2]==1)){period[2]=2;}
_0x23:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xE
	BRLT _0x27
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x1)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xC
; 0000 0085 if (period[2]==1){PWM_step[2]++;PWM_width_set[2]=(PWM_step[2]-displace[0])/(PWM_max_voltage);}
_0x26:
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x1)
	BRNE _0x29
	__GETB1MN _PWM_step,2
	SUBI R30,-LOW(1)
	__PUTB1MN _PWM_step,2
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 0086 if (period[2]==2){PWM_step[2]--;PWM_width_set[2]=(PWM_step[2]-displace[0])/(PWM_max_voltage);}
_0x29:
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x2)
	BRNE _0x2A
	__GETB1MN _PWM_step,2
	SUBI R30,LOW(1)
	__PUTB1MN _PWM_step,2
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 0087 
; 0000 0088 if((PWM_step[2]<=displace[0])&&(period[2]==2)){period[2]=3;PWM_step[2]=displace[0];}
_0x2A:
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x11
	CP   R30,R26
	BRLO _0x2C
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x2)
	BREQ _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
	__PUTB1MN _PWM_step,2
; 0000 0089 if (period[2]==3){PWM_step[3]++;PWM_width_set[3]=(PWM_step[3]-displace[0])/(PWM_max_voltage);}
_0x2B:
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x3)
	BRNE _0x2E
	__GETB1MN _PWM_step,3
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0000 008A if((PWM_step[3]>=PWM_wide+displace[0])&&(period[2]==3)){period[2]=4;}
_0x2E:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xD
	__GETB2MN _PWM_step,3
	RCALL SUBOPT_0xE
	BRLT _0x30
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x3)
	BREQ _0x31
_0x30:
	RJMP _0x2F
_0x31:
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xC
; 0000 008B if (period[2]==4){PWM_step[3]--;PWM_width_set[3]=(PWM_step[3]-displace[0])/(PWM_max_voltage);}
_0x2F:
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x4)
	BRNE _0x32
	__GETB1MN _PWM_step,3
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0000 008C if((PWM_step[3]<=displace[0])&&(period[2]==4)){period[2]=0;PWM_step[3]=displace[0];}
_0x32:
	__GETB2MN _PWM_step,3
	RCALL SUBOPT_0x11
	CP   R30,R26
	BRLO _0x34
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x4)
	BREQ _0x35
_0x34:
	RJMP _0x33
_0x35:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
	__PUTB1MN _PWM_step,3
; 0000 008D 
; 0000 008E 
; 0000 008F ////////////////////////////////////////////////////////////////////
; 0000 0090 if((PWM_step[4]<=0+displace[1])&&(period[4]==0)){period[4]=1;}   // 10<=0
_0x33:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	ADIW R30,0
	RCALL SUBOPT_0x2
	BRLT _0x37
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x0)
	BREQ _0x38
_0x37:
	RJMP _0x36
_0x38:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x17
; 0000 0091 if((PWM_step[4]>=PWM_wide+displace[1])&&(period[4]==1)){period[4]=2;}
_0x36:
	__GETBRMN 0,_PWM_step,4
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xD
	MOV  R26,R0
	RCALL SUBOPT_0xE
	BRLT _0x3A
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x1)
	BREQ _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x17
; 0000 0092 if (period[4]==1){PWM_step[4]++;PWM_width_set[4]=(PWM_step[4]-displace[1])/(PWM_max_voltage);}
_0x39:
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x1)
	BRNE _0x3C
	__GETB1MN _PWM_step,4
	SUBI R30,-LOW(1)
	__PUTB1MN _PWM_step,4
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 0093 if (period[4]==2){PWM_step[4]--;PWM_width_set[4]=(PWM_step[4]-displace[1])/(PWM_max_voltage);}
_0x3C:
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x2)
	BRNE _0x3D
	__GETB1MN _PWM_step,4
	SUBI R30,LOW(1)
	__PUTB1MN _PWM_step,4
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 0094 
; 0000 0095 if((PWM_step[4]<=displace[1])&&(period[4]==2)){period[4]=3;PWM_step[4]=displace[1];}
_0x3D:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x1A
	CP   R30,R26
	BRLO _0x3F
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x2)
	BREQ _0x40
_0x3F:
	RJMP _0x3E
_0x40:
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
	__PUTB1MN _PWM_step,4
; 0000 0096 if (period[4]==3){PWM_step[5]++;PWM_width_set[5]=(PWM_step[5]-displace[1])/(PWM_max_voltage);}
_0x3E:
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x3)
	BRNE _0x41
	__GETB1MN _PWM_step,5
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
; 0000 0097 if((PWM_step[5]>=PWM_wide+displace[1])&&(period[4]==3)){period[4]=4;}
_0x41:
	__GETBRMN 0,_PWM_step,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xD
	MOV  R26,R0
	RCALL SUBOPT_0xE
	BRLT _0x43
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x3)
	BREQ _0x44
_0x43:
	RJMP _0x42
_0x44:
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x17
; 0000 0098 if (period[4]==4){PWM_step[5]--;PWM_width_set[5]=(PWM_step[5]-displace[1])/(PWM_max_voltage);}
_0x42:
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x4)
	BRNE _0x45
	__GETB1MN _PWM_step,5
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
; 0000 0099 if((PWM_step[5]<=displace[1])&&(period[4]==4)){period[4]=0;PWM_step[5]=displace[1];}
_0x45:
	__GETB2MN _PWM_step,5
	RCALL SUBOPT_0x1A
	CP   R30,R26
	BRLO _0x47
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x4)
	BREQ _0x48
_0x47:
	RJMP _0x46
_0x48:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
	__PUTB1MN _PWM_step,5
; 0000 009A 
; 0000 009B 
; 0000 009C ////////////////////////////////////////////////////////////////////
; 0000 009D 
; 0000 009E 
; 0000 009F }
_0x46:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00A3 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A4 // Reinitialize Timer2 value
; 0000 00A5 TCNT2=0xC2;
	LDI  R30,LOW(194)
	OUT  0x24,R30
; 0000 00A6 //каждому порту установленное значение
; 0000 00A7 
; 0000 00A8 for (port=0;port<6;port++){
	CLR  R8
_0x4A:
	LDI  R30,LOW(6)
	CP   R8,R30
	BRSH _0x4B
; 0000 00A9 if (PWM_width_set[port]<PWM_width_now[port]){PORTD&= ~(1<<port);} //включаем порт, если now меньше set
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	BRSH _0x4C
	RCALL SUBOPT_0x20
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
; 0000 00AA if (PWM_width_set[port]>=PWM_width_now[port]){PORTD|=1<<port;}//выключаем
_0x4C:
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	BRLO _0x4D
	RCALL SUBOPT_0x20
	OR   R30,R1
	OUT  0x12,R30
; 0000 00AB if (PWM_width_now[port]>=PWM_width){PWM_width_now[port]=0;}
_0x4D:
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(-_PWM_width_now)
	SBCI R31,HIGH(-_PWM_width_now)
	LD   R26,Z
	CP   R26,R9
	BRLO _0x4E
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(-_PWM_width_now)
	SBCI R31,HIGH(-_PWM_width_now)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00AC PWM_width_now[port]++;
_0x4E:
	MOV  R26,R8
	LDI  R27,0
	SUBI R26,LOW(-_PWM_width_now)
	SBCI R27,HIGH(-_PWM_width_now)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 00AD }
	INC  R8
	RJMP _0x4A
_0x4B:
; 0000 00AE 
; 0000 00AF /////////////////////////
; 0000 00B0 
; 0000 00B1 if (Width_C4<Width_C4_now){PORTC&= ~(1<<4);} //включаем порт, если now меньше set
	RCALL SUBOPT_0x21
	CP   R26,R30
	BRSH _0x4F
	CBI  0x15,4
; 0000 00B2 if (Width_C4>Width_C4_now){PORTC|=1<<4;}//выключаем
_0x4F:
	RCALL SUBOPT_0x21
	CP   R30,R26
	BRSH _0x50
	SBI  0x15,4
; 0000 00B3 if (Width_C4_now>PWM_width_c){Width_C4_now=0;}
_0x50:
	LDS  R30,_PWM_width_c
	LDS  R26,_Width_C4_now
	CP   R30,R26
	BRSH _0x51
	LDI  R30,LOW(0)
	STS  _Width_C4_now,R30
; 0000 00B4 Width_C4_now++;
_0x51:
	LDS  R30,_Width_C4_now
	SUBI R30,-LOW(1)
	STS  _Width_C4_now,R30
; 0000 00B5 
; 0000 00B6 /////////////////////////
; 0000 00B7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#define ADC_VREF_TYPE 0x40
;
;// ADC interrupt service routine
;unsigned int read_adc(unsigned char adc_input)
; 0000 00BD {
_read_adc:
; .FSTART _read_adc
; 0000 00BE ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00BF // Delay needed for the stabilization of the ADC input voltage
; 0000 00C0 delay_us(10);
	__DELAY_USB 3
; 0000 00C1 // Start the AD conversion
; 0000 00C2 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00C3 // Wait for the AD conversion to complete
; 0000 00C4 while ((ADCSRA & 0x10)==0);
_0x52:
	SBIS 0x6,4
	RJMP _0x52
; 0000 00C5 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00C6 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2080001
; 0000 00C7 }
; .FEND
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 00CD {
_main:
; .FSTART _main
; 0000 00CE // Declare your local variables here
; 0000 00CF 
; 0000 00D0 // Input/Output Ports initialization
; 0000 00D1 // Port B initialization
; 0000 00D2 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 00D3 // State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
; 0000 00D4 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D5 DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 00D6 
; 0000 00D7 // Port C initialization
; 0000 00D8 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00D9 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00DA PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00DB DDRC=0b00010000;
	LDI  R30,LOW(16)
	OUT  0x14,R30
; 0000 00DC 
; 0000 00DD // Port D initialization
; 0000 00DE // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00DF // State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00E0 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00E1 DDRD=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00E2 
; 0000 00E3 // Timer/Counter 0 initialization
; 0000 00E4 // Clock source: System Clock
; 0000 00E5 // Clock value: 0,977 kHz
; 0000 00E6 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00E7 TCNT0=131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00E8 
; 0000 00E9 
; 0000 00EA // Timer/Counter 1 initialization
; 0000 00EB // Clock source: System Clock
; 0000 00EC // Clock value: 1000,000 kHz
; 0000 00ED // Mode: Normal top=FFFFh
; 0000 00EE // OC1A output: Discon.
; 0000 00EF // OC1B output: Discon.
; 0000 00F0 // Noise Canceler: Off
; 0000 00F1 // Input Capture on Falling Edge
; 0000 00F2 // Timer1 Overflow Interrupt: On
; 0000 00F3 // Input Capture Interrupt: Off
; 0000 00F4 // Compare A Match Interrupt: Off
; 0000 00F5 // Compare B Match Interrupt: Off
; 0000 00F6 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00F7 TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00F8 TCNT1H=0x00;
	RCALL SUBOPT_0x0
; 0000 00F9 TCNT1L=0x00;
; 0000 00FA ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00FB ICR1L=0x00;
	OUT  0x26,R30
; 0000 00FC OCR1AH=15 >> 8;
	OUT  0x2B,R30
; 0000 00FD OCR1AL=15 & 0xFF;
	LDI  R30,LOW(15)
	OUT  0x2A,R30
; 0000 00FE OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00FF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0100 
; 0000 0101 // Timer/Counter 2 initialization
; 0000 0102 // Clock source: System Clock
; 0000 0103 // Clock value: 1000,000 kHz
; 0000 0104 // Mode: Normal top=FFh
; 0000 0105 // OC2 output: Disconnected
; 0000 0106 ASSR=0x00;
	OUT  0x22,R30
; 0000 0107 TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 0108 TCNT2=0xC2;
	LDI  R30,LOW(194)
	OUT  0x24,R30
; 0000 0109 OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 010A 
; 0000 010B // External Interrupt(s) initialization
; 0000 010C // INT0: Off
; 0000 010D // INT1: Off
; 0000 010E MCUCR=0x00;
	OUT  0x35,R30
; 0000 010F 
; 0000 0110 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0111 TIMSK=0x55;
	LDI  R30,LOW(85)
	OUT  0x39,R30
; 0000 0112 //TIMSK=0x01;
; 0000 0113 // Analog Comparator initialization
; 0000 0114 // Analog Comparator: Off
; 0000 0115 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0116 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0117 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0118 
; 0000 0119 // ADC initialization
; 0000 011A // ADC Clock frequency: 500,000 kHz
; 0000 011B // ADC Voltage Reference: AVCC pin
; 0000 011C ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 011D ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 011E 
; 0000 011F // LCD module initialization
; 0000 0120 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0121 
; 0000 0122 // Global enable interrupts
; 0000 0123 #asm("sei")
	sei
; 0000 0124 
; 0000 0125 
; 0000 0126 
; 0000 0127 while (1)
_0x55:
; 0000 0128       {
; 0000 0129       // Place your code here
; 0000 012A #include <while.c>
;//while:
;
;
;#include "pwm.c";
;//pwm
;//DDRD.0^=1;
;//och=155;
;
;
;if (Timer_2==0){
	TST  R11
	BRNE _0x58
;
;adc[0]=read_adc(0)/20;
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL __DIVW21U
	RCALL SUBOPT_0x22
;
;
;if (adc[0]<=0){adc[0]=1;}
	RCALL SUBOPT_0x23
	SBIW R26,0
	BRNE _0x59
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x22
;if (adc[0]>=255){adc[0]=255;}
_0x59:
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRLO _0x5A
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL SUBOPT_0x22
;freq=adc[0];
_0x5A:
	__GETWRMN 4,5,0,_adc
;//och=7812/adc[0]*10;
;//if ()
;//och=256-31250/(freq*40*4);
;//och=39;
;och=1000000/(freq*PWM_wide*4)-1;
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R4
	RCALL __MULW12U
	RCALL __LSLW2
	CLR  R22
	CLR  R23
	__GETD2N 0xF4240
	RCALL __DIVD21
	SBIW R30,1
	MOVW R6,R30
;//och=249;
;//och=8000000/(freq*PWM_wide*4)-1;
;//och=1999;
;}
;
;
;
;//freq=adc[0];
;
;
;if(och>>8==0){
_0x58:
	RCALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0x5B
;    if (OCR1AL!=och & 0xff){
	RCALL SUBOPT_0x24
	BREQ _0x5C
;    Timer_reset();
	RCALL _Timer_reset
;    }
;}
_0x5C:
;if(och>>8!=0){
_0x5B:
	RCALL SUBOPT_0x1
	SBIW R30,0
	BREQ _0x5D
;   if ((OCR1AL!=och & 0xff)&&(OCR1AH!=och>>8)){
	RCALL SUBOPT_0x24
	BREQ _0x5F
	IN   R30,0x2B
	MOV  R26,R30
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	BRNE _0x60
_0x5F:
	RJMP _0x5E
_0x60:
;   Timer_reset();
	RCALL _Timer_reset
;   }
;}
_0x5E:
;
;
;
;if (Timer_2==1){
_0x5D:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x61
;adc[1]=read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	__PUTW1MN _adc,2
;adc[2]=read_adc(2)/102;
	LDI  R26,LOW(2)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	RCALL __DIVW21U
	__PUTW1MN _adc,4
;
;lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
;lcd_clear();
	RCALL _lcd_clear
;lcd_putsf("freq:");
	__POINTW2FN _0x0,0
	RCALL SUBOPT_0x25
;sprintf(lcd_buffer,"% i",adc[0]);
	LDS  R30,_adc
	LDS  R31,_adc+1
	RCALL SUBOPT_0x26
;lcd_puts(lcd_buffer);
;
;lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
;lcd_putsf("CO2:");
	__POINTW2FN _0x0,10
	RCALL SUBOPT_0x25
;sprintf(lcd_buffer,"% i",adc[1]);
	__GETW1MN _adc,2
	RCALL SUBOPT_0x26
;lcd_puts(lcd_buffer);
;}
;if(Timer_2==2){
_0x61:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x62
;Timer_2=0;
	CLR  R11
;}
;
;
; 0000 012B       };
_0x62:
	RJMP _0x55
; 0000 012C }
_0x63:
	RJMP _0x63
; .FEND
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
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL SUBOPT_0x27
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x28
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x28
	ADIW R26,2
	RCALL SUBOPT_0x2A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x28
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x28
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x27
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x2B
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x2B
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2C
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x2E
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x32
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x32
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x33
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x33
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x33
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x2B
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x32
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x32
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x33
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x34
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x32
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
; .FSTART __lcd_delay_G101
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
; .FEND
__lcd_read_nibble_G101:
; .FSTART __lcd_read_nibble_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G101:
; .FSTART _lcd_read_byte0_G101
	RCALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0x27
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x27
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G101:
; .FSTART __long_delay_G101
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G101:
; .FSTART __lcd_init_write_G101
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x35
	RCALL __long_delay_G101
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x27
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
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x27
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
; .FEND

	.DSEG
_lcd_buffer:
	.BYTE 0x10
_adc:
	.BYTE 0x6
_PWM_width_now:
	.BYTE 0x6
_PWM_width_set:
	.BYTE 0x6
_PWM_step:
	.BYTE 0x6
_period:
	.BYTE 0x6
_displace:
	.BYTE 0x3
_Width_C4:
	.BYTE 0x1
_Width_C4_now:
	.BYTE 0x1
_PWM_width_c:
	.BYTE 0x1
_Timer_nan_sec:
	.BYTE 0x1
_Timer_sec:
	.BYTE 0x1
_cycle:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	ANDI R31,HIGH(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	MOV  R26,R13
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDS  R26,_PWM_step
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDS  R26,_period
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	STS  _period,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	STS  _PWM_step,R30
	MOV  R30,R12
	RCALL SUBOPT_0x4
	RCALL __DIVB21U
	STS  _PWM_width_set,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__PUTB1MN _PWM_step,1
	__GETB2MN _PWM_step,1
	MOV  R30,R12
	RCALL __DIVB21U
	__PUTB1MN _PWM_width_set,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	__GETB2MN _PWM_step,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDS  R30,_displace
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	__GETB2MN _period,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	__PUTB1MN _period,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CLR  R27
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R12
	LDI  R31,0
	RCALL __DIVW21
	__PUTB1MN _PWM_width_set,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDS  R30,_displace
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__PUTB1MN _PWM_step,3
	__GETB2MN _PWM_step,3
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R12
	LDI  R31,0
	RCALL __DIVW21
	__PUTB1MN _PWM_width_set,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETB2MN _PWM_step,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	__GETB1MN _displace,1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	__GETB2MN _period,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	__PUTB1MN _period,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CLR  R27
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R12
	LDI  R31,0
	RCALL __DIVW21
	__PUTB1MN _PWM_width_set,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETB1MN _displace,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	__PUTB1MN _PWM_step,5
	__GETB2MN _PWM_step,5
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R12
	LDI  R31,0
	RCALL __DIVW21
	__PUTB1MN _PWM_width_set,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	MOV  R30,R8
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	SUBI R30,LOW(-_PWM_width_set)
	SBCI R31,HIGH(-_PWM_width_set)
	LD   R26,Z
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	SUBI R30,LOW(-_PWM_width_now)
	SBCI R31,HIGH(-_PWM_width_now)
	LD   R30,Z
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	IN   R1,18
	MOV  R30,R8
	LDI  R26,LOW(1)
	RCALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R30,_Width_C4_now
	LDS  R26,_Width_C4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	STS  _adc,R30
	STS  _adc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDS  R26,_adc
	LDS  R27,_adc+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	IN   R30,0x2A
	MOV  R26,R30
	MOVW R30,R6
	LDI  R27,0
	RCALL __NEW12
	ANDI R30,LOW(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	RCALL _lcd_putsf
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2B:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x2C
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RJMP __lcd_init_write_G101


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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__NEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRNE __NEW12T
	CLR  R30
__NEW12T:
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

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
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

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

;END OF CODE MARKER
__END_OF_CODE:
