
	.CSEG
;PCODE: $00000000 VOL: 0
;PCODE: $00000001 VOL: 0
    ld   r30,y
;PCODE: $00000002 VOL: 0
    swap r30
;PCODE: $00000003 VOL: 0
    andi r30,0xf
;PCODE: $00000004 VOL: 0
    mov  r26,r30
;PCODE: $00000005 VOL: 0
    lsl  r26
;PCODE: $00000006 VOL: 0
    lsl  r26
;PCODE: $00000007 VOL: 0
    add  r30,r26
;PCODE: $00000008 VOL: 0
    lsl  r30
;PCODE: $00000009 VOL: 0
    ld   r26,y+
;PCODE: $0000000A VOL: 0
    andi r26,0xf
;PCODE: $0000000B VOL: 0
    add  r30,r26
;PCODE: $0000000C VOL: 0
    ret
;PCODE: $0000000D VOL: 0
;PCODE: $0000000E VOL: 0
;PCODE: $0000000F VOL: 0
;PCODE: $00000010 VOL: 0
;PCODE: $00000011 VOL: 0
    ld   r26,y+
;PCODE: $00000012 VOL: 0
    clr  r30
;PCODE: $00000013 VOL: 0
bin2bcd0:
;PCODE: $00000014 VOL: 0
    subi r26,10
;PCODE: $00000015 VOL: 0
    brmi bin2bcd1
;PCODE: $00000016 VOL: 0
    subi r30,-16
;PCODE: $00000017 VOL: 0
    rjmp bin2bcd0
;PCODE: $00000018 VOL: 0
bin2bcd1:
;PCODE: $00000019 VOL: 0
    subi r26,-10
;PCODE: $0000001A VOL: 0
    add  r30,r26
;PCODE: $0000001B VOL: 0
    ret
;PCODE: $0000001C VOL: 0
;PCODE: $0000001D VOL: 0
;PCODE: $0000001E VOL: 0
