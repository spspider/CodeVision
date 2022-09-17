
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
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
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

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
	.DEF _lcd_stateU=R7
	.DEF _lcd_stateB=R6
	.DEF _Timer_1=R9
	.DEF _Timer_2=R8
	.DEF _PWM_width=R11
	.DEF _now_tempU=R12
	.DEF _now_tempU_msb=R13
	.DEF _show_lcd=R10

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x3,0xA,0x0,0x0

_0x3:
	.DB  0x1,0x1
_0x4:
	.DB  0x1
_0x5:
	.DB  0x3
_0x6:
	.DB  0x6F
_0x7:
	.DB  0xA,0xD7,0x23,0xBC
_0x8:
	.DB  0xA,0xD7,0x23,0xBC
_0x9:
	.DB  0x0,0x0,0x80,0x3F,0x0,0x0,0x80,0x3F
_0x0:
	.DB  0x20,0x0,0x3E,0x0,0x5F,0x0,0x7C,0x0
	.DB  0x48,0x0,0x4C,0x6F,0x61,0x64,0x69,0x6E
	.DB  0x67,0x0,0x25,0x63,0x25,0x33,0x64,0x25
	.DB  0x63,0x25,0x33,0x64,0x54,0x25,0x33,0x64
	.DB  0x2D,0x25,0x33,0x64,0x0,0x25,0x32,0x64
	.DB  0x55,0x25,0x32,0x64,0x52,0x25,0x31,0x64
	.DB  0x50,0x25,0x64,0x2D,0x25,0x64,0x0,0x25
	.DB  0x63,0x50,0x6D,0x55,0x3A,0x25,0x64,0x25
	.DB  0x63,0x50,0x6D,0x42,0x3A,0x25,0x64,0x0
	.DB  0x25,0x63,0x73,0x74,0x5F,0x55,0x3A,0x25
	.DB  0x64,0x25,0x63,0x73,0x74,0x5F,0x42,0x3A
	.DB  0x25,0x64,0x0,0x25,0x63,0x53,0x62,0x25
	.DB  0x64,0x0,0x25,0x63,0x53,0x70,0x25,0x64
	.DB  0x25,0x63,0x55,0x25,0x64,0x25,0x63,0x42
	.DB  0x25,0x64,0x0,0x6B,0x42,0x3A,0x25,0x64
	.DB  0x6B,0x55,0x3A,0x25,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x0A
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _PWM_setted
	.DW  _0x3*2

	.DW  0x01
	.DW  _lcd_switcher
	.DW  _0x4*2

	.DW  0x01
	.DW  _heater_swither
	.DW  _0x5*2

	.DW  0x04
	.DW  _heat_koeff_B
	.DW  _0x7*2

	.DW  0x04
	.DW  _heat_koeff_U
	.DW  _0x8*2

	.DW  0x08
	.DW  _PWM_koeff
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
;//#define HEAT_U PORTD
;#include <delay.h>
;#include <stdio.h>
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <eeprom.h>
;
;// Declare your global variables here
;char lcd_buffer[33],lcd_stateU,lcd_stateB,choose[13];
;unsigned char Timer_1,Timer_2;
;bit BTN3_pressed;
;//////////////////////////
;eeprom unsigned char PWM_setted_eeprom[2]={1,1};
;unsigned char PWM_setted[2]={1,1};

	.DSEG
;unsigned char PWM_width=10;
;//////////////////////////
;int now_tempU=0,now_tempB=0;
;//unsigned int set_tempB_prev,set_tempU_prev;
;unsigned char show_lcd=3,t_sec=0,t_min=0,t_hour=0,port,PWM_step[2],heater_on[2],sec_heat[2],lcd_switcher=1,BTN1_pressed, ...
;unsigned int sec_profile[2],sec_profile_off[2];
;int now_tempB_prev=0,now_tempU_prev=0;
;//unsigned char Timer_freq_buzz;
;
;//#define HUport 1<<PORTD2;
;//int POWER_H_U;
;//int POWER_H_B;
;unsigned char k=0;
;//buzzer:
;unsigned char buzz_freg=0,buzz_cont=0;
;
;//heater:
;unsigned char BTN_pressed=0,Timer_BTN_Pressed=0;
;unsigned char Timer_1sec=0;
;//t_profile
;unsigned char heat_approved[2]={0,0};
;unsigned char  Heat_time_timer_enabler=0,Heat_time[4],Heat_rule[4],Heat_time_timer=0;
;unsigned char  count_rules=0,now_rule=0,rule_engadged=0,rule_end=0,set_now_rule=0;
;unsigned int Heat_temp_U[4],Heat_temp_B[4];
;unsigned char Heat_speed[4],Heat_speed_B;
;eeprom unsigned int Heat_temp_U_eeprom[4],Heat_temp_B_eeprom[4];
;eeprom unsigned char Heat_speed_eeprom[4],Heat_speed_B_eeprom;
;unsigned char i;
;unsigned int sec_start_heat[2];
;
;unsigned char freq=111;//Tocr=(1/Tn)*8000000/1024=Tocr=(100/Tn)*78= от31 до 3906
;bit compliteU=0;
;bit compliteB=0;
;int  now_tempB_calc,now_tempU_calc;
;//float TCnt_0=70.0;
;//sec_iterrupt
;float heat_koeff_B =-0.01,heat_koeff_U=-0.01,PWM_koeff[2]={1.0,1.0};
;//float heat_koeff_B_profile=-0.01;
;int forecast_temp_U=0,forecast_temp_B=0;
;//unsigned int heat_koeff_int =0;
;//while
;unsigned int t_sec_least=0.0;
;unsigned char t_min_least=0,t_hour_least;
;unsigned char t_power_change_up[2],t_power_change_down[2];
;
;unsigned int koeff_b_int,koeff_u_int;
;
;int heat_k_B_int;
;int heat_k_U_int;
;void choose_v(char i){
; 0000 0058 void choose_v(char i){

	.CSEG
_choose_v:
; .FSTART _choose_v
; 0000 0059 
; 0000 005A     for (k=0;k<13;k++){
	ST   -Y,R26
;	i -> Y+0
	RCALL SUBOPT_0x0
_0xB:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0xD)
	BRSH _0xC
; 0000 005B     choose[k]=*" ";
	RCALL SUBOPT_0x2
; 0000 005C     }
	RCALL SUBOPT_0x3
	RJMP _0xB
_0xC:
; 0000 005D     choose[i]=*">";
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_choose)
	SBCI R27,HIGH(-_choose)
	__POINTW1FN _0x0,2
	LPM  R30,Z
	ST   X,R30
; 0000 005E }
	RJMP _0x20A0001
; .FEND
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0063 {
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
; 0000 0064 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0065 // Place your code here
; 0000 0066 
; 0000 0067 #include <heater.c>;
;//if (Bheater==1){
;
;
;
;//PWM_setted[0]=5;//текуща€ мощность нагревател€, нижний нагреватель
;//PWM_setted[1]=4;//текуща€ мощность нагревател€, верхний нагреватель
;//heat_sec_on[0]=5;
;//heat_sec_off[0]=5;
;//heat_sec_on[1]=5;
;//heat_sec_off[1]=5;
;
;for (port=0;port<2;port++){
	STS  _port,R30
_0xE:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x2)
	BRSH _0xF
;    if (heater_on[port]==1){ //heater_on[0]=PORTD. PORTD.2 PORTD.3
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_heater_on)
	SBCI R31,HIGH(-_heater_on)
	RCALL SUBOPT_0x6
	BRNE _0x10
;        if (PWM_setted[port]<PWM_step[port]){PORTD&= ~1<<(3-port);} //выключаем порт, если step больше 10
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
	BRSH _0x11
	RCALL SUBOPT_0x8
	LDI  R26,LOW(254)
	RCALL __LSLB12
	AND  R30,R1
	OUT  0x12,R30
;        if (PWM_setted[port]>=PWM_step[port]){PORTD|=1<<(3-port);}//включаем
_0x11:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
	BRLO _0x12
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x12,R30
;        if (PWM_step[port]>=PWM_width){PWM_step[port]=0;}
_0x12:
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LD   R26,Z
	CP   R26,R11
	BRLO _0x13
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LDI  R26,LOW(0)
	STD  Z+0,R26
;        PWM_step[port]++;                   //вместо 0 - 3 вместо 1 - 2
_0x13:
	RCALL SUBOPT_0x4
	LDI  R27,0
	SUBI R26,LOW(-_PWM_step)
	SBCI R27,HIGH(-_PWM_step)
	RCALL SUBOPT_0x9
;    }
;
;    if (heater_on[port]==0){
_0x10:
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_heater_on)
	SBCI R31,HIGH(-_heater_on)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x14
;    PORTD&= ~(1<<(3-port));}
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
;}
_0x14:
	LDS  R30,_port
	SUBI R30,-LOW(1)
	STS  _port,R30
	RJMP _0xE
_0xF:
;//формула, рассчитывающа€ по-переменный нагрев
;//heater_history[200];
;
; 0000 0068 }
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
; 0000 006B {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
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
; 0000 006C // Reinitialize Timer1 value
; 0000 006D TCNT1H=0xD8F0 >> 8;//10ms
	RCALL SUBOPT_0xA
; 0000 006E TCNT1L=0xD8F0 & 0xff;
; 0000 006F 
; 0000 0070 //TCNT1H=0xCF2C >> 8;//100ms
; 0000 0071 //TCNT1L=0xCF2C & 0xff;//100ms
; 0000 0072 // Place your code here
; 0000 0073 #include <sec_interrupt.c>
;
;Timer_1++;
	INC  R9
;//Timer_0=0;
;
;if (buzz_cont>0){
	LDS  R26,_buzz_cont
	CPI  R26,LOW(0x1)
	BRLO _0x15
;buzz_cont--;
	LDS  R30,_buzz_cont
	SUBI R30,LOW(1)
	RCALL SUBOPT_0xB
;}
;if (BTN_pressed==1){
_0x15:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1)
	BRNE _0x16
;Timer_BTN_Pressed++;
	LDS  R30,_Timer_BTN_Pressed
	SUBI R30,-LOW(1)
	STS  _Timer_BTN_Pressed,R30
;    if (Timer_BTN_Pressed>20){
	LDS  R26,_Timer_BTN_Pressed
	CPI  R26,LOW(0x15)
	BRLO _0x17
;    Timer_BTN_Pressed=0;
	LDI  R30,LOW(0)
	STS  _Timer_BTN_Pressed,R30
;    BTN_pressed=0;
	RCALL SUBOPT_0xD
;    }
;}
_0x17:
;
;
;//if (lcd_freeze<1){lcd_switcher++;}else{lcd_freeze--;}
;Timer_1sec++;
_0x16:
	LDS  R30,_Timer_1sec
	SUBI R30,-LOW(1)
	STS  _Timer_1sec,R30
;if (Timer_1sec>100){
	LDS  R26,_Timer_1sec
	CPI  R26,LOW(0x65)
	BRSH PC+2
	RJMP _0x18
;
;
;if (t_sec==59){
	LDS  R26,_t_sec
	CPI  R26,LOW(0x3B)
	BRNE _0x19
;
;    if (Heat_time_timer_enabler==1){
	LDS  R26,_Heat_time_timer_enabler
	CPI  R26,LOW(0x1)
	BRNE _0x1A
;    Heat_time_timer++;
	LDS  R30,_Heat_time_timer
	SUBI R30,-LOW(1)
	RJMP _0xDD
;    }
;    else{
_0x1A:
;    Heat_time_timer=0;
	LDI  R30,LOW(0)
_0xDD:
	STS  _Heat_time_timer,R30
;    }
;
;t_min++;t_sec=0;}
	LDS  R30,_t_min
	SUBI R30,-LOW(1)
	STS  _t_min,R30
	LDI  R30,LOW(0)
	STS  _t_sec,R30
;if (t_min>60){t_hour++;t_min=0;}
_0x19:
	LDS  R26,_t_min
	CPI  R26,LOW(0x3D)
	BRLO _0x1C
	LDS  R30,_t_hour
	SUBI R30,-LOW(1)
	STS  _t_hour,R30
	LDI  R30,LOW(0)
	STS  _t_min,R30
;Timer_1sec=0;
_0x1C:
	LDI  R30,LOW(0)
	STS  _Timer_1sec,R30
;
;if (start==0){
	LDS  R30,_start
	CPI  R30,0
	BRNE _0x1D
;lcd_stateU=*"_";heater_on[0]=0;now_rule=0;
	__POINTW1FN _0x0,4
	RCALL SUBOPT_0xE
	STS  _now_rule,R30
;now_tempU_prev=now_tempU;
	RCALL SUBOPT_0xF
;
;sec_profile[0]=t_sec=0;
	LDI  R30,LOW(0)
	STS  _t_sec,R30
	LDI  R31,0
	RCALL SUBOPT_0x10
;rule_end=0;
	RCALL SUBOPT_0x11
;sec_profile_off[0]=0;
	RCALL SUBOPT_0x12
;
;now_tempU_prev=now_tempU;
	RCALL SUBOPT_0xF
;now_tempU_calc=now_tempU;
	RCALL SUBOPT_0x13
;
;}
;PWM_setted_eeprom[0]=PWM_setted[0];
_0x1D:
	RCALL SUBOPT_0x14
	LDI  R26,LOW(_PWM_setted_eeprom)
	LDI  R27,HIGH(_PWM_setted_eeprom)
	RCALL __EEPROMWRB
;PWM_setted_eeprom[1]=PWM_setted[1];
	__POINTW2MN _PWM_setted_eeprom,1
	RCALL SUBOPT_0x15
	RCALL __EEPROMWRB
;//heat_koeff_U=((5-1)/2);
;if (start==1){
	RCALL SUBOPT_0x16
	BREQ PC+2
	RJMP _0x1E
;//t_sec++;
;
;if (heat_approved[0]==0){now_tempU_calc=now_tempU;sec_start_heat[0]=0;}
	LDS  R30,_heat_approved
	CPI  R30,0
	BRNE _0x1F
	RCALL SUBOPT_0x13
	LDI  R30,LOW(0)
	STS  _sec_start_heat,R30
	STS  _sec_start_heat+1,R30
;if (heat_approved[0]==1){sec_start_heat[0]++;}
_0x1F:
	LDS  R26,_heat_approved
	CPI  R26,LOW(0x1)
	BRNE _0x20
	LDI  R26,LOW(_sec_start_heat)
	LDI  R27,HIGH(_sec_start_heat)
	RCALL SUBOPT_0x17
;//sec_start_heat[0]=sec_profile[0];
;////////////////////////////////////////////////////////////////////////
;heat_koeff_U=((now_tempU-now_tempU_calc)*1.00)/(sec_start_heat[0]*1.00);//через 5 сек
_0x20:
	LDS  R26,_now_tempU_calc
	LDS  R27,_now_tempU_calc+1
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_sec_start_heat
	LDS  R31,_sec_start_heat+1
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	STS  _heat_koeff_U,R30
	STS  _heat_koeff_U+1,R31
	STS  _heat_koeff_U+2,R22
	STS  _heat_koeff_U+3,R23
;PWM_koeff[0]=heat_koeff_U*1.00/(Heat_speed[now_rule]*1.0/10.0);
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	STS  _PWM_koeff,R30
	STS  _PWM_koeff+1,R31
	STS  _PWM_koeff+2,R22
	STS  _PWM_koeff+3,R23
;if (sec_start_heat[0]>2){
	LDS  R26,_sec_start_heat
	LDS  R27,_sec_start_heat+1
	SBIW R26,3
	BRLO _0x21
;if (PWM_koeff[0]<0.5){ if (PWM_setted[0]<10){PWM_setted[0]++;};}}
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	BRSH _0x22
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0xA)
	BRSH _0x23
	RCALL SUBOPT_0x23
_0x23:
_0x22:
;if (PWM_koeff[0]>1.5){ if (PWM_setted[0]>0) {PWM_setted[0]--;};}
_0x21:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x24
	BREQ PC+2
	BRCC PC+2
	RJMP _0x24
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0x1)
	BRLO _0x25
	RCALL SUBOPT_0x25
_0x25:
;/////////////////////////////////////////////////////////////////////////////
;///if ()
;if (forecast_temp_U<=(now_tempU+30)){
_0x24:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
	BRLT _0x26
;if (forecast_temp_U<Heat_temp_U[now_rule]){
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	BRSH _0x27
;if (now_tempU<Heat_temp_U[now_rule]){
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	BRSH _0x28
;sec_profile[0]++;
	LDI  R26,LOW(_sec_profile)
	LDI  R27,HIGH(_sec_profile)
	RCALL SUBOPT_0x17
;}
;}
_0x28:
;}
_0x27:
;if (forecast_temp_U>=(now_tempU+30)){
_0x26:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x2B
	BRLT _0x29
;//float sec_calc=0.0;
;//sec_calc=(now_tempU*1.0/(Heat_speed[now_rule]*1.00/10.00));
;sec_profile[0]=(now_tempU*1.0/(Heat_speed[now_rule]*1.00/10.00))-now_tempU_prev;
	MOVW R30,R12
	RCALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_now_tempU_prev
	LDS  R31,_now_tempU_prev+1
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(_sec_profile)
	LDI  R27,HIGH(_sec_profile)
	RCALL __CFD1U
	RCALL SUBOPT_0x2D
;now_tempU_prev=now_tempU;
	RCALL SUBOPT_0xF
;now_tempU_calc=now_tempU;
	RCALL SUBOPT_0x13
;}
;//sec_start_heat[0]=sec_profile[0];
;
;
;if (forecast_temp_U<Heat_temp_U[now_rule]){
_0x29:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	BRSH _0x2A
;forecast_temp_U=now_tempU_prev+sec_profile[0]*(Heat_speed[now_rule]*1.00/10.00);;
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	LDS  R26,_sec_profile
	LDS  R27,_sec_profile+1
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL __MULF12
	LDS  R26,_now_tempU_prev
	LDS  R27,_now_tempU_prev+1
	RCALL SUBOPT_0x2E
	LDI  R26,LOW(_forecast_temp_U)
	LDI  R27,HIGH(_forecast_temp_U)
	RCALL __CFD1
	RCALL SUBOPT_0x2D
;}
;else{
	RJMP _0x2B
_0x2A:
;//sec_profile[1]=0;
;forecast_temp_U=Heat_temp_U[now_rule];
	RCALL SUBOPT_0x28
	STS  _forecast_temp_U,R30
	STS  _forecast_temp_U+1,R31
;}
_0x2B:
;
;
;
;
;if ((now_tempU==Heat_temp_U[now_rule])&&compliteU==0){compliteU=1;buzz_freg=50;buzz_cont=10;now_tempU_calc=now_tempU;}
	RCALL SUBOPT_0x28
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x2D
	SBRS R2,1
	RJMP _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	SET
	BLD  R2,1
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x13
;
;if (forecast_temp_U<=now_tempU){//текуща€ температура больше расчитанной
_0x2C:
	RCALL SUBOPT_0x30
	BRLT _0x2F
;
;    heat_approved[0]=0;
	RCALL SUBOPT_0x31
;    t_power_change_up[0]=0;
	LDI  R30,LOW(0)
	STS  _t_power_change_up,R30
;    t_power_change_down[0]++;
	LDS  R30,_t_power_change_down
	SUBI R30,-LOW(1)
	STS  _t_power_change_down,R30
;    lcd_stateU=*"|";
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0xE
;    heater_on[0]=0;
;    sec_heat[0]=0;
	STS  _sec_heat,R30
;
;;}
;if (forecast_temp_U>now_tempU){//текуща€ температура маеньше.
_0x2F:
	RCALL SUBOPT_0x30
	BRGE _0x30
;if (Heat_temp_U[now_rule]>now_tempU){
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	BRSH _0x31
;    heat_approved[0]=1;
	LDI  R30,LOW(1)
	STS  _heat_approved,R30
;    heater_on[0]=1;lcd_stateU=*"H";
	STS  _heater_on,R30
	__POINTW1FN _0x0,8
	LPM  R7,Z
;    t_power_change_up[0]++;
	LDS  R30,_t_power_change_up
	SUBI R30,-LOW(1)
	STS  _t_power_change_up,R30
;    t_power_change_down[0]=0;
	LDI  R30,LOW(0)
	STS  _t_power_change_down,R30
;    if (PWM_setted[0]<1){PWM_setted[0]=1;}
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0x1)
	BRSH _0x32
	LDI  R30,LOW(1)
	STS  _PWM_setted,R30
;;}
_0x32:
;;}
_0x31:
;
;
;
;
;
;
;
;
;}
_0x30:
;if (start_BT==0){
_0x1E:
	LDS  R30,_start_BT
	CPI  R30,0
	BRNE _0x33
;now_tempB_prev=now_tempB;
	RCALL SUBOPT_0x32
;lcd_stateB=*"_";heater_on[1]=0;
	__POINTW1FN _0x0,4
	RCALL SUBOPT_0x33
;now_tempB_prev=now_tempB;
	RCALL SUBOPT_0x32
;sec_profile[1]=0;sec_profile_off[1]=0;
	RCALL SUBOPT_0x34
	__POINTW1MN _sec_profile_off,2
	RCALL SUBOPT_0x35
;PORTB.1=0;
	CBI  0x18,1
;sec_profile[1]=0;
	RCALL SUBOPT_0x34
;now_tempB_prev=now_tempB;
	RCALL SUBOPT_0x32
;now_tempB_calc=now_tempB;
	RCALL SUBOPT_0x36
;//learn_pwm_B[0]=0;
;}
;if (start_BT==1){
_0x33:
	LDS  R26,_start_BT
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x36
;//if (now_tempB_start==0){now_tempB_start=now_tempB;}//установка начальной темп при старте
;//if (Heat_temp_B[now_rule]!=Heat_temp_B_start[now_rule])
;if (heat_approved[1]==0){now_tempB_calc=now_tempB;sec_start_heat[1]=0;}
	__GETB1MN _heat_approved,1
	CPI  R30,0
	BRNE _0x37
	RCALL SUBOPT_0x36
	__POINTW1MN _sec_start_heat,2
	RCALL SUBOPT_0x35
;if (heat_approved[1]==1){sec_start_heat[1]++;}
_0x37:
	__GETB2MN _heat_approved,1
	CPI  R26,LOW(0x1)
	BRNE _0x38
	__POINTW2MN _sec_start_heat,2
	RCALL SUBOPT_0x17
;
;//////////////////////////////////////////////////////////////////////
;//sec_start_heat[1]=sec_profile[1];
;heat_koeff_B=(now_tempB-now_tempB_calc)/sec_start_heat[1];//через 5 сек
_0x38:
	LDS  R26,_now_tempB_calc
	LDS  R27,_now_tempB_calc+1
	RCALL SUBOPT_0x37
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	__GETW1MN _sec_start_heat,2
	RCALL __DIVW21U
	LDI  R26,LOW(_heat_koeff_B)
	LDI  R27,HIGH(_heat_koeff_B)
	RCALL SUBOPT_0x19
	RCALL __PUTDP1
;PWM_koeff[1]=heat_koeff_B*1.00/(Heat_speed_B*1.0/10.0);
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x1C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	__PUTD1MN _PWM_koeff,4
;if (sec_start_heat[1]>2){
	__GETW2MN _sec_start_heat,2
	SBIW R26,3
	BRLO _0x39
;if (PWM_koeff[1]<0.5){ if (PWM_setted[1]<10){PWM_setted[1]++;};}}
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x21
	BRSH _0x3A
	RCALL SUBOPT_0x3B
	CPI  R26,LOW(0xA)
	BRSH _0x3B
	RCALL SUBOPT_0x15
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x3C
_0x3B:
_0x3A:
;if (PWM_koeff[1]>1.5){ if (PWM_setted[1]>0) {PWM_setted[1]--;};}
_0x39:
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x24
	BREQ PC+2
	BRCC PC+2
	RJMP _0x3C
	RCALL SUBOPT_0x3B
	CPI  R26,LOW(0x1)
	BRLO _0x3D
	RCALL SUBOPT_0x15
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x3C
_0x3D:
;/////////////////////////////////////////////////////////////////////
;//learn_pwm_B[0]+=PWM_setted[1];
;//float PWM_setted_float[1]=learn_pwm_B[1]/sec_profile[1];
;//PWM_setted[1]=PWM_setted_float[1];
;
;if (forecast_temp_B<Heat_temp_B[now_rule]){
_0x3C:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2B
	BRSH _0x3E
;forecast_temp_B=now_tempB_prev+sec_profile[1]*Heat_speed_B*1.00/10.0;
	__GETW2MN _sec_profile,2
	RCALL SUBOPT_0x39
	RCALL __MULW12U
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
	LDS  R26,_now_tempB_prev
	LDS  R27,_now_tempB_prev+1
	RCALL SUBOPT_0x2E
	LDI  R26,LOW(_forecast_temp_B)
	LDI  R27,HIGH(_forecast_temp_B)
	RCALL __CFD1
	RCALL SUBOPT_0x2D
;}
;else{
	RJMP _0x3F
_0x3E:
;//sec_profile[1]=0;
;forecast_temp_B=Heat_temp_B[now_rule];
	RCALL SUBOPT_0x3D
	STS  _forecast_temp_B,R30
	STS  _forecast_temp_B+1,R31
;}
_0x3F:
;
;if (forecast_temp_B<=(now_tempB+30)){
	RCALL SUBOPT_0x37
	ADIW R30,30
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x27
	BRLT _0x40
;if (forecast_temp_B<=Heat_temp_B[now_rule]){
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x27
	BRLO _0x41
;if (now_tempB<=Heat_temp_B[now_rule]){
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3F
	BRLO _0x42
;sec_profile[1]++
; ;}
	__POINTW2MN _sec_profile,2
	RCALL SUBOPT_0x17
; ;}
_0x42:
; ;}
_0x41:
;if (forecast_temp_B>=(now_tempB+30)){
_0x40:
	RCALL SUBOPT_0x37
	ADIW R30,30
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2B
	BRLT _0x43
;
;sec_profile[1]=(now_tempB*1.0/(Heat_speed_B*1.00/10.00))-now_tempB_prev;
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_now_tempB_prev
	LDS  R31,_now_tempB_prev+1
	RCALL SUBOPT_0x2C
	__POINTW2MN _sec_profile,2
	RCALL __CFD1U
	RCALL SUBOPT_0x2D
;now_tempB_prev=now_tempB;
	RCALL SUBOPT_0x32
;now_tempB_calc=now_tempB;
	RCALL SUBOPT_0x36
;}
;
;if ((now_tempB==Heat_temp_B[now_rule])&&compliteB==0){compliteB=1;buzz_freg=50;buzz_cont=10;}
_0x43:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3F
	BRNE _0x45
	SBRS R2,2
	RJMP _0x46
_0x45:
	RJMP _0x44
_0x46:
	SET
	BLD  R2,2
	RCALL SUBOPT_0x2F
;
;
;if (forecast_temp_B>now_tempB){
_0x44:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x27
	BRGE _0x47
;if (Heat_temp_B[now_rule]>now_tempB){
	RCALL SUBOPT_0x3D
	MOVW R26,R30
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x27
	BRSH _0x48
;    heat_approved[1]=1;
	LDI  R30,LOW(1)
	__PUTB1MN _heat_approved,1
;    heater_on[1]=1;lcd_stateB=*"H";
	__PUTB1MN _heater_on,1
	__POINTW1FN _0x0,8
	LPM  R6,Z
;    t_power_change_up[1]++;
	__GETB1MN _t_power_change_up,1
	SUBI R30,-LOW(1)
	__PUTB1MN _t_power_change_up,1
;    t_power_change_down[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _t_power_change_down,1
;    if (PWM_setted[1]<1){PWM_setted[1]=1;}
	RCALL SUBOPT_0x3B
	CPI  R26,LOW(0x1)
	BRSH _0x49
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3C
;
;}
_0x49:
;}
_0x48:
;if (forecast_temp_B<now_tempB){
_0x47:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2B
	BRGE _0x4A
;
;    heat_approved[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _heat_approved,1
;    lcd_stateB=*"|";
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x33
;    heater_on[1]=0;
;    sec_heat[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _sec_heat,1
;    t_power_change_up[1]=0;
	__PUTB1MN _t_power_change_up,1
;    t_power_change_down[1]++;
	__GETB1MN _t_power_change_down,1
	SUBI R30,-LOW(1)
	__PUTB1MN _t_power_change_down,1
;
;}
;
;}
_0x4A:
;//heat_koeff=0.54;
;
;
;
;
;
;
;}
_0x36:
;
; 0000 0074 }
_0x18:
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
; .FEND
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0076 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077 // Reinitialize Timer2 value
; 0000 0078 TCNT2=0x06;//500Hz
	LDI  R30,LOW(6)
	OUT  0x24,R30
; 0000 0079 #include <buzzer.c>;
;//buzzer=1;Freq_buzz=600;
;if (buzz_cont>0){
	LDS  R26,_buzz_cont
	CPI  R26,LOW(0x1)
	BRLO _0x4B
;PORTB.2^=1;
	LDI  R26,0
	SBIC 0x18,2
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x4C
	CBI  0x18,2
	RJMP _0x4D
_0x4C:
	SBI  0x18,2
_0x4D:
;}
;else{
	RJMP _0x4E
_0x4B:
;PORTB.2=0;
	CBI  0x18,2
;
;}
_0x4E:
;TCNT2=buzz_freg;
	LDS  R30,_buzz_freg
	OUT  0x24,R30
;//TCNT2=1;
;//expalpe:
;//buzz_cont=50;buzz_freg=178;
;
;//TCNT2=6;//250
;//TCNT2=48;//300
;//TCNT2=100;//400
;//TCNT2=131;//500
;//TCNT2=152;//600
;//TCNT2=167;//700
;//TCNT2=178;//800
;
; 0000 007A // Place your code here
; 0000 007B 
; 0000 007C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0083 {
_read_adc:
; .FSTART _read_adc
; 0000 0084 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0085 // Delay needed for the stabilization of the ADC input voltage
; 0000 0086 delay_us(100);
	RCALL SUBOPT_0x40
; 0000 0087 // Start the AD conversion
; 0000 0088 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0089 // Wait for the AD conversion to complete
; 0000 008A while ((ADCSRA & (1<<ADIF))==0);
_0x51:
	SBIS 0x6,4
	RJMP _0x51
; 0000 008B ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 008C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0001
; 0000 008D }
; .FEND
;
;
;
;void main(void)
; 0000 0092 {
_main:
; .FSTART _main
; 0000 0093 
; 0000 0094 #include <onload.c>;
;//heater_on[0]=1;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;//heater_on[1]=1;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;lcd_gotoxy(0,0);
	RCALL SUBOPT_0x41
;lcd_putsf("Loading");
	__POINTW2FN _0x0,10
	RCALL _lcd_putsf
;buzz_freg=178;buzz_cont=20;
	LDI  R30,LOW(178)
	RCALL SUBOPT_0x42
	LDI  R30,LOW(20)
	RCALL SUBOPT_0xB
;
;lcd_stateU=*" ";
	__POINTW1FN _0x0,0
	LPM  R7,Z
;lcd_stateB=*" ";
	__POINTW1FN _0x0,0
	LPM  R6,Z
;
;    for (k=0;k<13;k++){
	RCALL SUBOPT_0x0
_0x55:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0xD)
	BRSH _0x56
;    choose[k]=*" ";
	RCALL SUBOPT_0x2
;    }
	RCALL SUBOPT_0x3
	RJMP _0x55
_0x56:
;    for (k=0;k<5;k++){
	RCALL SUBOPT_0x0
_0x58:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x5)
	BRSH _0x59
;    //rule_end[k]=0;
;    }
	RCALL SUBOPT_0x3
	RJMP _0x58
_0x59:
;choose_v(0);
	LDI  R26,LOW(0)
	RCALL _choose_v
;
;Heat_rule[0]=3;//2-по достижению температуры 3- конец правил 1 - по времени
	LDI  R30,LOW(3)
	STS  _Heat_rule,R30
;Heat_time[0]=2;//общее врем€ секунд, греть
	LDI  R30,LOW(2)
	STS  _Heat_time,R30
;Heat_temp_U[0]=240;//температура режима
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	STS  _Heat_temp_U,R30
	STS  _Heat_temp_U+1,R31
;Heat_temp_B[0]=160;//температура режима
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	STS  _Heat_temp_B,R30
	STS  _Heat_temp_B+1,R31
;Heat_speed[0]=10;//температура режима(heatspeed/10=1sek 2градус в 1 сек.
	LDI  R30,LOW(10)
	STS  _Heat_speed,R30
;Heat_speed_B=10;
	RCALL SUBOPT_0x43
;sec_profile[0]=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x10
;
;Heat_rule[1]=0;//1-по достижению времени
	__PUTB1MN _Heat_rule,1
;Heat_time[1]=1;//общее врем€ секунд, греть
	LDI  R30,LOW(1)
	__PUTB1MN _Heat_time,1
;Heat_temp_U[1]=150;//температура режима
	__POINTW1MN _Heat_temp_U,2
	RCALL SUBOPT_0x44
;Heat_temp_B[1]=150;//температура режима
	__POINTW1MN _Heat_temp_B,2
	RCALL SUBOPT_0x44
;Heat_speed[1]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _Heat_speed,1
;
;Heat_rule[2]=0;//2-по достижению температуры
	LDI  R30,LOW(0)
	__PUTB1MN _Heat_rule,2
;Heat_temp_U[2]=230;//температура режима
	__POINTW1MN _Heat_temp_U,4
	RCALL SUBOPT_0x45
;Heat_temp_B[2]=150;//температура режима
	__POINTW1MN _Heat_temp_B,4
	RCALL SUBOPT_0x44
;Heat_speed[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _Heat_speed,2
;
;Heat_rule[3]=0;//конец правил
	LDI  R30,LOW(0)
	__PUTB1MN _Heat_rule,3
;Heat_temp_U[3]=230;//температура режима
	__POINTW1MN _Heat_temp_U,6
	RCALL SUBOPT_0x45
;Heat_temp_B[3]=150;//температура режима
	__POINTW1MN _Heat_temp_B,6
	RCALL SUBOPT_0x44
;Heat_speed[3]=8;
	LDI  R30,LOW(8)
	__PUTB1MN _Heat_speed,3
;
;//Heat_rule[3]=0;//2-по достижению температуры
;if ((PWM_setted_eeprom[0]>0)&&(PWM_setted_eeprom[0]<11)){PWM_setted[0]=PWM_setted_eeprom[0];}
	LDI  R26,LOW(_PWM_setted_eeprom)
	LDI  R27,HIGH(_PWM_setted_eeprom)
	RCALL SUBOPT_0x46
	BRLO _0x5B
	CPI  R30,LOW(0xB)
	BRLO _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
	LDI  R26,LOW(_PWM_setted_eeprom)
	LDI  R27,HIGH(_PWM_setted_eeprom)
	RCALL __EEPROMRDB
	STS  _PWM_setted,R30
;if ((PWM_setted_eeprom[1]>0)&&(PWM_setted_eeprom[1]<11)){PWM_setted[1]=PWM_setted_eeprom[1];}
_0x5A:
	__POINTW2MN _PWM_setted_eeprom,1
	RCALL SUBOPT_0x46
	BRLO _0x5E
	CPI  R30,LOW(0xB)
	BRLO _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
	__POINTW2MN _PWM_setted_eeprom,1
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x3C
;if ((Heat_speed_B_eeprom>0)&&(Heat_speed_B_eeprom<50)){Heat_speed_B=Heat_speed_B_eeprom;}
_0x5D:
	LDI  R26,LOW(_Heat_speed_B_eeprom)
	LDI  R27,HIGH(_Heat_speed_B_eeprom)
	RCALL SUBOPT_0x46
	BRLO _0x61
	CPI  R30,LOW(0x32)
	BRLO _0x62
_0x61:
	RJMP _0x60
_0x62:
	LDI  R26,LOW(_Heat_speed_B_eeprom)
	LDI  R27,HIGH(_Heat_speed_B_eeprom)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x43
;for (i=0;i<4;i++){
_0x60:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x47
_0x64:
	RCALL SUBOPT_0x48
	CPI  R26,LOW(0x4)
	BRSH _0x65
;if ((Heat_temp_U_eeprom[i]>0)&&(Heat_temp_U_eeprom[i]<255)){Heat_temp_U[i]=Heat_temp_U_eeprom[i];}
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RCALL __CPW01
	BRSH _0x67
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRLO _0x68
_0x67:
	RJMP _0x66
_0x68:
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4A
	MOVW R26,R0
	RCALL SUBOPT_0x2D
;if ((Heat_temp_B_eeprom[i]>0)&&(Heat_temp_B_eeprom[i]<255)){Heat_temp_B[i]=Heat_temp_B_eeprom[i];}
_0x66:
	RCALL SUBOPT_0x4D
	ADD  R26,R30
	ADC  R27,R31
	RCALL __EEPROMRDW
	RCALL __CPW01
	BRSH _0x6A
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRLO _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4C
	LDI  R26,LOW(_Heat_temp_B_eeprom)
	LDI  R27,HIGH(_Heat_temp_B_eeprom)
	RCALL SUBOPT_0x4F
	RCALL __EEPROMRDW
	MOVW R26,R0
	RCALL SUBOPT_0x2D
;if ((Heat_speed_eeprom[i]>0)&&(Heat_speed_eeprom[i]<255)){Heat_speed[i]=Heat_speed_eeprom[i];}
_0x69:
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x46
	BRLO _0x6D
	CPI  R30,LOW(0xFF)
	BRLO _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
	RCALL SUBOPT_0x51
	MOVW R0,R30
	RCALL SUBOPT_0x50
	RCALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
;
;}
_0x6C:
	RCALL SUBOPT_0x49
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x47
	RJMP _0x64
_0x65:
;count_rules=2;
	LDI  R30,LOW(2)
	STS  _count_rules,R30
;//TCnt_0=(100.0/freq)*78.125;
;//TCnt_float=70.0;
; 0000 0095 // Declare your local variables here
; 0000 0096 
; 0000 0097 // Input/Output Ports initialization
; 0000 0098 // Port B initialization
; 0000 0099 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 009A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(6)
	OUT  0x17,R30
; 0000 009B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 009C PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(56)
	OUT  0x18,R30
; 0000 009D 
; 0000 009E // Port C initialization
; 0000 009F // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A0 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00A1 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A2 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00A3 
; 0000 00A4 // Port D initialization
; 0000 00A5 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A6 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(12)
	OUT  0x11,R30
; 0000 00A7 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A8 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00A9 
; 0000 00AA // Timer/Counter 0 initialization
; 0000 00AB // Clock source: System Clock
; 0000 00AC // Clock value: 7,813 kHz
; 0000 00AD TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00AE TCNT0=0x70;
	LDI  R30,LOW(112)
	OUT  0x32,R30
; 0000 00AF 
; 0000 00B0 // Timer/Counter 1 initialization
; 0000 00B1 // Clock source: System Clock
; 0000 00B2 // Clock value: 1000.000 kHz
; 0000 00B3 // Mode: Normal top=0xFFFF
; 0000 00B4 // OC1A output: Disconnected
; 0000 00B5 // OC1B output: Disconnected
; 0000 00B6 // Noise Canceler: Off
; 0000 00B7 // Input Capture on Falling Edge
; 0000 00B8 // Timer Period: 10 ms
; 0000 00B9 // Timer1 Overflow Interrupt: On
; 0000 00BA // Input Capture Interrupt: Off
; 0000 00BB // Compare A Match Interrupt: Off
; 0000 00BC // Compare B Match Interrupt: Off
; 0000 00BD TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00BE TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00BF TCNT1H=0xD8;
	RCALL SUBOPT_0xA
; 0000 00C0 TCNT1L=0xF0;
; 0000 00C1 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00C2 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C3 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C4 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C5 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C6 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C7 
; 0000 00C8 // Timer/Counter 2 initialization
; 0000 00C9 // Clock source: System Clock
; 0000 00CA // Clock value: 125.000 kHz
; 0000 00CB // Mode: Normal top=0xFF
; 0000 00CC // OC2 output: Disconnected
; 0000 00CD // Timer Period: 0.664 ms
; 0000 00CE ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00CF TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 00D0 TCNT2=0xAD;
	LDI  R30,LOW(173)
	OUT  0x24,R30
; 0000 00D1 OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 00D2 
; 0000 00D3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D4 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(69)
	OUT  0x39,R30
; 0000 00D5 
; 0000 00D6 // External Interrupt(s) initialization
; 0000 00D7 // INT0: Off
; 0000 00D8 // INT1: Off
; 0000 00D9 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00DA 
; 0000 00DB // USART initialization
; 0000 00DC // USART disabled
; 0000 00DD UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00DE 
; 0000 00DF // Analog Comparator initialization
; 0000 00E0 // Analog Comparator: Off
; 0000 00E1 // The Analog Comparator's positive input is
; 0000 00E2 // connected to the AIN0 pin
; 0000 00E3 // The Analog Comparator's negative input is
; 0000 00E4 // connected to the AIN1 pin
; 0000 00E5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E6 
; 0000 00E7 // ADC initialization
; 0000 00E8 // ADC Clock frequency: 1000.000 kHz
; 0000 00E9 // ADC Voltage Reference: AREF pin
; 0000 00EA ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00EB ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00EC SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00ED 
; 0000 00EE // SPI initialization
; 0000 00EF // SPI disabled
; 0000 00F0 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00F1 
; 0000 00F2 // TWI initialization
; 0000 00F3 // TWI disabled
; 0000 00F4 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00F5 
; 0000 00F6 // Alphanumeric LCD initialization
; 0000 00F7 // Connections are specified in the
; 0000 00F8 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00F9 // RS - PORTD Bit 0
; 0000 00FA // RD - PORTD Bit 1
; 0000 00FB // EN - PORTD Bit 2
; 0000 00FC // D4 - PORTD Bit 3
; 0000 00FD // D5 - PORTD Bit 5
; 0000 00FE // D6 - PORTD Bit 6
; 0000 00FF // D7 - PORTD Bit 7
; 0000 0100 // Characters/line: 16
; 0000 0101 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0102 
; 0000 0103 
; 0000 0104 //if (set_tempU_eep==255){set_tempB=180;}
; 0000 0105 
; 0000 0106 // Global enable interrupts
; 0000 0107 #asm("sei")
	sei
; 0000 0108 
; 0000 0109 while (1)
_0x6F:
; 0000 010A       {
; 0000 010B #include <while.c>;
;if (Timer_2==5){  //*Timer_1=20 = 100
	LDI  R30,LOW(5)
	CP   R30,R8
	BRNE _0x72
;now_tempU=512-read_adc(0)/2;
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x52
	MOVW R12,R26
;now_tempB=512-read_adc(1)/2;
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x52
	STS  _now_tempB,R26
	STS  _now_tempB+1,R27
;Timer_2=0;
	CLR  R8
;}
;if (Timer_1==20){
_0x72:
	LDI  R30,LOW(20)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x73
;//первый ADC
;lcd_clear();
	RCALL _lcd_clear
;if (show_lcd!=5){
	LDI  R30,LOW(5)
	CP   R30,R10
	BREQ _0x74
;//sprintf(lcd_buffer,"%cB:%0.1f%cU:%0.1f",lcd_stateB,now_tempB,lcd_stateU,now_tempU);
;sprintf(lcd_buffer,"%c%3d%c%3dT%3d-%3d",lcd_stateU,now_tempU,lcd_stateB,now_tempB,forecast_temp_U,forecast_temp_B);
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,18
	RCALL SUBOPT_0x54
	MOV  R30,R7
	RCALL SUBOPT_0x55
	MOVW R30,R12
	RCALL SUBOPT_0x56
	MOV  R30,R6
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x56
	LDS  R30,_forecast_temp_U
	LDS  R31,_forecast_temp_U+1
	RCALL SUBOPT_0x56
	LDS  R30,_forecast_temp_B
	LDS  R31,_forecast_temp_B+1
	RCALL SUBOPT_0x56
	LDI  R24,24
	RCALL _sprintf
	ADIW R28,28
;
;//lcd_clear();        /* очистка диспле€ */
;lcd_gotoxy(0,0);        /* верхн€€ строка, 4 позици€ */
	RCALL SUBOPT_0x41
;lcd_puts(lcd_buffer);
	RCALL SUBOPT_0x57
;
;
;}
;if (lcd_freeze==0){
_0x74:
	LDS  R30,_lcd_freeze
	CPI  R30,0
	BRNE _0x75
;if(lcd_switcher==0){show_lcd=0;}//показываем установленную температуру
	LDS  R30,_lcd_switcher
	CPI  R30,0
	BRNE _0x76
	CLR  R10
;if(lcd_switcher==4){show_lcd=2;}//мощность нагр
_0x76:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0x4)
	BRNE _0x77
	RCALL SUBOPT_0x58
;if(lcd_switcher==6){show_lcd=4;}//вкл. и выкл. нагревателей
_0x77:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0x6)
	BRNE _0x78
	LDI  R30,LOW(4)
	MOV  R10,R30
;if(lcd_switcher>8){lcd_switcher=0;}
_0x78:
	LDS  R26,_lcd_switcher
	CPI  R26,LOW(0x9)
	BRLO _0x79
	LDI  R30,LOW(0)
	STS  _lcd_switcher,R30
;}
_0x79:
;//show_lcd=4;
;//set_tempB=read_adc(2)/4;
;//set_tempU=read_adc(3)/4;
;
;
;
;if ((show_lcd==0)||(show_lcd==1)){//меню обратного отсчета
_0x75:
	LDI  R30,LOW(0)
	CP   R30,R10
	BREQ _0x7B
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x7B
	RJMP _0x7A
_0x7B:
;//sprintf(lcd_buffer,"%cSB:%d%cSU:%d",choose[3],set_tempB,choose[4],set_tempU);
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x59
;heat_k_B_int= (int)(PWM_koeff[1]*10.0);
	__GETD1MN _PWM_koeff,4
	__GETD2N 0x41200000
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x5B
;heat_k_U_int= (int)(PWM_koeff[0]*10.0);
	RCALL SUBOPT_0x20
	__GETD1N 0x41200000
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x5C
;if (heat_k_U_int>99){heat_k_U_int=99;}
	RCALL SUBOPT_0x5D
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x7D
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	RCALL SUBOPT_0x5C
;if (heat_k_U_int<-99){heat_k_U_int=-9;}
_0x7D:
	RCALL SUBOPT_0x5D
	CPI  R26,LOW(0xFF9D)
	LDI  R30,HIGH(0xFF9D)
	CPC  R27,R30
	BRGE _0x7E
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	RCALL SUBOPT_0x5C
;if (heat_k_B_int>99){heat_k_B_int=99;}
_0x7E:
	RCALL SUBOPT_0x5E
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x7F
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	RCALL SUBOPT_0x5B
;if (heat_k_B_int<-99){heat_k_B_int=-9;}
_0x7F:
	RCALL SUBOPT_0x5E
	CPI  R26,LOW(0xFF9D)
	LDI  R30,HIGH(0xFF9D)
	CPC  R27,R30
	BRGE _0x80
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	RCALL SUBOPT_0x5B
;//t_min_least=Heat_time_timer;
;sprintf(lcd_buffer,"%2dU%2dR%1dP%d-%d",heat_k_B_int,heat_k_U_int,now_rule,PWM_setted[0],PWM_setted[1]);
_0x80:
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,37
	RCALL SUBOPT_0x54
	LDS  R30,_heat_k_B_int
	LDS  R31,_heat_k_B_int+1
	RCALL SUBOPT_0x56
	LDS  R30,_heat_k_U_int
	LDS  R31,_heat_k_U_int+1
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x55
	LDI  R24,20
	RCALL _sprintf
	ADIW R28,24
;lcd_puts(lcd_buffer);
	RCALL SUBOPT_0x57
;
;}
;if (show_lcd==2){ //меню PWM
_0x7A:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x81
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x59
;sprintf(lcd_buffer,"%cPmU:%d%cPmB:%d",choose[1],PWM_setted[0],choose[2],PWM_setted[1]);
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,55
	RCALL SUBOPT_0x54
	__GETB1MN _choose,1
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x55
	__GETB1MN _choose,2
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x5F
;lcd_puts(lcd_buffer);
;}
;if (show_lcd==3){// меню старт стоп
_0x81:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x82
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x59
;sprintf(lcd_buffer,"%cst_U:%d%cst_B:%d",choose[0],start,choose[12],start_BT);
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,72
	RCALL SUBOPT_0x54
	LDS  R30,_choose
	RCALL SUBOPT_0x55
	LDS  R30,_start
	RCALL SUBOPT_0x55
	__GETB1MN _choose,12
	RCALL SUBOPT_0x55
	LDS  R30,_start_BT
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x5F
;lcd_puts(lcd_buffer);
;}
;if (show_lcd==5){//настройка правил
_0x82:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x83
;lcd_gotoxy(0,0);
	RCALL SUBOPT_0x41
;//sprintf(lcd_buffer,"%cR%d%cH%d%cT%d%",choose[5],set_now_rule,choose[6],Heat_rule[set_now_rule],choose[7],Heat_time[set ...
;sprintf(lcd_buffer,"%cSb%d",choose[9],Heat_speed_B);
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,91
	RCALL SUBOPT_0x54
	__GETB1MN _choose,9
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x61
;
;lcd_puts(lcd_buffer);
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x59
;sprintf(lcd_buffer,"%cSp%d%cU%d%cB%d",choose[8],Heat_speed[set_now_rule],choose[10],Heat_temp_U[set_now_rule],choose[11] ...
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,98
	RCALL SUBOPT_0x54
	__GETB1MN _choose,8
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x62
	LDI  R31,0
	SUBI R30,LOW(-_Heat_speed)
	SBCI R31,HIGH(-_Heat_speed)
	LD   R30,Z
	RCALL SUBOPT_0x55
	__GETB1MN _choose,10
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	__GETB1MN _choose,11
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x64
	LDI  R24,24
	RCALL _sprintf
	ADIW R28,28
;lcd_puts(lcd_buffer);
	RCALL SUBOPT_0x57
;}
;/////////////////////////////////////////////
;if (show_lcd==6){
_0x83:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x84
;lcd_gotoxy(0,1);
	RCALL SUBOPT_0x59
;//unsigned int koeff_b_int=0;
;//heat_koeff_B=0.123456;
;koeff_b_int=(int)(heat_koeff_B*100.0);
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x67
	STS  _koeff_b_int,R30
	STS  _koeff_b_int+1,R31
;koeff_u_int=(int)(heat_koeff_U*100.0);
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x67
	STS  _koeff_u_int,R30
	STS  _koeff_u_int+1,R31
;sprintf(lcd_buffer,"kB:%dkU:%d",koeff_b_int,koeff_u_int);
	RCALL SUBOPT_0x53
	__POINTW1FN _0x0,115
	RCALL SUBOPT_0x54
	LDS  R30,_koeff_b_int
	LDS  R31,_koeff_b_int+1
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_koeff_u_int
	LDS  R31,_koeff_u_int+1
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x61
;lcd_puts(lcd_buffer);
;//TCnt_0=(100.0/freq)*78.125;
;////////////////////////////////////////////
;}
;Timer_1=0;
_0x84:
	CLR  R9
;Timer_2++;
	INC  R8
;}
;
;
;//if (set_tempB!=set_tempB_prev){show_lcd=0;lcd_freeze=5;set_tempB_prev=set_tempB;}
;//if (set_tempU!=set_tempU_prev){show_lcd=0;lcd_freeze=5;set_tempU_prev=set_tempU;}
; 0000 010C #include <t_profile.c>;
;
;if (start==1){
_0x73:
	RCALL SUBOPT_0x16
	BREQ PC+2
	RJMP _0x85
;
;//now_rule=0;
;if (rule_engadged==0){
	LDS  R30,_rule_engadged
	CPI  R30,0
	BRNE _0x86
;if (Heat_rule[now_rule]==1){//по достижению времени
	RCALL SUBOPT_0x68
	RCALL SUBOPT_0x6
	BRNE _0x87
;    rule_engadged=1;
	RCALL SUBOPT_0x69
;    Heat_time_timer_enabler=1;//включаем счетчик секунд
	LDI  R30,LOW(1)
	STS  _Heat_time_timer_enabler,R30
;    }
;if (Heat_rule[now_rule]==2){//по достижению температуры
_0x87:
	RCALL SUBOPT_0x68
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BRNE _0x88
;    rule_engadged=1;
	RCALL SUBOPT_0x69
;//    Heat_time_timer_enabler=1;//включаем счетчик секунд
;}
;if (Heat_rule[now_rule]==3){//конец правил
_0x88:
	RCALL SUBOPT_0x68
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BRNE _0x89
;    rule_engadged=1;
	RCALL SUBOPT_0x69
;//    Heat_time_timer_enabler=1;//включаем счетчик секунд
;}
;}
_0x89:
;
;
;        if (now_tempB<Heat_temp_B[now_rule]){
_0x86:
	RCALL SUBOPT_0x3D
	LDS  R26,_now_tempB
	LDS  R27,_now_tempB+1
	RCALL SUBOPT_0x2B
	BRLO _0x8B
;        //heat_approved[1]=1;
;        }
;        else{
;        heat_approved[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _heat_approved,1
;        }
_0x8B:
;        if (now_tempU<Heat_temp_U[now_rule]){
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	BRLO _0x8D
;        //heat_approved[0]=1;
;        }else{
;        heat_approved[0]=0;
	RCALL SUBOPT_0x31
;        }
_0x8D:
;
;
;
;if (rule_engadged==1){
	LDS  R26,_rule_engadged
	CPI  R26,LOW(0x1)
	BRNE _0x8E
;    if (Heat_rule[now_rule]==2){
	RCALL SUBOPT_0x68
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BRNE _0x8F
;
;    if (now_tempU>=Heat_temp_U[now_rule]){rule_end=1;}
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	BRLO _0x90
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x11
;
;    }
_0x90:
;if (Heat_rule[now_rule]==1){
_0x8F:
	RCALL SUBOPT_0x68
	RCALL SUBOPT_0x6
	BRNE _0x91
;  if (Heat_time_timer<Heat_time[now_rule]){//если таймер нагрева меньше
	RCALL SUBOPT_0x1D
	LDI  R31,0
	SUBI R30,LOW(-_Heat_time)
	SBCI R31,HIGH(-_Heat_time)
	LD   R30,Z
	LDS  R26,_Heat_time_timer
	CP   R26,R30
	BRLO _0x93
;
;  }
;    else{
;    rule_end=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x11
;    }
_0x93:
;  }
;if (rule_end==1){
_0x91:
	LDS  R26,_rule_end
	CPI  R26,LOW(0x1)
	BRNE _0x94
;
;
;
;
;
;    sec_profile[0]=0;
	LDI  R30,LOW(0)
	STS  _sec_profile,R30
	STS  _sec_profile+1,R30
;
;    buzz_cont=50;buzz_freg=178;
	RCALL SUBOPT_0x6A
	LDI  R30,LOW(178)
	RCALL SUBOPT_0x42
;    now_rule++;
	RCALL SUBOPT_0x1D
	SUBI R30,-LOW(1)
	STS  _now_rule,R30
;    rule_end=0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x11
;    t_sec=t_min=t_hour=0;
	LDI  R30,LOW(0)
	STS  _t_hour,R30
	STS  _t_min,R30
	STS  _t_sec,R30
;    rule_engadged=0;
	STS  _rule_engadged,R30
;    Heat_time_timer=0;
	STS  _Heat_time_timer,R30
;    Heat_time_timer_enabler=0;
	STS  _Heat_time_timer_enabler,R30
;    heat_approved[0]=0;
	RCALL SUBOPT_0x31
;    sec_profile_off[0]=0;
	RCALL SUBOPT_0x12
;}
;}
_0x94:
;
;
;
;}
_0x8E:
;
;
;
;
;
;
;
;
;
;
;
; 0000 010D #include <button_while.c>;
;
;//if ((PINB.5==0)&&(BTN1_pressed==0)&&(BTN_pressed==0)){
;if ((PINB.5==0)&&(BTN_pressed==0)){  //BTN+(sck)
_0x85:
	SBIC 0x16,5
	RJMP _0x96
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x0)
	BREQ _0x97
_0x96:
	RJMP _0x95
_0x97:
;if(heater_swither==1){if (PWM_setted[0]<10){PWM_setted[0]++;};show_lcd=2;}
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x1)
	BRNE _0x98
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0xA)
	BRSH _0x99
	RCALL SUBOPT_0x23
_0x99:
	RCALL SUBOPT_0x58
;if(heater_swither==2){if (PWM_setted[1]<10){PWM_setted[1]++;};show_lcd=2;}
_0x98:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x2)
	BRNE _0x9A
	RCALL SUBOPT_0x3B
	CPI  R26,LOW(0xA)
	BRSH _0x9B
	RCALL SUBOPT_0x15
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x3C
_0x9B:
	RCALL SUBOPT_0x58
;if(heater_swither==3){start=1;buzz_freg=131;buzz_cont=50;};
_0x9A:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x3)
	BRNE _0x9C
	LDI  R30,LOW(1)
	STS  _start,R30
	RCALL SUBOPT_0x6C
_0x9C:
;if (heater_swither==4){start_BT=1;buzz_freg=131;buzz_cont=50;}
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x4)
	BRNE _0x9D
	LDI  R30,LOW(1)
	STS  _start_BT,R30
	RCALL SUBOPT_0x6C
;//if (heater_swither==5){show_lcd=0;if (set_tempU<200){set_tempU++;};}
;if (heater_swither==8){show_lcd=5;if (set_now_rule<10){set_now_rule++;};}
_0x9D:
	RCALL SUBOPT_0x6D
	BRNE _0x9E
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x6F
	CPI  R26,LOW(0xA)
	BRSH _0x9F
	RCALL SUBOPT_0x62
	SUBI R30,-LOW(1)
	STS  _set_now_rule,R30
_0x9F:
;if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]<2){Heat_rule[set_now_rule]++;};}
_0x9E:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x9)
	BRNE _0xA0
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x70
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BRSH _0xA1
	RCALL SUBOPT_0x71
	SUBI R26,LOW(-_Heat_rule)
	SBCI R27,HIGH(-_Heat_rule)
	RCALL SUBOPT_0x9
_0xA1:
;//if (heater_swither==10){show_lcd=5;if (Heat_time[set_now_rule]<30){Heat_time[set_now_rule]++;};}//Heat_time
;if (heater_swither==10){show_lcd=5;if (Heat_speed_B<100){Heat_speed_B++;};}//Heat_speed_B
_0xA0:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xA)
	BRNE _0xA2
	RCALL SUBOPT_0x6E
	LDS  R26,_Heat_speed_B
	CPI  R26,LOW(0x64)
	BRSH _0xA3
	RCALL SUBOPT_0x60
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x43
_0xA3:
;if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]++;}//Heat_speed
_0xA2:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xB)
	BRNE _0xA4
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x71
	SUBI R26,LOW(-_Heat_speed)
	SBCI R27,HIGH(-_Heat_speed)
	RCALL SUBOPT_0x9
;if (heater_swither==12){show_lcd=5;heater_swither=13;}//Heat_power_B
_0xA4:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xC)
	BRNE _0xA5
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x72
;if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]<450){Heat_temp_U[set_now_rule]++;};}//Heat_temp_U
_0xA5:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xD)
	BRNE _0xA6
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x73
	BRSH _0xA7
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x17
_0xA7:
;if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]<450){Heat_temp_B[set_now_rule]++;};}//Heat_temp_B
_0xA6:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xE)
	BRNE _0xA8
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x73
	BRSH _0xA9
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x17
_0xA9:
;
;if (heater_swither==15){show_lcd=6;;}
_0xA8:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xF)
	BRNE _0xAA
	LDI  R30,LOW(6)
	MOV  R10,R30
;
;//set_tempU_ee=set_tempU;
;//set_tempB_ee=set_tempB;
;
;lcd_freeze=5;
_0xAA:
	RCALL SUBOPT_0x74
;BTN1_pressed=1;
	LDI  R30,LOW(1)
	STS  _BTN1_pressed,R30
;BTN_pressed=1;
	RCALL SUBOPT_0xD
;}
;//if(PINB.5==1){BTN1_pressed=0;}
;
;if ((PINB.3==0)&&(BTN_pressed==0)){
_0x95:
	SBIC 0x16,3
	RJMP _0xAC
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x0)
	BREQ _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
;if(heater_swither==1){if (PWM_setted[0]>0){PWM_setted[0]--;};show_lcd=2;}
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x1)
	BRNE _0xAE
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0x1)
	BRLO _0xAF
	RCALL SUBOPT_0x25
_0xAF:
	RCALL SUBOPT_0x58
;if(heater_swither==2){if (PWM_setted[1]>0){PWM_setted[1]--;};show_lcd=2;}
_0xAE:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x2)
	BRNE _0xB0
	RCALL SUBOPT_0x3B
	CPI  R26,LOW(0x1)
	BRLO _0xB1
	RCALL SUBOPT_0x15
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x3C
_0xB1:
	RCALL SUBOPT_0x58
;if(heater_swither==3){start=0;buzz_freg=6;buzz_cont=100;};
_0xB0:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x3)
	BRNE _0xB2
	LDI  R30,LOW(0)
	STS  _start,R30
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x42
	LDI  R30,LOW(100)
	RCALL SUBOPT_0xB
_0xB2:
;if (heater_swither==4){start_BT=0;buzz_freg=131;buzz_cont=50;}
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x4)
	BRNE _0xB3
	LDI  R30,LOW(0)
	STS  _start_BT,R30
	RCALL SUBOPT_0x6C
;//if (heater_swither==5){show_lcd=0;if (set_tempU>0){set_tempU--;};}
;if (heater_swither==8){show_lcd=5;if (set_now_rule>0){set_now_rule--;};}
_0xB3:
	RCALL SUBOPT_0x6D
	BRNE _0xB4
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x6F
	CPI  R26,LOW(0x1)
	BRLO _0xB5
	RCALL SUBOPT_0x62
	SUBI R30,LOW(1)
	STS  _set_now_rule,R30
_0xB5:
;if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]>0){Heat_rule[set_now_rule]--;}else{Heat_rule[set_now_rule]= ...
_0xB4:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x9)
	BRNE _0xB6
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x6
	BRLO _0xB7
	RCALL SUBOPT_0x71
	SUBI R26,LOW(-_Heat_rule)
	SBCI R27,HIGH(-_Heat_rule)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RJMP _0xB8
_0xB7:
	RCALL SUBOPT_0x70
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0xB8:
;//if (heater_swither==10){show_lcd=5;if(Heat_time[set_now_rule]>0){Heat_time[set_now_rule]--;};}//Heat_time
;if (heater_swither==10){show_lcd=5;if (Heat_speed_B>1){Heat_speed_B--;};}//Heat_speed_B
_0xB6:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xA)
	BRNE _0xB9
	RCALL SUBOPT_0x6E
	LDS  R26,_Heat_speed_B
	CPI  R26,LOW(0x2)
	BRLO _0xBA
	RCALL SUBOPT_0x60
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x43
_0xBA:
;if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]--;}//Heat_power_U
_0xB9:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xB)
	BRNE _0xBB
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x71
	SUBI R26,LOW(-_Heat_speed)
	SBCI R27,HIGH(-_Heat_speed)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
;if (heater_swither==12){heater_swither=13;}//Heat_power_B
_0xBB:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xC)
	BRNE _0xBC
	RCALL SUBOPT_0x72
;if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]>0){Heat_temp_U[set_now_rule]--;};}//Heat_temp_U
_0xBC:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xD)
	BRNE _0xBD
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x63
	RCALL __GETW1P
	RCALL __CPW01
	BRSH _0xBE
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x75
_0xBE:
;if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]>0){Heat_temp_B[set_now_rule]--;};}//Heat_temp_B
_0xBD:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xE)
	BRNE _0xBF
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x66
	RCALL __GETW1P
	RCALL __CPW01
	BRSH _0xC0
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x75
_0xC0:
;
;if (heater_swither==15){show_lcd=6;;}
_0xBF:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xF)
	BRNE _0xC1
	LDI  R30,LOW(6)
	MOV  R10,R30
;
;BTN_pressed=1;
_0xC1:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
;lcd_freeze=5;
	RCALL SUBOPT_0x74
;
;
;}
;//show_lcd=6;
;//if(PINB.3==1){BTN2_pressed=0;}
;
;if ((PINB.4==0)&&(BTN3_pressed==0)&&(BTN_pressed==0)){
_0xAB:
	SBIC 0x16,4
	RJMP _0xC3
	SBRC R2,0
	RJMP _0xC3
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x0)
	BREQ _0xC4
_0xC3:
	RJMP _0xC2
_0xC4:
;
;heater_swither++;
	LDS  R30,_heater_swither
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x76
;if (heater_swither>15){heater_swither=1;}
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x10)
	BRLO _0xC5
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x76
;
;if (heater_swither==1){choose_v(1);show_lcd=2;} //меню PWM
_0xC5:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x1)
	BRNE _0xC6
	LDI  R26,LOW(1)
	RCALL _choose_v
	RCALL SUBOPT_0x58
;if (heater_swither==2){choose_v(2);show_lcd=2;} //меню PWM
_0xC6:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x2)
	BRNE _0xC7
	LDI  R26,LOW(2)
	RCALL _choose_v
	RCALL SUBOPT_0x58
;if (heater_swither==3){show_lcd=3;choose_v(0);} // меню старт стоп
_0xC7:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x3)
	BRNE _0xC8
	LDI  R30,LOW(3)
	MOV  R10,R30
	LDI  R26,LOW(0)
	RCALL _choose_v
;if (heater_swither==4){show_lcd=3;choose_v(12);} // меню старт стоп
_0xC8:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x4)
	BRNE _0xC9
	LDI  R30,LOW(3)
	MOV  R10,R30
	LDI  R26,LOW(12)
	RCALL _choose_v
;if (heater_swither==5){heater_swither=6;};
_0xC9:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x5)
	BRNE _0xCA
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x76
_0xCA:
;if (heater_swither==6){show_lcd=1;}//меню обратного отсчета
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x6)
	BRNE _0xCB
	LDI  R30,LOW(1)
	MOV  R10,R30
;if (heater_swither==7){heater_swither=8;}
_0xCB:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x7)
	BRNE _0xCC
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x76
;if (heater_swither==8){show_lcd=5;choose_v(5);if (start==1){set_now_rule=now_rule;};}//set_now_rule   //настройка правил
_0xCC:
	RCALL SUBOPT_0x6D
	BRNE _0xCD
	RCALL SUBOPT_0x6E
	LDI  R26,LOW(5)
	RCALL _choose_v
	RCALL SUBOPT_0x16
	BRNE _0xCE
	RCALL SUBOPT_0x1D
	STS  _set_now_rule,R30
_0xCE:
;//if (heater_swither==9){show_lcd=5;choose_v(6);}//Heat_rule  //настройка правил
;//if (heater_swither==10){show_lcd=5;choose_v(7);}//Heat_time   //настройка правил
;if (heater_swither==8){heater_swither=10;}//пропуск с 8-го по 11
_0xCD:
	RCALL SUBOPT_0x6D
	BRNE _0xCF
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x76
;if (heater_swither==10){show_lcd=5;choose_v(9);}//Heat_speed_B    //настройка правил
_0xCF:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xA)
	BRNE _0xD0
	RCALL SUBOPT_0x6E
	LDI  R26,LOW(9)
	RCALL _choose_v
;if (heater_swither==11){show_lcd=5;choose_v(8);}//Heat_speed    //настройка правил
_0xD0:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xB)
	BRNE _0xD1
	RCALL SUBOPT_0x6E
	LDI  R26,LOW(8)
	RCALL _choose_v
;if (heater_swither==12){heater_swither=13;}
_0xD1:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xC)
	BRNE _0xD2
	RCALL SUBOPT_0x72
;if (heater_swither==13){show_lcd=5;choose_v(10);}//Heat_temp_U   //настройка правил
_0xD2:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xD)
	BRNE _0xD3
	RCALL SUBOPT_0x6E
	LDI  R26,LOW(10)
	RCALL _choose_v
;if (heater_swither==14){show_lcd=5;choose_v(11);}//Heat_temp_B  //настройка правил
_0xD3:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xE)
	BRNE _0xD4
	RCALL SUBOPT_0x6E
	LDI  R26,LOW(11)
	RCALL _choose_v
;if (heater_swither==15){show_lcd=6;}//tcnt
_0xD4:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0xF)
	BRNE _0xD5
	LDI  R30,LOW(6)
	MOV  R10,R30
;
;for (i=0;i<4;i++){
_0xD5:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x47
_0xD7:
	RCALL SUBOPT_0x48
	CPI  R26,LOW(0x4)
	BRSH _0xD8
;Heat_temp_U_eeprom[i]=Heat_temp_U[i];
	RCALL SUBOPT_0x49
	LDI  R26,LOW(_Heat_temp_U_eeprom)
	LDI  R27,HIGH(_Heat_temp_U_eeprom)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x77
;Heat_temp_B_eeprom[i]=Heat_temp_B[i];
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x77
;Heat_speed_eeprom[i]=Heat_speed[i];
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x51
	LD   R30,Z
	RCALL __EEPROMWRB
;}
	RCALL SUBOPT_0x49
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x47
	RJMP _0xD7
_0xD8:
;Heat_speed_B_eeprom = Heat_speed_B;
	RCALL SUBOPT_0x60
	LDI  R26,LOW(_Heat_speed_B_eeprom)
	LDI  R27,HIGH(_Heat_speed_B_eeprom)
	RCALL __EEPROMWRB
;
;BTN3_pressed=1;
	SET
	BLD  R2,0
;BTN_pressed=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
;lcd_freeze=5;
	RCALL SUBOPT_0x74
;
;buzz_freg=131;buzz_cont=10;
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x42
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xB
;
;}
;
;if((PINB.4==1)&&(BTN3_pressed==1)){
_0xC2:
	SBIS 0x16,4
	RJMP _0xDA
	SBRC R2,0
	RJMP _0xDB
_0xDA:
	RJMP _0xD9
_0xDB:
;BTN3_pressed=0;
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
; 0000 010E 
; 0000 010F 
; 0000 0110 
; 0000 0111 
; 0000 0112       // Place your code here
; 0000 0113 
; 0000 0114       }
_0xD9:
	RJMP _0x6F
; 0000 0115 }
_0xDC:
	RJMP _0xDC
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
	RCALL SUBOPT_0x78
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x79
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x7A
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
	RCALL SUBOPT_0x79
	ADIW R26,2
	RCALL SUBOPT_0x17
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x79
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x17
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x79
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL SUBOPT_0x2D
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x78
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x2D
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
	RCALL SUBOPT_0x7B
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x7B
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
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x7D
	RCALL SUBOPT_0x7C
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x7E
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x7F
	RCALL SUBOPT_0x80
	RCALL SUBOPT_0x81
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x7F
	RCALL SUBOPT_0x80
	RCALL SUBOPT_0x81
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
	RCALL SUBOPT_0x82
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
	RCALL SUBOPT_0x82
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x7F
	RCALL SUBOPT_0x80
	RCALL SUBOPT_0x83
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x83
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
	RCALL SUBOPT_0x7F
	RCALL SUBOPT_0x80
	RCALL SUBOPT_0x83
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
	RCALL SUBOPT_0x7B
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
	RCALL SUBOPT_0x82
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x7B
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
	RCALL SUBOPT_0x82
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x2B
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x83
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
	RCALL SUBOPT_0x7E
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x7B
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
	RCALL SUBOPT_0x7E
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
	RCALL SUBOPT_0x84
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x84
	RCALL SUBOPT_0x82
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x54
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x54
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0003:
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
	RCALL SUBOPT_0x85
	SBI  0x12,6
	RCALL SUBOPT_0x85
	CBI  0x12,6
	RCALL SUBOPT_0x85
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
	RCALL SUBOPT_0x86
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x86
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
	RCALL SUBOPT_0x78
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
	RJMP _0x20A0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x78
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x20A0002:
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
	RCALL SUBOPT_0x87
	RCALL SUBOPT_0x87
	RCALL SUBOPT_0x87
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	RCALL SUBOPT_0x40
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
	RCALL SUBOPT_0x78
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
	RCALL SUBOPT_0x78
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
	.BYTE 0x21
_choose:
	.BYTE 0xD

	.ESEG
_PWM_setted_eeprom:
	.DB  0x1,0x1

	.DSEG
_PWM_setted:
	.BYTE 0x2
_now_tempB:
	.BYTE 0x2
_t_sec:
	.BYTE 0x1
_t_min:
	.BYTE 0x1
_t_hour:
	.BYTE 0x1
_port:
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
_lcd_freeze:
	.BYTE 0x1
_heater_swither:
	.BYTE 0x1
_start:
	.BYTE 0x1
_start_BT:
	.BYTE 0x1
_sec_profile:
	.BYTE 0x4
_sec_profile_off:
	.BYTE 0x4
_now_tempB_prev:
	.BYTE 0x2
_now_tempU_prev:
	.BYTE 0x2
_k:
	.BYTE 0x1
_buzz_freg:
	.BYTE 0x1
_buzz_cont:
	.BYTE 0x1
_BTN_pressed:
	.BYTE 0x1
_Timer_BTN_Pressed:
	.BYTE 0x1
_Timer_1sec:
	.BYTE 0x1
_heat_approved:
	.BYTE 0x2
_Heat_time_timer_enabler:
	.BYTE 0x1
_Heat_time:
	.BYTE 0x4
_Heat_rule:
	.BYTE 0x4
_Heat_time_timer:
	.BYTE 0x1
_count_rules:
	.BYTE 0x1
_now_rule:
	.BYTE 0x1
_rule_engadged:
	.BYTE 0x1
_rule_end:
	.BYTE 0x1
_set_now_rule:
	.BYTE 0x1
_Heat_temp_U:
	.BYTE 0x8
_Heat_temp_B:
	.BYTE 0x8
_Heat_speed:
	.BYTE 0x4
_Heat_speed_B:
	.BYTE 0x1

	.ESEG
_Heat_temp_U_eeprom:
	.BYTE 0x8
_Heat_temp_B_eeprom:
	.BYTE 0x8
_Heat_speed_eeprom:
	.BYTE 0x4
_Heat_speed_B_eeprom:
	.BYTE 0x1

	.DSEG
_i:
	.BYTE 0x1
_sec_start_heat:
	.BYTE 0x4
_now_tempB_calc:
	.BYTE 0x2
_now_tempU_calc:
	.BYTE 0x2
_heat_koeff_B:
	.BYTE 0x4
_heat_koeff_U:
	.BYTE 0x4
_PWM_koeff:
	.BYTE 0x8
_forecast_temp_U:
	.BYTE 0x2
_forecast_temp_B:
	.BYTE 0x2
_t_power_change_up:
	.BYTE 0x2
_t_power_change_down:
	.BYTE 0x2
_koeff_b_int:
	.BYTE 0x2
_koeff_u_int:
	.BYTE 0x2
_heat_k_B_int:
	.BYTE 0x2
_heat_k_U_int:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _k,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R26,_k
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	RCALL SUBOPT_0x1
	LDI  R27,0
	SUBI R26,LOW(-_choose)
	SBCI R27,HIGH(-_choose)
	__POINTW1FN _0x0,0
	LPM  R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDS  R26,_port
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDS  R30,_port
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LD   R26,Z
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOVW R0,R30
	SUBI R30,LOW(-_PWM_setted)
	SBCI R31,HIGH(-_PWM_setted)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_PWM_step)
	SBCI R31,HIGH(-_PWM_step)
	LD   R30,Z
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	IN   R1,18
	RCALL SUBOPT_0x4
	LDI  R30,LOW(3)
	SUB  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(216)
	OUT  0x2D,R30
	LDI  R30,LOW(240)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	STS  _buzz_cont,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R26,_BTN_pressed
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	STS  _BTN_pressed,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LPM  R7,Z
	LDI  R30,LOW(0)
	STS  _heater_on,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	__PUTWMRN _now_tempU_prev,0,12,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	STS  _sec_profile,R30
	STS  _sec_profile+1,R31
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	STS  _rule_end,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _sec_profile_off,R30
	STS  _sec_profile_off+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	__PUTWMRN _now_tempU_calc,0,12,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDS  R30,_PWM_setted
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	__GETB1MN _PWM_setted,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x18:
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3F800000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETD2N 0x3F800000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDS  R26,_heat_koeff_U
	LDS  R27,_heat_koeff_U+1
	LDS  R24,_heat_koeff_U+2
	LDS  R25,_heat_koeff_U+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	__GETD1N 0x3F800000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1D:
	LDS  R30,_now_rule
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1E:
	LDI  R31,0
	SUBI R30,LOW(-_Heat_speed)
	SBCI R31,HIGH(-_Heat_speed)
	LD   R30,Z
	LDI  R31,0
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1F:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x20:
	LDS  R26,_PWM_koeff
	LDS  R27,_PWM_koeff+1
	LDS  R24,_PWM_koeff+2
	LDS  R25,_PWM_koeff+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	__GETD1N 0x3F000000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDS  R26,_PWM_setted
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x14
	SUBI R30,-LOW(1)
	STS  _PWM_setted,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	__GETD1N 0x3FC00000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x14
	SUBI R30,LOW(1)
	STS  _PWM_setted,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	MOVW R30,R12
	ADIW R30,30
	LDS  R26,_forecast_temp_U
	LDS  R27,_forecast_temp_U+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(_Heat_temp_U)
	LDI  R27,HIGH(_Heat_temp_U)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDS  R26,_forecast_temp_U
	LDS  R27,_forecast_temp_U+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	RCALL __CWD2
	RCALL __CDF2
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(50)
	STS  _buzz_freg,R30
	LDI  R30,LOW(10)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDS  R26,_forecast_temp_U
	LDS  R27,_forecast_temp_U+1
	CP   R12,R26
	CPC  R13,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(0)
	STS  _heat_approved,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x32:
	LDS  R30,_now_tempB
	LDS  R31,_now_tempB+1
	STS  _now_tempB_prev,R30
	STS  _now_tempB_prev+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LPM  R6,Z
	LDI  R30,LOW(0)
	__PUTB1MN _heater_on,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	__POINTW1MN _sec_profile,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x36:
	LDS  R30,_now_tempB
	LDS  R31,_now_tempB+1
	STS  _now_tempB_calc,R30
	STS  _now_tempB_calc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x37:
	LDS  R30,_now_tempB
	LDS  R31,_now_tempB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDS  R26,_heat_koeff_B
	LDS  R27,_heat_koeff_B+1
	LDS  R24,_heat_koeff_B+2
	LDS  R25,_heat_koeff_B+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDS  R30,_Heat_speed_B
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	__GETD2MN _PWM_koeff,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	__GETB2MN _PWM_setted,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__PUTB1MN _PWM_setted,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(_Heat_temp_B)
	LDI  R27,HIGH(_Heat_temp_B)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	LDS  R26,_forecast_temp_B
	LDS  R27,_forecast_temp_B+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDS  R26,_now_tempB
	LDS  R27,_now_tempB+1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x40:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	STS  _buzz_freg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	STS  _Heat_speed_B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(150)
	LDI  R27,HIGH(150)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(230)
	LDI  R27,HIGH(230)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	LDS  R26,_i
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x49:
	LDS  R30,_i
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(_Heat_temp_U_eeprom)
	LDI  R27,HIGH(_Heat_temp_U_eeprom)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	RCALL SUBOPT_0x49
	LDI  R26,LOW(_Heat_temp_U)
	LDI  R27,HIGH(_Heat_temp_U)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4C:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x49
	LDI  R26,LOW(_Heat_temp_B_eeprom)
	LDI  R27,HIGH(_Heat_temp_B_eeprom)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(_Heat_temp_B)
	LDI  R27,HIGH(_Heat_temp_B)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4F:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x50:
	RCALL SUBOPT_0x48
	LDI  R27,0
	SUBI R26,LOW(-_Heat_speed_eeprom)
	SBCI R27,HIGH(-_Heat_speed_eeprom)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x49
	LDI  R31,0
	SUBI R30,LOW(-_Heat_speed)
	SBCI R31,HIGH(-_Heat_speed)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x52:
	RCALL _read_adc
	LSR  R31
	ROR  R30
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x54:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x55:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x56:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x57:
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(2)
	MOV  R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x59:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	RCALL __MULF12
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5B:
	STS  _heat_k_B_int,R30
	STS  _heat_k_B_int+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5C:
	STS  _heat_k_U_int,R30
	STS  _heat_k_U_int+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDS  R26,_heat_k_U_int
	LDS  R27,_heat_k_U_int+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	LDS  R26,_heat_k_B_int
	LDS  R27,_heat_k_B_int+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	LDS  R30,_Heat_speed_B
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x62:
	LDS  R30,_set_now_rule
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x62
	LDI  R26,LOW(_Heat_temp_U)
	LDI  R27,HIGH(_Heat_temp_U)
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	RCALL __GETW1P
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x62
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x66:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x67:
	__GETD1N 0x42C80000
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x1D
	LDI  R31,0
	SUBI R30,LOW(-_Heat_rule)
	SBCI R31,HIGH(-_Heat_rule)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x69:
	LDI  R30,LOW(1)
	STS  _rule_engadged,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	LDI  R30,LOW(50)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x6B:
	LDS  R26,_heater_swither
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x42
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	RCALL SUBOPT_0x6B
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6E:
	LDI  R30,LOW(5)
	MOV  R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	LDS  R26,_set_now_rule
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x70:
	RCALL SUBOPT_0x62
	LDI  R31,0
	SUBI R30,LOW(-_Heat_rule)
	SBCI R31,HIGH(-_Heat_rule)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x6F
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x72:
	LDI  R30,LOW(13)
	STS  _heater_swither,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	RCALL __GETW1P
	CPI  R30,LOW(0x1C2)
	LDI  R26,HIGH(0x1C2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(5)
	STS  _lcd_freeze,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x75:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x76:
	STS  _heater_swither,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	RCALL SUBOPT_0x66
	RCALL __GETW1P
	MOVW R26,R0
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7A:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7B:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7D:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x7C
	RJMP SUBOPT_0x7D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x80:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x82:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x84:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x85:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x87:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	RJMP SUBOPT_0x40


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
	BRVS __ADDF1211
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
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
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
