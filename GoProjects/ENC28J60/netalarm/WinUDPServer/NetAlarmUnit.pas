unit NetAlarmUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdSocketHandle, ShellAPI, IniFiles;

  {
  Windows, Messages, Graphics, Controls, Forms, Dialogs, IdWinsock2, stdctrls,
  SysUtils, Classes, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdComponent, IdUDPBase, IdUDPClient, IdStack, IdUDPServer, IdSocketHandle;}


type
  TUDPAlarm = class(TService)
    UDPServer: TIdUDPServer;
    UDPAntiFreeze: TIdAntiFreeze;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure UDPServerUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
  private
    { Private declarations }
    UDPport: Integer;
    FromIP: String;
    ToDo: TStringList;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  UDPAlarm: TUDPAlarm;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  UDPAlarm.Controller(CtrlCode);
end;

function TUDPAlarm.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TUDPAlarm.ServiceStart(Sender: TService; var Started: Boolean);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create('NetAlarm.ini');
  try
    UDPport:=IniFile.ReadInteger('settings', 'udpport', 773);
    FromIP:=IniFile.ReadString('settings', 'fromip', '');
    ToDo := TStringList.Create;
    try
      IniFile.ReadSectionValues('todo', ToDo);
    finally
    end;

   finally
    IniFile.Free;
  end;
  UDPServer.DefaultPort := UDPport;
  UDPServer.Active := True;
end;

procedure TUDPAlarm.UDPServerUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  i: Integer;
  AlarmString: String;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    if (ABinding.PeerIP = FromIP) then
    begin
      for i:=0 to ToDo.Count-1 do
      begin
        AlarmString := trim(ToDo.Names[i]);
        if ((DataStringStream.DataString = AlarmString) or (AlarmString = '*')) then
        begin
          ShellExecute(0, nil, PChar(trim(ToDo.ValueFromIndex[i])), nil, nil, SW_SHOW);
        end;
      end;
    end;
  finally
    DataStringStream.Free;
  end;
end;

end.
