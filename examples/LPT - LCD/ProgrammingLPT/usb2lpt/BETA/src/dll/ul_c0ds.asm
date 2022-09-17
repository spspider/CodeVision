	PAGE	250,200	; (fast) keine l�stigen Seiten im Listing
;Startup-Datei f�r Eigenschaftsseiten-Lieferant 16bit
;untersdr�ckt das Einbinden der C-Standardbibliothek
;und liefert die Funktion _pascal ss_strtoul(char _ss*, char _ss* _ss*, int)
;F�r MASM 5.10 (im �Windows Server 2003 DDK� enthalten unter bin/bin16/)
;F�r MASM 6.11d (im �Windows 98 DDK� enthalten als bin/bin16/ml.exe)

EXTRN pascal LocalInit :far

	.MODEL	small,pascal
	
	.DATA
	db	16 dup (0)	; Die ersten 16 Bytes eines LocalHeap frei!
	
	.CODE

;Eintrittspunkt: hier keine DLL-Initialisierung
.386	;kein "push 0"-Umweg bitte!
LibEntry proc  far
	push	ds
	push	0
	push	cx
	call	LocalInit
	ret
LibEntry endp

;Windows-Exit-Prozedur (Einsprungpunkt anbieten)
WEP proc far
	ret	2
WEP endp

;Zeichenkette in Zahl umwandeln, alle Zeiger near SS-basiert
;Ohne �bergehung f�hrender Leerzeichen und Tabs
.8086
ss_strtoul proc uses si, s:WORD, endptr:WORD, base:WORD 
	mov	si,s		; Erste Anweisung in 8086-Modus generiert
.386				; k�rzeres "push bp; mov bp,sp..."
	movzx	ebx,base
        xor	edx,edx		; 32-bit-Akku
        cld
@@l:
	db	036h		;segss
	lodsb			; Ziffer->AL laden
	cmp	al,60h		; Kleinbuchstaben?
	jc	@f
	and	al,not 20h	; zum Gro�buchstaben
@@:	sub	al,'0'
	cmp	al,10
	jc	@f
	sub	al,7
@@:	cmp	al,bl		; Gr��er-gleich Zahlenbasis?
	jnc	@f		; ung�ltiges Zeichen
        movzx	ecx,al		; Ziffer retten
        xchg	eax,edx
	mul	ebx		; Akku*=Radix
	or	edx,edx
	jnz	@f		; Zahl zu gro�
	add	eax,ecx
	jc	@f		; Zahl zu gro�
	xchg	edx,eax		; zur�ck als EDX = Akku
	jmp	@@l
@@:	mov	bx,endptr
	or	bx,bx
	jz	@f
	mov	ss:[bx],si	; Adresse falsches Zeichen ablegen
@@:	push	edx
	pop	ax
	pop	dx
.8086
	ret			; generiert "pop si; pop bp; retn 6"
ss_strtoul endp

;Speicher f�llen
RtlFillMemory proc uses di, buf:DWORD, len:WORD, fill:WORD
	les	di,[buf]
	cld
	mov	ax,[fill]
	mov	cx,[len]
	rep stosb
	ret
RtlFillMemory endp

;Speicher kopieren, �berlappung beachten
RtlMoveMemory proc uses ds si di, d:DWORD, s:DWORD, l:WORD
	lds	si,[s]
	les	di,[d]
	mov	cx,[l]
	cld
.386
	mov	eax,[s]
	cmp	eax,[d]
.8086
	jnc	@f		; Ziel < Quelle
	add	si,cx
	add	di,cx
	dec	si
	dec	di
	std
@@:	rep movsb
	cld
	ret
RtlMoveMemory endp

end LibEntry
