object Form6: TForm6
  Left = 249
  Top = 189
  AutoScroll = False
  AutoSize = True
  Caption = #52572#44540#50640' '#44036' '#49324#51060#53944
  ClientHeight = 393
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 361
    Height = 393
    TabOrder = 0
    object ListBox1: TListBox
      Left = 16
      Top = 16
      Width = 337
      Height = 305
      ImeName = 'Microsoft IME 2010'
      ItemHeight = 13
      TabOrder = 0
    end
    object Button1: TButton
      Left = 16
      Top = 328
      Width = 337
      Height = 25
      Caption = #52488#44592#54868
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 360
      Width = 337
      Height = 25
      Caption = #49325#51228
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
  end
end
