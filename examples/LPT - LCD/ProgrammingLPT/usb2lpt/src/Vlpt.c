#include "usb2lpt.h"

/***********************
 ** Globale Variablen **
 ***********************/

#define Usage_Len 32		// >=4, die ersten vier (auch) via DR0..DR3
static USHORT Usage[Usage_Len];	// Überwachte Portadressen
// Der Wert 0 bedeutet: freies Debugregister
// Der Wert 1 weist beim Treiber-Start besetzte Debugregister aus
// (diese werden jedoch bei UCB_ForceDebReg trotzdem verwendet)
// Die Indizes 0..3 gelten für DR0..DR3, alle anderen: ausschließlich [RW]_PORT_U[CSL]
static ULONG UsageBits;

static PDEVICE_EXTENSION X4DR[Usage_Len]; // zugehörige USB2LPT-Geräte

static LARGE_INTEGER OldInt1;	/* bleibt Null ohne Pentium */
static USHORT SaveDS,SaveFS;	// Für ISR zum Restaurieren
/*static*/ ULONG CurThreadPtr;	// Get_Cur_Thread_Handle-Ersatz
// Strukturzeiger für 2. Kernel-Stack (Win9x) C0013E78
// Unter W2K/WXP ist der aktuelle Thread durch FS: adressiert
// ...dann ist diese Variable = NULL.
void NewInt1(void);
static MYTIMER debset;	// Debugregister-Setz-Zeitgeber (periodisch)
// Der Timer dient zur Feststellung "geklauter" Debugregister.

/*****************************
 ** Debug-Register und Int1 **
 *****************************/
/* Zu tun: Auf Mehrprozessormaschinen müssen in _allen_ Prozessoren
 * die Debugregister gesetzt/gelesen/geprüft werden.
 * Ein NTDDK-Treiber kann dazu KeSetTargetProcessorDpc benutzen?
 * Auf Dual-Code-Maschinen (zumindest beim FSC Pentium4HT
 * "Mauersberger.mb.tu-chemnitz.de") haben die beiden Prozessoren
 * _verschiedene_ IDT-Einträge! Da stürzt der Debugregister-Trap zz. ab!
 */

static void __declspec(naked) SetHook1(void) {
/* PE: CX:EAX=neue Adresse für INT1 */
/* PA: CX:EAX=alte Adresse von INT1 */
 _asm{	mov	edx,cr0
	push	edx
	 btr	edx,16			/* Supervisor Mode Write Protect */
	 mov	cr0,edx
	 push	edx
	 push	edx
	 sidt	[esp+2]
	 pop	edx
	 pop	edx			// EDX = Basisadresse der IDT
	 xchg	ax,[edx+8*1+0]		/* Low-Teil Offset */
	 rol	eax,16
	 xchg	ax,[edx+8*1+6]		/* High-Teil Offset */
	 rol	eax,16
	 xchg	cx,[edx+8*1+2]		/* Segment */
	pop	edx
	mov	cr0,edx
	ret
 }
}

static void __declspec(naked) HookInt1(void) {
/* Faule Annahme: bei INT1 befindet sich bereits ein gültiger Gate-Deskriptor
/* VR: EAX,CX,EDX; EFlags unverändert */
// NICHT MULTIPROZESSOR-SICHER, weil anderer Prozessor gerade Int1 ausführen
// könnte (und ich weiß nicht, wie man ihn daran hindert)
// Noch schlimmer wird's, falls jeder Prozessor eine eigene ISR hat.
 _asm{	pushfd
	 cli
	 mov	eax,offset NewInt1
	 mov	cx,cs
	 cmp	[dword ptr OldInt1],0
	 jz	no_586
	 call	SetHook1
no_586:
	popfd
	ret
 }
}

static void __declspec(naked) UnhookInt1(void) {
/* VR: EAX,CX,ESI; EFlags unverändert */
// NICHT MULTIPROZESSOR-SICHER, weil anderer Prozessor gerade Int1 ausführen
// könnte (und ich weiß nicht, wie man ihn daran hindert)
 _asm{	pushfd
	 cli
	 mov	eax,[dword ptr OldInt1]
	 mov	cx,[word ptr OldInt1+4]
	 or	eax,eax
	 jz	no_586
	 call	SetHook1
no_586:
	popfd
	ret
 }
}

static BOOLEAN __declspec(naked) LoadDR(void) {
/* Debugregister laden/wiederherstellen, VR: EAX */
// Liefert TRUE sowie CY=1 wenn sich die Debugregister dabei verändern
// NICHT MULTIPROZESSOR-SICHER, weil Debugregister des anderen Prozessors
// unerreichbar (und ich weiß nicht, wie)
 _asm{	pushad
	 xor	ecx,ecx		// Bit-Sammler
	 mov	esi,offset Usage// im Ring 0 immer CLD (?)
	 _emit	0x0F		// mov eax,cr4
	 _emit	0x20
	 _emit	0xE0
	 BTS	eax,3		/* PENTIUM Debug Extension (DE) aktivieren */
	 _emit	0x0F		// mov cr4,eax
	 _emit	0x22
	 _emit	0xE0
	 setnc	cl		// CL=1 wenn Debug Extension ausgeschaltet war
	 mov	ebx,DR7
	 xor	eax,eax
	 lodsw
	 or	ah,ah		// mit (gültiger) Adresse gefüllt?
	 jz	no0
	 mov	edx,DR0
	 mov	DR0,eax
	 sub	edx,eax
	 or	edx,ecx
	 setnz	cl		// CL=1 wenn DR0 verändert wurde oder CL=1 war
	 or	ebx,0x000E0202
	 btr	ebx,16		/* DR7=xxxxxxxx xxxx1110 xxxxxx1x xxxxxx1x */
no0:	 lodsw
	 or	ah,ah
	 jz	no1
	 mov	edx,DR1
	 mov	DR1,eax
	 sub	edx,eax
	 or	edx,ecx
	 setnz	cl		// CL=1 wenn DR1 verändert wurde oder CL=1 war
	 or	ebx,0x00E00208
	 btr	ebx,20		/* DR7=xxxxxxxx 1110xxxx xxxxxx1x xxxx1xxx */
no1:	 lodsw
	 or	ah,ah
	 jz	no2
	 mov	edx,DR2
	 mov	DR2,eax
	 sub	edx,eax
	 or	edx,ecx
	 setnz	cl		// CL=1 wenn DR2 verändert wurde oder CL=1 war
	 or	ebx,0x0E000220
	 btr	ebx,24		/* DR7=xxxx1110 xxxxxxxx xxxxxx1x xx1xxxxx */
no2:	 lodsw
	 or	ah,ah
	 jz	no3
	 mov	edx,DR3
	 mov	DR3,eax
	 sub	edx,eax
	 or	edx,ecx
	 setnz	cl		// CL=1 wenn DR3 verändert wurde oder CL=1 war
	 or	ebx,0xE0000280
	 btr	ebx,28		/* DR7=1110xxxx xxxxxxxx xxxxxx1x 1xxxxxxx */
no3:	 mov	edx,DR7
	 mov	DR7,ebx
	 sub	edx,ebx
	 or	edx,ecx
	 setnz	cl		// CL=1 wenn DR7 verändert wurde oder CL=1 war
	 shr	ecx,1		// Returnwert nach CY
	popad
	setc	al		// für sog. Hochsprachen...
	ret
 }
}

static VOID SetDebDpc(IN PKDPC dpc,PVOID x,PVOID a,PVOID b) {
 if (LoadDR()) {
  int i;	// In allen Zählern inkrementieren
  for (i=0;i<Usage_Len;i++) if (X4DR[i]) X4DR[i]->ac.steal++;
  Vlpt_KdPrint2(("Debugregister gemaust!\n"));
 }
}

static void __declspec(naked) SwapID(void) {	/* Pentium-Test */
 _asm{	pushfd
	pop	eax
	btc	eax,21
	push	eax
	popfd
	ret
 }
}

// Liefert TRUE wenn der Prozessor das Umschalten des CPUID-Flagbits zulässt
BOOLEAN __declspec(naked) IsPentium(void) {
 _asm{
 	call	SwapID
	xchg	ecx,eax
	call	SwapID
	sub	eax,ecx
	setnz	al
	ret
 }
}

// Nur aufrufen wenn IsPentium() TRUE lieferte
void PrepareDR(void) {
/* PA: [OldInt1]=Adresse von INT1, aber nur beim Pentium */
// Weiterhin SaveDS, SaveFS, CurThreadPtr
 _asm{	push	eax
	push	eax		// Platz auf dem Stack
 	sidt	[esp+2]
	pop	esi		// Len im High-Teil
	pop	esi		// Basisadresse der IDT
// Sucht ab Int0 den Befehl "mov edi,[xxxxxxxx]"; der Wert ist der
// globale Zeiger für den aktuellen Thread (Stack-Tausch) (Win98)
	mov	di,[esi+0+6]	// High-Teil Int0 (bei Int1 stört SoftICE)
	rol	edi,16
	mov	di,[esi+0+0]	// Low-Teil
	mov	eax,0xC766006A	// So geht's bei W2K los
	scasd
	je	l2		// keine Bytefolge suchen, alles FS-adressierbar
	mov	ecx,100h
	mov	al,0x8B		// Bytefolge 8B 3D suchen
l1:	repne	scasb
	jne	l2
	cmp	byte ptr [edi],0x3D
	jne	l1
	mov	eax,[edi+1]
	jmp	l3
l2:	xor	eax,eax		// Null für WinNT
l3:	mov	[CurThreadPtr],eax	// gleichzeitig Win9x-Kennung
// holt den OldInt1-Zeiger, aber bitte nur, wenn's ein Pentium ist
	mov	ax,[esi+8+6]		/* High-Teil Offset */
	shl	eax,16
	mov	ax,[esi+8+0]		/* Low-Teil Offset */
	cmp	eax,offset NewInt1	// schon gehookt?
	jz	no_586			// nichts (mehr) tun!
	mov	edi,offset OldInt1
	cld
	stosd
	movzx	eax,word ptr [esi+8+2]	/* Segment */
	stosd
	mov	[SaveDS],ds	// Win9x: 30h	WinNT:
	mov	[SaveFS],fs	// Win9x: 78h	WinNT:
// markiert die bereits vor dem Treiber-Start verwendeten Debugregister
// als "nicht verwendungsfähig für uns".  Aufzurufen beim Treiber-Start
// NICHT MULTIPROZESSOR-SICHER
 	mov	esi,offset Usage
	mov	eax,DR7
	push	4
	pop	ecx
l:	test	al,3		// Lx oder Gx gesetzt? (Also in Benutzung?)
	setnz	[esi]		// wenn ja, auf 1 setzen, sonst 0 lassen
	shr	eax,2		// nächstes Debugregister
	add	esi,2		// nächstes Usage-Word
	loop	l
 }
// Debugregister-Diebstahl zyklisch rückgängig machen (WinXP)
// Besser wäre es, die Ursache auszumachen...
 KeInitializeTimer(&debset.tmr);
 KeInitializeDpc(&debset.dpc,SetDebDpc,NULL);
no_586:;
}

static void _fastcall SetTimerX() {
 if (!KeSetTimerEx(&debset.tmr,RtlConvertLongToLargeInteger(100*-10000),
   100,&debset.dpc)) TRAP();
}

int _stdcall AllocDR(USHORT adr,PDEVICE_EXTENSION X) {
// Belegung eines E/A-Debugregisters und andere Arbeiten
// Start der Umleitung von 4 aufeinander folgenden Portadressen
// via Debugregister (wenn in X->uc.flags UC_Debugreg gesetzt ist)
// und via {READ|WRITE}_PORT_U{CHAR|SHORT|LONG}.
 int i;
 if (adr&0x3) return -1;	// Fehlerkode: falsche Adresse
 if (!(adr&0xFF00)) return -1;	// Board-Register sind ebenfalls unzulässig
// if (!OldInt1.QuadPart) return -6;	// Kein Pentium
 for (i=0; i<Usage_Len; i++) if (adr==Usage[i]) return -2; // Schon benutzt
 i=4; if (X->uc.flags&UC_Debugreg && IsPentium()) i=0;
 for (; i<Usage_Len; i++) if (!Usage[i]) {
  Usage[i]=adr;
  if (!(UsageBits&0xF) && i<4) {
   HookInt1();
   SetTimerX();
  }
  UsageBits|=1<<i;
  X4DR[i]=X;
  if (i<4) LoadDR();		// Rückgabewert egal, sollte TRUE sein
  return i;
 }
 return -3;			// Kein Debugregister frei
}

int _stdcall FreeDRN(int dr) {	// Freigabe einer Debugregister-Nummer
 if ((unsigned)dr>=Usage_Len) return -4;// Ungültiges "Handle"
 if (!(Usage[dr]&0xFF00)) return -5;	// Debugregister nicht in Benutzung
 X4DR[dr]=NULL;
 UsageBits&=~(1<<dr);
 if (dr<4) {
  _asm{
  	mov	ecx,dr
	mov	edx,DR7
	mov	eax,0xFFFCFFF0	// Maske für DR0, HiWord/LoWord vertauscht
	shl	cl,1		// Nr. mal zwei
	shl	eax,cl		// HiWord (künftiges LoWord) richtig
	shl	ax,cl		// LoWord (künftiges HiWord) richtig
	ror	eax,16		// Vertauschen HiWord/LoWord
	and	eax,edx		// Bits weg, Debugregister frei
	mov	DR7,eax
	xor	eax,eax
	shr	cl,1		// wieder zurück
	jnz	no0
	mov	DR0,eax		// hübsch machen (nicht erforderlich)
no0:	loop	no1
	mov	DR1,eax
no1:	loop	no2
	mov	DR2,eax
no2:	loop	no3
	mov	DR3,eax
no3:
  }
  if (!(UsageBits&0xF)) {	// Kein Debugregister beteiligt?
   KeCancelTimer(&debset.tmr);	// Ganz zurückziehen
   UnhookInt1();
  }
 }
 Usage[dr]=0;			// Freigabe
 return dr;			// okay
}

/************************************************************
 ** Abfangen von READ_PORT_UCHAR und WRITE_PORT_UCHAR (NT) **
 ************************************************************/
// Für LabView muss extra ...ULONG abgegangen werden!

static void __declspec(naked) FindAddr(void) {
//PE: DX=Portadresse
//PA: NZ wenn nicht gefunden
//    EDI=X4DR-Eintrag, ESI=Index, EDX unverändert
//Stille Voraussetzung:
// Adressen beim Word- und DWord-Zugriff kreuzen keine 4-Byte-Grenze!
 _asm{	cmp	dh,1		// Niemals <100h trappen!
	jc	exi		// NZ!
	mov	eax,edx
	and	al,0xFC		// Vier aufeinanderfolgende Adressen
	push	Usage_Len
	pop	ecx
	cld			// ??? (sicherheitshalber)
	mov	edi,offset Usage
	repne	scasw
	jne	exi
	push	Usage_Len-1
	pop	esi		// Index ermitteln
	sub	esi,ecx
	mov	edi,X4DR[esi*4]
	test	byte ptr[edi]DEVICE_EXTENSION.f,No_Function
exi:	ret
 }
}

static ULONG __declspec(naked) MyWritePort(void) {
// Gleiches "Ende" für MyWritePortUchar/Ushort/Ulong
 _asm{	 inc	[edi]DEVICE_EXTENSION.ac.wpu
	 push	[esp+1Ch+4]	// EAX
	 push	edx
	 push	edi
	 call	HandleOut	// blockiert Thread gelegentlich
	popad
	popfd
	ret	8
 }
}

static ULONG __declspec(naked) MyReadPort(void) {
// Gleiches "Ende" für MyReadPortUchar/Ushort/Ulong
 _asm{	
	 inc	[edi]DEVICE_EXTENSION.ac.rpu
	 lea	eax,[esp+1Ch+4]	// PUSHAD-Struktur modifizieren lassen
	 push	eax
	 push	edx
	 push	edi
	 call	HandleIn	// blockiert Thread immer für ca. 1 ms
	popad
	popfd
	ret	4
 }
}

static void __declspec(naked) MyWritePortUchar(PUCHAR a,UCHAR b) {
// Gleiche Signatur wie WRITE_PORT_UCHAR()
 _asm{	mov	edx,[esp+4]	// a
	mov	eax,[esp+8]	// b
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	1
	 jmp	MyWritePort
l1:
	popad
	popfd
	out	dx,al
	ret	8
 }
}

static UCHAR __declspec(naked) MyReadPortUchar(PUCHAR a) {
// Gleiche Signatur wie READ_PORT_UCHAR()
 _asm{	mov	edx,[esp+4]	// a
	xor	eax,eax
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	1
	 jmp	MyReadPort
l1:
	popad
	popfd
	in	al,dx
	ret	4
 }
}

static void __declspec(naked) MyWritePortUshort(PUCHAR a,USHORT b) {
// Gleiche Signatur wie WRITE_PORT_USHORT()
 _asm{	mov	edx,[esp+4]	// a
	mov	eax,[esp+8]	// b
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	2
	 jmp	MyWritePort
l1:
	popad
	popfd
	out	dx,ax
	ret	8
 }
}

static USHORT __declspec(naked) MyReadPortUshort(PUCHAR a) {
// Gleiche Signatur wie READ_PORT_USHORT()
 _asm{	mov	edx,[esp+4]	// a
	xor	eax,eax
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	2
	 jmp	MyReadPort
l1:
	popad
	popfd
	in	ax,dx
	ret	4
 }
}

static void __declspec(naked) MyWritePortUlong(PUCHAR a,ULONG b) {
// Gleiche Signatur wie WRITE_PORT_ULONG()
 _asm{	mov	edx,[esp+4]	// a
	mov	eax,[esp+8]	// b
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	4
	 jmp	MyWritePort
l1:
	popad
	popfd
	out	dx,eax
	ret	8
 }
}

static ULONG __declspec(naked) MyReadPortUlong(PUCHAR a) {
// Gleiche Signatur wie READ_PORT_ULONG()
 _asm{	mov	edx,[esp+4]	// a
	pushfd
	pushad
	 call	FindAddr
	 jnz	l1
	 push	4
	 jmp	MyReadPort
l1:
	popad
	popfd
	in	eax,dx
	ret	4
 }
}

static void __declspec(naked) Hook(void) {
// PE:	ESI=zu patchende (Code-)Adresse
//	ECX=Sprungziel-5
//	EDI=Sicherungsspeicher für Wiederherstellung (5 Byte Platz)
// PA:	EDI zeigt hinter die 5 geretteten Bytes
// VR:	EAX,EDI,ECX
 _asm{ 	mov	al,0E9h			// JMP rel.
	xchg	[esi],al
	stosb
	xchg	eax,ecx
	sub	eax,esi
	xchg	[esi+1],eax
	stosd
	ret
 }
}
// Unhook ist einfach "movsb"+"movsd"

static UCHAR save[6][5];	// Platz für die sechs weggepatchen JMP

extern void __declspec(naked) HookSyscalls(void) {
// Dieser Hook geht davon aus, dass kein anderer auf die gleiche Idee kommt!
// NICHT MULTIPROZESSOR-SICHER, weil anderer Prozessor gerade die zu patchende
// Funktion ausführen könnte (und ich weiß nicht, wie man ihn daran hindert)
 _asm{	mov	edx,cr0
	push	esi
	push	edi
	push	edx
	pushfd
	 btr	edx,16			// Supervisor Mode Write Protect
	 cli				// höchstes IRQL, keine ISR darf funken!
	 cld
	 mov	cr0,edx
	 mov	edi,offset save
	 mov	esi,[WRITE_PORT_UCHAR]	// Tatsächlicher Prozedurstart; Zeigertabelle!
	 mov	ecx,offset MyWritePortUchar-5
	 call	Hook
	 mov	esi,[READ_PORT_UCHAR]
	 mov	ecx,offset MyReadPortUchar-5
	 call	Hook
	 mov	esi,[WRITE_PORT_USHORT]
	 mov	ecx,offset MyWritePortUshort-5
	 call	Hook
	 mov	esi,[READ_PORT_USHORT]
	 mov	ecx,offset MyReadPortUshort-5
	 call	Hook
	 mov	esi,[WRITE_PORT_ULONG]
	 mov	ecx,offset MyWritePortUlong-5
	 call	Hook
	 mov	esi,[READ_PORT_ULONG]
	 mov	ecx,offset MyReadPortUlong-5
	 call	Hook
	popfd
	pop	edx
	pop	edi
	pop	esi
	mov	cr0,edx
	ret
 }
}

extern void __declspec(naked) UnhookSyscalls(void) {
// NICHT MULTIPROZESSOR-SICHER, weil anderer Prozessor gerade die zu patchende
// Funktion ausführen könnte (und ich weiß nicht, wie man ihn daran hindert)
 _asm{	mov	edx,cr0
	push	esi
	push	edi
	push	edx
	pushfd
	 btr	edx,16			// Supervisor Mode Write Protect
	 cli				// höchstes IRQL, keine ISR darf funken!
	 cld
	 mov	cr0,edx
	 mov	esi,offset save
	 mov	edi,[WRITE_PORT_UCHAR]
	 movsb
	 movsd
	 mov	edi,[READ_PORT_UCHAR]
	 movsb
	 movsd
	 mov	edi,[WRITE_PORT_USHORT]
	 movsb
	 movsd
	 mov	edi,[READ_PORT_USHORT]
	 movsb
	 movsd
	 mov	edi,[WRITE_PORT_ULONG]
	 movsb
	 movsd
	 mov	edi,[READ_PORT_ULONG]
	 movsb
	 movsd
	popfd
	pop	edx
	pop	edi
	pop	esi
	mov	cr0,edx
	ret
 }
}

/***************************
 ** Portzugriffe und Trap **
 ***************************/
//#define CurXX 0xC0013E78
//#define CurVM 0xC0013EEC

void _declspec(naked) HandleOutIn(void) {
// PE:	ECX Bit 22 = USE32-Bit (aus LAR-Befehl)
//	AH=Opcode EC(inb), ED(inw), EE(outb), EF(outw)
//	   Opcode 6C(insb), 6D(insw), 6E(outsb), 6F(outsw) nicht unterstützt!
//	   Opcode E4, E5, E6, E7 nicht unterstützt! (Wäre in AL)
//	AL=Präfix (66)
//	DX=Portadresse
//	ESI=Client-EAX-Zeiger
//	EDI=DevExt-Zeiger
//	Interrupts gesperrt
 _asm{	mov	cl,2		// USE16
	bt	ecx,22
	jnc	use16
	mov	cl,4		// USE32
//jetzt:CL=4 oder 2 (USE32 oder USE16 je nach Attribut des unterbrochenen Kodesegmentes)
use16: 	cmp	al,0x66		// Präfixbyte? (Schätzung!!)
	jne	no_swap
	xor	cl,6		// aus 4 mach 2 und aus 2 mach 4
no_swap:xchg	ah,al
	cmp	al,0xEF		//OUT dx,ax oder OUT dx,eax
	je	out_cl
	cmp	al,0xEE		//OUT dx,al
	jne	no_outb
	mov	cl,1		//Präfix gilt nicht!
out_cl:	inc	[edi]DEVICE_EXTENSION.ac.out
	sti
	push	ecx
	push	[esi]		//Client_EAX
	push	edx
	push	edi
	call	HandleOut
	jmp	supported	//mit AL/AX/EAX=geschriebenes Byte
no_outb:
	cmp	al,0xED		//IN ax,dx oder IN eax,dx
	je	in_cl
	cmp	al,0xEC		//IN al,dx
	jne	no_inb
	mov	cl,1
in_cl:	inc	[edi]DEVICE_EXTENSION.ac.in
	sti
	push	ecx
	push	esi
	push	edx
	push	edi
	call	HandleIn	//Thread blockieren...
	jmp	supported
no_inb:
	inc	[edi]DEVICE_EXTENSION.ac.fail
#if DBG
 	int 3
#endif
supported:
	cli
	ret
 }
}
/* Stackaufbau 80386+, Win9x	WinNT
EBP+	Register-9x	EBP+	Register-NT
44	 GS		88		(nur V86)
40	 FS		84		(nur V86)
3C	 DS		80		(nur V86)
38	 ES		7C		(nur V86)
34	 SS		78		(nur Ring3)
30	 ESP		74		(nur Ring3)
2C	 EFlags		70		(Bit17 = V86)
28	 CS		6C		(kein Selektor wenn V86!)
24	 EIP		68
20	 Fehlerkode	64
1C	EAX		60	EBP
18	ECX		5C	EBX
14	EDX		58	ESI
10	EBX		54	EDI
0C	(ESP)		50	FS
08	EBP		4C	Geheimnisvolle Speicherzelle
04	ESI		48	0
00	EDI		44	EAX
			40	ECX
			3C	EDX
			38	DS
			34	ES
			30	GS
EFlags-Aufbau
21 20  19  18 17 16 15 14 13-12 11 10  9  8  7  6 5  4 3  2 1  0
ID VIP VIF AC VM RF  0 NT IOPL  OF DF IF TF SF ZF 0 AF 0 PF 1 CF
*/

void __declspec(naked) NewInt1(void) {
 _asm{	push	0		// "Fehlerkode"
 	pushad
	 mov	eax,DR6
	 mov	ecx,cs:[UsageBits]
	 and	ecx,0Fh
	 test	ecx,eax		// Zugriff auf eine "unserer" Adressen?
	 jnz	access03	// ja
	popad			// nein, andere Software ist dran
	add	esp,4
	jmp	fword ptr cs:[OldInt1]	//weiter (zu SoftICE o.ä.)
access03:
//bei jedem Portzugriff (LPT) steht in DX die Portadresse
//In AL steht das Datenbyte (nur bei OUT)
	 not	ecx
	 and	ecx,eax		// "Unsere" Bits in DR6 löschen
	 mov	DR6,ecx
	 bsf	esi,eax		// Merken, welches Debugregister es war
/* Kontext-Retten (Win9x) Start */
	cld
	mov	eax,cs:[CurThreadPtr]
	or	eax,eax
	jz	winnt		// Unter NT alles FS-adressierbar
	mov	di,cs:[SaveDS]
	mov	eax,cs:[eax]	// Cur_Thread_Handle
	mov	ebp,esp		//CRS adressierbar machen (ab EIP -4!)
	test	byte ptr [ebp+0x2E],2	//V86-Mode?
	jz	protmode
//Opcode beschaffen; Adreßrechnung je nach V86- oder Protmode
// V86: Segmentregister sind schon auf dem Stack gerettet
	mov	bx,cs
	mov	es,bx
	movzx	ebx,word ptr [ebp+0x28]	//Real-Mode-CS
	shl	ebx,4
	add	ebx,[ebp+0x24]		//Real-Mode-Offset
	xor	ecx,ecx		// immer USE16
	jmp	fromvm
//Annahme: Zugriff im Protected Mode mit lesbarem Code-Segment
protmode:
//	mov	ebx,cs:[eax+0x14]	// Momentane Virtuelle Maschine CurVM
//	cmp	ebp,cs:[ebx+8]	// VM_ClientRegs
// Etwas sauberer ist der Test des Kodesegment-Registers auf dem Stack...
//Alternative:
	lar	ecx,[ebp+0x28]	// USE32 und DPL beschaffen
	test	ch,0x60
	jz	pm0		// Ungleich? Intra-Ring-Aufruf!
// PM3: Bei Aufruf aus Ring3 heraus die V86-Segmentregister nachbilden
	mov	[ebp+0x38],es
	mov	[ebp+0x3C],ds
	mov	[ebp+0x40],fs
	mov	[ebp+0x44],gs	// V86-kompatibel ablegen
	 les	ebx,fword ptr [ebp+0x24] //Code-Zeiger (FAR48)
// Stack-Umschaltung bei Ring-Übergang...
fromvm:
	 mov	ds,di
	 add	eax,0x4C
	 xchg	esp,[eax]	// Stack (nicht aber EBP!) umschalten
	 push	eax
	 jmp	saved
pm0:
// PM0: Keine Ring- und Stackumschaltung! Aber trotzdem Register retten!
	inc	dword ptr [ebp+0x20]	// Fehlerkode als Kennung missbrauchen
	push	ds
	push	es
	push	fs
	push	gs
	 les	ebx,fword ptr [ebp+0x24] //Code-Zeiger (FAR48)
	 mov	ds,di
saved:
	 mov	fs,[SaveFS]
	 mov	ax,es:[ebx-2]		//Opcode (AH, ggf. mit Präfix 66h)
	 mov	es,di
	 mov	gs,di
/* Kontext-Retten (Win9x) Ende */
//DevExt-Zeiger beschaffen für Rückruf
	 mov	edi,X4DR[esi*4]
//Richtung des Portzugriffs (Lesen oder Schreiben) ermitteln
	 call	HandleOutIn
/* Kontext-Wiederherstellen (Win9x) Start */
	 bt	dword ptr [ebp+0x20],0	//Ohne Ringübergang?
	 jnc	trans
	pop	gs
	pop	fs
	pop	es
	pop	ds
	jmp	nopop
trans:
	 pop	eax
	 xchg	esp,[eax]	// Stack rückschalten
	 test	byte ptr [ebp+0x2E],2	//V86-Mode?
	 jnz	nopop
	mov	gs,[ebp+0x44]
	mov	fs,[ebp+0x40]
	mov	ds,[ebp+0x3C]
	mov	es,[ebp+0x38]
nopop:
/* Kontext-Wiederherstellen (Win9x) Ende */
	popad
	add	esp,4		// "Fehlerkode" übergehen
	iretd

winnt:
	mov	[esp+0x20],esi	// als "Fehlerkode" retten
	popad			// Stack umstapeln
	push	ebp		// NT ist bekloppt: Nutzt PUSHAD nicht
	push	ebx
	push	esi
	push	edi
	push	fs
	mov	fs,cs:[SaveFS]
	push	fs:dword ptr[0]
	//mov	fs:dword ptr[0],-1
	push	0
	push	eax
	push	ecx
	push	edx
	push	ds		// Bei V86-Unterbrechung sind da nur Nullen drin
	push	es
	push	gs
	 mov	di,cs:[SaveDS]
	 sub	esp,0x30
	 mov	ds,di
	 mov	ebp,esp
	 test	byte ptr[ebp+0x72],2	// V86?
	 jz	nt1
	 lea	esi,[ebp+0x7C]	// Segmentregister umkopieren
	 lodsd
	 mov	[ebp+0x34],eax
	 lodsd
	 mov	[ebp+0x38],eax
	 lodsd
	 mov	[ebp+0x50],eax
	 lodsd
	 mov	[ebp+0x30],eax
	 mov	ax,cs
	 mov	es,ax
	 movzx	ebx,word ptr [ebp+0x6C]	//Real-Mode-CS
	 shl	ebx,4
	 add	ebx,[ebp+0x68]		//Real-Mode-Offset
	 xor	ecx,ecx
	 jmp	nt2
nt1:	// Protected Mode
	 les	ebx,[ebp+0x68]	// Client_CS_EIP
	 lar	ecx,[ebp+0x6C]	// Client_CS -> USE32-Bit
nt2:
	 mov	esi,fs:[0x124]	//TEB
	 add	esi,0x128
	 push	dword ptr[esi]	// alten Rahmenzeiger retten
	 mov	[esi],ebp	// neuen Rahmenzeiger setzen
	 mov	al,[ebp+0x6C]	//CS
	 and	al,1
	 mov	[esi+0x134-0x128],al	// Privileg setzen
	 push	esi
	 mov	esi,[ebp+0x64]
//-------------------------
	 mov	ax,es:[ebx-2]	//Opcode (ggf. mit Präfix)
	 mov	es,di
	 mov	gs,di
//DevExt-Zeiger beschaffen für Rückruf
	 mov	edi,X4DR[esi*4]
//Richtung des Portzugriffs (Lesen oder Schreiben) ermitteln
	 lea	esi,[ebp+0x44]	// Client_EAX
	 call	HandleOutIn
//-------------------------
	 pop	esi
	 pop	dword ptr[esi]		// Rahmenzeiger wiederherstellen
	 add	esp,0x30
	test	byte ptr[ebp+0x72],2	// V86?
	jz	nt3
	add	esp,12
	jmp	nt4
nt3:	pop	gs
	pop	es
	pop	ds
nt4:	pop	edx
	pop	ecx
	pop	eax
	pop	ebx		// Dummy-Lesen
	pop	fs:dword ptr[0]
	pop	fs
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	add	esp,4
	iretd
 }
}

