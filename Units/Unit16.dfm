object Form16: TForm16
  Left = 957
  Top = 269
  Width = 241
  Height = 240
  AutoSize = True
  Caption = #54924#50896#44032#51077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 233
    Height = 209
    Caption = #54924#50896#44032#51077
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 18
      Width = 74
      Height = 13
      Caption = #50500#51060#46356'(4~16): '
    end
    object Label2: TLabel
      Left = 8
      Top = 74
      Width = 57
      Height = 13
      Caption = #48708#48128#48264#54840' :  '
    end
    object Label3: TLabel
      Left = 8
      Top = 98
      Width = 82
      Height = 13
      Caption = #48708#48128#48264#54840' '#54869#51064' :  '
    end
    object PaintBox1: TPaintBox
      Left = 8
      Top = 120
      Width = 217
      Height = 25
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object Button3: TButton
      Left = 160
      Top = 144
      Width = 65
      Height = 25
      Caption = #49352#47196#44256#52840
      TabOrder = 6
      OnClick = Button3Click
    end
    object Edit4: TEdit
      Left = 8
      Top = 144
      Width = 153
      Height = 26
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      MaxLength = 6
      ParentFont = False
      TabOrder = 4
    end
    object Edit3: TEdit
      Left = 104
      Top = 96
      Width = 121
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      PasswordChar = '*'
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 104
      Top = 16
      Width = 121
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      MaxLength = 16
      TabOrder = 1
      OnChange = Edit1Change
    end
    object Edit2: TEdit
      Left = 104
      Top = 72
      Width = 121
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      PasswordChar = '*'
      TabOrder = 2
    end
    object Button1: TButton
      Left = 8
      Top = 176
      Width = 217
      Height = 25
      Caption = #54924#50896' '#44032#51077
      Enabled = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 40
      Width = 217
      Height = 25
      Caption = #51473#48373#54869#51064
      TabOrder = 5
      OnClick = Button2Click
    end
  end
end
