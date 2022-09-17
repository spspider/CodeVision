// Eigenschaftsseiten-Lieferant für USB2LPT im Gerätemanager
// Übersetzbar mit Borland C++ 3.1
#define NONAMELESSUNION
#define STRICT
//#include "wutils.h"

#include <stdlib.h>	// strtoul
#include <string.h>	// _fmemcmp
#include <windows.h>
#include <windowsx.h>	// Message Cracker
#include <shellapi.h>
#include <setupx.h>
#include <prsht.h>
#include <compobj.h>	// EXTERN_C, benötigt _fmemcmp
#include <initguid.h>	// DEFINE_GUID, benötigt EXTERN_C

#include "usb2lpt.h"
#include <varargs.h>
#include "thunk16.h"

#define CTL_CODE(DeviceType,Function,Method,Access) \
  (((DWORD)(DeviceType)<<16)|((Access)<<14)|((Function)<<2)|(Method))

#define FILE_DEVICE_UNKNOWN	0x22
#define METHOD_BUFFERED		0
//#define METHOD_IN_DIRECT	1
//#define METHOD_OUT_DIRECT	2
//#define METHOD_NEITHER		3
#define FILE_ANY_ACCESS		0

typedef char TCHAR;
typedef unsigned long ULONG,FAR*LPULONG,NEAR*NPULONG,*PULONG;
typedef UINT *PUINT,NEAR*NPUINT,FAR*LPUINT;
typedef const TCHAR *PCTSTR,NEAR*NPCTSTR,FAR*LPCTSTR;
#define TEXT(x) x
#define nobreak
typedef enum {false,true} bool;


#define hInst (HINSTANCE)_DS

typedef struct{
 BYTE usage;		// Benutzungszähler, für 2 Dialoge
 BYTE wizard;		// Install-Wizard aktiv
 TUserCfg uc;		// Konfiguration für Treiber (3 WORDs)
 TAccessCnt ac;		// Zugriffszähler aus Treiber (6 DWORDs)
 DWORD kernel32;	// Geladene 32-bit-DLL
 DWORD dev;		// Griff zum .SYS-Treiber
 HFONT bold,italic;	// Für hübscheren Dialog, fette und kursive Schrift
 LPDEVICE_INFO info;	// brauchen wir zz. nicht: SetupDi==Holzweg!
}TSetup,*PSetup,FAR*LPSetup,NEAR*NPSetup;


TCHAR MBoxTitle[64];

/*********************************************
 * Hilfsfunktionen, vornehmlich aus WUTILS.C *
 *********************************************/

int vMBox(HWND Wnd, UINT id, UINT style, va_list arglist) {
 TCHAR buf1[256],buf2[256];
 LoadString(hInst,id,buf1,elemof(buf1));
 wvsprintf(buf2,buf1,arglist);
 return MessageBox(Wnd,buf2,MBoxTitle,style);
}

int _cdecl MBox(HWND Wnd, UINT id, UINT style,...) {
 return vMBox(Wnd,id,style,(va_list)(&style+1));
}

UINT GetComboHex(HWND Wnd) {	// Liefert Hex-Wert oder 0 bei Fehler
 TCHAR s[20];
 GetWindowText(Wnd,s,elemof(s));
 return (UINT)strtol(s,NULL,16);
}

UINT GetCheckboxGroup(HWND Wnd, UINT u, UINT o) {
 UINT v,m;
 for (v=0,m=1; u<=o; u++,m+=m) if (IsDlgButtonChecked(Wnd,u)==1) v|=m;
 return v;
}

void SetCheckboxGroup(HWND Wnd, UINT u, UINT o, UINT v) {
 for (; u<=o; u++,v>>=1) CheckDlgButton(Wnd,u,v&1);
}

void ChangeFonts(HWND w) {
/* Macht alle eingeklammerten () statischen Texte kursiv und
 * Überschriften von Gruppenfenstern fett; der besseren Übersicht wegen.
 * Fonts werden neu erzeugt, wenn die entspr. Felder in TSetup NULL sind.
 * Diese beiden Fonts müssen beim Beenden freigegeben werden!
 */
 HFONT normal;
 LOGFONT font;
 PSetup S=(PSetup)GetWindowLong(w,DWL_USER);

 normal=GetWindowFont(w);
 if (!S->italic) {
  GetObject(normal,sizeof(font),&font);
  font.lfItalic=TRUE;
  S->italic=CreateFontIndirect(&font);
 }
 if (!S->bold) {
  GetObject(normal,sizeof(font),&font);
  font.lfWeight=700;
  S->bold=CreateFontIndirect(&font);
 }
 for (w=GetWindow(w,GW_CHILD);w;w=GetNextSibling(w)) {
  TCHAR s[2],cl[10];		// reicht für das erste Zeichen
  GetClassName(w,cl,elemof(cl));
  if (!lstrcmpi(cl,T("STATIC"))) {
   GetWindowText(w,s,elemof(s));
   if (s[0]=='(') SetWindowFont(w,S->italic,TRUE);
  }
  if (!lstrcmpi(cl,T("BUTTON"))) {
   if ((GetWindowStyle(w)&0x0F) == BS_GROUPBOX)
     SetWindowFont(w,S->bold,TRUE);
  }
 }
}

/**********************************************
 * Dialogprozedur: Lese-Cache-Feineinstellung *
 **********************************************/

BOOL CALLBACK _loadds ExtraDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 PSetup S=(PSetup)GetWindowLong(Wnd,DWL_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   S=(PSetup)lParam;
   SetWindowLong(Wnd,DWL_USER,lParam);
   SetCheckboxGroup(Wnd,20,22,S->uc.flags>>UCB_ReadCache0);
  }return TRUE;

  case WM_COMMAND: switch (LOWORD(wParam)) {
   case IDOK: {
    S->uc.flags&=~(7<<UCB_ReadCache0);
    S->uc.flags|=GetCheckboxGroup(Wnd,20,22)<<UCB_ReadCache0;
   }nobreak;
   case IDCANCEL: EndDialog(Wnd,wParam);
  }
 }
 return FALSE;
}

//SetupDiOpenDevRegKey
//CONFIGMG_Write_Registry_Value

bool OpenDev(PSetup S) {
 TCHAR k[200],n[MAX_PATH];
 DWORD lpCreateFile,cfgmgr32,lpGetDevID,lpGetDevIF;
 bool ok;
 if (S->dev) return true;	// Ist schon offen!
 cfgmgr32=LoadLibraryEx32W("cfgmgr32.dll",0,0);
 if (!cfgmgr32) return false;
 ok=(bool)(lpGetDevID=GetProcAddress32W(cfgmgr32,"CM_Get_Device_IDA"))
 && (bool)(lpGetDevIF=GetProcAddress32W(cfgmgr32,"CM_Get_Device_Interface_ListA"))
 && !CallProcEx32W(4,2,lpGetDevID,S->info->dnDevnode,(LPSTR)k,(DWORD)sizeof(k),0L)
 && !CallProcEx32W(5,7,lpGetDevIF,(LPGUID)&Vlpt_GUID,(LPSTR)k,(LPSTR)n,(DWORD)sizeof(n),0L);
 FreeLibrary32W(cfgmgr32);
 if (!ok) return false;

 S->kernel32=LoadLibraryEx32W("kernel32.dll",0,0);
 if (!S->kernel32) return false;
 lpCreateFile=GetProcAddress32W(S->kernel32,"CreateFileA");
 if (!lpCreateFile) return false;
 S->dev=CallProcEx32W(7,1,lpCreateFile,
   (LPSTR)n,0xC0000000L,0L,(DWORD)NULL,3L/*OPEN_EXISTING*/,0L,0L);
 if (S->dev==(DWORD)-1) {
  S->dev=0;	// wegen von Unix geerbter Win32-Macke!
  return false;
 }
 return true;
}

long DevIoctl(PSetup S,DWORD code,LPVOID p1,long l1,LPVOID p2,long l2) {
 long ret=-1;
 if (S->dev) {
  DWORD lpDeviceIoControl=GetProcAddress32W(S->kernel32,"DeviceIoControl");
  if (lpDeviceIoControl) CallProcEx32W(8,0x54,lpDeviceIoControl,
    S->dev,code,p1,l1,p2,l2,(LPVOID)&ret,0L);
 }
 return ret;
}

void CloseDev(PSetup S) {
 if (S->kernel32 && S->dev) {
  DWORD lpCloseHandle=GetProcAddress32W(S->kernel32,"CloseHandle");
  if (lpCloseHandle) CallProcEx32W(1,0,lpCloseHandle,S->dev);
  S->dev=0;
 }
 if (S->kernel32) FreeLibrary32W(S->kernel32);
 S->kernel32=0;
}

/************************************************
 * Eigenschaftsseiten-Dialogprozedur: Emulation *
 ************************************************/

void CheckButton13(HWND Wnd, PSetup S) {
 UINT i=2;
 switch ((S->uc.flags>>UCB_ReadCache0) &7) {
  case 0: i--; nobreak;// i=0
  case 7: i--;	// i=1
 }
 CheckDlgButton(Wnd,13,i);
}

BOOL CALLBACK _loadds EmulDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 static const WORD DefLpt[]={0x378,0x278,0x3BC};
 PSetup S=(PSetup)GetWindowLong(Wnd,DWL_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   static const TCHAR LptStd[]=T("LPT1\0LPT2\0LPT1 anno 1985\0");
   static const TCHAR LptEnh[]=T("SPP\0EPP 1.9\0ECP\0ECP + EPP\0");
   PCTSTR p;
   TCHAR s[32];
   HWND w0,w2;
   int i;

   S=(PSetup)((LPPROPSHEETPAGE)lParam)->lParam;
   SetWindowLong(Wnd,DWL_USER,(LONG)S);
   ChangeFonts(Wnd);
   w0=GetDlgItem(Wnd,100);	// Adresse
   for (p=LptStd,i=0;*p;p+=lstrlen(p)+1,i++) {
    wsprintf(s,T("%Xh (%u, %s)"),DefLpt[i],DefLpt[i],(LPCSTR)p);
    (void)ComboBox_AddString(w0,s);
   }
   w2=GetDlgItem(Wnd,102);	// Parallelport-Erweiterung
   for (p=LptEnh;*p;p+=lstrlen(p)+1) (void)ComboBox_AddString(w2,p);

   if (OpenDev(S)) {
    DevIoctl(S,IOCTL_VLPT_UserCfg,&S->uc,0,&S->uc,sizeof(TUserCfg));
    CloseDev(S);
   }else{	// Werte aus Registry holen, wie??
    MessageBeep(MB_ICONHAND);
   }
   for (i=0; i<3; i++) if (S->uc.LptBase==DefLpt[i]) {
    (void)ComboBox_SetCurSel(w0,i);
    goto skip;
   }
   wsprintf(s,T("%Xh"),S->uc.LptBase);
   SetWindowText(w0,s);
skip:
   (void)ComboBox_SetCurSel(w2,S->uc.Mode);
   SetCheckboxGroup(Wnd,10,12,S->uc.flags>>UCB_Debugreg);
   SetDlgItemInt(Wnd,101,S->uc.TimeOut,FALSE);
   SendMessage(Wnd,WM_COMMAND,12,0);
   CheckButton13(Wnd,S);
/*
   DWORD length=sizeof(s);
   HKEY key;
   key=SetupDiOpenDevRegKey(stuff->info,stuff->sdd,DICS_FLAG_GLOBAL,0,DIREG_DEV,KEY_READ);
   if (key) {
    if (!RegQueryValueEx(key,T("Portadresse"),NULL,NULL,(LPBYTE)s,&length)) {
     MessageBeep(0);
     DoEnvironmentSubst(s,sizeof(s));
    }
    RegCloseKey(key);
   }				// get sample info URL
*/
  }return TRUE;
    	
  case WM_COMMAND: switch (LOWORD(wParam)) {
   case 12: EnableWindow(GetDlgItem(Wnd,101),IsDlgButtonChecked(Wnd,12)); break;
   case 13: switch (IsDlgButtonChecked(Wnd,13)) {
    case 2: CheckDlgButton(Wnd,13,0); nobreak;	// 3. Zustand nicht klickbar!
    case 0: S->uc.flags&=~(7<<UCB_ReadCache0); break;	// Alles aus
    case 1: S->uc.flags|=7<<UCB_ReadCache0; break;	// Alles an
   }break;
   case 103: if (DialogBoxParam(hInst,MAKEINTRESOURCE(102),Wnd,ExtraDlgProc,
     (LPARAM)S)==IDOK) CheckButton13(Wnd,S); break;
  }break;

  case WM_NOTIFY: switch (((LPNMHDR)lParam)->code){
   case PSN_KILLACTIVE: {	// Überprüfung der Eingabefelder!
    HWND w;
    UINT u;
    BOOL Ok;
    //---
    w=GetDlgItem(Wnd,100);
    u=GetComboHex(w);
    if (!u) {
     MBox(Wnd,17,MB_OK|MB_ICONEXCLAMATION);
     goto f1;
    }
    if (u<0x100 || u&3 || u>>16	// gewöhnliche Fehler
    || u==0x1E0 || u==0x1E4 || u==0x1F0 || u==0x1F4 || u==0x3E4 || u==0x3F4) {
     MBox(Wnd,18,MB_OK|MB_ICONEXCLAMATION);
f1:  SetFocus(w);	// Festplattenports vor DAU schützen!!
     (void)ComboBox_SetEditSel(w,0,(UINT)-1);
     goto fail;
    }
    S->uc.LptBase=(WORD)u;
    //---
    w=GetDlgItem(Wnd,102);
    u=ComboBox_GetCurSel(w);
    if (u&1 && S->uc.LptBase&7)	{// EPP geht nur mit durch 8 teilbaren Adressen!
     MBox(Wnd,19,MB_OK|MB_ICONEXCLAMATION);
     SetFocus(w);
     goto fail;
    }
    S->uc.Mode=(BYTE)u;
    //---
    if (!S->wizard) {
     w=GetDlgItem(Wnd,101);
     u=GetDlgItemInt(Wnd,101,&Ok,FALSE);
     if (!Ok || u>1000) {
      MBox(Wnd,20,MB_OK|MB_ICONEXCLAMATION);
      SetFocus(w);
      Edit_SetSel(w,0,(UINT)-1);
      goto fail;
     }
     S->uc.TimeOut=(WORD)u;
    //---
     S->uc.flags&=~(7<<UCB_Debugreg);
     S->uc.flags|=GetCheckboxGroup(Wnd,10,12)<<UCB_Debugreg;
    }
    break;
fail: SetWindowLong(Wnd,DWL_MSGRESULT,1);	// Fokus nicht entfernen!
   }return TRUE;

   case PSN_APPLY: {
    int i;
    for (i=0; i<elemof(DefLpt); i++) if (DefLpt[i]==S->uc.LptBase) goto setit;
    if (MBox(Wnd,16,MB_YESNO,S->uc.LptBase)!=IDYES) {
     SetWindowLong(Wnd,DWL_MSGRESULT,PSNRET_INVALID);
     return TRUE;
    }
setit:
    if (OpenDev(S)) {
     DevIoctl(S,IOCTL_VLPT_UserCfg,&S->uc,sizeof(TUserCfg),&S->uc,0);
     CloseDev(S);
    }else{	// Meckern??
     MessageBeep(MB_ICONHAND);
    }break;
   }
  }
 }
 return FALSE;
}

void UpdateEditArray(HWND Wnd, UINT u, UINT o, ULONG*old, ULONG _ss*n) {
 for (;u<=o;u++,old++,n++) {
  if (*old!=*n) {
   char s[32];
   wsprintf(s,T("%lu"),(*old=*n));
   SetDlgItemText(Wnd,u,s);
  }
 }
}

BOOL CALLBACK _loadds StatDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 PSetup S=(PSetup)GetWindowLong(Wnd,DWL_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   S=(PSetup)((LPPROPSHEETPAGE)lParam)->lParam;
   SetWindowLong(Wnd,DWL_USER,(LONG)S);
   ChangeFonts(Wnd);
   S->ac.out=S->ac.in=S->ac.fail=S->ac.steal=S->ac.wpu=S->ac.rpu=(ULONG)-1;
   SendMessage(Wnd,WM_TIMER,0,0);
  }return TRUE;

  case WM_TIMER: if (OpenDev(S)) {	// bleibt normalerweise geöffnet
   TAccessCnt AC;
   if (DevIoctl(S,IOCTL_VLPT_AccessCnt,&AC,0,&AC,sizeof(AC))!=-1)
     UpdateEditArray(Wnd,100,105,&S->ac.out,&AC.out);
  }break;

  case WM_COMMAND: switch (LOWORD(wParam)) {
   case 106: S->ac.out=S->ac.in=S->ac.fail=S->ac.steal=0; goto weiter;
   case 107: S->ac.wpu=S->ac.rpu=0; weiter: {
    if (!OpenDev(S)) break;
    if (DevIoctl(S,IOCTL_VLPT_AccessCnt,&S->ac,sizeof(S->ac),&S->ac,0)==1)
      MessageBeep(MB_ICONEXCLAMATION);
   }
  }break;

  case WM_NOTIFY: switch (((LPNMHDR)lParam)->code){
   case PSN_SETACTIVE: {
    SetTimer(Wnd,100,500,NULL);
   }break;
   case PSN_KILLACTIVE: {
    KillTimer(Wnd,100);
    CloseDev(S);
   }break;
  }break;
 }
 return FALSE;
}

#pragma argsused
UINT CALLBACK _loadds PageCallbackProc(HWND Wnd, UINT Msg, LPPROPSHEETPAGE p) {
 PSetup S=(PSetup)p->lParam;
 if (S) switch (Msg) {
  case PSPCB_CREATE: S->usage++; break;
  case PSPCB_RELEASE: if (!(--S->usage)) {
   CloseDev(S);
   if (S->italic)DeleteFont(S->italic);
   if (S->bold)  DeleteFont(S->bold);
   LocalFree((HLOCAL)S);
//   free(S);
   p->lParam=0;
  }
 }
 return TRUE;
}

UINT InitStruct(void far*buf, unsigned len) {
 _fmemset(buf,0,len);
 *(unsigned far*)buf=len;
 return 0;
}

EXTERN_C BOOL CALLBACK _loadds EnumPropPages(LPDEVICE_INFO lpdi,
  LPFNADDPROPSHEETPAGE AddPage, LPARAM lParam) {
 HPROPSHEETPAGE hpage;
 NPSetup S;
// PSetup S=new TSetup;
 PROPSHEETPAGE page;
// _asm int 3;
 S=(PSetup)LocalAlloc(LPTR,sizeof(TSetup));
// Ohne HEAPSIZE in der prop16.def hängt LocalAlloc den Prozess auf!
// S=(PSetup)malloc(sizeof(TSetup));
 InitStruct(&page,sizeof(page));
 LOWORD(page.dwFlags)=PSP_USECALLBACK;
 page.hInstance=hInst;
 LOWORD(page.DUMMYUNIONNAME.pszTemplate)=100;
 page.pfnDlgProc=EmulDlgProc;
 page.lParam=(LPARAM)S;
 page.pfnCallback=PageCallbackProc;
 S->info=lpdi;
 lstrcpy(MBoxTitle,lpdi->szDescription);
 hpage=CreatePropertySheetPage(&page);
 if (!AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 page.DUMMYUNIONNAME.pszTemplate++;
 page.pfnDlgProc=StatDlgProc;
 hpage=CreatePropertySheetPage(&page);
 if (!AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 return TRUE;
}

#pragma argsused
EXTERN_C DWORD CALLBACK _loadds CoDeviceInstall(
  UINT InstallFunction,
  LPDEVICE_INFO DeviceInfoData,
  /*PCOINSTALLER_CONTEXT_DATA*/long Context) {
 _asm int 3;
#if 0
 switch (InstallFunction) {
  case DIF_NEWDEVICEWIZARD_FINISHINSTALL: {
   SP_NEWDEVICEWIZARD_DATA NDWD;
   PSetup S=(PSetup)LocalAlloc(LPTR,sizeof(TSetup));
   PROPSHEETPAGE page={
    sizeof(PROPSHEETPAGE),
    PSP_USECALLBACK|PSP_USEHEADERTITLE|PSP_USEHEADERSUBTITLE,
    hInst,		//nicht-statisch
    MAKEINTRESOURCE(103),
    0,			// Icon
    NULL,		// Titel
    EmulDlgProc,
    (LPARAM)S,		//nicht-statisch
    PageCallbackProc,
    NULL,		//pcRefParent
    MAKEINTRESOURCE(21),// erfordert (irgendwo) ein #define _WIN32_IE 0x0500
    MAKEINTRESOURCE(22)};

   S->wizard=TRUE;
   S->info=DeviceInfoSet;
   S->sdd= DeviceInfoData;
   NDWD.ClassInstallHeader.cbSize=sizeof(SP_CLASSINSTALL_HEADER);
   NDWD.ClassInstallHeader.InstallFunction=DIF_ADDPROPERTYPAGE_ADVANCED;
   if (SetupDiGetClassInstallParams(DeviceInfoSet,DeviceInfoData,
     &NDWD.ClassInstallHeader,sizeof(NDWD),NULL)
   && NDWD.NumDynamicPages < MAX_INSTALLWIZARD_DYNAPAGES) {
    NDWD.DynamicPages[NDWD.NumDynamicPages++]=
      CreatePropertySheetPage(&page);
    SetupDiSetClassInstallParams(DeviceInfoSet,DeviceInfoData,
      &NDWD.ClassInstallHeader,sizeof(NDWD));
   }else{
    MessageBeep(MB_ICONEXCLAMATION);
    LocalFree(S);
   }
  }break;
 }
#endif
 return 0/*NO_ERROR*/;
}

#pragma argsused
EXTERN_C int CALLBACK LibMain(HANDLE hModule, WORD wDataSeg,
  WORD cbHeapSize, LPSTR lpszCmdLine) {
 return TRUE;
}
