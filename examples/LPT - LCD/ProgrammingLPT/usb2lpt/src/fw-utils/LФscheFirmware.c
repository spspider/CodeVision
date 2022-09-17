#include <windows.h>
#include <winioctl.h>
HANDLE hStdIn, hStdOut, hStdErr;
HANDLE hAccess;

void _cdecl printf(const char*t,...){
 TCHAR buf[256];
 DWORD len;
 len=wvsprintf(buf,t,(va_list)(&t+1));
 CharToOemBuff(buf,buf,len);
 WriteConsole(hStdOut,buf,len,&len,NULL);
}

int JaNein(void){
 char c;
 DWORD len,OldMode;
 GetConsoleMode(hStdIn,&OldMode);
 SetConsoleMode(hStdIn,0);
 ReadConsole(hStdIn,&c,1,&len,NULL);
 printf("%c\n",c);
 SetConsoleMode(hStdIn,OldMode);
 switch (c){
  case 'J':
  case 'j':
  case 'Y':
  case 'y': return IDYES;
  case 'N':
  case 'n': return IDNO;
 }
 return 0;
}

void _cdecl mainCRTStartup(){
 BYTE data=0;
 WORD adr=0;
 DWORD dw;
 hStdIn =GetStdHandle(STD_INPUT_HANDLE);
 hStdOut=GetStdHandle(STD_OUTPUT_HANDLE);
 hStdErr=GetStdHandle(STD_ERROR_HANDLE);

 printf("Hilfsprogramm zum Löschen (Deaktivieren) der Firmware vom h#s USB2LPT-Gerät\n");
 printf("Versionen 1.0 bis 1.4, April 2007\n\n");
 for (dw=8;dw;dw--){	// von hinten probieren
  TCHAR DevName[16];
  wsprintf(DevName,"\\\\.\\LPT%u",dw);
  hAccess=CreateFile(DevName,
   GENERIC_READ|GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,0);
  if (hAccess!=INVALID_HANDLE_VALUE) break;
 }
 if (hAccess==INVALID_HANDLE_VALUE){
  printf("USB2LPT anstecken, muss LPTx sein!\n");
  goto ende;
 }
// C2-Byte zur Kontrolle lesen (B2 beim AN2131)
 if (!DeviceIoControl(hAccess,
   CTL_CODE(FILE_DEVICE_UNKNOWN,0x08A2,METHOD_OUT_DIRECT,FILE_ANY_ACCESS),
   &adr,2,&data,1,&dw,NULL) /*|| dw!=1*/) {
  printf("Fehler beim Ausführen der Gerätesteuerung, USB2LPT nicht angesteckt?\n");
  goto ende;
 }
 if (data!=0xC2 && data!=0xB2) {
  printf("Firmware ist bereits gelöscht. USB2LPT abziehen und wieder anstecken!\n");
  goto ende;
 }
// C2-Byte löschen (Brücke in Rev. 2 und 3 funktioniert nicht!)
 printf("Firmware im EEPROM des USB2LPT jetzt löschen?\n"
  "[Zum Beschreiben des EEPROM wird die kostenlose Entwicklungssoftware von\n"
  "www.cypress.com benötigt, davon m.W. das Programm EzMr.exe.]\n"
  "Erstes Byte (0x%02X) löschen (überschreiben mit 0xFF)? J/N: ",data);
 if (JaNein()!=IDYES) goto ende;
 data=0xFF;
 if (!DeviceIoControl(hAccess,
   CTL_CODE(FILE_DEVICE_UNKNOWN,0x08A2,METHOD_IN_DIRECT,FILE_ANY_ACCESS),
   &adr,2,&data,1,&dw,NULL) /*|| dw!=1*/) {
  printf("Fehler beim Ausführen der Gerätesteuerung, USBLPT nicht angesteckt?\n");
  goto ende;
 }
 printf("Firmware wurde durch Überschreiben des ersten Bytes gelöscht.");

ende:
 CloseHandle(hAccess);
 printf("\nBeliebige Taste zum Programmende drücken ...");
 JaNein();
 ExitProcess(0);
}
