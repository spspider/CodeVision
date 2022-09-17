
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _currentState=R4

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _Timer1Capt
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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x40000:
	.DB  0x74,0x65,0x73,0x74,0x0
_0x60014:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x40003
	.DW  _0x40000*2

	.DW  0x02
	.DW  0x04
	.DW  _0x60014*2

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
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
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
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xE0)
	LDI  R29,HIGH(0xE0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;//***************************************************************************
;//
;//  File........: bcd.с
;//
;//  Author(s)...: Pashgan ChipEnable.Ru
;//
;//  Target(s)...: для любого микроконтроллера
;//
;//  Compiler....: для любого компилятора
;//
;//  Description.: библиотека для перевода двоичных чисел в символы и вывода их на жкд
;//
;//  Revisions...:
;//
;//  18.10.2009 - 1.0 - Создан                                       - Pashgan.
;//
;//***************************************************************************
;#include "bcd.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;//символ "нуля" или пробела
;#ifdef MIRROR_NULL_
;  #define SYMB_NULL 48
;#else
;  #define SYMB_NULL 32
;#endif
;
;void BCD_1Lcd(unsigned char value)
; 0000 001C {

	.CSEG
; 0000 001D     value += 48;
;	value -> Y+0
; 0000 001E     LcdSendData(value);                  // ones
; 0000 001F }
;
;void BCD_2Lcd(unsigned char value)
; 0000 0022 {
; 0000 0023     unsigned char high = 0;
; 0000 0024 
; 0000 0025     while (value >= 10)                 // Count tens
;	value -> Y+1
;	high -> R17
; 0000 0026     {
; 0000 0027         high++;
; 0000 0028         value -= 10;
; 0000 0029     }
; 0000 002A     if (high) high += 48;
; 0000 002B     else high = SYMB_NULL;
; 0000 002C     LcdSendData(high);
; 0000 002D 
; 0000 002E     value += 48;
; 0000 002F     LcdSendData(value);                  // Add ones
; 0000 0030 }
;
;
;void BCD_3Lcd(unsigned char value)
; 0000 0034 {
_BCD_3Lcd:
; 0000 0035     unsigned char high = 0;
; 0000 0036     unsigned char flag = 0;
; 0000 0037 
; 0000 0038     if (value >= 100) flag = 48;
	RCALL __SAVELOCR2
;	value -> Y+2
;	high -> R17
;	flag -> R16
	LDI  R17,0
	LDI  R16,0
; 0000 0039     else flag = SYMB_NULL;
_0x33:
	LDI  R16,LOW(48)
; 0000 003A     while (value >= 100)                // Count hundreds
_0xA:
	LDD  R26,Y+2
	CPI  R26,LOW(0x64)
	BRLO _0xC
; 0000 003B     {
; 0000 003C         high++;
	SUBI R17,-1
; 0000 003D         value -= 100;
	LDD  R30,Y+2
	SUBI R30,LOW(100)
	STD  Y+2,R30
; 0000 003E     }
	RJMP _0xA
_0xC:
; 0000 003F     if (high) high += 48;
	CPI  R17,0
	BREQ _0xD
	SUBI R17,-LOW(48)
; 0000 0040     else high = SYMB_NULL;
	RJMP _0xE
_0xD:
	LDI  R17,LOW(48)
; 0000 0041     LcdSendData(high );
_0xE:
	ST   -Y,R17
	RCALL _LCD_WriteData
; 0000 0042 
; 0000 0043     high = 0;
	LDI  R17,LOW(0)
; 0000 0044     while (value >= 10)                 // Count tens
_0xF:
	LDD  R26,Y+2
	CPI  R26,LOW(0xA)
	BRLO _0x11
; 0000 0045     {
; 0000 0046         high++;
	SUBI R17,-1
; 0000 0047         value -= 10;
	LDD  R30,Y+2
	SUBI R30,LOW(10)
	STD  Y+2,R30
; 0000 0048     }
	RJMP _0xF
_0x11:
; 0000 0049     if (high) high += 48;
	CPI  R17,0
	BREQ _0x12
	SUBI R17,-LOW(48)
; 0000 004A     else high = flag;
	RJMP _0x13
_0x12:
	MOV  R17,R16
; 0000 004B     LcdSendData(high );
_0x13:
	ST   -Y,R17
	RCALL _LCD_WriteData
; 0000 004C 
; 0000 004D     value += 48;
	LDD  R30,Y+2
	SUBI R30,-LOW(48)
	STD  Y+2,R30
; 0000 004E     LcdSendData(value);                  // Add ones
	RCALL SUBOPT_0x0
; 0000 004F }
	RCALL __LOADLOCR2
	RJMP _0x2000002
;
;void BCD_3IntLcd(unsigned int value)
; 0000 0052 {
; 0000 0053     unsigned char high = 0;
; 0000 0054     unsigned char flag = 0;
; 0000 0055 
; 0000 0056     if (value >= 100) flag = 48;
;	value -> Y+2
;	high -> R17
;	flag -> R16
; 0000 0057     else flag = SYMB_NULL;
; 0000 0058     while (value >= 100)                // Count hundreds
; 0000 0059     {
; 0000 005A         high++;
; 0000 005B         value -= 100;
; 0000 005C     }
; 0000 005D     if (high) high += 48;
; 0000 005E     else high = SYMB_NULL;
; 0000 005F     LcdSendData(high );
; 0000 0060 
; 0000 0061     high = 0;
; 0000 0062     while (value >= 10)                 // Count tens
; 0000 0063     {
; 0000 0064         high++;
; 0000 0065         value -= 10;
; 0000 0066     }
; 0000 0067     if (high) high += 48;
; 0000 0068     else high = flag;
; 0000 0069     LcdSendData(high );
; 0000 006A 
; 0000 006B     value += 48;
; 0000 006C     LcdSendData(value);                  // Add ones
; 0000 006D }
;
;void BCD_4IntLcd(unsigned int value)
; 0000 0070 {
; 0000 0071     unsigned char high = 0;
; 0000 0072     unsigned char flag = 0;
; 0000 0073     unsigned char flag2 = 0;
; 0000 0074 
; 0000 0075 
; 0000 0076     if (value >= 1000) {flag = 48; flag2 = 48;}
;	value -> Y+4
;	high -> R17
;	flag -> R16
;	flag2 -> R19
; 0000 0077     else
; 0000 0078     {
; 0000 0079       if (value >= 100) {flag = SYMB_NULL; flag2 = 48;}
; 0000 007A       else {flag = SYMB_NULL; flag2 = SYMB_NULL;}
; 0000 007B     }
; 0000 007C 
; 0000 007D     while (value >= 1000)                // Count thousand
; 0000 007E     {
; 0000 007F         high++;
; 0000 0080         value -= 1000;
; 0000 0081     }
; 0000 0082     if (high) high += 48;
; 0000 0083     else high = SYMB_NULL;
; 0000 0084     LcdSendData(high);
; 0000 0085 
; 0000 0086     high = 0;
; 0000 0087     while (value >= 100)                // Count hundreds
; 0000 0088     {
; 0000 0089         high++;
; 0000 008A         value -= 100;
; 0000 008B     }
; 0000 008C     if (high) high += 48;
; 0000 008D     else high = flag;
; 0000 008E     LcdSendData(high );
; 0000 008F 
; 0000 0090 
; 0000 0091     high = 0;
; 0000 0092     while (value >= 10)                 // Count tens
; 0000 0093     {
; 0000 0094         high++;
; 0000 0095         value -= 10;
; 0000 0096     }
; 0000 0097     if (high) high += 48;
; 0000 0098     else high = flag2;
; 0000 0099     LcdSendData(high );
; 0000 009A 
; 0000 009B     value += 48;
; 0000 009C     LcdSendData(value);
; 0000 009D }
;
;
;
;
;#include "lcd_lib.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;//макросы для работы с битами
;#define ClearBit(reg, bit)       reg &= (~(1<<(bit)))
;#define SetBit(reg, bit)         reg |= (1<<(bit))
;
;#define FLAG_BF 7
;
;unsigned char __swap_nibbles(unsigned char data)
; 0001 000A {

	.CSEG
___swap_nibbles:
; 0001 000B  #asm
;	data -> Y+0
; 0001 000C  ld r30, Y
 ld r30, Y
; 0001 000D  swap r30
 swap r30
; 0001 000E  #endasm
; 0001 000F }
	RJMP _0x2000004
;
;void LCD_WriteComInit(unsigned char data)
; 0001 0012 {
_LCD_WriteComInit:
; 0001 0013   unsigned char tmp;
; 0001 0014   delay_us(40);
	ST   -Y,R17
;	data -> Y+1
;	tmp -> R17
	__DELAY_USB 213
; 0001 0015   ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
	CBI  0x15,2
; 0001 0016 #ifdef BUS_4BIT
; 0001 0017   tmp  = PORT_DATA & 0x0f;
	RJMP _0x2000005
; 0001 0018   tmp |= (data & 0xf0);
; 0001 0019   PORT_DATA = tmp;		//вывод старшей тетрады
; 0001 001A #else
; 0001 001B   PORT_DATA = data;		//вывод данных на шину индикатора
; 0001 001C #endif
; 0001 001D   SetBit(PORT_SIG, EN);	        //установка E в 1
; 0001 001E   delay_us(2);
; 0001 001F   ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
; 0001 0020 }
;
;
;inline static void LCD_CommonFunc(unsigned char data)
; 0001 0024 {
_LCD_CommonFunc_G001:
; 0001 0025 #ifdef BUS_4BIT
; 0001 0026   unsigned char tmp;
; 0001 0027   tmp  = PORT_DATA & 0x0f;
	ST   -Y,R17
;	data -> Y+1
;	tmp -> R17
	IN   R30,0x15
	RCALL SUBOPT_0x1
; 0001 0028   tmp |= (data & 0xf0);
; 0001 0029 
; 0001 002A   PORT_DATA = tmp;		//вывод старшей тетрады
; 0001 002B   SetBit(PORT_SIG, EN);
; 0001 002C   delay_us(2);
; 0001 002D   ClearBit(PORT_SIG, EN);
; 0001 002E 
; 0001 002F   data = __swap_nibbles(data);
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL ___swap_nibbles
	STD  Y+1,R30
; 0001 0030   tmp  = PORT_DATA & 0x0f;
_0x2000005:
	IN   R30,0x15
	RCALL SUBOPT_0x1
; 0001 0031   tmp |= (data & 0xf0);
; 0001 0032 
; 0001 0033   PORT_DATA = tmp;		//вывод младшей тетрады
; 0001 0034   SetBit(PORT_SIG, EN);
; 0001 0035   delay_us(2);
; 0001 0036   ClearBit(PORT_SIG, EN);
; 0001 0037 #else
; 0001 0038   PORT_DATA = data;		//вывод данных на шину индикатора
; 0001 0039   SetBit(PORT_SIG, EN);	        //установка E в 1
; 0001 003A   delay_us(2);
; 0001 003B   ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
; 0001 003C #endif
; 0001 003D }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;inline static void LCD_Wait(void)
; 0001 0040 {
_LCD_Wait_G001:
; 0001 0041 #ifdef CHECK_FLAG_BF
; 0001 0042   #ifdef BUS_4BIT
; 0001 0043 
; 0001 0044   unsigned char data;
; 0001 0045   DDRX_DATA &= 0x0f;            //конфигурируем порт на вход
; 0001 0046   PORT_DATA |= 0xf0;	        //включаем pull-up резисторы
; 0001 0047   SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
; 0001 0048   ClearBit(PORT_SIG, RS);	//RS в 0 команды
; 0001 0049   do{
; 0001 004A     SetBit(PORT_SIG, EN);
; 0001 004B     delay_us(2);
; 0001 004C     data = PIN_DATA & 0xf0;      //чтение данных с порта
; 0001 004D     ClearBit(PORT_SIG, EN);
; 0001 004E     data = __swap_nibbles(data);
; 0001 004F     SetBit(PORT_SIG, EN);
; 0001 0050     delay_us(2);
; 0001 0051     data |= PIN_DATA & 0xf0;      //чтение данных с порта
; 0001 0052     ClearBit(PORT_SIG, EN);
; 0001 0053     data = __swap_nibbles(data);
; 0001 0054   }while((data & (1<<FLAG_BF))!= 0 );
; 0001 0055   ClearBit(PORT_SIG, RW);
; 0001 0056   DDRX_DATA |= 0xf0;
; 0001 0057 
; 0001 0058   #else
; 0001 0059   unsigned char data;
; 0001 005A   DDRX_DATA = 0;                //конфигурируем порт на вход
; 0001 005B   PORT_DATA = 0xff;	        //включаем pull-up резисторы
; 0001 005C   SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
; 0001 005D   ClearBit(PORT_SIG, RS);	//RS в 0 команды
; 0001 005E   do{
; 0001 005F     SetBit(PORT_SIG, EN);
; 0001 0060     delay_us(2);
; 0001 0061     data = PIN_DATA;            //чтение данных с порта
; 0001 0062     ClearBit(PORT_SIG, EN);
; 0001 0063   }while((data & (1<<FLAG_BF))!= 0 );
; 0001 0064   ClearBit(PORT_SIG, RW);
; 0001 0065   DDRX_DATA = 0xff;
; 0001 0066   #endif
; 0001 0067 #else
; 0001 0068   delay_us(40);
	__DELAY_USB 213
; 0001 0069 #endif
; 0001 006A }
	RET
;
;//функция записи команды
;void LCD_WriteCom(unsigned char data)
; 0001 006E {
_LCD_WriteCom:
; 0001 006F   LCD_Wait();
;	data -> Y+0
	RCALL _LCD_Wait_G001
; 0001 0070   ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
	CBI  0x15,2
; 0001 0071   LCD_CommonFunc(data);
	RJMP _0x2000003
; 0001 0072 }
;
;//функция записи данных
;void LCD_WriteData(unsigned char data)
; 0001 0076 {
_LCD_WriteData:
; 0001 0077   LCD_Wait();
;	data -> Y+0
	RCALL _LCD_Wait_G001
; 0001 0078   SetBit(PORT_SIG, RS);	        //установка RS в 1 - данные
	SBI  0x15,2
; 0001 0079   LCD_CommonFunc(data);
_0x2000003:
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_CommonFunc_G001
; 0001 007A }
_0x2000004:
	ADIW R28,1
	RET
;
;//функция инициализации
;void LCD_Init(void)
; 0001 007E {
_LCD_Init:
; 0001 007F #ifdef BUS_4BIT
; 0001 0080   DDRX_DATA |= 0xf0;
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
; 0001 0081   PORT_DATA |= 0xf0;
	IN   R30,0x15
	ORI  R30,LOW(0xF0)
	OUT  0x15,R30
; 0001 0082 #else
; 0001 0083   DDRX_DATA |= 0xff;
; 0001 0084   PORT_DATA |= 0xff;
; 0001 0085 #endif
; 0001 0086 
; 0001 0087   DDRX_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
	IN   R30,0x14
	ORI  R30,LOW(0x7)
	OUT  0x14,R30
; 0001 0088   PORT_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
	IN   R30,0x15
	ORI  R30,LOW(0x7)
	OUT  0x15,R30
; 0001 0089   ClearBit(PORT_SIG, RW);
	CBI  0x15,1
; 0001 008A   delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x2
; 0001 008B 
; 0001 008C #ifdef HD44780
; 0001 008D   LCD_WriteComInit(0x30);
; 0001 008E   delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x2
; 0001 008F   LCD_WriteComInit(0x30);
; 0001 0090   delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x2
; 0001 0091   LCD_WriteComInit(0x30);
; 0001 0092 #endif
; 0001 0093 
; 0001 0094 #ifdef BUS_4BIT
; 0001 0095   LCD_WriteComInit(0x20); //4-ми разрядная шина
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LCD_WriteComInit
; 0001 0096   LCD_WriteCom(0x28); //4-ми разрядная шина, 2 - строки
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x3
; 0001 0097 #else
; 0001 0098   LCD_WriteCom(0x38); //8-ми разрядная шина, 2 - строки
; 0001 0099 #endif
; 0001 009A   LCD_WriteCom(0x08);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x3
; 0001 009B   LCD_WriteCom(0x0c);  //0b00001111 - дисплей вкл, курсор и мерцание выключены
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x3
; 0001 009C   LCD_WriteCom(0x01);  //0b00000001 - очистка дисплея
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
; 0001 009D   delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0001 009E   LCD_WriteCom(0x06);  //0b00000110 - курсор движется вправо, сдвига нет
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3
; 0001 009F }
	RET
;
;//функция вывода строки из флэш памяти
;void LCD_SendStringFlash(char __flash *str)
; 0001 00A3 {
; 0001 00A4   unsigned char data;
; 0001 00A5   while (*str)
;	*str -> Y+1
;	data -> R17
; 0001 00A6   {
; 0001 00A7     data = *str++;
; 0001 00A8     LCD_WriteData(data);
; 0001 00A9   }
; 0001 00AA }
;
;//функция вывда строки из ОЗУ
;void LCD_SendString(char *str)
; 0001 00AE {
_LCD_SendString:
; 0001 00AF   unsigned char data;
; 0001 00B0   while (*str)
	ST   -Y,R17
;	*str -> Y+1
;	data -> R17
_0x20006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x20008
; 0001 00B1   {
; 0001 00B2     data = *str++;
	LD   R17,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
; 0001 00B3     LCD_WriteData(data);
	ST   -Y,R17
	RCALL _LCD_WriteData
; 0001 00B4   }
	RJMP _0x20006
_0x20008:
; 0001 00B5 }
	LDD  R17,Y+0
_0x2000002:
	ADIW R28,3
	RET
;
;void LCD_Clear(void)
; 0001 00B8 {
; 0001 00B9   LCD_WriteCom(0x01);
; 0001 00BA   delay_ms(2);
; 0001 00BB }
;//***************************************************************************
;//  File........: main.c
;//
;//  Author(s)...: Pashgan    chipenable.ru
;//
;//  Target(s)...: ATMega...
;//
;//  Compiler....: CodeVision 2.04
;//
;//  Description.: Использование схемы захвата для декодирования сигналов ИК ПДУ
;//
;//  Data........: 18.04.11
;//
;//***************************************************************************
;#include <mega8535.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "lcd_lib.h"
;#include "timer.h"
;
;void main(void)
; 0002 0014 {

	.CSEG
_main:
; 0002 0015   LCD_Init();
	RCALL _LCD_Init
; 0002 0016   TIM_Init();
	RCALL _TIM_Init
; 0002 0017   LCD_SendString("test");
	__POINTW1MN _0x40003,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_SendString
; 0002 0018   #asm("sei");
	sei
; 0002 0019 
; 0002 001A   while(1){
_0x40004:
; 0002 001B      TIM_Handle();
	RCALL _TIM_Handle
; 0002 001C      TIM_Display();
	RCALL _TIM_Display
; 0002 001D   }
	RJMP _0x40004
; 0002 001E }
_0x40007:
	RJMP _0x40007

	.DSEG
_0x40003:
	.BYTE 0x5
;#include "timer.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define PRE 64UL
;
;#define START_IMP_TH  (12000UL*FCPU)/PRE
;#define START_IMP_MAX (15000UL*FCPU)/PRE
;#define BIT_IMP_MAX   (3000UL*FCPU)/PRE
;#define BIT_IMP_TH    (1500UL*FCPU)/PRE
;
;volatile unsigned int icr1 = 0;
;volatile unsigned int icr2 = 0;
;enum state {IDLE = 0, RESEIVE = 1};
;enum state currentState = IDLE;
;
;#define CAPTURE    0
;#define RESEIVE_OK 1
;volatile unsigned char flag = 0;
;
;//первые четыре байта - адрес и команда, пятый байт - количество повторов
;#define NUM_REPEAT 4
;#define MAX_SIZE 5
;unsigned char buf[MAX_SIZE];
;
;//инициализация таймера Т1
;void TIM_Init(void)
; 0003 001A {

	.CSEG
_TIM_Init:
; 0003 001B    DDRD &= ~(1<<PIND6);
	CBI  0x11,6
; 0003 001C    PORTD |= (1<<PIND6);
	SBI  0x12,6
; 0003 001D 
; 0003 001E    TIMSK = (1<<TICIE1); //разрешаем прерывание по событию захват
	LDI  R30,LOW(32)
	OUT  0x39,R30
; 0003 001F    TCCR1A=(0<<COM1A1)|(0<<COM1A0)|(0<<WGM11)|(0<<WGM10);  //режим - normal,
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0003 0020    TCCR1B=(0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(1<<CS11)|(1<<CS10); //захват по заднему фронту, предделитель - 64
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0003 0021    TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0003 0022 
; 0003 0023    currentState = IDLE;
	CLR  R4
	CLR  R5
; 0003 0024 }
	RET
;
;
;//прерывание по событию захват
;interrupt [TIM1_CAPT] void Timer1Capt(void)
; 0003 0029 {
_Timer1Capt:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 002A 
; 0003 002B    icr1 = icr2;
	LDS  R30,_icr2
	LDS  R31,_icr2+1
	STS  _icr1,R30
	STS  _icr1+1,R31
; 0003 002C    icr2 = ((unsigned int)ICR1H<<8)|ICR1L;
	IN   R30,0x27
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R30
	IN   R30,0x26
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _icr2,R30
	STS  _icr2+1,R31
; 0003 002D    SetBit(flag, CAPTURE);
	RCALL SUBOPT_0x4
	ORI  R30,1
	RCALL SUBOPT_0x5
; 0003 002E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;unsigned int TIM_CalcPeriod(void)
; 0003 0031 {
_TIM_CalcPeriod:
; 0003 0032   unsigned int buf1, buf2;
; 0003 0033 
; 0003 0034   #asm("cli");
	RCALL __SAVELOCR4
;	buf1 -> R16,R17
;	buf2 -> R18,R19
	cli
; 0003 0035   buf1 = icr1;
	__GETWRMN 16,17,0,_icr1
; 0003 0036   buf2 = icr2;
	__GETWRMN 18,19,0,_icr2
; 0003 0037   #asm("sei");
	sei
; 0003 0038 
; 0003 0039   if (buf2 > buf1) {
	__CPWRR 16,17,18,19
	BRSH _0x60003
; 0003 003A     buf2 -= buf1;
	__SUBWRR 18,19,16,17
; 0003 003B   }
; 0003 003C   else {
	RJMP _0x60004
_0x60003:
; 0003 003D     buf2 += (65535 - buf1);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	SUB  R30,R16
	SBC  R31,R17
	__ADDWRR 18,19,30,31
; 0003 003E   }
_0x60004:
; 0003 003F   return buf2;
	MOVW R30,R18
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; 0003 0040 }
;
;//
;void TIM_Handle(void)
; 0003 0044 {
_TIM_Handle:
; 0003 0045   unsigned int period;
; 0003 0046   static unsigned char data;
; 0003 0047   static unsigned char countBit, countByte;
; 0003 0048 
; 0003 0049   if (BitIsClear(flag, CAPTURE)) return;
	RCALL __SAVELOCR2
;	period -> R16,R17
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x1)
	BRNE _0x60005
	RJMP _0x2000001
; 0003 004A 
; 0003 004B   period = TIM_CalcPeriod();
_0x60005:
	RCALL _TIM_CalcPeriod
	MOVW R16,R30
; 0003 004C 
; 0003 004D   switch(currentState){
	MOVW R30,R4
; 0003 004E       //ждем стартовый импульс
; 0003 004F       case IDLE:
	SBIW R30,0
	BRNE _0x60009
; 0003 0050          if (period < START_IMP_MAX) {
	__CPWRN 16,17,3750
	BRSH _0x6000A
; 0003 0051            if (period > START_IMP_TH){
	__CPWRN 16,17,3001
	BRLO _0x6000B
; 0003 0052              data = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
; 0003 0053              countBit = 0;
	RCALL SUBOPT_0x7
; 0003 0054              countByte = 0;
	STS  _countByte_S0030003000,R30
; 0003 0055              buf[NUM_REPEAT] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _buf,4
; 0003 0056              currentState = RESEIVE;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0003 0057            }
; 0003 0058            else {
	RJMP _0x6000C
_0x6000B:
; 0003 0059              buf[NUM_REPEAT]++;
	__GETB1MN _buf,4
	SUBI R30,-LOW(1)
	__PUTB1MN _buf,4
; 0003 005A            }
_0x6000C:
; 0003 005B          }
; 0003 005C          break;
_0x6000A:
	RJMP _0x60008
; 0003 005D 
; 0003 005E        //прием посылки
; 0003 005F        case RESEIVE:
_0x60009:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60012
; 0003 0060          if (period < BIT_IMP_MAX){
	__CPWRN 16,17,750
	BRSH _0x6000E
; 0003 0061            if (period > BIT_IMP_TH){
	__CPWRN 16,17,376
	BRLO _0x6000F
; 0003 0062               SetBit(data, 7);
	LDS  R30,_data_S0030003000
	ORI  R30,0x80
	RCALL SUBOPT_0x6
; 0003 0063            }
; 0003 0064            countBit++;
_0x6000F:
	LDS  R30,_countBit_S0030003000
	SUBI R30,-LOW(1)
	STS  _countBit_S0030003000,R30
; 0003 0065            if (countBit == 8){
	LDS  R26,_countBit_S0030003000
	CPI  R26,LOW(0x8)
	BRNE _0x60010
; 0003 0066              buf[countByte] = data;
	LDS  R30,_countByte_S0030003000
	LDI  R31,0
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	LDS  R26,_data_S0030003000
	STD  Z+0,R26
; 0003 0067              countBit = 0;
	RCALL SUBOPT_0x7
; 0003 0068              data = 0;
	RCALL SUBOPT_0x6
; 0003 0069              countByte++;
	LDS  R30,_countByte_S0030003000
	SUBI R30,-LOW(1)
	STS  _countByte_S0030003000,R30
; 0003 006A              if (countByte == (MAX_SIZE - 1)){
	LDS  R26,_countByte_S0030003000
	CPI  R26,LOW(0x4)
	BRNE _0x60011
; 0003 006B                SetBit(flag, RESEIVE_OK);
	RCALL SUBOPT_0x4
	ORI  R30,2
	RCALL SUBOPT_0x5
; 0003 006C                currentState = IDLE;
	CLR  R4
	CLR  R5
; 0003 006D                break;
	RJMP _0x60008
; 0003 006E              }
; 0003 006F            }
_0x60011:
; 0003 0070            data = data>>1;
_0x60010:
	LDS  R30,_data_S0030003000
	LSR  R30
	RCALL SUBOPT_0x6
; 0003 0071          }
; 0003 0072          break;
_0x6000E:
; 0003 0073 
; 0003 0074 
; 0003 0075        default:
_0x60012:
; 0003 0076           break;
; 0003 0077     }
_0x60008:
; 0003 0078 
; 0003 0079   ClearBit(flag, CAPTURE);
	RCALL SUBOPT_0x4
	ANDI R30,0xFE
	RCALL SUBOPT_0x5
; 0003 007A }
_0x2000001:
	RCALL __LOADLOCR2P
	RET
;
;
;void TIM_Display(void)
; 0003 007E {
_TIM_Display:
; 0003 007F   if(BitIsSet(flag, RESEIVE_OK)){
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x2)
	BREQ _0x60013
; 0003 0080     LCD_Goto(0,0);
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x3
; 0003 0081     BCD_3Lcd(buf[0]);
	LDS  R30,_buf
	RCALL SUBOPT_0x8
; 0003 0082     LCD_WriteData(' ');
; 0003 0083     BCD_3Lcd(buf[1]);
	__GETB1MN _buf,1
	RCALL SUBOPT_0x8
; 0003 0084     LCD_WriteData(' ');
; 0003 0085     BCD_3Lcd(buf[2]);
	__GETB1MN _buf,2
	RCALL SUBOPT_0x8
; 0003 0086     LCD_WriteData(' ');
; 0003 0087     BCD_3Lcd(buf[3]);
	__GETB1MN _buf,3
	RCALL SUBOPT_0x8
; 0003 0088     LCD_WriteData(' ');
; 0003 0089     ClearBit(flag, RESEIVE_OK);
	RCALL SUBOPT_0x4
	ANDI R30,0xFD
	RCALL SUBOPT_0x5
; 0003 008A   }
; 0003 008B 
; 0003 008C   LCD_Goto(0,1);
_0x60013:
	LDI  R30,LOW(192)
	RCALL SUBOPT_0x3
; 0003 008D   BCD_3Lcd(buf[NUM_REPEAT]);
	__GETB1MN _buf,4
	ST   -Y,R30
	RCALL _BCD_3Lcd
; 0003 008E }
	RET

	.DSEG
_icr1:
	.BYTE 0x2
_icr2:
	.BYTE 0x2
_flag:
	.BYTE 0x1
_buf:
	.BYTE 0x5
_data_S0030003000:
	.BYTE 0x1
_countBit_S0030003000:
	.BYTE 0x1
_countByte_S0030003000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	RJMP _LCD_WriteData

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	OR   R17,R30
	OUT  0x15,R17
	SBI  0x15,0
	__DELAY_USB 11
	CBI  0x15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP _LCD_WriteComInit

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _LCD_WriteCom

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_flag
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	STS  _data_S0030003000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _countBit_S0030003000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	RCALL _BCD_3Lcd
	LDI  R30,LOW(32)
	RJMP SUBOPT_0x0


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
