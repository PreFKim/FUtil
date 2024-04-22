object Form12: TForm12
  Left = 455
  Top = 456
  Width = 193
  Height = 312
  AutoSize = True
  Caption = #50508#46988
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 185
    Height = 97
    Caption = #52628#44032' '#54624#49884#44036'('#52488#47924#49884')'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 1
      Caption = #51068
    end
    object SpeedButton2: TSpeedButton
      Left = 32
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = #50900
    end
    object SpeedButton3: TSpeedButton
      Left = 56
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 3
      Caption = #54868
    end
    object SpeedButton4: TSpeedButton
      Left = 80
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 4
      Caption = #49688
    end
    object SpeedButton5: TSpeedButton
      Left = 104
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 5
      Caption = #47785
    end
    object SpeedButton6: TSpeedButton
      Left = 128
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 6
      Caption = #44552
    end
    object SpeedButton7: TSpeedButton
      Left = 152
      Top = 40
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 7
      Caption = #53664
    end
    object Button1: TButton
      Left = 8
      Top = 64
      Width = 169
      Height = 25
      Caption = #52628#44032
      TabOrder = 0
      OnClick = Button1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 8
      Top = 16
      Width = 169
      Height = 21
      Date = 41734.366666666670000000
      Time = 41734.366666666670000000
      Kind = dtkTime
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 97
    Width = 185
    Height = 184
    Caption = #49884#44036#46308
    TabOrder = 1
    object Button2: TButton
      Left = 8
      Top = 152
      Width = 169
      Height = 25
      Caption = #49325#51228
      TabOrder = 0
      OnClick = Button2Click
    end
    object ListView1: TListView
      Left = 8
      Top = 16
      Width = 169
      Height = 129
      Columns = <
        item
          AutoSize = True
          Caption = #49884#44036
        end
        item
          AutoSize = True
          Caption = #50836#51068
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnKeyDown = ListView1KeyDown
    end
  end
  object checktime: TTimer
    Interval = 1
    OnTimer = checktimeTimer
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 24
  end
end
