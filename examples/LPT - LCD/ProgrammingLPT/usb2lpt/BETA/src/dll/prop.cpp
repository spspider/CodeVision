// Eigenschaftsseiten-Lieferant für USB2LPT im Gerätemanager
// Ressource mehrsprachig, einfach erweiterbar
// Übersetzbar 16bit BorlandC3.1 für Win98/Me
//       sowie 32bit (MSVC6)     für Win2k/XP
#define INITGUID	// hier GUID speichern
#include "prop.h"

const TCHAR HelpFileName[]=T("USB2LPT.HLP");
TCHAR MBoxTitle[64];

/*******************************************
 * Unterschiedliche Funktionen Win16/Win32 *
 *******************************************/

#ifdef WIN32
HINSTANCE hInst;
HANDLE hActCtx;	// „Aktivierungskontext“, das Ding mit der Teletubbie-Optik
// Das Benutzen von #define ISOLATION_AWARE_ENABLED 1 führt zu einer
// Unmenge wirren Kodes, u.a. wird UNICOWS.DLL und die Laufzeitbibliothek bemüht!
// (Aber Teletubbie-Optik gibts doch gar nicht unter 98/Me!)
// Nach vielen Stunden mühsamer Wurstelei mit den (absichtlich kryptischen!)
// Kopfdateien von Winzigweich wurde das wirklich Notwendige herausgepopelt;
// das ist dann erfreulich wenig Kode.
// Leider lädt Win32 eine DLL gar nicht erst, wenn Referenzen nicht vorhanden sind.
// Wie schön war's da bei Win16, als man mit UndefDynLink() vergleichen konnte …
// Also doch das langweilige GetProcAddress() bemühen, damit's unter W2k läuft.
BOOL (WINAPI*pQueryActCtxW)(DWORD,HANDLE,PVOID,ULONG,PVOID,SIZE_T,SIZE_T*);
BOOL (WINAPI*pReleaseActCtx)(HANDLE);

EXTERN_C BOOL APIENTRY _DllMainCRTStartup(HMODULE hModule, DWORD reason, LPVOID lpReserved) {
 switch (reason) {
  case DLL_PROCESS_ATTACH: {
   ACTIVATION_CONTEXT_BASIC_INFORMATION actCtxBasicInfo;
   hInst=(HINSTANCE)hModule;
   DisableThreadLibraryCalls(hModule);
   InitCommonControls();
#ifdef _WIN64
# define pQueryActCtxW QueryActCtxW	// Teletubbieoptik gibt es bei Win64 immer
# define pReleaseActCtx ReleaseActCtx
#else
   HMODULE hKernel=GetModuleHandle(T("KERNEL32.dll"));
   *(FARPROC*)&pQueryActCtxW =GetProcAddress(hKernel,"QueryActCtxW");
   *(FARPROC*)&pReleaseActCtx=GetProcAddress(hKernel,"ReleaseActCtx");
   if (pQueryActCtxW)			// Windows 2000 hat diese Funktionen nicht
#endif
   {
    if (pQueryActCtxW(
      QUERY_ACTCTX_FLAG_ACTCTX_IS_ADDRESS|QUERY_ACTCTX_FLAG_NO_ADDREF,
      &hActCtx,
      NULL,
      ActivationContextBasicInformation,
      &actCtxBasicInfo,
      sizeof(actCtxBasicInfo),
      NULL)
    && actCtxBasicInfo.hActCtx!=INVALID_HANDLE_VALUE)
      hActCtx=actCtxBasicInfo.hActCtx;
   }
  }break;
  case DLL_PROCESS_DETACH: {
   if (hActCtx) pReleaseActCtx(hActCtx);
  }break;
 }
 return TRUE;
}

static void SetMBoxTitle(PSetup S) {
 SetupDiGetDeviceRegistryProperty(S->info,S->sdd,SPDRP_DEVICEDESC,
   NULL,(PBYTE)MBoxTitle,sizeof(MBoxTitle),NULL);
}
// Das Setzen von MBoxTitle wird bei Win16 von EnumPropPages() erledigt
#endif

#ifdef _IDE_	// BC3.1 IDE kann nicht ohne Standardbibliothek!
EXTERN_C int CALLBACK LibMain(HANDLE hModule, WORD wDataSeg,
  WORD cbHeapSize, LPSTR lpszCmdLine) {
 return TRUE;
}
#endif


/*********************************************
 * Hilfsfunktionen, vornehmlich aus WUTILS.C *
 *********************************************/

// MB_HELP erfordert in Gerätemanager-Eigenschaftsseiten besondere Behandlung.
// Die Nachricht WM_HELP kommt beim Container-Fenster an, da muss ein temporärer Hook her.
static struct WMHELPHANDLER{
 WNDPROC oldproc;
 UINT helpid;
 static LONG_PTR CALLBACK hook(HWND,UINT,WPARAM,LPARAM);
}WmHelpHandler;

LONG_PTR CALLBACK _loadds WMHELPHANDLER::hook(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 switch (Msg) {
  case WM_HELP: {	// einzige Quelle hier ist die MessageBox!
   WinHelp(Wnd,HelpFileName,HELP_CONTEXT,WmHelpHandler.helpid);
   SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);
  }return TRUE;
 }
 return CallWindowProc(WmHelpHandler.oldproc,Wnd,Msg,wParam,lParam);
}

int vMBox(HWND Wnd, UINT id, UINT style, va_list arglist) {
 TCHAR buf1[256],buf2[256];
 LoadString(hInst,id,buf1,elemof(buf1));
 wvsprintf(buf2,buf1,arglist);
 HWND Handler=Wnd;
 if (style&MB_HELP) {
  while (GetWindowStyle(Handler)&WS_CHILD) Handler=GetParent(Handler);
  WmHelpHandler.oldproc=SubclassWindow(Handler,WMHELPHANDLER::hook);
  WmHelpHandler.helpid=id;
 }
 int ret=MessageBox(Wnd,buf2,MBoxTitle,style);
 if (style&MB_HELP) SubclassWindow(Handler,WmHelpHandler.oldproc);
 return ret;
}

int _cdecl MBox(HWND Wnd, UINT id, UINT style,...) {
 return vMBox(Wnd,id,style,(va_list)(&style+1));
}

// Hexzahl eingeben; ASCII-Zeicheneingabe mittels vorangestelltem "'" (Apostroph)
// wie KC85: %MODIFY, oder auch "-"
bool GetDlgItemHex(HWND w, UINT id, UINT _ss* v) {
 UINT val;
 TCHAR s[12];
#ifdef WIN32	// Shell-Lightweight-API verwenden
 if (!GetDlgItemText(w,id,s+2,elemof(s)-2)) return false;
 if ((unsigned)(s[2]-'!')<'0'-'!') {
  val=(BYTE)s[3];	// Unicode: Nur ISO-Latin-1 nehmen
  if (!val) return false;
 }else{
  s[0]='0';	// Ohne Präfix will StrToIntEx nicht!
  s[1]='x';
  if (!StrToIntEx(s,STIF_SUPPORT_HEX,(int*)&val)) return false;
 }
#else		// Standardbibliothek verwenden
 if (!GetDlgItemText(w,id,s,elemof(s))) return false;
 if ((unsigned)(s[0]-'!')<'0'-'!') {
  val=(BYTE)s[1];
  if (!val) return false;
 }else{
  TCHAR _ss*e;
  val=(UINT)ss_strtoul(s,&e,16);	// Standardfunktion mit _ss-Zugriff
  if (*e) return false;		// falsches Zeichen
 }
#endif
 if (v) *v=val;
 return true;
}

static UINT GetCheckboxGroup(HWND Wnd, UINT u, UINT o) {
 UINT v,m;
 for (v=0,m=1; u<=o; u++,m+=m) if (IsDlgButtonChecked(Wnd,u)==1) v|=m;
 return v;
}

static void SetCheckboxGroup(HWND Wnd, UINT u, UINT o, UINT v) {
 for (; u<=o; u++,v>>=1) CheckDlgButton(Wnd,u,v&1);
}

static void ShowChilds(HWND Wnd, UINT num, int nShow) {
 if (num) do{
  if (!Wnd) break;
  ShowWindow(Wnd,nShow);
  Wnd=GetNextSibling(Wnd);
 }while (--num);
}

extern void ChangeFonts(HWND w, PSetup S) {
/* Macht alle eingeklammerten () statischen Texte kursiv und
 * Überschriften von Gruppenfenstern fett; der besseren Übersicht wegen.
 * Fonts werden neu erzeugt, wenn die entspr. Felder in TSetup NULL sind.
 * Diese beiden Fonts müssen beim Beenden freigegeben werden!
 */
 HFONT normal;
 LOGFONT font;

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
 HMENU m;
 TCHAR s[32];
 hi.MousePos.x=GET_X_LPARAM(lParam);
 hi.MousePos.y=GET_Y_LPARAM(lParam);
 hi.hItemHandle=WindowFromPoint(hi.MousePos);
 if (!hi.hItemHandle) return;
 m=CreatePopupMenu();
 LoadString(hInst,25/*Direkthilfe*/,s,elemof(s));
 AppendMenu(m,MF_STRING,9,s);
 if (TrackPopupMenu(m,
   TPM_LEFTALIGN|TPM_TOPALIGN|TPM_RETURNCMD|TPM_NONOTIFY|TPM_RIGHTBUTTON|TPM_HORPOSANIMATION,
   hi.MousePos.x,hi.MousePos.y,0,Wnd,NULL)) {
  hi.cbSize=sizeof(hi);
  hi.iContextType=HELPINFO_WINDOW;
  hi.iCtrlId=GetDlgCtrlID((HWND)hi.hItemHandle);
#ifdef WIN32
  hi.dwContextId=GetWindowContextHelpId((HWND)hi.hItemHandle);
#endif
  SendMessage(Wnd,WM_HELP,0,(LPARAM)(LPHELPINFO)&hi);
 }
 DestroyMenu(m);
}

/**********************************************
 * Dialogprozedur: Lese-Cache-Feineinstellung *
 **********************************************/

static INT_PTR CALLBACK _loadds ExtraDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 PSetup S=(PSetup)GetWindowPtr(Wnd,DWLP_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   S=(PSetup)lParam;
   SetWindowPtr(Wnd,DWLP_USER,S);
   SetCheckboxGroup(Wnd,20,22,S->uc.flags>>UCB_ReadCache0);
  }return TRUE;

  case WM_COMMAND: switch (wParam) {	// hier nur Buttons, kein LOWORD
   case IDOK: {
    S->uc.flags&=~(7<<UCB_ReadCache0);
    S->uc.flags|=GetCheckboxGroup(Wnd,20,22)<<UCB_ReadCache0;
   }nobreak;
   case IDCANCEL: EndDialog(Wnd,wParam);
  }break;

  case WM_CONTEXTMENU: WM_ContextMenu_to_WM_Help(Wnd,lParam); break;

  case WM_HELP: {
   int id=((LPHELPINFO)lParam)->iCtrlId;
   if (id) {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXTPOPUP,MAKELONG(id,102));
    SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);
    return TRUE;
   }
  }break;

 }
 return FALSE;
}

#ifdef WIN32

bool OpenDev(PSetup S) {
 TCHAR k[200],n[MAX_PATH];
 if (S->dev) return true;	// Ist schon offen!
 if (CM_Get_Device_ID(S->sdd->DevInst,k,elemof(k),0)!=CR_SUCCESS) return false;
 if (CM_Get_Device_Interface_List((LPGUID)&Vlpt_GUID,
   k,n,elemof(n),0)!=CR_SUCCESS) return false;
 S->dev=CreateFile(n,GENERIC_READ|GENERIC_WRITE,
   FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,0,0);
 if (S->dev==INVALID_HANDLE_VALUE) {
  S->dev=0;	// hier: 0 = kein Handle
  return false;
 }
 return true;
}

int DevIoctl(PSetup S, DWORD code, LPCVOID p1, int l1, LPVOID p2, int l2) {
 DWORD BytesRet;
 if (DeviceIoControl(S->dev,code,(LPVOID)p1,l1,p2,l2,&BytesRet,NULL))
   return (int)BytesRet;
 else return -1;
}

void CloseDev(PSetup S) {
 if (S->dev) CloseHandle(S->dev); S->dev=0;
}

#else//Win16

bool OpenDev(PSetup S) {
 TCHAR k[200],n[MAX_PATH];
 DWORD lpCreateFile,cfgmgr32,lpGetDevID,lpGetDevIF;
 bool ok;
 if (S->dev) return true;	// Ist schon offen!
 cfgmgr32=LoadLibraryEx32W("cfgmgr32.dll",0,0);
 if (!cfgmgr32) return false;
 ok=(bool)((lpGetDevID=GetProcAddress32W(cfgmgr32,"CM_Get_Device_IDA"))!=0	// bool-Typecast wird von BC31(C++) gefordert
 && (lpGetDevIF=GetProcAddress32W(cfgmgr32,"CM_Get_Device_Interface_ListA"))!=0
 && !CallProcEx32W(4,2,lpGetDevID,S->info->dnDevnode,(LPSTR)k,(DWORD)sizeof(k),0L)
 && !CallProcEx32W(5,7,lpGetDevIF,(LPGUID)&Vlpt_GUID,(LPSTR)k,(LPSTR)n,(DWORD)sizeof(n),0L));
 FreeLibrary32W(cfgmgr32);
 if (!ok) return false;

 S->kernel32=LoadLibraryEx32W("kernel32.dll",0,0);
 if (!S->kernel32) return false;
 lpCreateFile=GetProcAddress32W(S->kernel32,"CreateFileA");
 if (!lpCreateFile) return false;
 S->dev=CallProcEx32W(7,1,lpCreateFile,
   (LPSTR)n,0xC0000000L,0L,(DWORD)NULL,3L/*OPEN_EXISTING*/,0L,0L);
 if (S->dev==(DWORD)-1) {
  S->dev=0;	// hier: 0 = kein Handle
  return false;
 }
 return true;
}

int DevIoctl(PSetup S, DWORD code, LPCVOID p1, int l1, LPVOID p2, int l2) {
 long ret=-1;
 if (S->dev) {
  DWORD lpDeviceIoControl=GetProcAddress32W(S->kernel32,"DeviceIoControl");
  if (lpDeviceIoControl) CallProcEx32W(8,0x54,lpDeviceIoControl,
    S->dev,code,p1,(long)l1,p2,(long)l2,(LPVOID)&ret,0L);
 }
 return (int)ret;
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
#endif//WIN32

/************************************************
 * Eigenschaftsseiten-Dialogprozedur: Emulation *
 ************************************************/

static void CheckButton13(HWND Wnd, PSetup S) {
 UINT i=2;	// BST_INDETERMINATE
 switch ((S->uc.flags>>UCB_ReadCache0)&7) {
  case 0: i--; nobreak;// i=0
  case 7: i--;	// i=1, BST_CHECKED
 }
 CheckDlgButton(Wnd,13,i);
}

// Achtung! Diese Dialogprozedur wird sowohl für den Eigenschafts-Dialog
// als auch für die Schlussseite beim Hardware-Assistenten verwendet.
static INT_PTR CALLBACK _loadds EmulDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 static const WORD DefLpt[]={0x378,0x278,0x3BC};
 PSetup S=(PSetup)GetWindowPtr(Wnd,DWLP_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   static const TCHAR LptStd[]=T("LPT1\0LPT2\0LPT1 anno 1985\0");
   static const TCHAR LptEnh[]=T("SPP\0EPP 1.9\0ECP\0ECP + EPP\0");
   PCTSTR p;
   TCHAR s[128];
   HWND w0,w2;
   int i;

   S=(PSetup)((LPPROPSHEETPAGE)lParam)->lParam;
   SetWindowPtr(Wnd,DWLP_USER,S);
   ChangeFonts(Wnd,S);

#ifdef WIN32	// in Win98 gibt's kein SetupDiXxx
   if (S->wizard) {
    SendDlgItemMessage(Wnd,10,STM_SETICON,(WPARAM)LoadIcon(0,IDI_WARNING),0);
    SendDlgItemMessage(Wnd,11,STM_SETICON,(WPARAM)LoadIcon(0,IDI_INFORMATION),0);
    PropSheet_SetWizButtons(GetParent(Wnd),PSWIZB_NEXT);
   }
#endif

   w0=GetDlgItem(Wnd,100);	// Adresse
   for (p=LptStd,i=0;*p;p+=lstrlen(p)+1,i++) {
    wsprintf(s,T("%Xh (%u, %s)"),DefLpt[i],DefLpt[i],(LPCTSTR)p);
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
   wsprintf(s,T("%Xh"),S->uc.LptBase);	// Nicht-Standard-Adresse
   SetWindowText(w0,s);
skip:
   (void)ComboBox_SetCurSel(w2,S->uc.Mode);
#ifdef WIN32
   if (!S->wizard)
#endif
   {
    SetCheckboxGroup(Wnd,10,12,S->uc.flags>>UCB_Debugreg);
    CheckDlgButton(Wnd,17,S->uc.flags>>UCB_ForceAlloc);	// neuer Treiber
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
   }
*/
  }return TRUE;

  case WM_CONTEXTMENU: WM_ContextMenu_to_WM_Help(Wnd,lParam); break;

  case WM_HELP: {	// Klassische Verarbeitung durch lange [MAP]-Sektion in Hilfedatei
   int id=((LPHELPINFO)lParam)->iCtrlId;
   if (id) {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXTPOPUP,MAKELONG(id,100));
    SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);
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
    UINT u;
    HWND w;
    //---
    if (!GetDlgItemHex(Wnd,100,&u)) {
     MBox(Wnd,17,MB_OK|MB_ICONEXCLAMATION);
     goto f1;
    }
    if (u<0x100 || u&3 || u>>16) {	// gewöhnliche Fehler
     MBox(Wnd,18,MB_OK|MB_ICONEXCLAMATION);
f1:  w=GetDlgItem(Wnd,100);
     SetFocus(w);
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
     BOOL ok;
     w=GetDlgItem(Wnd,101);
     u=GetDlgItemInt(Wnd,101,&ok,FALSE);
     if (!ok || u>1000) {
      MBox(Wnd,20,MB_OK|MB_ICONEXCLAMATION);
      SetFocus(w);
      Edit_SetSel(w,0,(UINT)-1);
      goto fail;
     }
     S->uc.TimeOut=(WORD)u;
    //---
     S->uc.flags&=~(UC_Debugreg|UC_Function|UC_WriteCache|UC_ForceAlloc);
     S->uc.flags|=GetCheckboxGroup(Wnd,10,12)<<UCB_Debugreg;
     S->uc.flags|=IsDlgButtonChecked(Wnd,17)<<UCB_ForceAlloc;
    }
    break;
fail: SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);	// Fokus nicht entfernen!
   }return TRUE;

#ifdef WIN32
   case PSN_WIZNEXT: {
    ((LPNMHDR)lParam)->code=PSN_KILLACTIVE;	// Fehlende Msg nachholen??
    SendMessage(Wnd,WM_NOTIFY,wParam,lParam);
   }nobreak;
#endif

   case PSN_APPLY: {
    int i;
    for (i=0; i<elemof(DefLpt); i++) if (DefLpt[i]==S->uc.LptBase) goto setit;
    if (MBox(Wnd,16,MB_YESNO|MB_ICONQUESTION,S->uc.LptBase)!=IDYES) {
     SetWindowLongPtr(Wnd,DWLP_MSGRESULT,S->wizard?-1:PSNRET_INVALID);
     return TRUE;
    }
setit:
    if (OpenDev(S)) {
     DevIoctl(S,IOCTL_VLPT_UserCfg,&S->uc,sizeof(TUserCfg),&S->uc,0);
     CloseDev(S);
    }else{	// Meckern?? Im Fall von "Wizard" Umgebungsvariable?
     MessageBeep(MB_ICONHAND);
    }
   }break;

   case PSN_HELP: {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXT,MAKELONG(0,100));
   }break;

  }
 }
 return FALSE;
}

/**************************
 * Dialogprozedur: Extras *
 **************************/

// Feature-Register lesen und Markierungsfelder setzen
static void ReadCheckboxes(HWND Wnd, PSetup S) {
 BYTE Feature=0x1F;	// Kommando: Feature-Byte lesen
 DevIoctl(S,IOCTL_VLPT_OutIn,&Feature,1,&Feature,1);
 if (Feature==0xFF) {	// Antwort von zu alter Firmware
  HWND w=GetDlgItem(Wnd,99);	// STATIC mit anderem Text
  TCHAR Text[256];
  LoadString(hInst,23/*Zu alte FW*/,Text,elemof(Text));
  SetWindowText(w,Text);
	// Weitere Dialogelemente verschwinden lassen
  ShowChilds(GetNextSibling(w),8,SW_HIDE);
  EnableWindow(GetDlgItem(Wnd,3),FALSE);
  EnableWindow(GetDlgItem(Wnd,1),FALSE);
  return;
 }
 CheckDlgButton(Wnd,100,Feature&1);	// Bit 0: Offener Kollektor für Daten
 CheckDlgButton(Wnd,101,Feature&4?1:Feature&2?0:-1);	// Bit 2+1: für Steuerport
 CheckDlgButton(Wnd,102,Feature>>7);	// Bit 7: Pullup-Schalter
 CheckDlgButton(Wnd,103,(Feature>>6)&1);// Bit 6: DirectIO-Schalter
 SendMessage(Wnd,WM_COMMAND,103,(LPARAM)GetDlgItem(Wnd,103));	// Farbwechsel
}

// Markierungsfelder lesen und Feature-Register setzen
static void WriteCheckboxes(HWND Wnd, PSetup S) {
 BYTE IoctlData[]={0x0F,0x1F};
 if (DevIoctl(S,IOCTL_VLPT_OutIn,IoctlData+1,1,IoctlData+1,1)==-1) return;
 IoctlData[1]&=0x38;		// hier nicht gezeigte Bits bleiben!
 if (IsDlgButtonChecked(Wnd,100)) IoctlData[1]|=0x01;
 switch (IsDlgButtonChecked(Wnd,101)) {
  case 0: IoctlData[1]|=0x02; break;
  case 1: IoctlData[1]|=0x04; break;
 }	// im dritten Zustand bleiben die beiden Bits Null
 if (IsDlgButtonChecked(Wnd,102)) IoctlData[1]|=0x80;
 if (IsDlgButtonChecked(Wnd,103)) IoctlData[1]|=0x40;
 DevIoctl(S,IOCTL_VLPT_OutIn,IoctlData,2,NULL,0);
}

static int FormatDate(WORD FatDate, LPTSTR s, UINT slen) {
 if (FatDate && (WORD)~FatDate) {	// weder 0x0000 noch 0xFFFF
#ifdef WIN32
  FILETIME ft;
  if (!DosDateTimeToFileTime(FatDate,0,&ft)) goto falsch;
  SYSTEMTIME st;
  FileTimeToSystemTime(&ft,&st);
  return GetDateFormat(LOCALE_USER_DEFAULT,0,&st,NULL,s,slen);
#else
  return wsprintf(s,T("%u-%02u-%02u"),(FatDate>>9)+1980,(FatDate>>5)&0x0F,FatDate&0x1F);
#endif
 }
falsch:
 return LoadString(hInst,36/*unbekannt*/,s,slen);
}

// Seriennummer und Firmware-Datum lesen und Editfelder setzen
static void ReadSerialAndDate(HWND Wnd, PSetup S) {
 WORD adr=0xFFFC;	// Seriennummer-Position (im EEPROM)
 WORD date;		// Datum im FAT-Format
 DWORD sn=0;		// Seriennummer selbst
 TCHAR Text[32];
 DevIoctl(S,IOCTL_VLPT_EepromRead,&adr,sizeof(adr),&sn,sizeof(sn));
 if (!~sn) sn=0;	// ungebrannte Seriennummer
 if (!(~sn&0xFFFFFFL)) sn>>=24;	// Seriennummer im MSB (altes Format)
 if (sn && sn!=(DWORD)-1) {
  wsprintf(Text,T("%lu"),sn);	// 32-bit-Zahl! Deshalb kein SetDlgItemInt
 }else{
  LoadString(hInst,24/*"keine"*/,Text,elemof(Text));
 }
 SetDlgItemText(Wnd,110,Text);	// Text setzen
 adr=0x0006;		// Datums-Position (im XRAM)
 DevIoctl(S,IOCTL_VLPT_XramRead,&adr,sizeof(adr),&date,sizeof(date));
 FormatDate(date,Text,elemof(Text));
 SetDlgItemText(Wnd,111,Text);	// Text setzen
}

// Seriennummer schreiben (via Hintertür)
static void WriteSerial(HWND Wnd, PSetup S) {
 WORD adr=0xFFFC;	// Seriennummer-Position (im EEPROM)
 DWORD sn;		// Seriennummer
 if (!IsWindowEnabled(GetDlgItem(Wnd,110))) return;	// Nur bei geöffneter Hintertür!
#ifdef WIN32
 sn=GetDlgItemInt(Wnd,110,NULL,FALSE);
#else
 {
  TCHAR Text[16];
  GetDlgItemText(Wnd,110,Text,elemof(Text));
  sn=ss_strtoul(Text,NULL,10);
 }
#endif
 DevIoctl(S,IOCTL_VLPT_EepromWrite,&adr,sizeof(adr),&sn,sizeof(sn));
}

/**************************************************
 * Kurzschlusstest (Kurzuschlusstest.C entnommen) *
 **************************************************/

static const BYTE savecmd[8]={0x10,0x11,0x12,0x1A,0x1C,0x1D,0x1E,0x1F};

static BYTE Check(PSetup S, BYTE bData, BYTE bStatus, BYTE bControl, BYTE bDoOut){
 if (bDoOut){
  static const BYTE CheckRev12=0x1D;	// zum Testen auf Rev.2 und Rev.3, die können ACK und BUSY nicht zum Ausgang machen
  BYTE StatusDir;
  DevIoctl(S,IOCTL_VLPT_OutIn,&CheckRev12,1,&StatusDir,1);
  if (~StatusDir&0xC0) bStatus|=0xC0;	// kann nicht ausgeben!
  BYTE OutBundle[6];
  OutBundle[0]=0,	OutBundle[1]=bData,
  OutBundle[2]=1,	OutBundle[3]=(bStatus^0x80)|0x07,
  OutBundle[4]=2,	OutBundle[5]=(bControl^0x0B)&0x0F,
  DevIoctl(S,IOCTL_VLPT_OutIn,OutBundle,6,NULL,0);
 }
 BYTE InBundle[3];
 DevIoctl(S,IOCTL_VLPT_OutIn,savecmd,3,InBundle,3);
 bData   ^=InBundle[0];
 bStatus ^=InBundle[1]^0x80; bStatus &=0xF8;
 bControl^=InBundle[2]^0x0B; bControl&=0x0F;
 return bData|bStatus|bControl;		// sollte 0 sein, wenn alles in Ordnung ist!
}


// Kurzschlusstest (auch: Verbindungstest mit LPT-Pegeltester LPTCHK)
static void RunSelfTest(HWND Wnd, PSetup S) {
 BYTE fail;
 BYTE regsave[8];
 DevIoctl(S,IOCTL_VLPT_OutIn,savecmd,8,regsave,8);		// (alte Firmware unterstützen, nicht mehr als 8 Bytes)
 static const BYTE RegSet[7]={0x0F,0x00,0x0A,0x00,0x0D,0xFF,0x1D};// keine Features, SPP-Modus, Statusleitungen Ausgänge
 BYTE b;
 DevIoctl(S,IOCTL_VLPT_OutIn,RegSet,7,&b,1);		// (alte Firmware unterstützen, daher kein DirectIO)
 fail=~b&0x38;						// "Dieser Test erfordert Firmware 060629 oder neuer!"
 for(b=1;b;b<<=1) {	// Daten testen
  fail|=Check(S,b,0,0,TRUE);
  fail|=Check(S,~b,0xFF,0xFF,TRUE);
 }
 for(b=8;b;b<<=1) {	// Statusleitungen
  fail|=Check(S,0,b,0,TRUE);
  fail|=Check(S,0xFF,~b,0xFF,TRUE);
 }
 for(b=1;b<0x10;b<<=1) {// Steuerleitungen
  fail|=Check(S,0,0,b,TRUE);
  fail|=Check(S,0xFF,0xFF,~b,TRUE);
 }
// Prüfen auf Vorhandensein der (ATmega: internen) Pullups
 static const BYTE DdrClr[7]={2,0x3F^0x0B,0x0C,0,0x0D,0,0x1F};
 DevIoctl(S,IOCTL_VLPT_OutIn,DdrClr,7,&b,1);	// b = Feature-Register
 if (!(b&0x02)) {
  static const BYTE DdrClr2[2]={0x0E,0};	// Steuerport nur, wenn Pull-Up vorhanden
  DevIoctl(S,IOCTL_VLPT_OutIn,DdrClr2,2,NULL,0);
 }
#ifdef WIN32
 Sleep(10);
#else
 SetTimer(Wnd,42,10,NULL);
 MSG Msg;
 do {
  GetMessage(&Msg,Wnd,WM_TIMER,WM_TIMER);
 }while (Msg.wParam!=42);
 KillTimer(Wnd,42);
#endif
 fail|=Check(S,0xFF,0xFF,0xFF,FALSE);	// muss alles High sein
 UINT answer=IDNO;
 if (!fail) {		// LED-Test schließt sich als letztes an (prüft Kontaktgabe der IC- und SubD-Pins)
  static const BYTE DdrSet[6]={0x0C,0xFF,0x0D,0xFF,0x0E,0xFF};
  DevIoctl(S,IOCTL_VLPT_OutIn,DdrSet,6,NULL,0);
  answer=MBox(Wnd,40,MB_YESNOCANCEL|MB_ICONQUESTION|MB_DEFBUTTON2|MB_HELP);
 }
 BYTE r[8];
 r[0]=0,	r[1]=regsave[0],
 r[2]=1,	r[3]=regsave[1],
 r[4]=2,	r[5]=regsave[2],
 r[6]=10,	r[7]=regsave[3],
 DevIoctl(S,IOCTL_VLPT_OutIn,r,8,NULL,0);
 r[0]=12,	r[1]=regsave[4],
 r[2]=13,	r[3]=regsave[5],
 r[4]=14,	r[5]=regsave[6],
 r[6]=15,	r[7]=regsave[7],
 DevIoctl(S,IOCTL_VLPT_OutIn,r,8,NULL,0);
 if (answer!=IDCANCEL) MBox(Wnd,answer==IDNO ? 39 : 38,
   fail ? MB_OK|MB_ICONEXCLAMATION : MB_OK|MB_ICONINFORMATION);
}

// Eigentliche Dialogprozedur
static INT_PTR CALLBACK _loadds ExtrasDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 PSetup S=(PSetup)GetWindowPtr(Wnd,DWLP_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   S=(PSetup)lParam;
   SetWindowPtr(Wnd,DWLP_USER,S);
   ChangeFonts(Wnd,S);
   ReadCheckboxes(Wnd,S);
   // Hintertür: Bei gedrückter Shift-Taste Seriennummer zur Editierung freigeben
   if (GetKeyState(VK_SHIFT)<0) EnableWindow(GetDlgItem(Wnd,110),TRUE);
   ReadSerialAndDate(Wnd,S);
  }return TRUE;

#ifdef WIN32
  case WM_CTLCOLORSTATIC: {	// obwohl es ein "Button" ist! (W2k, SP4)
   if ((HWND)lParam==GetDlgItem(Wnd,103)
   && IsDlgButtonChecked(Wnd,103)) {
    HBRUSH br=(HBRUSH)SendMessage(Wnd,WM_CTLCOLORDLG,wParam,(LPARAM)Wnd);
#else
  case WM_CTLCOLOR: if (HIWORD(lParam)==CTLCOLOR_BTN) {
   if ((HWND)lParam==GetDlgItem(Wnd,103)
   && IsDlgButtonChecked(Wnd,103)) {
    HBRUSH br=(HBRUSH)SendMessage(Wnd,WM_CTLCOLOR,wParam,MAKELONG(Wnd,CTLCOLOR_DLG));
#endif
    SetTextColor((HDC)wParam,0x0000C0);	// auffälliges Rot bei diesem Schalter!
    return (INT_PTR)br; 
   }
  }break;

  case WM_CONTEXTMENU: WM_ContextMenu_to_WM_Help(Wnd,lParam); break;

  case WM_HELP: {
   int id=((LPHELPINFO)lParam)->iCtrlId;
   if (id) {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXTPOPUP,MAKELONG(id,104));
    SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);
    return TRUE;
   }
  }break;
    	
  case WM_COMMAND: switch (LOWORD(wParam)) {
   case 1: WriteCheckboxes(Wnd,S); nobreak;
   case 2: EndDialog(Wnd,LOWORD(wParam)); break;
   case 3: {
    WriteCheckboxes(Wnd,S);
    ReadCheckboxes(Wnd,S);
    WriteSerial(Wnd,S);
   }break;
   case 4: RunSelfTest(Wnd,S); break;
   case 103: InvalidateRect((HWND)lParam,NULL,TRUE); break;	// Farbwechsel
  }break;
 }
 return FALSE;
}

/**************************************************
 * Firmware-Update (nur Full/High-Speed-USB2LPT!) *
 **************************************************/

// Anzeige der MessageBox mit den beiden Firmware-Datumsangaben
static int ShowDates(HWND Wnd, WORD olddate, WORD newdate) {
 TCHAR so[32], sn[32];
 FormatDate(olddate,so,elemof(so));
 FormatDate(newdate,sn,elemof(sn));
 return MBox(Wnd,35/*Datum der Firmware…*/,
   MB_YESNO|MB_DEFBUTTON2|MB_ICONQUESTION|MB_HELP,(LPCTSTR)so,(LPCTSTR)sn);
}
 
// Die alte Firmware muss bereits den EEPROM-Zugriff (A2-Request) unterstützen!
// .HEX-Dateien werden nicht verarbeitet.
static void DoFirmwareUpdate(HWND Wnd, PSetup S) {
 BYTE FirstByte=0;
 if (DevIoctl(S,IOCTL_VLPT_EepromRead,NULL,0,&FirstByte,1)==-1) return;
// Bug (oder Feature) im USB2LPT.SYS: Hier liefert DevIoctl() keine Längenangabe,
// sondern 0 wenn OK (und alles übertragen wurde). Zeiger NULL = Adresse 0
 switch (FirstByte) {
  case 0xB2:	/*AN2131*/
  case 0xC2:	/*CY7C68013A*/ break;
  case 0x42:	/*ATmega zurückpatchen mit Shift-Taste (Hintertür zum Testen, dann mit irreführender Meldung) */
   if (GetKeyState(VK_SHIFT)>=0) goto def; nobreak;
  case 0xFF:	/*ATmega*/
  if (MBox(Wnd,41/*Bootloader-Umschaltung*/,MB_YESNO|MB_ICONQUESTION|MB_HELP)==IDYES) {
   FirstByte^=0xFF^0x42;	// Kennbyte für Bootloader einsetzen, nichts weiter!
   DevIoctl(S,IOCTL_VLPT_EepromWrite,NULL,0,&FirstByte,1);
  }return;
  default: def: MessageBeep(MB_ICONEXCLAMATION); return;	// sollte nicht vorkommen
 }
 OPENFILENAME ofn;
 TCHAR sFilename[MAX_PATH];
 sFilename[0]=0;
 TCHAR sFilter[64];
 sFilter[LoadString(hInst,37/*"Firmware\0*.iic"*/,sFilter,elemof(sFilter)-1)+1]=0;
 InitStruct(&ofn,sizeof(ofn));
 ofn.hwndOwner=Wnd;
 ofn.lpstrFilter=sFilter;
 ofn.lpstrFile=sFilename;
 ofn.nMaxFile=elemof(sFilename);
 ofn.Flags=OFN_LONGNAMES|OFN_FILEMUSTEXIST|OFN_HIDEREADONLY|OFN_DONTADDTORECENT;
 if (!GetOpenFileName(&ofn)) return;
 BYTE *IicData=(BYTE*)LocalAlloc(LPTR,0x2000); // mehr als 8 KB gehen in den EEPROM nicht rein
 if (!IicData) {MessageBeep(MB_ICONEXCLAMATION); return;}	// sollte nicht vorkommen
 int IicLen;
#ifdef WIN32
 HANDLE f=CreateFile(sFilename,GENERIC_READ,FILE_SHARE_READ,
   NULL,OPEN_EXISTING,0,0);
 if (f!=INVALID_HANDLE_VALUE
 && ReadFile(f,IicData,0x2000,(DWORD*)&IicLen,NULL)
 && CloseHandle(f)
#else
 HFILE f=_lopen(sFilename,OF_READ|OF_SHARE_DENY_WRITE);
 if (f!=HFILE_ERROR
 && (IicLen=_lread(f,IicData,0x2000))!=HFILE_ERROR
 && _lclose(f)==0
#endif
 && IicLen>100
 && IicLen<=0x2000-16	// hinten etwas Platz!
 && IicData[0]==FirstByte) {
  UINT adr=0x11;		// der erste Block sei lückenlos!
  if (FirstByte==0xC2) adr++;
  WORD olddate;
  DevIoctl(S,IOCTL_VLPT_EepromRead,&adr,sizeof(adr),&olddate,2);
  if (ShowDates(Wnd,olddate,*(WORD*)(IicData+adr))==IDYES) {	// Little Endian vorausgesetzt
   bool fail=false;
   if (DevIoctl(S,IOCTL_VLPT_EepromWrite,NULL,0,IicData,IicLen)==-1) fail=true;
   MBox(Wnd,32+fail,fail ? MB_OK|MB_ICONSTOP : MB_OK|MB_ICONINFORMATION);
  }
 }else{
  MBox(Wnd,34/*Nicht die richtige Datei*/,MB_OK|MB_ICONSTOP,(LPTSTR)sFilename);
 }
 LocalFree(IicData);
}

/************************************************
 * Eigenschaftsseiten-Dialogprozedur: Statistik *
 ************************************************/

static void UpdateEditArray(HWND Wnd, UINT u, UINT o, ULONG*old, ULONG _ss*n) {
 for (;u<=o;u++,old++,n++) {
  ULONG v=*n;	// Arbeitskopie
  if (*old!=v) {
#ifdef WIN32
   SetDlgItemInt(Wnd,u,v,FALSE);
#else
   TCHAR s[32];
   wsprintf(s,"%lu",v);
   SetDlgItemText(Wnd,u,s);
#endif
   *old=v;
  }
 }
}

static INT_PTR CALLBACK _loadds StatDlgProc(HWND Wnd, UINT Msg, WPARAM wParam, LPARAM lParam) {
 PSetup S=(PSetup)GetWindowPtr(Wnd,DWLP_USER);
 switch (Msg) {
  case WM_INITDIALOG: {
   S=(PSetup)((LPPROPSHEETPAGE)lParam)->lParam;	// Zeiger wurde bei Erzeugung angegeben, hier kommt er
   SetWindowPtr(Wnd,DWLP_USER,S);	// Struktur ("Objekt") an Fenster binden
   ChangeFonts(Wnd,S);
//Vergleichsspeicher mit (großer) Sicherheit ungleich gelesenen Werten machen
   RtlFillMemory(&S->ac,sizeof(TAccessCnt),-1);
   SendMessage(Wnd,WM_TIMER,0,0);	// Timer wird bei PSN_SETACTIVE gesetzt
  }return TRUE;

  case WM_TIMER: if (OpenDev(S)) {	// bleibt normalerweise geöffnet
   TAccessCnt AC;
   RtlZeroMemory(&AC,sizeof(AC));
   if (DevIoctl(S,IOCTL_VLPT_AccessCnt,NULL,0,&AC,sizeof(AC))>=0) {
    UpdateEditArray(Wnd,100,106,&S->ac.out,&AC.out);	// 7 LongInts
    if (S->ac.debregs!=AC.debregs) {	// bei Änderung
     S->ac.debregs=AC.debregs;
     if (AC.debregs) {	// Bei neuem Treiber ist (zumindest) Bit7 gesetzt
      SetCheckboxGroup(Wnd,108,110,AC.debregs);
      S->ac.debregs=AC.debregs;
     }else{		// alter Treiber: Nur 6 DWORDs benutzt
// Debugregisterverwendungsanzeige verschwinden lassen
      ShowChilds(GetPrevSibling(GetDlgItem(Wnd,108)),4,SW_HIDE);
// Übergrößenanzeige verschwinden lassen (immer 0)
// ?? ShowChilds(GetPrevSibling(GetDlgItem(Wnd,106)),2,SW_HIDE);
     }
    }
   }
  }break;

  case WM_COMMAND: switch (wParam) {	// High-Teil ist 0 bei Buttons, LOWORD() kann entfallen
   case 116:
   case 117: {
    TAccessCnt AC;
    if (!OpenDev(S)) break;
#if defined(WIN32) && !defined(_WIN64)
    AC=S->ac;					// 32-bit-Compiler erzeugt Kode inline
#else
    RtlCopyMemory(&AC,&S->ac,sizeof(AC));	// 16- und 64-bit-Compiler würde auf Standardbibliothek verweisen
#endif
    if (wParam==116) RtlZeroMemory(&AC.out,4*sizeof(ULONG));	// vordere 4 DWORDs nullen
    else RtlZeroMemory(&AC.wpu,3*sizeof(ULONG));		// hintere 3 DWORDs nullen
    if (DevIoctl(S,IOCTL_VLPT_AccessCnt,&AC,sizeof(AC),NULL,0)<0)
      MessageBeep(MB_ICONEXCLAMATION);
   }break;

   case 111: {	// Extras
    DialogBoxParam(hInst,MAKEINTRESOURCE(104),Wnd,ExtrasDlgProc,(LPARAM)S);
   }break;
   
   case 112: {	// Firmware-Update
    DoFirmwareUpdate(Wnd,S);
   }break;
  }break;

  case WM_CONTEXTMENU: WM_ContextMenu_to_WM_Help(Wnd,lParam); break;

  case WM_HELP: {
   int id=((LPHELPINFO)lParam)->iCtrlId;
   if (id) {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXTPOPUP,MAKELONG(id,101));
    SetWindowLongPtr(Wnd,DWLP_MSGRESULT,1);
    return TRUE;
   }
  }break;
    	
  case WM_NOTIFY: switch (((LPNMHDR)lParam)->code){
   case PSN_SETACTIVE: {
    SetTimer(Wnd,100,250,NULL);
   }break;
   case PSN_KILLACTIVE: {
    KillTimer(Wnd,100);
    CloseDev(S);
   }break;
   case PSN_HELP: {
    WinHelp(Wnd,HelpFileName,HELP_CONTEXT,MAKELONG(0,101));
   }break;
  }break;
 }
 return FALSE;
}

/* Aufruf-Verhalten, Win2k, IE6 (falsch dokumentiert!):
 * PSPCB_ADDREF: 3x beim Laden der DLL (Öffnen der Eigenschaften)
 * PSPCB_CREATE: Sobald eine Seite das erste Mal angezeigt wird (also 0x bis 3x)
 * PSPCB_RELEASE: 3x beim Entladen der DLL (Schließen der Eigenschaften)
 * Aufruf-Verhalten, Win98 (so dokumentiert und gesehen, noch mal debuggen!):
 * PSPCB_ADDREF: nie
 * PSPCB_CREATE: Sobald eine Seite das erste Mal angezeigt wird (also 0x bis 3x)
 * PSPCB_RELEASE: So oft wie PSPCB_CREATE vorbei kam, beim Entladen der DLL
 */
UINT CALLBACK _loadds PageCallbackProc(HWND, UINT Msg, LPPROPSHEETPAGE p) {
 PSetup S=(PSetup)p->lParam;
 if (S) switch (Msg) {
  case PSPCB_ADDREF: S->usage++; break;		// 2 Zähler, so funktioniert's mit jedem Internet Explorer
  case PSPCB_CREATE: S->usage+=0x10; break;	// (Bei IE4 kommt vermutlich nur PSPCB_CREATE vorbei …)
  case PSPCB_RELEASE: if (S->usage) {		// Notbremse, Bedingung sollte stets wahr sein
   if (S->usage&0x0F) S->usage--;		// Beide Zähler dekrementieren, sofern !=0
   if (S->usage&0xF0) S->usage-=0x10;
   if (!(S->usage)) {
    CloseDev(S);
    if (S->italic)DeleteFont(S->italic);
    if (S->bold)  DeleteFont(S->bold);
    LocalFree((HLOCAL)S);			// Wehe, wenn jetzt noch mal PageCallbackProc() gerufen wird!
    p->lParam=0;
   }
  }break;
 }
 return TRUE;
}

/**********************************
 * (Bis zu) Zwei DLL-Aufrufpunkte *
 **********************************/

// _declspec(dllexport) wird nicht benötigt; der Export mit undekoriertem
// Namen geht eh' nur mittels .DEF-Datei oder /exports-Kommandozeilenoption
EXTERN_C BOOL CALLBACK _loadds EnumPropPages(
#ifdef WIN32
  PSP_PROPSHEETPAGE_REQUEST p,
#else
  LPDEVICE_INFO lpdi,
#endif
  LPFNADDPROPSHEETPAGE AddPage, LPARAM lParam) {

 HPROPSHEETPAGE hpage;
 PSetup S=(PSetup)LocalAlloc(LPTR,sizeof(TSetup));
 PROPSHEETPAGE page;

 InitStruct(&page,sizeof(page));
 page.dwFlags		=PSP_USECALLBACK|PSP_HASHELP|PSP_USEFUSIONCONTEXT;
 page.hInstance		=hInst;
 *(BYTE _ss*)&page.u.pszTemplate +=100;
 page.pfnDlgProc	=EmulDlgProc;
 page.lParam		=(LPARAM)S;
 page.pfnCallback	=PageCallbackProc;
#ifdef WIN32
 S->info=p->DeviceInfoSet;
 S->sdd= p->DeviceInfoData;
 page.hActCtx		=hActCtx;
 SetMBoxTitle(S);
#else
 S->info=lpdi;
 lstrcpy(MBoxTitle,lpdi->szDescription);
#endif
 hpage=CreatePropertySheetPage(&page);
#ifdef WIN32
 if (!hpage) {	// mit kleinerem dwSize noch mal versuchen (alte comctl32.dll)
  page.dwSize=PROPSHEETPAGE_V1_SIZE;
  hpage=CreatePropertySheetPage(&page);	// jetzt MUSS es klappen
 }
#endif
 if (hpage && !AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 *(BYTE _ss*)&page.u.pszTemplate +=1;	// 101
 page.pfnDlgProc	=StatDlgProc;
 hpage=CreatePropertySheetPage(&page);
 if (hpage && !AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
 *(BYTE _ss*)&page.u.pszTemplate +=4;	// 105
 page.pfnDlgProc	=MonDlgProc;
 hpage=CreatePropertySheetPage(&page);
 if (hpage && !AddPage(hpage,lParam)) DestroyPropertySheetPage(hpage);
// Normale Eigenschaftsseite anhängen; bei Win16 liefert das Makro TRUE
 return ParallelPortPropPageProvider(p,AddPage,lParam);
}

#ifdef WIN32	// kein CoDeviceInstall bei Win16 verfügbar!
DWORD CALLBACK CoDeviceInstall(
  DI_FUNCTION InstallFunction,
  HDEVINFO DeviceInfoSet,
  PSP_DEVINFO_DATA DeviceInfoData,
  PCOINSTALLER_CONTEXT_DATA Context) {

 switch (InstallFunction) {
  case DIF_NEWDEVICEWIZARD_FINISHINSTALL: {
   SP_NEWDEVICEWIZARD_DATA NDWD;
   PSetup S=(PSetup)LocalAlloc(LPTR,sizeof(TSetup));
   PROPSHEETPAGE page={
    sizeof(PROPSHEETPAGE),
    PSP_USECALLBACK|PSP_USEHEADERTITLE|PSP_USEHEADERSUBTITLE|PSP_HASHELP|PSP_USEFUSIONCONTEXT,
    hInst,		//nicht-statisch
    MAKEINTRESOURCE(103),
    0,			// Icon
    NULL,		// Titel
    EmulDlgProc,
    (LPARAM)S,		//nicht-statisch
    PageCallbackProc,
    NULL,		//pcRefParent
    MAKEINTRESOURCE(21),// erfordert (irgendwo) ein #define _WIN32_IE 0x0500
    MAKEINTRESOURCE(22),
    hActCtx};

   S->wizard=TRUE;
   S->info=DeviceInfoSet;
   S->sdd= DeviceInfoData;
   SetMBoxTitle(S);
   NDWD.ClassInstallHeader.cbSize=sizeof(SP_CLASSINSTALL_HEADER);
   NDWD.ClassInstallHeader.InstallFunction=DIF_ADDPROPERTYPAGE_ADVANCED; // lt. Doku unnötig
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
 return NO_ERROR;
}

#endif
