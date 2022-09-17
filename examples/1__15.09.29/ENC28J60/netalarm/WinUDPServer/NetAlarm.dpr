program NetAlarm;

uses
  SvcMgr,
  NetAlarmUnit in 'NetAlarmUnit.pas' {UDPAlarm: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'NetAlarm';
  Application.CreateForm(TUDPAlarm, UDPAlarm);
  Application.Run;
end.
