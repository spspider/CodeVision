object UDPAlarm: TUDPAlarm
  OldCreateOrder = False
  DisplayName = 'Net Alarm'
  OnStart = ServiceStart
  Left = 192
  Top = 107
  Height = 356
  Width = 446
  object UDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 773
    OnUDPRead = UDPServerUDPRead
    Left = 40
    Top = 16
  end
  object UDPAntiFreeze: TIdAntiFreeze
    OnlyWhenIdle = False
    Left = 84
    Top = 16
  end
end
