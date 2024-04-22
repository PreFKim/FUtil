object Form14: TForm14
  Left = 1209
  Top = 120
  AutoScroll = False
  AutoSize = True
  Caption = #51064#51613
  ClientHeight = 161
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 305
    Height = 161
    TabOrder = 0
    object PaintBox1: TPaintBox
      Left = 8
      Top = 16
      Width = 289
      Height = 105
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object Button1: TButton
      Left = 8
      Top = 128
      Width = 75
      Height = 25
      Caption = #49352#47196#44256#52840
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 93
      Top = 130
      Width = 121
      Height = 21
      MaxLength = 6
      TabOrder = 1
      OnKeyDown = Edit1KeyDown
    end
    object Button2: TButton
      Left = 222
      Top = 128
      Width = 75
      Height = 25
      Caption = #54869#51064
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
  end
end
