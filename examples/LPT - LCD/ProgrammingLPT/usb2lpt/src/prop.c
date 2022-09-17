// Eigenschaftsseiten-Lieferant für USB2LPT im Gerätemanager
// Ressource zweisprachig deutsch/englisch
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <windowsx.h>
#include <winioctl.h>
#include <setupapi.h>
#include <shellapi.h>
#include <shlwapi.h>
#include <cfgmgr32.h>
#include <objbase.h>
#include <initguid.h>
#include "usb2lpt.h"
#pragma comment(linker,"/NOD /OPT:NOWIN98 /LARGEADDRESSAWARE /RELEASE")

typedef CONST TCHAR *PCTSTR;
typedef enum {false,true} bool;
#define nobreak

HINSTANCE hInst;
static const TCHAR HelpFileName[]="USB2LPT.HLP";

typedef struct{
 BYTE usage;		// Benutzungszähler, für 2 Dialoge
 BYTE wizard;		// Install-Wizard aktiv
 TUserCfg uc;		// Konfiguration für Treiber (3 WORDs)
 TAccessCnt ac;		// Zugriffszähler aus Treiber (6 DWORDs)
 HANDLE dev;		// Griff zum .SYS-Treiber
 HFONT bold,italic;	// Für hübscheren Dialog, fette und kursive Schrift
 HDEVINFO info;		// brauchen wir zz. nicht: SetupDi==Holzweg!
 PSP_DEVINFO_DATA sdd;
}TSetup,*PSetup;

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
 UINT ret=0;
 s[0]=T('0'); s[1]=T('x');	// Ohne Präfix will StrToIntEx nicht!
 GetWindowText(Wnd,s+2,elemof(s)-2);
 StrToIntEx(s,STIF_SUPPORT_HEX,&ret);
 return ret;
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

void WM_ContextMenu_to_WM_Help(HWND Wnd, LPARAM lParam){
 HELPINFO hi;
 hi.cbSize=sizeof(hi);
 hi.iContextType=HELPINFO_WINDOW;
 hi.MousePos.x=((PPOINTS)&lParam)->x;
 hi.MousePos.y=((PPOINTS)&lParam)->y;
 hi.hItemHandle=WindowFromPoint(hi.MousePos);
 hi.iCtrlId=GetDlgCtrlID(hi.hItemHandle);
 hi.dwContextId=GetWindowContextHelpId(hi.hItemHandle);
 SendMessage(Wnd,WM_HELP,0,(LPARAM)(LPHELPINFO)&hi);
}
/**********************************************
 * Dialogprozedur: Lese-Cache-Feineinstellung *
 **********************************************/

BOOL WINAPI ExtraDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
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

bool OpenDev(PSetup S) {
 TCHAR k[100],n[MAX_PATH];
 if (S->dev) return true;	// Ist schon offen!
 if (CM_Get_Device_ID(S->sdd->DevInst,k,elemof(k),0)!=CR_SUCCESS) return false;
 if (CM_Get_Device_Interface_List((LPGUID)&Vlpt_GUID,
   k,n,sizeof(n),0)!=CR_SUCCESS) return false;
 S->dev=CreateFile(n,GENERIC_READ|GENERIC_WRITE,
   FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,0,0);
 if (S->dev==INVALID_HANDLE_VALUE) {
  S->dev=0;	// wegen von Unix geerbter Win32-Macke!
  return false;
 }
 return true;
}

void CloseDev(PSetup S) {
 if (S->dev) CloseHandle(S->dev); S->dev=0;
}

/************************************************
 * Eigenschaftsseiten-Dialogprozedur: Emulation *
 ************************************************/

void CheckButton13(HWND Wnd, PSetup S) {
 UINT i=2;
 switch (S->uc.flags>>UCB_ReadCache0 &7) {
  case 0: i--; nobreak;// i=0
  case 7: i--;	// i=1
 }
 CheckDlgButton(Wnd,13,i);
}

BOOL WINAPI EmulDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 static const WORD DefLpt[]={0x378,0x278,0x3BC};
 PSetup S=(PSetup)GetWindowLong(Wnd,DWL_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   static const TCHAR LptStd[]=T("LPT1\0LPT2\0LPT1 anno 1985");
   static const TCHAR LptEnh[]=T("SPP\0EPP 1.9\0ECP\0ECP + EPP\0");
   PCTSTR p;
   TCHAR s[128];
   HWND w0,w2;
   int i;

   S=(PSetup)((LPPROPSHEETPAGE)lParam)->lParam;
   SetWindowLong(Wnd,DWL_USER,(LONG)S);
   ChangeFonts(Wnd);
   SetupDiGetDeviceRegistryProperty(S->info,S->sdd,SPDRP_DEVICEDESC,
     NULL,MBoxTitle,sizeof(MBoxTitle),NULL);

   if (S->wizard) {
    SendDlgItemMessage(Wnd,10,STM_SETICON,(WPARAM)LoadIcon(0,IDI_WARNING),0);
    SendDlgItemMessage(Wnd,11,STM_SETICON,(WPARAM)LoadIcon(0,IDI_INFORMATION),0);
    PropSheet_SetWizButtons(GetParent(Wnd),PSWIZB_NEXT);
   }

   w0=GetDlgItem(Wnd,100);	// Adresse
   for (p=LptStd,i=0;*p;p+=lstrlen(p)+1,i++) {
    wsprintf(s,T("%Xh (%u, %s)"),DefLpt[i],DefLpt[i],p);
    ComboBox_AddString(w0,s);
   }
   w2=GetDlgItem(Wnd,102);	// Parallelport-Erweiterung
   for (p=LptEnh;*p;p+=lstrlen(p)+1) ComboBox_AddString(w2,p);
   
   if (OpenDev(S)) {
    DWORD BytesRet;
    DeviceIoControl(S->dev,IOCTL_VLPT_UserCfg,
      &S->uc,0,&S->uc,sizeof(TUserCfg),&BytesRet,NULL);
    CloseDev(S);
   }else{	// Werte aus Registry holen, wie??
    MessageBeep(MB_ICONHAND);
   }
   for (i=0; i<3; i++) if (S->uc.LptBase==DefLpt[i]) {
    ComboBox_SetCurSel(w0,i);
    goto skip;
   }
   wsprintf(s,T("%Xh"),S->uc.LptBase);
   SetWindowText(w0,s);
skip:
   ComboBox_SetCurSel(w2,S->uc.Mode);
   if (!S->wizard) {
    SetCheckboxGroup(Wnd,10,12,S->uc.flags>>UCB_Debugreg);
    SetDlgItemInt(Wnd,101,S->uc.TimeOut,FALSE);
    SendMessage(Wnd,WM_COMMAND,12,0);
    CheckButton13(Wnd,S);
   }
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

  case WM_CONTEXTMENU: WM_ContextMenu_to_WM_Help(Wnd,lParam); break;

  case WM_HELP: {
   unsigned PopupId=0;
   switch (((LPHELPINFO)lParam)->iCtrlId) {
    case 100: PopupId=1; break;	// Adresse
    case 102: PopupId=2; break;	// Erweiterung
    case 10:
    case 11:  PopupId=3; break;	// Methode
    case 12:
    case 101:
    case 13:
    case 103: PopupId=4; break;	// PerfOpt
   }
   if (PopupId) {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXTPOPUP,PopupId);
    SetWindowLong(Wnd,DWL_MSGRESULT,1);
    return TRUE;
   }
  }break;
    	
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
     ComboBox_SetEditSel(w,0,(UINT)-1);
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
     BOOL OK;
     w=GetDlgItem(Wnd,101);
     u=GetDlgItemInt(Wnd,101,&OK,FALSE);
     if (!OK || u>1000) {
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

   case PSN_WIZNEXT: {
    ((LPNMHDR)lParam)->code=PSN_KILLACTIVE;	// Fehlende Msg nachholen??
    SendMessage(Wnd,WM_NOTIFY,wParam,lParam);
   }nobreak;

   case PSN_APPLY: {
    int i;
    for (i=0; i<elemof(DefLpt); i++) if (DefLpt[i]==S->uc.LptBase) goto setit;
    if (MBox(Wnd,16,MB_YESNO,S->uc.LptBase)!=IDYES) {
     SetWindowLong(Wnd,DWL_MSGRESULT,S->wizard?-1:PSNRET_INVALID);
     return TRUE;
    }
setit:
    if (OpenDev(S)) {
     DWORD BytesRet;
     DeviceIoControl(S->dev,IOCTL_VLPT_UserCfg,
       &S->uc,sizeof(TUserCfg),&S->uc,0,&BytesRet,NULL);
     CloseDev(S);
    }else{	// Meckern??
     MessageBeep(MB_ICONHAND);
    }break;
//SetupDiOpenDevRegKey    
//CONFIGMG_Write_Registry_Value
   }
  }
 }
 return FALSE;
}

/************************************************
 * Eigenschaftsseiten-Dialogprozedur: Statistik *
 ************************************************/

void UpdateEditArray(HWND Wnd, UINT u, UINT o, PULONG old, PULONG n) {
 for (;u<=o;u++,old++,n++) {
  if (*old!=*n) {
#ifdef WIN32
   SetDlgItemInt(Wnd,u,*n,FALSE);
#else
   TCHAR s[32];
   wsprintf(s,T("%lu"),*n);
   SetDlgItemText(Wnd,u,s);
#endif
   *old=*n;
  }
 }
}

BOOL WINAPI StatDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
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
   DWORD BytesRet;
   TAccessCnt AC;
   if (DeviceIoControl(S->dev,IOCTL_VLPT_AccessCnt,
     &AC,0,&AC,sizeof(AC),&BytesRet,NULL))
     UpdateEditArray(Wnd,100,105,(PULONG)&S->ac,(PULONG)&AC);
  }break;

  case WM_COMMAND: switch (LOWORD(wParam)) {
   case 106:
   case 107: {
    TAccessCnt AC=S->ac;
    DWORD BytesRet;
    if (LOWORD(wParam)==106) AC.out=AC.in=AC.fail=AC.steal=0;
    else AC.wpu=AC.rpu=0;
    if (!OpenDev(S)) break;
    if (!DeviceIoControl(S->dev,IOCTL_VLPT_AccessCnt,
      &AC,sizeof(AC),&AC,0,&BytesRet,NULL))
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

UINT CALLBACK PageCallbackProc(HWND junk,UINT Msg, LPPROPSHEETPAGE p) {
 PSetup S=(PSetup)p->lParam;
 if (S) switch (Msg) {
  case PSPCB_CREATE: S->usage++; break;
  case PSPCB_RELEASE: if (!(--S->usage)) {
   CloseDev(S);
   if (S->italic)DeleteFont(S->italic);
   if (S->bold)  DeleteFont(S->bold);
   LocalFree((HLOCAL)S);
   p->lParam=0;
  }
 }
 return TRUE;
}

/*************************
 * Zwei DLL-Aufrufpunkte *
 *************************/

BOOL __declspec(dllexport) CALLBACK EnumPropPages(
  PSP_PROPSHEETPAGE_REQUEST p,LPFNADDPROPSHEETPAGE AddPage, LPARAM lParam) {
 HPROPSHEETPAGE hpage;
 PSetup S=(PSetup)LocalAlloc(LPTR,sizeof(TSetup));
 PROPSHEETPAGE page={
   sizeof(PROPSHEETPAGE),
   PSP_USECALLBACK,
   hInst,		//nicht-statisch
   MAKEINTRESOURCE(100),
   0,			// Icon
   NULL,		// Titel
   EmulDlgProc,
   (LPARAM)S,		//nicht-statisch
   PageCallbackProc};

 S->info=p->DeviceInfoSet;
 S->sdd= p->DeviceInfoData;
 hpage=CreatePropertySheetPage(&page);
 if (!AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 page.pszTemplate=MAKEINTRESOURCE(101);
 page.pfnDlgProc=StatDlgProc;
 hpage=CreatePropertySheetPage(&page);
 if (!AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 return TRUE;
}

DWORD __declspec(dllexport) CALLBACK CoDeviceInstall(
  DI_FUNCTION InstallFunction,
  HDEVINFO DeviceInfoSet,
  PSP_DEVINFO_DATA DeviceInfoData,
  PCOINSTALLER_CONTEXT_DATA Context) {

#ifdef DIF_NEWDEVICEWIZARD_FINISHINSTALL
// Win98DDK hat Probleme!

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
 return NO_ERROR;
}


BOOL APIENTRY _DllMainCRTStartup(HANDLE hModule, DWORD reason, LPVOID lpReserved) {
 switch (reason) {
  case DLL_PROCESS_ATTACH: {
   hInst=(HINSTANCE)hModule;
   DisableThreadLibraryCalls(hModule);
  }
 }
 return TRUE;
}
