object Form15: TForm15
  Left = 652
  Top = 258
  AutoScroll = False
  AutoSize = True
  Caption = #54028#49905#54268
  ClientHeight = 225
  ClientWidth = 297
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
    Width = 297
    Height = 225
    Caption = #54028#49905
    TabOrder = 0
    object Label1: TLabel
      Left = 116
      Top = 146
      Width = 11
      Height = 16
      Caption = #50752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 260
      Top = 146
      Width = 22
      Height = 16
      Caption = #49324#51060
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 170
      Width = 27
      Height = 16
      Caption = #44208#44284':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 8
      Top = 144
      Width = 105
      Height = 21
      TabOrder = 0
      OnClick = Edit1Click
    end
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 281
      Height = 121
      Lines.Strings = (
        #44160#49353#54624' '#53581#49828#53944)
      ScrollBars = ssVertical
      TabOrder = 1
      OnClick = Memo1Click
    end
    object Edit2: TEdit
      Left = 136
      Top = 144
      Width = 121
      Height = 21
      TabOrder = 2
      OnClick = Edit2Click
    end
    object Button1: TButton
      Left = 8
      Top = 192
      Width = 281
      Height = 25
      Caption = #54028#49905#54616#44592
      TabOrder = 3
      OnClick = Button1Click
    end
    object Edit3: TEdit
      Left = 48
      Top = 168
      Width = 241
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = #44160#49353#46108' '#44208#44284#44032' '#50630#49845#45768#45796'.'
    end
  end
end
