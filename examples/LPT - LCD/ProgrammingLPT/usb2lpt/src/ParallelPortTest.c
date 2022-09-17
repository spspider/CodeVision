#define WIN32_LEAN_AND_MEAN
#define STRICT
#define WINVER 0x0500
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>

#ifdef WIN32	// Win32 wird zurzeit mit MSVC6 übersetzt
#include <shlwapi.h>
#include <winioctl.h>
#pragma comment(linker, "/NOD /OPT:NOWIN98 /ALIGN:4096 /RELEASE")
// Compilerschalter "/GZ" entfernen!
#else		// Win16 wird zurzeit mit BC4 übersetzt
#include <dos.h>
#include <stdlib.h>
typedef char TCHAR,*PTSTR,FAR*LPTSTR,NEAR*NPTSTR;
typedef void *PVOID,FAR*LPVOID,NEAR*NPVOID;
#define TEXT(x) x
#define _stdcall _cdecl	// gleiche Parameter-Reihenfolge!
#define MAKEPOINTS MAKEPOINT
#endif

#define elemof(x) (sizeof(x)/sizeof(*(x)))
#define T(x) TEXT(x)
#define nobreak
typedef enum {false,true} bool;
typedef const TCHAR *PCTSTR;

#ifdef WIN32
int InOutMeth=3;	// 0=direkt, 1=ZLPORTIO, 2=EZUSB-0, 3=(USB2)LPT2
#endif

//static POINT Pins[25];
BYTE LptRegsRd[16];
BYTE LptRegsWr[16];

HWND hwndTT;
HANDLE hAccess=INVALID_HANDLE_VALUE;	//Direktzugriff aufs Port
UINT LptBase=0x378;

UINT Index2Addr(int a) {	// Index (0..15) in Parallelportadresse wandeln
 return LptBase+(a<8?a:a-8+0x400);
}

void outb(int a, BYTE b) {
 LptRegsWr[a]=b;	// vermerken
#ifdef WIN32
 switch (InOutMeth){
  case 0:{	// Direktzugriff (Win9x)
   a=Index2Addr(a);
   _asm{
	mov	edx,a
	mov	al,b
	out	dx,al
   }
  }break;

  case 1:{	// ZLPORTIO
   DWORD IoData[3]={Index2Addr(a),0,b};	// Byte=0, igitt!
   DWORD BytesRet;
   DeviceIoControl(hAccess,CTL_CODE(0x80FF,2,METHOD_BUFFERED,FILE_ANY_ACCESS),
     IoData,sizeof(IoData),NULL,0,&BytesRet,NULL);
  }break;

  case 2:{	// EZUSB-0
   DWORD PipeNum;
   BYTE IoData[2];
   DWORD BytesRet;
   IoData[0]=(BYTE)a;
   IoData[1]=b;
   PipeNum=0;
   DeviceIoControl(hAccess,
     CTL_CODE(FILE_DEVICE_UNKNOWN,0x814,METHOD_IN_DIRECT,FILE_ANY_ACCESS),
     &PipeNum,sizeof(PipeNum),IoData,sizeof(IoData),&BytesRet,NULL);
  }break;

  case 3:{	// LPTx
   BYTE IoData[2];
   DWORD BytesRet;
   IoData[0]=(BYTE)a;
   IoData[1]=b;
   DeviceIoControl(hAccess,
     CTL_CODE(FILE_DEVICE_UNKNOWN,0x804,METHOD_BUFFERED,FILE_ANY_ACCESS),
     IoData,sizeof(IoData),NULL,0,&BytesRet,NULL);
  }break;
 }
#else
 outportb(Index2Addr(a),b);
#endif
}

BYTE inb(int a) {
#ifdef WIN32
 switch (InOutMeth){
  case 0:{	// Direktzugriff (Win9x)
   a=Index2Addr(a);
   _asm{
	mov	edx,a
	in	al,dx
	mov	a,eax
   }
  }break;

  case 1:{	// ZLPORTIO
   DWORD IoData[3]={Index2Addr(a),0};
   DWORD BytesRet;
   DeviceIoControl(hAccess,CTL_CODE(0x80FF,1,METHOD_BUFFERED,FILE_ANY_ACCESS),
     IoData,sizeof(IoData),&IoData[2],sizeof(DWORD),&BytesRet,NULL);
   a=IoData[2];
  }break;

  case 2:{	// EZUSB-0
   DWORD PipeNum;
   BYTE IoData[1];
   DWORD BytesRet;
   IoData[0]=(BYTE)a|0x10;	// Lese-Bit
   PipeNum=0;
   DeviceIoControl(hAccess,
     CTL_CODE(FILE_DEVICE_UNKNOWN,0x814,METHOD_IN_DIRECT,FILE_ANY_ACCESS),
     &PipeNum,sizeof(PipeNum),IoData,sizeof(IoData),&BytesRet,NULL);
   PipeNum=1;
   Sleep(1);
   DeviceIoControl(hAccess,
     CTL_CODE(FILE_DEVICE_UNKNOWN,0x813,METHOD_OUT_DIRECT,FILE_ANY_ACCESS),
     &PipeNum,sizeof(PipeNum),IoData,sizeof(IoData),&BytesRet,NULL);
   a=IoData[0];
  }break;

  case 3:{	// LPTx
   BYTE IoData[1];
   DWORD BytesRet;
   IoData[0]=(BYTE)a|0x10;	// Lese-Bit
   DeviceIoControl(hAccess,
     CTL_CODE(FILE_DEVICE_UNKNOWN,0x804,METHOD_BUFFERED,FILE_ANY_ACCESS),
     IoData,sizeof(IoData),IoData,sizeof(IoData),&BytesRet,NULL);
   a=IoData[0];
  }break;
 }
 return a;
#else
 return inportb(Index2Addr(a));
#endif
}

#undef ZeroMemory

void WINAPI ZeroMemory(LPVOID p, UINT len) {
#ifdef WIN32
 _asm{	push	edi
	 mov	edi,p
	 mov	ecx,len
	 shr	ecx,2
	 xor	eax,eax
	 rep stosd
	pop	edi
 }
#else
 _asm{	push	di
	 les	di,p
	 mov	cx,len
	 shr	cx,1
	 xor	ax,ax
	 rep stosw
	pop	di
 }
#endif
}

void InitStruct(PVOID p, UINT len) {
 ZeroMemory(p,len);
 *(PDWORD)p=len;
}

static const BYTE PinAssign[25]={	// High-Nibble=Adresse, Low-Nibble=BitNr, Bit3=Inv
 0x28,0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x16,0x1F,0x15,0x14,
   0x29,0x13,0x22,0x2B,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
static const COLORREF PinColor[3]={0x00FF00,0x0000FF,0x00E0E0};
// Was für ein Zufall! WinDriver verwendet die gleichen Farben wie LptChk!

// Pin-Bezeichnungen mit Invertierungsschrägstrich - aus Sicht der Software!
static const TCHAR SppS[]=T("/BUSY (beschäftigt)\0/ACK (Bestätigung)\0PE (Papierende)\0SEL (Auswahl)\0/ERR (Fehler)\0/IRQ (Interruptanforderung)\0");		// 6 Bits
static const TCHAR SppC[]=T("STB (Strobe)\0AF (AutoFeed)\0/INI (Init, Rücksetzen)\0SELIN (Select Input, Auswahl)\0IRQEN (Interruptfreigabe)\0DIRIN (Datenrichtung: Eingabe)\0");	// 6 Bits

static const TCHAR BytS[]="PtrBusy\0PtrClk\0AckDataReq\0Xflag\0/DataAvail";	// 5 Bits
static const TCHAR BytC[]="1284Active\0/Init\0HostBusy\0HostClk";		// 4 Bits

static const TCHAR NibS[]="R3\0PtrClk\0R2\0R1\0R0";

static const TCHAR EcpS[]=T("PeriphAck\0PeriphClk\0/AckReverse\0Xflag\0/PeriphRequest\0");
static const TCHAR EcpC[]=T("HostClk\0HostAck\0/ReverseRequest\0001284Active\0");

static const TCHAR EppS[]="/Wait\0/Intr\0Spare\0Spare\0Spare\0-\0-\0Timeout\0";				// 2 Bits
static const TCHAR EppC[]="Write\0DataStb\0/Reset\0AddrStb\0";		// 4 Bits

//ECR-Modes für Kombinationsfenster
static const TCHAR EcrMode[]=T("SPP (Nibble)\0Bidirektional\0AutoStrobe\0ECP\0EPP\0reserviert\0Test\0Konfiguration\0");

struct {
 HPEN ColorPen[3];
 HBRUSH ColorBrush[3];
 HPEN WidePen;
 HPEN AirwirePen;
 HPEN NullPen;
 HFONT SmallFont;
 HFONT DescFont;
}gdi;

enum{
 SubDPosX  =50,	// Position linke obere Ecke (am wirklichen Pin 13...
 SubDPosY  =92,	// beim Blick auf die Buchsen-Löcher
 SubDSpaceX=16,	// Pin-Abstand (in Wahrheit 53 mil), muss hier gerade sein
 SubDSpaceY=16,	// Reihenabstand
 SubDPinD  =10,	// Durchmesser, muss gerade sein
 SubDRand  =12,	// Abstand zum Rand (von den Mittelpunkten der Pins)
 SubDRandW =3	// Strichbreite für Umrandung
};

static void CreateGdiResources(void) {
 int i;
 for (i=0; i<3; i++) {
  gdi.ColorPen[i]=CreatePen(PS_SOLID,0,PinColor[i]);
  gdi.ColorBrush[i]=CreateSolidBrush(PinColor[i]);
 }
 gdi.WidePen=CreatePen(PS_SOLID,SubDRandW,0);
 gdi.AirwirePen=CreatePen(PS_SOLID,0,0xFF0000L);
 gdi.NullPen=CreatePen(PS_NULL,0,0);
 gdi.SmallFont=CreateFont(-7,0,0,0,0,0,0,0,0,0,0,0,0,T("Small Fonts"));
 gdi.DescFont=CreateFont(-10,0,0,0,0,0,0,0,0,0,0,0,0,T("Helv"));
}

static void DeleteGdiResources(void) {
 int i;
 for (i=0; i<sizeof(gdi)/sizeof(HGDIOBJ); i++) {
  DeleteObject(((HGDIOBJ*)&gdi)[i]);
 }
}

void SetDlgItemHex(HWND w, UINT id, UINT v) {
 TCHAR s[12];
 wsprintf(s,T("%02X"),v);
 SetDlgItemText(w,id,s);	// Fehler in DDK windows.h: kein BOOL!
}

BOOL GetDlgItemHex(HWND w, UINT id, UINT*v) {
 TCHAR s[12];
 UINT val;
#ifdef WIN32	// Shell-Lightweight-API verwenden
 s[0]=T('0'); s[1]=T('x');	// Ohne Präfix will StrToIntEx nicht!
 if (GetDlgItemText(w,id,s+2,elemof(s)-2)
 && StrToIntEx(s,STIF_SUPPORT_HEX,&val)){
#else		// Standardbibliothek verwenden
 if (GetDlgItemText(w,id,s,elemof(s))){
  val=(UINT)strtoul(s,NULL,16);
#endif
  if (v) *v=val;
  return TRUE;
 }
 return FALSE;
}

void InflatePoint(const POINT* pt, PRECT rc, int dx, int dy) {
 rc->left=rc->right=pt->x;
 rc->top=rc->bottom=pt->y;
 InflateRect(rc,dx,dy);
}

/*================ SubD-Buchse ================*/

static void GetPinPos(BYTE pin, PPOINT pt) {	// Pins sind 0-basiert
 pt->x=SubDPosX+SubDRand+SubDSpaceX*(12-pin);
 pt->y=SubDPosY+SubDRand;
 if (pin>=13) {
  pt->x+=SubDSpaceX*25/2;
  pt->y+=SubDSpaceY;
 }
}

static void GetPinRect(BYTE pin, PRECT rc) {	// gut für Treffertest
 POINT pt;
 GetPinPos(pin,&pt);
 InflatePoint(&pt,rc,SubDPinD/2,SubDPinD/2);
}

// pin=SubD-Pin-Nummer! BorlandC verlangt ein paar überflüssige Klammern
static void DrawPin(HDC dc, BYTE pin) {
 RECT rc;
 HPEN hOldPen;
 HBRUSH hOldBrush;
 BYTE PinAss=PinAssign[pin];
 BYTE PinHigh;
 int PortIndex=(signed char)(PinAss&0xF0)>>4;

 GetPinRect(pin,&rc);
 if (PortIndex>=0) {
  hOldPen=SelectPen(dc,gdi.ColorPen[PortIndex]);
  PinHigh=LptRegsRd[PortIndex]&(1<<(PinAss&7));
  if (PinAss&8) PinHigh=!PinHigh;
  if (PinHigh) hOldBrush=SelectBrush(dc,gdi.ColorBrush[PortIndex]);
 }
 Ellipse(dc,rc.left,rc.top,rc.right,rc.bottom);
 if (PortIndex>=0) {
  SelectPen(dc,hOldPen);
  if (PinHigh) SelectBrush(dc,hOldBrush);
 }
}

static void DrawPinNumber(HDC dc, BYTE pin) {
 POINT pt;
 TCHAR nr[3];
 GetPinPos(pin,&pt);
 TextOut(dc,pt.x+2,pt.y-SubDRand+1,nr,wsprintf(nr,T("%i"),pin+1));
}

static void DrawSubD(HDC dc) {	// SubD-Buchse malen (nur Schale)
 HPEN hOld;

 static const POINT Poly[6]={
  {SubDPosX+SubDSpaceX*12+SubDRand*2,	SubDPosY},
  {SubDPosX+SubDSpaceX*12+SubDRand*2,	SubDPosY+SubDRand+SubDSpaceY/2},
  {SubDPosX+SubDSpaceX*23/2+SubDRand*2,	SubDPosY+SubDRand*2+SubDSpaceY},
  {SubDPosX+SubDSpaceX/2,		SubDPosY+SubDRand*2+SubDSpaceY},
  {SubDPosX,				SubDPosY+SubDRand+SubDSpaceY/2},
  {SubDPosX,				SubDPosY}};
 
 hOld=SelectPen(dc,gdi.WidePen);
 Polygon(dc,Poly,elemof(Poly));
 SelectPen(dc,hOld);
}

static void DrawPins(HDC dc) {	// SubD-Pins malen
 BYTE pin;
 HFONT hOld;

 hOld=SelectFont(dc,gdi.SmallFont);
 SetBkMode(dc,TRANSPARENT);
 pin=0; do{
  DrawPin(dc,pin);
  DrawPinNumber(dc,pin);
 }while (++pin<25);
 SetBkMode(dc,OPAQUE);
 SelectFont(dc,hOld);
}

#ifdef _BORLANDC_
# pragma argsused
#endif
static bool _stdcall HitTestPin(int x, int y, BYTE*ppin) {
 BYTE pin;
 for (pin=0; pin<17; pin++) {
  RECT rc;
  GetPinRect(pin,&rc);
  if (PtInRect(&rc,*((PPOINT)&x))) {
   if (ppin) *ppin=pin;
   return true;
  }
 }
 return false;
}

/*================ Bit-Kästchen ================*/

/************************************************************************
 * Mittelpunkt eines der 24 Bit-Kästchen beschaffen
 * bit = Bitadresse: aaaaibbb (aaaa=Portadresse, i=Invers, bbb=Bitnummer)
 ************************************************************************/
static void GetBitPos(BYTE bit, PPOINT ppt) {
 static const POINT bit7[3]={	// Positionen des Bit 7 (der drei Bitketten)
  {SubDPosX+SubDRand+SubDSpaceX*4,	SubDPosY-30},
  {SubDPosX+SubDSpaceX*4/2,		SubDPosY+SubDRand*2+SubDSpaceY+40},
  {SubDPosX+SubDRand+SubDSpaceX*11/2,	SubDPosY+SubDRand*2+SubDSpaceY+80}};

 *ppt=bit7[bit>>4];
 ppt->x+=(7-(bit&7))*SubDSpaceX;
}

/************************************************************************
 * Zeichenrechteck eines der 24 Bit-Kästchen beschaffen
 * bit = Bitadresse: aaaaibbb (aaaa=Portadresse, i=Invers, bbb=Bitnummer)
 ************************************************************************/
static void GetBitRect(BYTE bit, PRECT rc) {
 POINT pt;
 GetBitPos(bit,&pt);
 InflatePoint(&pt,rc,SubDSpaceX/2,SubDSpaceY/2);
}

/************************************************************************
 * Bitadresse in SubD-Pinnummer (0-basiert!) umrechnen
 * bit = Bitadresse: aaaaibbb (aaaa=Portadresse, i=Invers, bbb=Bitnummer)
 * Liefert <false> wenn Bitadresse keiner SubD-Pinnummer entspricht
 ************************************************************************/
static bool FindPin(BYTE bit, BYTE*ppin) {
 BYTE pin;
 for (pin=0; pin<25; pin++) {
  if (!((bit^PinAssign[pin])&0xF7)) {	// Wenn sich aaaa und bbb gleichen
   if (ppin) *ppin=pin;
   return true;
  }
 }
 return false;
}

/************************************************************************
 * Zeichne ein Bit-Kästchen
 * bit = Bitadresse: aaaaibbb (aaaa=Portadresse, i=Invers, bbb=Bitnummer)
 * LptRegsRd und LptRegsWr müssen die richtigen Werte bereits enthalten.
 ************************************************************************/
static void DrawBit(HDC dc, BYTE bit) {
 int PortIndex=bit>>4;
 BYTE Mask,BitHighRd,BitHighWr;
 RECT rc;
 HBRUSH hOldBrush;
 BYTE pin;

 Mask=1<<(bit&7);
 BitHighRd=LptRegsRd[PortIndex]&Mask;
 BitHighWr=LptRegsWr[PortIndex]&Mask;
 GetBitRect(bit,&rc);
 if (BitHighRd|BitHighWr) hOldBrush=SelectBrush(dc,gdi.ColorBrush[PortIndex]);
 Rectangle(dc,rc.left,rc.top,rc.right,rc.bottom);
 if (BitHighRd|BitHighWr) SelectBrush(dc,hOldBrush);
 if (BitHighRd^BitHighWr) {
  HPEN hOld=SelectPen(dc,gdi.NullPen);
  POINT pt[3];
  CopyRect((PRECT)pt,&rc);
  InflateRect((PRECT)pt,-1,-1);
  pt[2].x=pt[1].x; pt[2].y=pt[0].y;
  if (BitHighRd) pt[0].y=pt[1].y; else pt[1].x=pt[0].x;
  Polygon(dc,pt,3);	// weißes Dreieck zeichnen
  SelectPen(dc,hOld);
 }
 if (FindPin(bit,&pin)) {
  HFONT hOld;
  TCHAR Buf[3];
  int Dx=SubDSpaceX/2-1;	// Position der Ziffer (2. Zeichen)
  bit=PinAssign[pin];
  hOld=SelectFont(dc,gdi.DescFont);
  SetBkMode(dc,TRANSPARENT);
  ExtTextOut(dc,rc.left+1,rc.top+2,ETO_CLIPPED,&rc,Buf,wsprintf(Buf,T("%c%d"),
    T("DSC")[bit>>4],bit&7),&Dx);
  SetBkMode(dc,OPAQUE);
  SelectFont(dc,hOld);
  if (bit&8) {			// Invertierung?
   POINT pt[2];			// BorlandC verträgt keine nicht-konstanten
   pt[0].x=rc.left+2;		// Initialisierer (C-konform; unpraktisch)
   pt[0].y=rc.top+2;
   pt[1].x=rc.right-2;
   pt[1].y=rc.top+2;
   Polyline(dc,pt,2);		// Überstrich zeichnen
  }
 }
}

/************************************************************************
 * Zeichne alle 8 Bit-Kästchen eines Bytes
 * bit = Bitadresse: aaaa0--- (aaaa=Portadresse)
 ************************************************************************/
static void DrawByte(HDC dc, BYTE bit) {	// Bit-Felder malen
 for (; !(bit&8); bit++) {
  DrawBit(dc,bit);
 }
}

/************************************************************************
 * Zeichne alle (17) Luftlinien
 ************************************************************************/
static void DrawAirwires(HDC dc) {
 HPEN hOld;
 BYTE pin;
 hOld=SelectPen(dc,gdi.AirwirePen);
 for (pin=0; pin<17; pin++) {
  POINT pt[2];
  GetPinPos(pin,pt+0);
  GetBitPos(PinAssign[pin],pt+1);
  pt[1].y-=SubDSpaceY/2;	// oben ansetzen
  Polyline(dc,pt,2);
 }
 SelectPen(dc,hOld);
}


/************************************************************************
 * Treffertest für die 24 Bit-Kästchen
 * Liefert <true> bei Treffer und ggf. die "Bitadresse" in *pb
 ************************************************************************/
#ifdef _BORLANDC_
# pragma argsused
#endif
static bool _stdcall HitTestBit(int x, int y, BYTE*pbit) {
 BYTE bit;
 for (bit=0; bit<0x30; ) {
  RECT rc;
  GetBitRect(bit,&rc);
  if (PtInRect(&rc,*((PPOINT)&x))) {
   if (pbit) *pbit=bit;
   return true;
  }
  bit++; if (bit&8) bit+=8;	// Bit 3 (Negativ-Bit) überspringen
 }
 return false;
}

/************************************************************************
 * Knöpfe zur Datenein/Ausgabe aktivieren/deaktivieren
 * Dialogelemente füllen
 ************************************************************************/
static void SetEcrMode(HWND Wnd, int Mode){
 static const BYTE Info[8]={0x52,0x52,0x52,0xDF,0x5F,0x02,0x57,0x11};
 BYTE Inf=Info[Mode];
 HWND w;
// Info-Bits: Bit0: Eingabe-Byte sichtbar
//		1: Eingabe-Byte readonly, sonst "cfgA" und "cfgB" sichbar
//		2: Eingabe-Knopf sichtbar
//		3: Radiobuttons sichtbar
//		4: Ausgabe-Byte sichtbar
//		5: Ausgabe-Byte readonly
//		6: Ausgabe-Knopf sichtbar
//		7: Radiobutton-Ersatztext "Komm&ando" statt "&Adresse"
 SendDlgItemMessage(Wnd,102,CB_SETCURSEL,Mode,0);
 w=GetDlgItem(Wnd,168);	// Eingabe-Byte
 ShowWindow(w,Inf&0x01?SW_SHOW:SW_HIDE);
 (void)Edit_SetReadOnly(w,Inf&0x02);
 w=GetDlgItem(Wnd,131);	// Eingabe-Knopf
 ShowWindow(w,Inf&0x04?SW_SHOW:SW_HIDE);
 w=GetDlgItem(Wnd,122);	// Radioknopf "Adresse"
 ShowWindow(w,Inf&0x08?SW_SHOW:SW_HIDE);
 SetWindowText(w,Inf&0x80?T("Komm&ando"):T("&Adresse"));
 w=GetWindow(w,GW_HWNDNEXT);
 ShowWindow(w,Inf&0x08?SW_SHOW:SW_HIDE);
 w=GetDlgItem(Wnd,130);	// Ausgabe-Knopf
 ShowWindow(w,Inf&0x40?SW_SHOW:SW_HIDE);
 w=GetDlgItem(Wnd,169);	// Ausgabe-Byte
 ShowWindow(w,Inf&0x10?SW_SHOW:SW_HIDE);
 (void)Edit_SetReadOnly(w,Inf&0x20);
 w=GetDlgItem(Wnd,118);	// Text "CfgA"
 ShowWindow(w,Inf&0x02?SW_HIDE:SW_SHOW);
 w=GetDlgItem(Wnd,119);	// Text "CfgB"
 ShowWindow(w,Inf&0x02?SW_HIDE:SW_SHOW);
 switch (Mode){
  case 7:{	// Konfigurationsmodus: cfgA und cfgB lesen
   LptRegsRd[8]=inb(8);
   SetDlgItemHex(Wnd,168,LptRegsRd[8]);
   KillTimer(Wnd,168);
   LptRegsRd[9]=inb(9);
   SetDlgItemHex(Wnd,169,LptRegsRd[9]);
   KillTimer(Wnd,169);
  }break;
 }
 w=GetDlgItem(Wnd,117);		// Knopf "lesen" (für Datenport +0)
 ShowWindow(w,Mode<2||Mode==4?SW_HIDE:SW_SHOW);
}

static void OnOutputButton(HWND Wnd){
 int Mode=(int)SendDlgItemMessage(Wnd,102,CB_GETCURSEL,0,0);
 UINT u;
 BYTE b;
 HDC dc;
 if (GetDlgItemHex(Wnd,169,&u) && u<256){
  b=(BYTE)u;
  switch (Mode){
   case 0:
   case 1:{
    outb(0,b);			// Datenbyte anlegen
    outb(2,(BYTE)(LptRegsWr[2]|0x01));	// Strobe generieren
    outb(2,(BYTE)(LptRegsWr[2]&~0x01));
    goto xxx;
   }break;
   case 2:{
    outb(0,b);
    SetDlgItemHex(Wnd,160,b);
    KillTimer(Wnd,160);
   }break;	//SPP-FIFO
   case 3:	// ECP
    outb(IsDlgButtonChecked(Wnd,122)?0:8,b); break; // Kommando:0, Daten:400h
   case 4:{	// EPP
    outb(IsDlgButtonChecked(Wnd,122)?3:4,b); // Adresse:3, Daten:4
    LptRegsWr[0]=b;	// automatisch
xxx:
    dc=GetDC(Wnd);
    DrawByte(dc,0x00);
    ReleaseDC(Wnd,dc);
    SetDlgItemHex(Wnd,160,b);
    KillTimer(Wnd,160);
   }break;
   case 6: outb(8,b); break;	// Test: 400h
  }
  b++;	// ein anderes Datenbyte anbieten (ist zweckmäßig!)
  SetDlgItemHex(Wnd,169,b);
  KillTimer(Wnd,169);
 }else{
  MessageBeep(MB_ICONEXCLAMATION);
  SetFocus(GetDlgItem(Wnd,169));
 }
 Edit_SetSel(GetDlgItem(Wnd,169),0,-1);
}

static void OnInputButton(HWND Wnd){
 int Mode=(int)SendDlgItemMessage(Wnd,102,CB_GETCURSEL,0,0);
 BYTE b;
 switch (Mode){
  case 3: b=inb(IsDlgButtonChecked(Wnd,122)?0:8); break;	// ECP
  case 4: b=inb(IsDlgButtonChecked(Wnd,122)?3:4); break;	// ECP
  case 6: b=inb(8); break;
  default: return;
 }
 SetDlgItemHex(Wnd,168,b);
 KillTimer(Wnd,168);
}

static void update(HWND Wnd, int a){	// Portadresse lesen und Darstellung aktualisieren
 BYTE b=inb(a);
 if (b==LptRegsRd[a]) return;
 switch (a) {
  case 0:
  case 1:
  case 2: {
   BYTE m,bit,pin;
   HDC dc=GetDC(Wnd);
   for (m=1,bit=a<<4; m; m<<=1,bit++) {
    if ((LptRegsRd[a]^b)&m) {
     LptRegsRd[a]^=m;
     DrawBit(dc,bit);		// Bit-Kästchen aktualisieren
     if (FindPin(bit,&pin)) DrawPin(dc,pin);	// Pin-Kreis aktualisieren
    }
   }
   ReleaseDC(Wnd,dc);

   SetDlgItemHex(Wnd,176+a,b);	// Hexadezimalanzeige aktualisieren
  }break;

  case 8:	// cfgA
  case 9:{	// cfgB
   SetDlgItemHex(Wnd,160+a,b);	// Hexadezimalanzeige aktualisieren
   KillTimer(Wnd,160+a);
   LptRegsRd[a]=b;
  }break;

  case 10:{	// ECR (+402)
   if ((LptRegsRd[10]^b)&0x01) CheckDlgButton(Wnd,121,b&0x01);
   if ((LptRegsRd[10]^b)&0x02) CheckDlgButton(Wnd,120,(b>>1)&0x01);
   if ((LptRegsRd[10]^b)&0xE0) SetEcrMode(Wnd,b>>5);
   SetDlgItemHex(Wnd,176+a,b);	// Hexadezimalanzeige aktualisieren
  }nobreak;

  default: LptRegsRd[a]=b;
 }
}

// Ein zu schreibendes Bit ("Bitnummer" b) kippen
static void ToggleBit(HWND Wnd, BYTE b) {
 HDC dc=GetDC(Wnd);
 int i;
 i=b>>4;
 outb(i,(BYTE)(LptRegsWr[i]^(1<<(b&7)))); // neues Byte ausgeben
 SetDlgItemHex(Wnd,160+i,LptRegsWr[i]);	// anzeigen
 KillTimer(Wnd,160+i);			// EN_CHANGE abwürgen
 DrawBit(dc,b);				// anzeigen
 ReleaseDC(Wnd,dc);
 update(Wnd,i);				// gleiche Adresse einlesen
}

static void ToggleAt(HWND Wnd, int x, int y) {
 BYTE bit,pin;
 if (HitTestPin(x,y,&pin)) ToggleBit(Wnd,PinAssign[pin]);
 else if (HitTestBit(x,y,&bit)) ToggleBit(Wnd,bit);
}

void GetMousePos(HWND Wnd, PPOINT ppt) {
//ermittelt Mauskordinaten der letzten Nachricht
#ifdef WIN32
 DWORD dw=GetMessagePos();
 ppt->x=MAKEPOINTS(dw).x;
 ppt->y=MAKEPOINTS(dw).y;
#else
 *(PDWORD)ppt=GetMessagePos();
#endif
 ScreenToClient(Wnd,ppt);
}

static PCTSTR Index2String(PCTSTR p, int i) {
// Gegenfunktion, liefert String zum Index, NULL wenn <i> ungültig
 for (;*p;p+=lstrlen(p)+1,i--) if (!i) return p;
 return NULL;
}

static PCTSTR Index2String2(PCTSTR p1, PCTSTR p2, int i) {
//Probiere erst p1, wenn's nicht klappt, dann p2:
 PCTSTR p=Index2String(p1,i);
 if (p) return p;
 return Index2String(p2,i);
}

typedef union{		// aktueller Hit-Test (gesetzt von WM_SetCursor)
 struct{
  BYTE bit;	// 0xFF = kein Treffer
  BYTE pin;	// 0xFF = kein Treffer
 }u;
 WORD both;	// 0xFFFF = kein Treffer
}THitTest,*PHitTest;

THitTest gHitTest;	// enthält Treffertest nach WM_SetCursor

static void GetBubblehelpText(HWND Wnd, LPTSTR buf, UINT buflen) {
 int Mode;
 BYTE bit,inv=0;
 PCTSTR AltS,AltC,ps=NULL;	// Alternative Strings
 TCHAR s[8];
 buf[0]=0;
 if (gHitTest.both==0xFFFF) return;
 Mode=(int)SendDlgItemMessage(Wnd,102,CB_GETCURSEL,0,0);
 switch (Mode){
  case 2: AltS=BytS; AltC=BytC; break;	// Autostrobe
  case 3: AltS=EcpS; AltC=EcpC; break;	// ECP
  case 4: AltS=EppS; AltC=EppC; break;	// EPP
  default:AltS=SppS; AltC=SppC;
 }
 bit=gHitTest.u.bit;		// Treffer am Bit?
 if (bit==0xFF){
  bit=PinAssign[gHitTest.u.pin];// Treffer am Pin!
  inv=bit&0x08;
  bit&=0xF7;
 }
 switch (bit>>4){
  case 0:{
   wsprintf(s,T("Data %u"),bit);
   ps=s;
  }break;
  case 1:{
   ps=Index2String2(AltS,SppS,0x17-bit);// von oben
  }break;
  case 2:{
   ps=Index2String2(AltC,SppC,bit-0x20);// von unten
  }break;
 }
 if (!ps) return;
// Invertierungen am Pin umkehren
 if (inv){
  if (*ps==T('/')) ps++; // Invertierungsstrich am Signalnamen entfernen
  else if (buflen){
   *buf++=T('/');	// Invertierungsstrich hinzufügen
   buflen--;
  }
 }
 lstrcpyn(buf,ps,buflen);
}

void ReadPorts(void) {
 BYTE a;
 for (a=0; a<16; a++) LptRegsRd[a]=~(LptRegsWr[a]=inb(a));
// erst das Gegenteil einschreiben, dann updaten lassen
}

BOOL CALLBACK MainDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 switch (Msg) {
  case WM_INITDIALOG:{
   TOOLINFO ti;
   PCTSTR p;
   HWND w=GetDlgItem(Wnd,102);
   for(p=EcrMode;*p;p+=lstrlen(p)+1){
    (void)ComboBox_AddString(w,p);
   }
   outb(0,0x8F);
   ReadPorts();
   CreateGdiResources();
   InitCommonControls();
   hwndTT=CreateWindow(TOOLTIPS_CLASS, NULL,
	WS_POPUP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,
	NULL,0,0,NULL);
   InitStruct(&ti,sizeof(ti));
   ti.uFlags=TTF_TRACK|TTF_CENTERTIP;
   ti.hwnd=Wnd;
   ti.uId=(UINT)Wnd;
   ti.lpszText=LPSTR_TEXTCALLBACK;
   SendMessage(hwndTT,TTM_ADDTOOL,0,(LPARAM)&ti);
   CheckDlgButton(Wnd,122,TRUE);	//"Adresse" auswählen
   SetTimer(Wnd,1,100,NULL);
  }return TRUE;

  case WM_TIMER: switch (wParam){
   case 1:{	// zyklisches Update
    int Mode=LptRegsRd[10]>>5;
    if (Mode<2 || Mode==4) update(Wnd,0);	// im ECP-Modus kein Auslesen! (Test?)
// Im Autostrobe-Modus und im Testmodus bewirkt das Lesen von Adresse+0
// das Leeren der FIFO (am Rechner "Mixer"): undokumentiert!
// Bei Autostrobe wartet die FIFO auf BUSY=LOW
    update(Wnd,1);
    update(Wnd,2);
    if (Mode==7){	// Nur im Testmodus automatisch auslesen
     update(Wnd,8);
     update(Wnd,9);
    }
    update(Wnd,10);
   }break;
   case 160:
   case 161:
   case 162:
   case 168:
   case 169:
   case 170:{	// Editfeld geändert: automatische Byte-Ausgabe
    UINT v;
    KillTimer(Wnd,wParam);	// nicht-zyklisch!
    if (wParam==169 && (LptRegsRd[10]&0xE0)!=0xE0) {
     OnOutputButton(Wnd);	// Abzweigen zum Äquivalent des Knopfdrückens
     break;
    }
    SendDlgItemMessage(Wnd,wParam,EM_SETSEL,0,(LPARAM)-1);	// alles markieren
    if (GetDlgItemHex(Wnd,wParam,&v)){
     wParam-=160;
     if (LptRegsWr[wParam]!=v){
      outb(wParam,(BYTE)v);	// setzt LptRegsWr
      if (wParam<3){
       HDC dc=GetDC(Wnd);
       DrawByte(dc,(BYTE)(wParam<<4));
       ReleaseDC(Wnd,dc);
      }
     }
    }else MessageBeep(MB_ICONEXCLAMATION);
   }break;
  }break;

  case WM_PAINT:{
   PAINTSTRUCT PS;
   BeginPaint(Wnd,&PS);
   DrawSubD(PS.hdc);
   DrawAirwires(PS.hdc);
   DrawPins(PS.hdc);
   DrawByte(PS.hdc,0x00);
   DrawByte(PS.hdc,0x10);
   DrawByte(PS.hdc,0x20);
   EndPaint(Wnd,&PS);
  }break;

  case WM_SETCURSOR:{
   POINT pt;
   TOOLINFO ti;
   THitTest ht;
   InitStruct(&ti,sizeof(ti));
   ti.hwnd=Wnd;
   ti.uId=(UINT)Wnd;
   GetMousePos(Wnd,&pt);
   ht.both=0xFFFF;
   HitTestPin(pt.x,pt.y,&ht.u.pin);
   HitTestBit(pt.x,pt.y,&ht.u.bit);
   if (ht.both!=0xFFFF){
    SetCursor(LoadCursor(0,IDC_HAND));
    if (gHitTest.both!=ht.both){
     gHitTest=ht;
     SendMessage(hwndTT,TTM_TRACKACTIVATE,TRUE,(LPARAM)&ti);
     SendMessage(hwndTT,TTM_TRACKPOSITION,0,MAKELONG(pt.x,pt.y));
    }
    return TRUE;
   }
   if (gHitTest.both!=0xFFFF){
    gHitTest=ht;
    SendMessage(hwndTT,TTM_TRACKACTIVATE,FALSE,(LPARAM)&ti);
   }
  }break;

  case WM_LBUTTONDOWN:
  case WM_LBUTTONDBLCLK:{
   ToggleAt(Wnd,MAKEPOINTS(lParam).x,MAKEPOINTS(lParam).y);
  }break;

  case WM_NOTIFY:{
#define ttt ((LPNMTTDISPINFO)lParam)
   switch (ttt->hdr.code) {
    case TTN_GETDISPINFO: {
     GetBubblehelpText(Wnd,ttt->szText,elemof(ttt->szText));
     //ttt->lpszText=ttt->szText;
    }break;
   }
#undef ttt
  }break;

  case WM_COMMAND: switch (LOWORD(wParam)) {
   case IDCANCEL: EndDialog(Wnd,LOWORD(wParam)); break;

   case 102: switch (GET_WM_COMMAND_CMD(wParam,lParam)) {
    case CBN_SELCHANGE: {
     int Mode=ComboBox_GetCurSel((HWND)lParam);
     outb(10,(BYTE)((LptRegsWr[10]&0x1F)|(Mode<<5)));
     SetDlgItemHex(Wnd,170,LptRegsWr[10]);
     KillTimer(Wnd,170);
    }break;
   }break;

   case 117: update(Wnd,0); break;	// Knopf "Lesen" für Datenport (+0)

   case 160:
   case 161:
   case 162:
   case 168:	// Eingabe-Byte: Nur editierbar im Konfigurationsmodus (cfgA)
   case 169:	// Ausgabe-Byte oder cfgB
   case 170: switch (GET_WM_COMMAND_CMD(wParam,lParam)) {
    case EN_CHANGE: SetTimer(Wnd,LOWORD(wParam),500,NULL); break;
   }break;

   case 131: OnInputButton(Wnd); break;

   case 130: OnOutputButton(Wnd); break;
  }break;

  case WM_DESTROY:{
   DeleteGdiResources();
  }break;
 }

 return FALSE;
}

#ifdef WIN32
int WINAPI WinMainCRTStartup() {
 PCTSTR DevName=NULL;
 switch (InOutMeth){
  case 1: DevName=T("\\\\.\\ZLPORTIO"); break;	// Dienst muss gestartet werden!
  case 2: DevName=T("\\\\.\\EZUSB-0"); break;
  case 3: DevName=T("\\\\.\\LPT2"); break;
 }
 if (DevName) hAccess=CreateFile(DevName,
   GENERIC_READ|GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,0);
 DialogBox(0,MAKEINTRESOURCE(100),0,MainDlgProc);
 if (hAccess!=INVALID_HANDLE_VALUE) CloseHandle(hAccess);
 return 0;
}
#else
#pragma argsused
int PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
 return DialogBox(_DS,MAKEINTRESOURCE(100),0,MainDlgProc);
}
#endif
