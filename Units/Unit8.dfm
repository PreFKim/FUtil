object Form8: TForm8
  Left = 479
  Top = 303
  AutoScroll = False
  AutoSize = True
  Caption = #50689#49345' '#51116#49373#44592
  ClientHeight = 417
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 425
    Height = 417
    Caption = #50689#49345
    TabOrder = 0
    object Label1: TLabel
      Left = 272
      Top = 24
      Width = 48
      Height = 13
      Caption = #49345#54889#48320#44221
      Visible = False
    end
    object WindowsMediaPlayer1: TWindowsMediaPlayer
      Left = 8
      Top = 16
      Width = 245
      Height = 240
      TabOrder = 0
      OnStatusChange = WindowsMediaPlayer1StatusChange
      ControlData = {
        000300000800000000000500000000000000F03F030000000000050000000000
        0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
        08000200000000000300320000000B00000008000A000000660075006C006C00
        00000B0000000B0000000B00FFFF0B00FFFF0B00000008000200000000000800
        020000000000080002000000000008000200000000000B00000052190000CE18
        0000}
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 360
      Width = 411
      Height = 49
      Caption = #44592#53440#44592#45733
      TabOrder = 1
      object Button1: TButton
        Left = 8
        Top = 16
        Width = 195
        Height = 25
        Caption = #54028#51068#50676#44592
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 208
        Top = 16
        Width = 195
        Height = 25
        Caption = #51204#52404#54868#47732
        Enabled = False
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
  end
  object OpenDialog1: TOpenDialog
    Filter = #50689#49345#54028#51068'('#50504#46104#45716#44144' '#47566#50500#50836')|*.avi;*.wmv;*mp4|'#47784#46304' '#54028#51068'|*.*'
    Left = 24
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 48
  end
end
