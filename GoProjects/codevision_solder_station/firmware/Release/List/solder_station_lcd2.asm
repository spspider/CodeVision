
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : long, width
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
	.DEF _Timer_1=R5
	.DEF _lcd_stateU=R4
	.DEF _lcd_stateB=R7
	.DEF _now_tempU=R8
	.DEF _now_tempU_msb=R9
	.DEF _now_tempB=R10
	.DEF _now_tempB_msb=R11
	.DEF _set_tempB_prev=R12
	.DEF _set_tempB_prev_msb=R13
	.DEF _show_lcd=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;DATA STACK END MARKER INITIALIZATION
__DSTACK_END_INIT:
	.DB  'D','S','T','A','C','K','E','N','D',0

;HARDWARE STACK END MARKER INITIALIZATION
__HSTACK_END_INIT:
	.DB  'H','S','T','A','C','K','E','N','D',0

_0x3:
	.DB  0xA
_0x4:
	.DB  0x1
_0x5:
	.DB  0xC8
_0x6:
	.DB  0xC8
_0x7:
	.DB  0x5,0x5
_0x8:
	.DB  0x5,0x5
_0x9:
	.DB  0x5,0x5
_0x0:
	.DB  0x20,0x0,0x3E,0x0,0x25,0x63,0x42,0x3A
	.DB  0x25,0x64,0x20,0x25,0x63,0x55,0x3A,0x25
	.DB  0x64,0x0,0x25,0x63,0x53,0x42,0x3A,0x25
	.DB  0x64,0x0,0x25,0x63,0x53,0x55,0x3A,0x25
	.DB  0x64,0x0,0x25,0x64,0x3A,0x25,0x64,0x3A
	.DB  0x25,0x64,0x0,0x25,0x63,0x50,0x77,0x72
	.DB  0x55,0x3A,0x25,0x64,0x25,0x63,0x50,0x77
	.DB  0x72,0x42,0x3A,0x25,0x64,0x0,0x25,0x63
	.DB  0x20,0x73,0x74,0x61,0x72,0x74,0x3A,0x25
	.DB  0x64,0x0,0x25,0x63,0x55,0x6F,0x6E,0x3A
	.DB  0x25,0x64,0x20,0x6F,0x66,0x66,0x3A,0x25
	.DB  0x64,0x0,0x25,0x63,0x42,0x6F,0x6E,0x3A
	.DB  0x25,0x64,0x20,0x6F,0x66,0x66,0x3A,0x25
	.DB  0x64,0x0,0x48,0x0,0x70,0x0,0x7C,0x0
	.DB  0x5F,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  __SRAM_START
	.DW  __DSTACK_END_INIT*2

	.DW  0x09
	.DW  0x19F
	.DW  __HSTACK_END_INIT*2

	.DW  0x01
	.DW  _PWM_width
	.DW  _0x3*2

	.DW  0x01
	.DW  _lcd_switcher
	.DW  _0x4*2

	.DW  0x01
	.DW  _set_tempB
	.DW  _0x5*2

	.DW  0x01
	.DW  _set_tempU
	.DW  _0x6*2

	.DW  0x02
	.DW  _PWM_setted
	.DW  _0x7*2

	.DW  0x02
	.DW  _heat_sec_on
	.DW  _0x8*2

	.DW  0x02
	.DW  _heat_sec_off
	.DW  _0x9*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.10 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : solder station
;Version :
;Date    : 13.02.2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
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
;#include <delay.h>
;#include <stdio.h>
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <eeprom.h>
;
;// Declare your global variables here
;char lcd_buffer[20],Timer_1,lcd_stateU,lcd_stateB,choose[6];
;bit BTN3_pressed;
;unsigned int now_tempU,now_tempB,set_tempB_prev,set_tempU_prev;
;unsigned char show_lcd,sec,min,hour,port,PWM_width=10,PWM_step[2],heater_on[2],sec_heat[2],lcd_switcher=1,BTN1_pressed,B ...

	.DSEG
;unsigned char set_tempB=200, set_tempU=200;
;eeprom unsigned char set_tempB_eep=200;
;eeprom unsigned char set_tempU_eep=200;
;unsigned char PWM_setted[2]={5,5},heat_sec_on[2]={5,5},heat_sec_off[2]={5,5};
;
;
;int POWER_H_U;
;int POWER_H_B;
;unsigned char k;
;// Timer 0 overflow interrupt service routine
;
;
;
;void choose_v(char i){
; 0000 0032 void choose_v(char i){

	.CSEG
_choose_v:
; .FSTART _choose_v
; 0000 0033 
; 0000 0034     for (k=0;k<6;k++){
	ST   -Y,R26
;	i -> Y+0
	LDI  R30,LOW(0)
	STS  _k,R30
_0xB:
	LDS  R26,_k
	CPI  R26,LOW(0x6)
	BRSH _0xC
; 0000 0035     choose[k]=*" ";
	LDI  R27,0
	SUBI R26,LOW(-_choose)
	SBCI R27,HIGH(-_choose)
	__POINTW1FN _0x0,0
	LPM  R30,Z
	ST   X,R30
; 0000 0036     }
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
	RJMP _0xB
_0xC:
; 0000 0037     choose[i]=*">";
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_choose)
	SBCI R27,HIGH(-_choose)
	__POINTW1FN _0x0,2
	LPM  R30,Z
	ST   X,R30
; 0000 0038 }
	RJMP _0x20A0001
; .FEND
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003D {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003E TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 003F // Place your code here
; 0000 0040 Timer_1++;
	INC  R5
; 0000 0041 #include <heater.c>;
;//if (Bheater==1){
;
;
;//PWM_setted[0]=5;//текущая мощность нагревателя, нижний нагреватель
;//PWM_setted[1]=4;//текущая мощность нагревателя, верхний нагреватель
;//heat_sec_on[0]=5;
;//heat_sec_off[0]=5;
;//heat_sec_on[1]=5;
;//heat_sec_off[1]=5;
;
;for (port=0;port<2;port++){
	LDI  R30,LOW(0)
	STS  _port,R30
_0xE:
	LDS  R26,_port
	CPI  R26,LOW(0x2)
	BRLO PC+2
	RJMP _0xF
;    if (heater_on[port]==1){
	LDS  R30,_port
	LDI  R31,0
	SUBI R30,LOW(-_heater_on)
	SBCI R31,HIGH(-_heater_on)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x10
;        if (PWM_setted[port]<PWM_step[port]){PORTB&= ~(1<<port);} //выключаем порт, если step больше 10
	LDS  R30,_port
	LDI  R31,0
	MOVW R0,R30
	SUBI R30,LOW(-_PWM_setted)
	SBCI R31,HIGH(-_PWM_setted)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LD   R30,Z
	CP   R26,R30
	BRSH _0x11
	IN   R1,24
	LDS  R30,_port
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x18,R30
;        if (PWM_setted[port]>=PWM_step[port]){PORTB|=1<<port;}//включаем
_0x11:
	LDS  R30,_port
	LDI  R31,0
	MOVW R0,R30
	SUBI R30,LOW(-_PWM_setted)
	SBCI R31,HIGH(-_PWM_setted)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LD   R30,Z
	CP   R26,R30
	BRLO _0x12
	IN   R1,24
	LDS  R30,_port
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x18,R30
;        if (PWM_step[port]>=PWM_width){PWM_step[port]=0;}
_0x12:
	LDS  R30,_port
	LDI  R31,0
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LD   R26,Z
	LDS  R30,_PWM_width
	CP   R26,R30
	BRLO _0x13
	LDS  R30,_port
	LDI  R31,0
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;        PWM_step[port]++;
_0x13:
	LDS  R26,_port
	LDI  R27,0
	SUBI R26,LOW(-_PWM_step)
	SBCI R27,HIGH(-_PWM_step)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
;    }
;    if (heater_on[port]==0){
_0x10:
	LDS  R30,_port
	LDI  R31,0
	SUBI R30,LOW(-_heater_on)
	SBCI R31,HIGH(-_heater_on)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x14
;    PORTB&= ~(1<<port);}
	IN   R1,24
	LDS  R30,_port
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x18,R30
;}
_0x14:
	LDS  R30,_port
	SUBI R30,-LOW(1)
	STS  _port,R30
	RJMP _0xE
_0xF:
;//формула, рассчитывающая по-переменный нагрев
;//heater_history[200];
;
; 0000 0042 }
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
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0045 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0046 // Reinitialize Timer1 value
; 0000 0047 TCNT1H=0x85EE >> 8;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 0048 TCNT1L=0x85EE & 0xff;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0049 // Place your code here
; 0000 004A #include <sec_interrupt.c>
;
;
;if (lcd_freeze==0){lcd_switcher++;}else{lcd_freeze--;}
	LDS  R30,_lcd_freeze
	CPI  R30,0
	BRNE _0x15
	LDS  R30,_lcd_switcher
	SUBI R30,-LOW(1)
	STS  _lcd_switcher,R30
	RJMP _0x16
_0x15:
	LDS  R30,_lcd_freeze
	SUBI R30,LOW(1)
	STS  _lcd_freeze,R30
_0x16:
;
;
;if (start==1){
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BRNE _0x17
;sec_heat[0]++;
	LDS  R30,_sec_heat
	SUBI R30,-LOW(1)
	STS  _sec_heat,R30
;sec_heat[1]++;
	__GETB1MN _sec_heat,1
	SUBI R30,-LOW(1)
	__PUTB1MN _sec_heat,1
;sec++;
	LDS  R30,_sec
	SUBI R30,-LOW(1)
	STS  _sec,R30
;sec_profile[0]++;
	LDS  R30,_sec_profile
	SUBI R30,-LOW(1)
	STS  _sec_profile,R30
;sec_profile[1]++;
	__GETB1MN _sec_profile,1
	SUBI R30,-LOW(1)
	__PUTB1MN _sec_profile,1
;}
;else{
	RJMP _0x18
_0x17:
;sec_profile[0]=sec_profile[1]=sec_heat[0]=sec_heat[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _sec_heat,1
	STS  _sec_heat,R30
	__PUTB1MN _sec_profile,1
	STS  _sec_profile,R30
;}
_0x18:
;
;if (sec>60){min++;sec=0;}
	LDS  R26,_sec
	CPI  R26,LOW(0x3D)
	BRLO _0x19
	LDS  R30,_min
	SUBI R30,-LOW(1)
	STS  _min,R30
	LDI  R30,LOW(0)
	STS  _sec,R30
;if (min>60){hour++;min=0;}
_0x19:
	LDS  R26,_min
	CPI  R26,LOW(0x3D)
	BRLO _0x1A
	LDS  R30,_hour
	SUBI R30,-LOW(1)
	STS  _hour,R30
	LDI  R30,LOW(0)
	STS  _min,R30
;
; 0000 004B }
_0x1A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0053 {
_read_adc:
; .FSTART _read_adc
; 0000 0054 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0055 // Delay needed for the stabilization of the ADC input voltage
; 0000 0056 delay_us(100);
	__DELAY_USW 200
; 0000 0057 // Start the AD conversion
; 0000 0058 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0059 // Wait for the AD conversion to complete
; 0000 005A while ((ADCSRA & (1<<ADIF))==0);
_0x1B:
	SBIS 0x6,4
	RJMP _0x1B
; 0000 005B ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 005C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0001
; 0000 005D }
; .FEND
;
;void main(void)
; 0000 0060 {
_main:
; .FSTART _main
; 0000 0061 lcd_stateU=*" ";
	__POINTW1FN _0x0,0
	LPM  R4,Z
; 0000 0062 lcd_stateB=lcd_stateU;
	MOV  R7,R4
; 0000 0063 
; 0000 0064     for (k=0;k<6;k++){
	LDI  R30,LOW(0)
	STS  _k,R30
_0x1F:
	LDS  R26,_k
	CPI  R26,LOW(0x6)
	BRSH _0x20
; 0000 0065     choose[k]=*" ";
	LDI  R27,0
	SUBI R26,LOW(-_choose)
	SBCI R27,HIGH(-_choose)
	__POINTW1FN _0x0,0
	LPM  R30,Z
	ST   X,R30
; 0000 0066     }
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
	RJMP _0x1F
_0x20:
; 0000 0067 
; 0000 0068 // Declare your local variables here
; 0000 0069 
; 0000 006A // Input/Output Ports initialization
; 0000 006B // Port B initialization
; 0000 006C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 006D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 006E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0070 
; 0000 0071 // Port C initialization
; 0000 0072 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0073 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0074 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0075 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0076 
; 0000 0077 // Port D initialization
; 0000 0078 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0079 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 007A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 007C 
; 0000 007D // Timer/Counter 0 initialization
; 0000 007E // Clock source: System Clock
; 0000 007F // Clock value: 7.813 kHz
; 0000 0080 TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0081 TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 1 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: Timer1 Stopped
; 0000 0086 // Mode: Normal top=0xFFFF
; 0000 0087 // OC1A output: Disconnected
; 0000 0088 // OC1B output: Disconnected
; 0000 0089 // Noise Canceler: Off
; 0000 008A // Input Capture on Falling Edge
; 0000 008B // Timer1 Overflow Interrupt: Off
; 0000 008C // Input Capture Interrupt: Off
; 0000 008D // Compare A Match Interrupt: Off
; 0000 008E // Compare B Match Interrupt: Off
; 0000 008F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0090 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0091 TCNT1H=0x85;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 0092 TCNT1L=0xEE;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0093 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0094 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0095 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0096 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0097 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0098 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0099 
; 0000 009A // Timer/Counter 2 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: Timer2 Stopped
; 0000 009D // Mode: Normal top=0xFF
; 0000 009E // OC2 output: Disconnected
; 0000 009F ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00A0 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00A1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00A2 OCR2=0x00;
	OUT  0x23,R30
; 0000 00A3 
; 0000 00A4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A5 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 00A6 
; 0000 00A7 // External Interrupt(s) initialization
; 0000 00A8 // INT0: Off
; 0000 00A9 // INT1: Off
; 0000 00AA MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00AB 
; 0000 00AC // USART initialization
; 0000 00AD // USART disabled
; 0000 00AE UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00AF 
; 0000 00B0 // Analog Comparator initialization
; 0000 00B1 // Analog Comparator: Off
; 0000 00B2 // The Analog Comparator's positive input is
; 0000 00B3 // connected to the AIN0 pin
; 0000 00B4 // The Analog Comparator's negative input is
; 0000 00B5 // connected to the AIN1 pin
; 0000 00B6 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B7 
; 0000 00B8 // ADC initialization
; 0000 00B9 // ADC Clock frequency: 1000.000 kHz
; 0000 00BA // ADC Voltage Reference: AREF pin
; 0000 00BB ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00BC ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00BD SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00BE 
; 0000 00BF // SPI initialization
; 0000 00C0 // SPI disabled
; 0000 00C1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00C2 
; 0000 00C3 // TWI initialization
; 0000 00C4 // TWI disabled
; 0000 00C5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00C6 
; 0000 00C7 // Alphanumeric LCD initialization
; 0000 00C8 // Connections are specified in the
; 0000 00C9 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00CA // RS - PORTD Bit 0
; 0000 00CB // RD - PORTD Bit 1
; 0000 00CC // EN - PORTD Bit 2
; 0000 00CD // D4 - PORTD Bit 3
; 0000 00CE // D5 - PORTD Bit 5
; 0000 00CF // D6 - PORTD Bit 6
; 0000 00D0 // D7 - PORTD Bit 7
; 0000 00D1 // Characters/line: 16
; 0000 00D2 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00D3 
; 0000 00D4 set_tempU=set_tempU_eep;
	LDI  R26,LOW(_set_tempU_eep)
	LDI  R27,HIGH(_set_tempU_eep)
	RCALL __EEPROMRDB
	STS  _set_tempU,R30
; 0000 00D5 set_tempB=set_tempB_eep;
	LDI  R26,LOW(_set_tempB_eep)
	LDI  R27,HIGH(_set_tempB_eep)
	RCALL __EEPROMRDB
	STS  _set_tempB,R30
; 0000 00D6 
; 0000 00D7 // Global enable interrupts
; 0000 00D8 #asm("sei")
	sei
; 0000 00D9 
; 0000 00DA while (1)
_0x21:
; 0000 00DB       {
; 0000 00DC #include <while.c>;
;if (Timer_1==50){
	LDI  R30,LOW(50)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x24
;//первый ADC
;lcd_clear();
	RCALL _lcd_clear
;if (show_lcd!=4){
	LDI  R30,LOW(4)
	CP   R30,R6
	BREQ _0x25
;now_tempB=read_adc(0)/4;
	LDI  R26,LOW(0)
	RCALL _read_adc
	RCALL __LSRW2
	MOVW R10,R30
;now_tempU=read_adc(1)/4;
	LDI  R26,LOW(1)
	RCALL _read_adc
	RCALL __LSRW2
	MOVW R8,R30
;sprintf(lcd_buffer,"%cB:%d %cU:%d",lcd_stateB,now_tempB,lcd_stateU,now_tempU);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,4
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	MOVW R30,R10
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	MOV  R30,R4
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	MOVW R30,R8
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
;//lcd_clear();        /* очистка дисплея */
;lcd_gotoxy(0,0);        /* верхняя строка, 4 позиция */
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;
;
;}
;if (lcd_freeze==0){
_0x25:
	LDS  R30,_lcd_freeze
	CPI  R30,0
	BRNE _0x26
;if(lcd_switcher==0){show_lcd=0;}//показываем установленную температуру
	LDS  R30,_lcd_switcher
	CPI  R30,0
	BRNE _0x27
	CLR  R6
;if(lcd_switcher==5){if (start==1){show_lcd=1;}else{lcd_switcher=8;};}//время с момоента пуска
_0x27:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0x5)
	BRNE _0x28
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BRNE _0x29
	LDI  R30,LOW(1)
	MOV  R6,R30
	RJMP _0x2A
_0x29:
	LDI  R30,LOW(8)
	STS  _lcd_switcher,R30
_0x2A:
;if(lcd_switcher==8){show_lcd=2;}//мощность нагр
_0x28:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0x8)
	BRNE _0x2B
	LDI  R30,LOW(2)
	MOV  R6,R30
;if(lcd_switcher==10){show_lcd=4;}//вкл. и выкл. нагревателей
_0x2B:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0xA)
	BRNE _0x2C
	LDI  R30,LOW(4)
	MOV  R6,R30
;if(lcd_switcher==14){lcd_switcher=0;}
_0x2C:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0xE)
	BRNE _0x2D
	LDI  R30,LOW(0)
	STS  _lcd_switcher,R30
;}
_0x2D:
;//show_lcd=4;
;//set_tempB=read_adc(2)/4;
;//set_tempU=read_adc(3)/4;
;
;
;
;if (show_lcd==0){
_0x26:
	TST  R6
	BRNE _0x2E
;//третий ADC
;sprintf(lcd_buffer,"%cSB:%d",choose[3],set_tempB);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,18
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _choose,3
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_set_tempB
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
;lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;
;//четвертый ADC
;sprintf(lcd_buffer,"%cSU:%d",choose[4],set_tempU);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _choose,4
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_set_tempU
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
;lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;//четвертый ADC
;}
;if (show_lcd==1){
_0x2E:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x2F
;lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;sprintf(lcd_buffer,"%d:%d:%d",hour,min,sec);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_hour
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_min
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_sec
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;}
;if (show_lcd==2){
_0x2F:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x30
;lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;sprintf(lcd_buffer,"%cPwrU:%d%cPwrB:%d",choose[1],PWM_setted[0],choose[2],PWM_setted[1]);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,43
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _choose,1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_PWM_setted
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETB1MN _choose,2
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETB1MN _PWM_setted,1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;}
;if (show_lcd==3){
_0x30:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x31
;lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;sprintf(lcd_buffer,"%c start:%d",choose[0],start);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,62
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_choose
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_start
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;}
;if (show_lcd==4){
_0x31:
	LDI  R30,LOW(4)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x32
;lcd_clear();
	RCALL _lcd_clear
;lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
;sprintf(lcd_buffer,"%cUon:%d off:%d",lcd_stateU,heat_sec_on[0],heat_sec_off[0]);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_heat_sec_on
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_heat_sec_off
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
;sprintf(lcd_buffer,"%cBon:%d off:%d",lcd_stateB,heat_sec_on[1],heat_sec_off[1]);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,90
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETB1MN _heat_sec_on,1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETB1MN _heat_sec_off,1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
;lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
;}
;Timer_1=0;
_0x32:
	CLR  R5
;
;}
;
;
;//if (set_tempB!=set_tempB_prev){show_lcd=0;lcd_freeze=5;set_tempB_prev=set_tempB;}
;//if (set_tempU!=set_tempU_prev){show_lcd=0;lcd_freeze=5;set_tempU_prev=set_tempU;}
; 0000 00DD #include <t_profile.c>;
;if (start==1){
_0x24:
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x33
;if (now_tempB<set_tempB){
	LDS  R30,_set_tempB
	MOVW R26,R10
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x34
;    if(sec_heat[0]==0){heater_on[0]=1;lcd_stateB=*"H";}
	LDS  R30,_sec_heat
	CPI  R30,0
	BRNE _0x35
	LDI  R30,LOW(1)
	STS  _heater_on,R30
	__POINTW1FN _0x0,106
	LPM  R7,Z
;    if(sec_heat[0]==heat_sec_on[0]){heater_on[0]=0;lcd_stateB=*"p";}
_0x35:
	LDS  R30,_heat_sec_on
	LDS  R26,_sec_heat
	CP   R30,R26
	BRNE _0x36
	LDI  R30,LOW(0)
	STS  _heater_on,R30
	__POINTW1FN _0x0,108
	LPM  R7,Z
;    if(sec_heat[0]==heat_sec_on[0]+heat_sec_off[0]){sec_heat[0]=0;}
_0x36:
	LDS  R26,_heat_sec_on
	CLR  R27
	LDS  R30,_heat_sec_off
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_sec_heat
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x37
	LDI  R30,LOW(0)
	STS  _sec_heat,R30
;    }
_0x37:
;    else{
	RJMP _0x38
_0x34:
;    lcd_stateB=*"|";
	__POINTW1FN _0x0,110
	LPM  R7,Z
;    heater_on[0]=0;
	LDI  R30,LOW(0)
	STS  _heater_on,R30
;    sec_heat[0]=0;
	STS  _sec_heat,R30
;}
_0x38:
;
;if (now_tempU<set_tempU){
	LDS  R30,_set_tempU
	MOVW R26,R8
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x39
;    if(sec_heat[1]==0){heater_on[1]=1;lcd_stateU=*"H";}
	__GETB1MN _sec_heat,1
	CPI  R30,0
	BRNE _0x3A
	LDI  R30,LOW(1)
	__PUTB1MN _heater_on,1
	__POINTW1FN _0x0,106
	LPM  R4,Z
;    if(sec_heat[1]==heat_sec_on[1]){heater_on[1]=0;lcd_stateU=*"p";}
_0x3A:
	__GETB2MN _sec_heat,1
	__GETB1MN _heat_sec_on,1
	CP   R30,R26
	BRNE _0x3B
	LDI  R30,LOW(0)
	__PUTB1MN _heater_on,1
	__POINTW1FN _0x0,108
	LPM  R4,Z
;    if(sec_heat[1]==heat_sec_on[1]+heat_sec_off[1]){sec_heat[1]=0;}
_0x3B:
	__GETBRMN 0,_sec_heat,1
	__GETB2MN _heat_sec_on,1
	CLR  R27
	__GETB1MN _heat_sec_off,1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOV  R26,R0
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x3C
	LDI  R30,LOW(0)
	__PUTB1MN _sec_heat,1
;    }
_0x3C:
;    else{
	RJMP _0x3D
_0x39:
;    lcd_stateU=*"|";
	__POINTW1FN _0x0,110
	LPM  R4,Z
;    heater_on[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _heater_on,1
;    sec_heat[1]=0;
	__PUTB1MN _sec_heat,1
;}
_0x3D:
;}
;else{
	RJMP _0x3E
_0x33:
;lcd_stateU=lcd_stateB=*"_";heater_on[0]=heater_on[1]=0;
	__POINTW1FN _0x0,112
	LPM  R30,Z
	MOV  R7,R30
	MOV  R4,R30
	LDI  R30,LOW(0)
	__PUTB1MN _heater_on,1
	STS  _heater_on,R30
;}
_0x3E:
;
;
;
;if (start==1){
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x3F
;if (sec_profile[0]==2){
	LDS  R26,_sec_profile
	CPI  R26,LOW(0x2)
	BRNE _0x40
;    if (now_tempB>now_tempB_prev+1){
	LDS  R30,_now_tempB_prev
	LDI  R31,0
	ADIW R30,1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x41
;        if (heat_sec_off[0]<10) {heat_sec_off[0]++;}
	LDS  R26,_heat_sec_off
	CPI  R26,LOW(0xA)
	BRSH _0x42
	LDS  R30,_heat_sec_off
	SUBI R30,-LOW(1)
	STS  _heat_sec_off,R30
;        if (heat_sec_on[0]>0) {heat_sec_on[0]--;}
_0x42:
	LDS  R26,_heat_sec_on
	CPI  R26,LOW(0x1)
	BRLO _0x43
	LDS  R30,_heat_sec_on
	SUBI R30,LOW(1)
	STS  _heat_sec_on,R30
;           now_tempB_prev=now_tempB;
_0x43:
	STS  _now_tempB_prev,R10
;    }
;    if (now_tempB<now_tempB_prev+1){
_0x41:
	LDS  R30,_now_tempB_prev
	LDI  R31,0
	ADIW R30,1
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x44
;            if (heat_sec_off[0]>1) {heat_sec_off[0]--;}
	LDS  R26,_heat_sec_off
	CPI  R26,LOW(0x2)
	BRLO _0x45
	LDS  R30,_heat_sec_off
	SUBI R30,LOW(1)
	STS  _heat_sec_off,R30
;            if (heat_sec_on[0]<10) {heat_sec_on[0]++;}
_0x45:
	LDS  R26,_heat_sec_on
	CPI  R26,LOW(0xA)
	BRSH _0x46
	LDS  R30,_heat_sec_on
	SUBI R30,-LOW(1)
	STS  _heat_sec_on,R30
;            now_tempB_prev=now_tempB;
_0x46:
	STS  _now_tempB_prev,R10
;    sec_profile[0]=0;
	LDI  R30,LOW(0)
	STS  _sec_profile,R30
;    }
;    }
_0x44:
;if (sec_profile[1]==2){
_0x40:
	__GETB2MN _sec_profile,1
	CPI  R26,LOW(0x2)
	BRNE _0x47
;    if (now_tempU>now_tempU_prev+1){
	LDS  R30,_now_tempU_prev
	LDI  R31,0
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x48
;        if (heat_sec_off[1]<10) {heat_sec_off[1]++;}
	__GETB2MN _heat_sec_off,1
	CPI  R26,LOW(0xA)
	BRSH _0x49
	__GETB1MN _heat_sec_off,1
	SUBI R30,-LOW(1)
	__PUTB1MN _heat_sec_off,1
;        if (heat_sec_on[1]>0) {heat_sec_on[1]--;}
_0x49:
	__GETB2MN _heat_sec_on,1
	CPI  R26,LOW(0x1)
	BRLO _0x4A
	__GETB1MN _heat_sec_on,1
	SUBI R30,LOW(1)
	__PUTB1MN _heat_sec_on,1
;        now_tempU_prev=now_tempU;
_0x4A:
	STS  _now_tempU_prev,R8
;    ;}
;    if (now_tempU<now_tempU_prev+1){
_0x48:
	LDS  R30,_now_tempU_prev
	LDI  R31,0
	ADIW R30,1
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x4B
;            if (heat_sec_off[1]>1) {heat_sec_off[1]--;}
	__GETB2MN _heat_sec_off,1
	CPI  R26,LOW(0x2)
	BRLO _0x4C
	__GETB1MN _heat_sec_off,1
	SUBI R30,LOW(1)
	__PUTB1MN _heat_sec_off,1
;            if (heat_sec_on[1]<10) {heat_sec_on[1]++;}
_0x4C:
	__GETB2MN _heat_sec_on,1
	CPI  R26,LOW(0xA)
	BRSH _0x4D
	__GETB1MN _heat_sec_on,1
	SUBI R30,-LOW(1)
	__PUTB1MN _heat_sec_on,1
;            now_tempU_prev=now_tempU;
_0x4D:
	STS  _now_tempU_prev,R8
;     ;}
;    sec_profile[1]=0;
_0x4B:
	LDI  R30,LOW(0)
	__PUTB1MN _sec_profile,1
;    }
;}
_0x47:
; 0000 00DE #include <button_while.c>;
;
;if ((PINB.2==0)&&(BTN1_pressed==0)){
_0x3F:
	SBIC 0x16,2
	RJMP _0x4F
	LDS  R26,_BTN1_pressed
	CPI  R26,LOW(0x0)
	BREQ _0x50
_0x4F:
	RJMP _0x4E
_0x50:
;if(heater_swither==0){PWM_setted[0]++;show_lcd=2;}
	LDS  R30,_heater_swither
	CPI  R30,0
	BRNE _0x51
	LDS  R30,_PWM_setted
	SUBI R30,-LOW(1)
	STS  _PWM_setted,R30
	LDI  R30,LOW(2)
	MOV  R6,R30
;if(heater_swither==1){PWM_setted[1]++;show_lcd=2;}
_0x51:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x1)
	BRNE _0x52
	__GETB1MN _PWM_setted,1
	SUBI R30,-LOW(1)
	__PUTB1MN _PWM_setted,1
	LDI  R30,LOW(2)
	MOV  R6,R30
;if(heater_swither==2){start=1;show_lcd=3;};
_0x52:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x2)
	BRNE _0x53
	LDI  R30,LOW(1)
	STS  _start,R30
	LDI  R30,LOW(3)
	MOV  R6,R30
_0x53:
;if (heater_swither==3){show_lcd=0;set_tempB++;}
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x3)
	BRNE _0x54
	CLR  R6
	LDS  R30,_set_tempB
	SUBI R30,-LOW(1)
	STS  _set_tempB,R30
;if (heater_swither==4){show_lcd=0;set_tempU++;}
_0x54:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x4)
	BRNE _0x55
	CLR  R6
	LDS  R30,_set_tempU
	SUBI R30,-LOW(1)
	STS  _set_tempU,R30
;
;//set_tempU_ee=set_tempU;
;//set_tempB_ee=set_tempB;
;
;lcd_freeze=5;
_0x55:
	LDI  R30,LOW(5)
	STS  _lcd_freeze,R30
;BTN1_pressed=1;
	LDI  R30,LOW(1)
	STS  _BTN1_pressed,R30
;}
;if(PINB.2==1){BTN1_pressed=0;}
_0x4E:
	SBIS 0x16,2
	RJMP _0x56
	LDI  R30,LOW(0)
	STS  _BTN1_pressed,R30
;
;if ((PINB.3==0)&&(BTN2_pressed==0)){
_0x56:
	SBIC 0x16,3
	RJMP _0x58
	LDS  R26,_BTN2_pressed
	CPI  R26,LOW(0x0)
	BREQ _0x59
_0x58:
	RJMP _0x57
_0x59:
;if(heater_swither==0){PWM_setted[0]--;show_lcd=2;}
	LDS  R30,_heater_swither
	CPI  R30,0
	BRNE _0x5A
	LDS  R30,_PWM_setted
	SUBI R30,LOW(1)
	STS  _PWM_setted,R30
	LDI  R30,LOW(2)
	MOV  R6,R30
;if(heater_swither==1){PWM_setted[1]--;show_lcd=2;}
_0x5A:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x1)
	BRNE _0x5B
	__GETB1MN _PWM_setted,1
	SUBI R30,LOW(1)
	__PUTB1MN _PWM_setted,1
	LDI  R30,LOW(2)
	MOV  R6,R30
;if(heater_swither==2){start=0;show_lcd=3;};
_0x5B:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x2)
	BRNE _0x5C
	LDI  R30,LOW(0)
	STS  _start,R30
	LDI  R30,LOW(3)
	MOV  R6,R30
_0x5C:
;if (heater_swither==3){show_lcd=0;set_tempB--;}
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x3)
	BRNE _0x5D
	CLR  R6
	LDS  R30,_set_tempB
	SUBI R30,LOW(1)
	STS  _set_tempB,R30
;if (heater_swither==4){show_lcd=0;set_tempU--;}
_0x5D:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x4)
	BRNE _0x5E
	CLR  R6
	LDS  R30,_set_tempU
	SUBI R30,LOW(1)
	STS  _set_tempU,R30
;
;
;BTN2_pressed=1;
_0x5E:
	LDI  R30,LOW(1)
	STS  _BTN2_pressed,R30
;lcd_freeze=5;
	LDI  R30,LOW(5)
	STS  _lcd_freeze,R30
;}
;if(PINB.3==1){BTN2_pressed=0;}
_0x57:
	SBIS 0x16,3
	RJMP _0x5F
	LDI  R30,LOW(0)
	STS  _BTN2_pressed,R30
;
;if ((PINB.4==0)&&(BTN3_pressed==0)){
_0x5F:
	SBIC 0x16,4
	RJMP _0x61
	SBRS R2,0
	RJMP _0x62
_0x61:
	RJMP _0x60
_0x62:
;
;heater_swither++;
	LDS  R30,_heater_swither
	SUBI R30,-LOW(1)
	STS  _heater_swither,R30
;if (heater_swither>4){heater_swither=0;}
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x5)
	BRLO _0x63
	LDI  R30,LOW(0)
	STS  _heater_swither,R30
;
;if (heater_swither==0){choose_v(1);show_lcd=2;}
_0x63:
	LDS  R30,_heater_swither
	CPI  R30,0
	BRNE _0x64
	LDI  R26,LOW(1)
	RCALL _choose_v
	LDI  R30,LOW(2)
	MOV  R6,R30
;if (heater_swither==1){choose_v(2);show_lcd=2;}
_0x64:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x1)
	BRNE _0x65
	LDI  R26,LOW(2)
	RCALL _choose_v
	LDI  R30,LOW(2)
	MOV  R6,R30
;if (heater_swither==2){show_lcd=3;choose_v(0);}
_0x65:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x2)
	BRNE _0x66
	LDI  R30,LOW(3)
	MOV  R6,R30
	LDI  R26,LOW(0)
	RCALL _choose_v
;if (heater_swither==3){show_lcd=0;choose_v(3);}
_0x66:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x3)
	BRNE _0x67
	CLR  R6
	LDI  R26,LOW(3)
	RCALL _choose_v
;if (heater_swither==4){show_lcd=0;choose_v(4);}
_0x67:
	LDS  R26,_heater_swither
	CPI  R26,LOW(0x4)
	BRNE _0x68
	CLR  R6
	LDI  R26,LOW(4)
	RCALL _choose_v
;
;
;set_tempU_eep=set_tempU;
_0x68:
	LDS  R30,_set_tempU
	LDI  R26,LOW(_set_tempU_eep)
	LDI  R27,HIGH(_set_tempU_eep)
	RCALL __EEPROMWRB
;set_tempB_eep=set_tempB;
	LDS  R30,_set_tempB
	LDI  R26,LOW(_set_tempB_eep)
	LDI  R27,HIGH(_set_tempB_eep)
	RCALL __EEPROMWRB
;
;
;BTN3_pressed=1;
	SET
	BLD  R2,0
;lcd_freeze=5;
	LDI  R30,LOW(5)
	STS  _lcd_freeze,R30
;}
;
;if((PINB.4==1)&&(BTN3_pressed==1)){BTN3_pressed=0;
_0x60:
	SBIS 0x16,4
	RJMP _0x6A
	SBRC R2,0
	RJMP _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
	CLT
	BLD  R2,0
;//eeprom_write_byte(uint8_t * __p,0x55);
;
;//eeprom_write_byte((uint8_t*)0,set_tempB);
;}
;//hjgkgmjhl.dddd890
;//fgh87)-+|89****dgh+
;
;//}
; 0000 00DF 
; 0000 00E0 
; 0000 00E1 
; 0000 00E2       // Place your code here
; 0000 00E3 
; 0000 00E4       }
_0x69:
	RJMP _0x21
; 0000 00E5 }
_0x6C:
	RJMP _0x6C
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
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	RCALL __GETW1P
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
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
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,11
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,1
	STD  Y+23,R30
	STD  Y+23+1,R31
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
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	RJMP _0x20000D2
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
	BRNE _0x2000028
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
	CPI  R18,108
	BRNE _0x200002C
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x200002C:
	RJMP _0x200002D
_0x2000028:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200001B
_0x200002D:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000032
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x73)
	BRNE _0x2000035
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x70)
	BRNE _0x2000038
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000036:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x64)
	BREQ _0x200003C
	CPI  R30,LOW(0x69)
	BRNE _0x200003D
_0x200003C:
	ORI  R16,LOW(4)
	RJMP _0x200003E
_0x200003D:
	CPI  R30,LOW(0x75)
	BRNE _0x200003F
_0x200003E:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000040
	__GETD1N 0x3B9ACA00
	__PUTD1S 8
	LDI  R17,LOW(10)
	RJMP _0x2000041
_0x2000040:
	__GETD1N 0x2710
	__PUTD1S 8
	LDI  R17,LOW(5)
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x58)
	BRNE _0x2000043
	ORI  R16,LOW(8)
	RJMP _0x2000044
_0x2000043:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000044:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000046
	__GETD1N 0x10000000
	__PUTD1S 8
	LDI  R17,LOW(8)
	RJMP _0x2000041
_0x2000046:
	__GETD1N 0x1000
	__PUTD1S 8
	LDI  R17,LOW(4)
_0x2000041:
	SBRS R16,1
	RJMP _0x2000047
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x20000D3
_0x2000047:
	SBRS R16,2
	RJMP _0x2000049
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETW1P
	RCALL __CWD1
	RJMP _0x20000D3
_0x2000049:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETW1P
	CLR  R22
	CLR  R23
_0x20000D3:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x200004B
	LDD  R26,Y+15
	TST  R26
	BRPL _0x200004C
	__GETD1S 12
	RCALL __ANEGD1
	__PUTD1S 12
	LDI  R20,LOW(45)
_0x200004C:
	CPI  R20,0
	BREQ _0x200004D
	SUBI R17,-LOW(1)
	RJMP _0x200004E
_0x200004D:
	ANDI R16,LOW(251)
_0x200004E:
_0x200004B:
_0x2000039:
	SBRC R16,0
	RJMP _0x200004F
_0x2000050:
	CP   R17,R21
	BRSH _0x2000052
	SBRS R16,7
	RJMP _0x2000053
	SBRS R16,2
	RJMP _0x2000054
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000055
_0x2000054:
	LDI  R18,LOW(48)
_0x2000055:
	RJMP _0x2000056
_0x2000053:
	LDI  R18,LOW(32)
_0x2000056:
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2000050
_0x2000052:
_0x200004F:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x2000057
_0x2000058:
	CPI  R19,0
	BREQ _0x200005A
	SBRS R16,3
	RJMP _0x200005B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x200005C
_0x200005B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005C:
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	CPI  R21,0
	BREQ _0x200005D
	SUBI R21,LOW(1)
_0x200005D:
	SUBI R19,LOW(1)
	RJMP _0x2000058
_0x200005A:
	RJMP _0x200005E
_0x2000057:
_0x2000060:
	__GETD1S 8
	__GETD2S 12
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000062
	SBRS R16,3
	RJMP _0x2000063
	SUBI R18,-LOW(55)
	RJMP _0x2000064
_0x2000063:
	SUBI R18,-LOW(87)
_0x2000064:
	RJMP _0x2000065
_0x2000062:
	SUBI R18,-LOW(48)
_0x2000065:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x200006B
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x200006B:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	__GETD1S 8
	__GETD2S 12
	RCALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	__PUTD1S 8
	RCALL __CPD10
	BREQ _0x2000061
	RJMP _0x2000060
_0x2000061:
_0x200005E:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000033:
_0x20000D2:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,25
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	SBIW R30,0
	BRNE _0x2000078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x2000078:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
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
_0x20A0002:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,5
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,5
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,7
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,7
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,4
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,4
_0x202000B:
	__DELAY_USB 13
	SBI  0x12,6
	__DELAY_USB 13
	CBI  0x12,6
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
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
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20A0001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,5
	SBI  0x17,7
	SBI  0x17,6
	SBI  0x11,4
	SBI  0x11,6
	SBI  0x17,0
	SBI  0x11,7
	CBI  0x12,6
	CBI  0x18,0
	CBI  0x12,7
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
	ST   -Y,R27
	ST   -Y,R26
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
	.BYTE 0x14
_choose:
	.BYTE 0x6
_sec:
	.BYTE 0x1
_min:
	.BYTE 0x1
_hour:
	.BYTE 0x1
_port:
	.BYTE 0x1
_PWM_width:
	.BYTE 0x1
_PWM_step:
	.BYTE 0x2
_heater_on:
	.BYTE 0x2
_sec_heat:
	.BYTE 0x2
_lcd_switcher:
	.BYTE 0x1
_BTN1_pressed:
	.BYTE 0x1
_BTN2_pressed:
	.BYTE 0x1
_lcd_freeze:
	.BYTE 0x1
_heater_swither:
	.BYTE 0x1
_start:
	.BYTE 0x1
_now_tempB_prev:
	.BYTE 0x1
_sec_profile:
	.BYTE 0x2
_now_tempU_prev:
	.BYTE 0x1
_set_tempB:
	.BYTE 0x1
_set_tempU:
	.BYTE 0x1

	.ESEG
_set_tempB_eep:
	.DB  0xC8
_set_tempU_eep:
	.DB  0xC8

	.DSEG
_PWM_setted:
	.BYTE 0x2
_heat_sec_on:
	.BYTE 0x2
_heat_sec_off:
	.BYTE 0x2
_k:
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

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
