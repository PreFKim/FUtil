object Form13: TForm13
  Left = 627
  Top = 120
  Width = 577
  Height = 144
  AutoSize = True
  BorderIcons = []
  Caption = #49884#44036#50508#47548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MediaPlayer1: TMediaPlayer
    Left = 168
    Top = 1
    Width = 29
    Height = 20
    VisibleButtons = []
    Visible = False
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 569
    Height = 113
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 23
      Width = 129
      Height = 58
      Alignment = taCenter
      AutoSize = False
      Caption = 'label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -48
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 288
      Top = 80
      Width = 273
      Height = 25
      Caption = #49548#47532#45124#44592
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 8
      Top = 80
      Width = 273
      Height = 25
      Caption = #50508#46988' '#51333#47308
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
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
