; Hilfs-Quelltext für den fehlenden Inline-Assembler bei AMD64-Plattform des C-Compilers.
; Nur Debugregister-Anzapfung - die HAL von AMD64 hat keine Portzugriffsfunktionen.
; Funktioniert natürlich noch nicht! Die ISR muss erst disassembliert werden.

.data?
Usage_Len	equ	32
Usage		dw	Usage_Len dup (?)
; Der Wert 0 bedeutet: freies Debugregister
; Der Wert 1 weist beim Treiber-Start besetzte Debugregister aus
; (diese werden jedoch bei UCB_ForceDebReg trotzdem verwendet)
; Ungerade Zahlen (Bit 0 gesetzt) für temporär ausgeschaltete Portadressen
; Die Indizes 0..3 gelten für DR0..DR3, alle anderen sind Reservepositionen
; Dieses Array kann mit "rep scasw" schnell nach dem passenden Index durchsucht werden.

OldInt1		dq	?
OldInt2E	dq	?	;Wird der noch verwendet?
OldSysEnter	dq	?

SaveGS		dw	?	; Zeiger KPCR
		dw	?	; Ausrichtung
UsageBits	dd	?	; 0-Bits für temporär ausgeschaltete Portadressen

DebRegStolen	dd	3 dup (?)	; globale Zähler für "geklaute" Debugregister
; Index 0: Timer
; Index 1: Int2E
; Index 2: SysEnter
	public DebRegStolen

.code
	extern DispatchHook:proc	;Parameter: ECX=Index (0..31), EDX=Portadresse
	;Weiterhin: R8 = Zeiger zu Quell/Zieldaten, R9 = Länge, Stack = Typ
	;Diese verteilt dann an die entsprechenden Aufrufer der (künftigen) DLL

;*****************************
;** Debug-Register und Int1 **
;*****************************/
; Auf Mehrprozessormaschinen müssen in _allen_ Prozessoren
; die Debugregister gesetzt/gelesen/geprüft werden.

; IRQL >= DISPATCH_LEVEL
; Der KDPC (1. Argument) wird nicht mehr benötigt.
;void EachProcessorDpc(KDPC*Dpc, PVOID Context, PVOID Arg1, PVOID Arg2)
EachProcessorDpc proc
	push	r9			;Arg2 = Zeiger auf Affinitätsmaske
	 mov	rcx,r8			;Arg1 = Argument
	 call	rdx			;Context = Prozedurzeiger
	pop	rcx
	movzx	rax,byte ptr gs:[197]	;KPCR.Number
	lock btr qword ptr[rcx],rax	;Für diesen Prozessor als erledigt markieren
	ret
EachProcessorDpc endp


; IRQL == DISPATCH_LEVEL! (Prozessor darf nicht wechseln.)
; PE: CL = Interrupt-Nummer
; PA: RAX = Adresse aus IDT (des aktuellen Prozessors)
; VR: EAX,ECX
;void* GetIdtAddr(UCHAR nr)
GetIdtAddr proc private
	movzx	rax,cl
	shl	eax,4
	mov	rcx,gs:[160]		;KPCR.IDT
	add	rcx,rax
	mov	eax,[rcx+8]		;High-Teil
	shl	rax,32
	mov	ax,[rcx+6]		;vorletztes WORD
	shl	rax,16
	mov	ax,[rcx+0]		;letztes WORD
	ret
GetIdtAddr endp

; IRQL == DISPATCH_LEVEL! (Prozessor darf nicht wechseln.)
;void SetIdtAddr(UCHAR nr)
; PE: RAX=neue Adresse für INT
;     CL: Interrupt-Nummer
; PA: -
; VR: RCX,RDX,RAX,R8
SetIdtAddr proc private
	movzx	rdx,cl
	mov	rcx,cr0
	shl	edx,4
	mov	r8,rcx
	btr	rcx,16			; Supervisor Mode Write Protect
	mov	cr0,rcx
	mov	rcx,gs:[160]		;KPCR.IDT
	add	rcx,rdx
	mov	[rcx+0],ax		;unterstes WORD
	shr	rax,16
	mov	[rcx+6],ax		;nächstes WORD
	shr	rax,16
	mov	[rcx+8],eax		;High-Teil
	mov	cr0,r8
	ret
SetIdtAddr endp

; IRQL == DISPATCH_LEVEL! (Prozessor darf nicht wechseln.)
;void GetInts(void)
GetInts proc
	push	rdi
	 mov	cl,1
	 call	GetIdtAddr
	 lea	rdx,[NewInt1]
	 cmp	rax,rdx			; schon gehookt?
	 je	@f			; nichts tun! (Schleifen vermeiden)
	 lea	rdi,[OldInt1]
	 stosq
	 mov	cl,2Eh
	 call	GetIdtAddr
	 stosq
	 mov	ecx,176h		; IA32_SYSENTER_EIP
	 rdmsr
	 stosq
@@:	pop	rdi
	ret
GetInts endp


;void SetSysEnter(void)
;PE: RAX = zu setzende Adresse für SysEnter-Befehl
SetSysEnter proc private
	mov	rcx,176h		; IA32_SYSENTER_EIP
	xor	rdx,rdx			; sonst GPF!
	wrmsr
	ret
SetSysEnter endp


; IRQL == DISPATCH_LEVEL! (Prozessor darf nicht wechseln.)
;void HookInts(int unused)
; Faule Annahme: bei INT1 befindet sich bereits ein gültiger Gate-Deskriptor
; VR: RAX,RDX,RCX,R8; EFlags unverändert
; Bei Hyperthreading hat jeder Prozessor eine eigene IDT.
HookInts proc
	pushfq
	 cli
	 cmp	OldInt1,0
	 je	@f
	 lea	rax,[NewInt1]		; ISR-Anfangsadresse
	 mov	cl,1
	 call	SetIdtAddr
	 lea	rax,[NewInt2E]
	 mov	cl,2Eh
	 call	SetIdtAddr
	 lea	rax,[NewSysEnter]
	 call	SetSysEnter
@@:	popfq
	ret
HookInts endp

; IRQL == DISPATCH_LEVEL! (Prozessor darf nicht wechseln.)
;void UnhookInts(int unused)
; VR: RAX,RDX,RCX,R8; EFlags unverändert
UnhookInts proc
	pushfq
	 cli
	 push	rsi
	  lea	rsi,[OldInt1]
	  lodsq
	  or	rax,rax
	  jz	@f
	  mov	cl,1
	  call	SetIdtAddr
	  lodsq
	  mov	cl,2Eh
	  call	SetIdtAddr
	  lodsq
	  call	SetSysEnter
@@:	 pop	rsi
	popfq
	ret
UnhookInts endp

; Nur sinnvoll mit IRQL >= DISPATCH_LEVEL!
;void cyLoadDR(void)
; Debugregister des aktuellen Prozessors laden/wiederherstellen, VR: RAX,RBX,RCX,RDX,RSI,Flags
; Liefert ECX!=0 wenn sich die Debugregister dabei verändern
cyLoadDR proc private
	xor	ecx,ecx		; Bit-Sammler
	lea	rsi,[Usage]	; im Ring 0 immer CLD
	mov	rax,cr4
	bts	eax,3		; PENTIUM Debug Extension (DE) aktivieren
	mov	cr4,rax
	setnc	cl		; CL=1 wenn Debug Extension ausgeschaltet war
	mov	rbx,DR7
	xor	rax,rax		; obere 48 Bits löschen
	lodsw			; 16 Bits laden
	or	ah,ah		; mit (gültiger) Adresse gefüllt?
	jz	@f
	mov	rdx,DR0
	mov	DR0,rax
	xor	edx,eax
	or	ecx,edx		; ECX!=0 wenn DR0 verändert wurde
	or	ebx,000E0202h
	btr	ebx,16		; DR7=xxxxxxxx xxxx1110 xxxxxx1x xxxxxx1x
@@:	lodsw
	or	ah,ah
	jz	@f
	mov	rdx,DR1
	mov	DR1,rax
	xor	edx,eax
	or	ecx,edx		; ECX!=0 wenn DR1 verändert wurde
	or	ebx,00E00208h
	btr	ebx,20		; DR7=xxxxxxxx 1110xxxx xxxxxx1x xxxx1xxx
@@:	lodsw
	or	ah,ah
	jz	@f
	mov	rdx,DR2
	mov	DR2,rax
	xor	edx,eax
	or	ecx,edx		; ECX!=0 wenn DR2 verändert wurde
	or	ebx,0E000220h
	btr	ebx,24		; DR7=xxxx1110 xxxxxxxx xxxxxx1x xx1xxxxx
@@:	lodsw
	or	ah,ah
	jz	@f
	mov	rdx,DR3
	mov	DR3,rax
	xor	edx,eax
	or	ecx,edx		; ECX!=0 wenn DR3 verändert wurde
	or	ebx,0E0000280h
	btr	ebx,28		; DR7=1110xxxx xxxxxxxx xxxxxx1x 1xxxxxxx
@@:	mov	rdx,DR7
	mov	DR7,rbx
	xor	edx,ebx
	or	ecx,edx		; ECX!=0 wenn DR7 verändert wurde
	ret
cyLoadDR endp

; Nur sinnvoll mit IRQL >= DISPATCH_LEVEL!
;BOOLEAN LoadDR(int unused)
LoadDR proc
	push	rsi
	push	rbx
	 call	cyLoadDR
	pop	rbx
	pop	rsi
	add	ecx,-1		; Returnwert nach CY (gesetzt wenn ECX!=0)
	setc	al		; für sog. Hochsprachen...
	ret
LoadDR endp


;void PrepareDR(void)
; PA: [OldInt.Int1]=Adresse von INT1
; Weiterhin SaveGS
iPrepareDR proc
	call	GetInts
	mov	[SaveGS],gs
; markiert die bereits vor dem Treiber-Start verwendeten Debugregister
; als "nicht verwendungsfähig für uns".  Aufzurufen beim Treiber-Start
	lea	rdx,[Usage]
	mov	rax,DR7
	push	4
	pop	rcx
@@:	test	al,3		; Lx oder Gx gesetzt? (Also in Benutzung?)
	setnz	byte ptr[rdx]	; wenn ja, auf 1 setzen, sonst 0 lassen
	shr	eax,2		; nächstes Debugregister
	add	rdx,2		; nächstes Usage-Word
	loop	@b
; KeInitializeTimer(&debset.tmr);
; KeInitializeDpc(&debset.dpc,SetDebDpc,NULL);
iPrepareDR endp

;********************************
;* API (öffentliche Funktionen) *
;********************************

; Scans the USHORT array for given USHORT and returns a pointer to entry; returns NULL if not found
;USHORT* ScanMemW(SIZE_T l /*RCX*/, const USHORT*p /*RDX*/, USHORT a /*R8*/)
ScanMemW proc
	xchg	rdx,rdi
	mov	eax,r8d
	repne	scasw
	lea	rax,[rdi-2]
	je	@f
	xor	rax,rax
@@:	xchg	rdi,rdx
	ret
ScanMemW endp

; Diese Routine wird mit ECX = Debugregister-Nummer aufgerufen
; Nur sinnvoll mit IRQL >= DISPATCH_LEVEL!
;void UnloadDR(UCHAR debregnumber)
UnloadDR proc
	mov	rdx,DR7
	mov	eax,0FFFCFFF0h	; Maske für DR7, HiWord/LoWord vertauscht
	shl	cl,1		; Nr. mal zwei
	shl	eax,cl		; HiWord (künftiges LoWord) richtig
	shl	ax,cl		; LoWord (künftiges HiWord) richtig
	ror	eax,16		; Vertauschen HiWord/LoWord
	and	edx,eax		; Bits weg, Debugregister frei
	mov	DR7,rdx
	xor	edx,edx		; High-Teil sollte Null sein
	shr	cl,1		; wieder zurück
	jnz	@f
	mov	DR0,rdx		; hübsch machen (nicht erforderlich, aber macht das Debuggen übersichtlicher)
@@:	loop	@f
	mov	DR1,rdx
@@:	loop	@f
	mov	DR2,rdx
@@:	loop	@f
	mov	DR3,rdx
@@:	ret
UnloadDR endp


;************************************************************
;** Abfangen von READ_PORT_UCHAR und WRITE_PORT_UCHAR (NT) **
;************************************************************
; Gibt's bei AMD64 gar nicht!!


;***************************
;** Portzugriffe und Trap **
;***************************

;void NewInt2E(void)
NewInt2E proc private
	pushfq
	push	rax
	push	rcx
	push	rdx
	push	rbx
	push	rsi
	 call	cyLoadDR
	 lock inc [DebRegStolen+4]
	pop	rsi
	pop	rbx
	pop	rdx
	pop	rcx
	pop	rax
	popfq
	jmp	OldInt2E
NewInt2E endp

;void NewSysEnter(void)
NewSysEnter proc private
	pushfq
	push	rax
	push	rcx
	push	rdx
	push	rbx
	push	rsi
	 call	cyLoadDR
	 lock inc [DebRegStolen+8]
	pop	rsi
	pop	rbx
	pop	rdx
	pop	rcx
	pop	rax
	popfq
	jmp	OldSysEnter
NewSysEnter endp

;void HandleOutIn(void)
; Hilfsroutine für Debugregister-Anzapfung
;  insb/outsb-Unterstützung würde tiefgreifende Erweiterungen erfordern,
;  um die verschiedenen Adressierungsarten (VM, PM16, PM32; Segmentpräfix) zu verarbeiten
; PE:	ECX Bit 22 = USE32-Bit (aus LAR-Befehl)
;	AH=Opcode EC(inb), ED(inw), EE(outb), EF(outw)
;	   Opcode 6C(insb), 6D(insw), 6E(outsb), 6F(outsw) nicht unterstützt!
;	   Opcode E4, E5, E6, E7 nicht unterstützt! (Wäre in AL)
;	AL=Präfix (66)
;	DX=Portadresse
;	ESI=Client-EAX-Zeiger
;	EDI=DevExt-Zeiger
;	Interrupts gesperrt
HandleOutIn proc private
;	mov	cl,2		// USE16
;	bt	ecx,22
;	jnc	use16
;	mov	cl,4		// USE32
;jetzt:CL=4 oder 2 (USE32 oder USE16 je nach Attribut des unterbrochenen Kodesegmentes)
;use16: 	cmp	al,66h		// Präfixbyte? (Schätzung!!)
;	jne	no_swap
;	xor	cl,6		// aus 4 mach 2 und aus 2 mach 4
;no_swap:xchg	ah,al
;	cmp	al,0EFh		//OUT dx,ax oder OUT dx,eax
;	je	out_cl
;	cmp	al,0EEh		//OUT dx,al
;	jne	no_outb
;	mov	cl,1		//Präfix gilt nicht!
;out_cl:	inc	[edi]DEVICE_EXTENSION.ac.out
;	sti
;	push	ecx
;	push	[esi]		//Client_EAX
;	push	edx
;	push	edi
;	call	HandleOut
;	jmp	supported	//mit AL/AX/EAX=geschriebenes Byte
;no_outb:
;	cmp	al,0EDh		//IN ax,dx oder IN eax,dx
;	je	in_cl
;	cmp	al,0ECh		//IN al,dx
;	jne	no_inb
;	mov	cl,1
;in_cl:	inc	[edi]DEVICE_EXTENSION.ac.in
;	sti
;	push	ecx
;	push	esi
;	push	edx
;	push	edi
;	call	HandleIn	//Thread blockieren...
;	jmp	supported
;no_inb:
;	inc	[edi]DEVICE_EXTENSION.ac.fail
;#if DBG
; 	int 3
;#endif
;supported:
;	cli
	ret
HandleOutIn endp

; Stackaufbau 	WinNT64
;		EBP+	Register-NT
;44	 GS		88		(nur V86)
;40	 FS		84		(nur V86)
;3C	 DS		80		(nur V86)
;38	 ES		7C		(nur V86)
;34	 SS		78		(nur Ring3)
;30	 ESP		74		(nur Ring3)
;2C	 EFlags		70		(Bit17 = V86)
;28	 CS		6C		(kein Selektor wenn V86!)
;24	 EIP		68
;20	 Fehlerkode	64
;1C	EAX		60	RBP
;18	ECX		5C	RBX
;14	EDX		58	RSI
;10	EBX		54	RDI
;0C	(ESP)		50	FS
;08	BP		4C	Geheimnisvolle Speicherzelle
;04	RSI		48	0
;00	RDI		44	RAX
;			40	RCX
;			3C	RDX
;			38	DS?
;			34	ES?
;			30	GS
;EFlags-Aufbau
;21 20  19  18 17 16 15 14 13-12 11 10  9  8  7  6 5  4 3  2 1  0
;ID VIP VIF AC VM RF  0 NT IOPL  OF DF IF TF SF ZF 0 AF 0 PF 1 CF

;void NewInt1(void)
NewInt1 proc private
	push	rax
	push	rbp
	 mov	eax,[UsageBits]
	 mov	rbp,DR6
	 and	rax,0Fh
	 test	rax,rbp
	 jnz	@f
	pop	rbp
	pop	rax
	jmp	OldInt1
@@:
	 not	rax
	 and	rax,rbp		; "Unsere" Bits in DR6 löschen
	 mov	DR6,rax
	 bsf	rbp,rbp		; Merken, welches Debugregister es war (0..3) -> EBP
	 xor	rax,rax
	 xchg	[esp+8],rax	; Fehlerkode Null setzen, RAX restaurieren
	 cld
	 push	rbx		; Restlicher NT-Stack
	 push	rsi
	 push	rdi
	 push	gs
	 mov	gs,[SaveGS]
	 push	gs:qword ptr[0]
	 ;mov	gs:dword ptr[0],-1
	 push	0
	 push	rax
	 push	rcx
	 push	rdx
	 push	fs
	 push	r8
	 push	r9
	 push	r10
	 push	r11
	 push	r12
	 push	r13
	 push	r14
	 push	r15
	  sub	rsp,30h
	  mov	rdx,rbp		; Debugregister-Nummer (0..3)
	  mov	rbp,rsp
	  test	byte ptr[rbp+72h],2	; V86?
	  jz	protmode
	  lea	rsi,[rbp+7Ch]	; Segmentregister umkopieren
	  lodsq
	  mov	[rbp+34h],rax
	  lodsq
	  mov	[rbp+38h],rax
	  lodsq
	  mov	[rbp+50h],rax
	  lodsq
	  mov	[rbp+30h],rax
	  mov	rbx,[rbp+6Ch]	; Client_CS (V86-Modus, <64K)
	  shl	rbx,4
	  add	rbx,[rbp+68h]	; Client_EIP (V86-Modus, <64K)
	  xor	rcx,rcx		; niemals USE32
	  jmp	fromvm
protmode:	; Protected Mode, entweder Ring 0 oder Ring 3
;	  les	rbx,[rbp+68h]	; Client_CS_EIP
;	  lar	rcx,[rbp+6Ch]	; Client_CS -> USE32-Bit
fromvm:
	  mov	rsi,gs:[124h]	;TEB
	  add	rsi,128h	; lange Opcodes vermeiden
	  push	qword ptr[rsi]	; alten Rahmenzeiger retten
	  mov	[rsi],rbp	; neuen Rahmenzeiger setzen
	  mov	al,[rbp+6Ch]	; Client_CS
	  and	al,1
	  mov	[rsi+134h-128h],al	; Privileg setzen
	  push	rsi
;-------------------------
	   mov	ax,[rbx-2]	;Opcode (ggf. mit Präfix) - UNSAUBER, erwischt Mehrfachpräfixe sowie REP nicht
;DevExt-Zeiger beschaffen für Rückruf
;	   mov	rdi,X4DR[rdx*4]
;Richtung des Portzugriffs (Lesen oder Schreiben) ermitteln
	   lea	rsi,[rbp+44h]	; Client_EAX
	   mov	rdx,[rbp+3Ch]	; Client_EDX
	   call	HandleOutIn
;-------------------------
	  pop	rsi
	  pop	qword ptr[rsi]		; Rahmenzeiger wiederherstellen
	  add	rsp,30h
	 test	byte ptr[ebp+72h],2	; V86?
	 jz	novm
	add	rsp,12
	jmp	nopop
novm:	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	gs
nopop:	pop	rdx
	pop	rcx
	pop	rax
	pop	rbx		; Dummy-Lesen
	pop	gs:qword ptr[0]
	pop	gs
	pop	rdi
	pop	rsi
	pop	rbx
	pop	rbp
	add	rsp,8		; "Fehlercode" übergehen
	iretd

NewInt1 endp

end
