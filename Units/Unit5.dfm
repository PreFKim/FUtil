object Form5: TForm5
  Left = 1015
  Top = 700
  Width = 610
  Height = 280
  AutoSize = True
  Caption = #51600#44200#52286#44592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button37: TButton
    Left = 0
    Top = 0
    Width = 289
    Height = 25
    Caption = #50676#44592
    TabOrder = 1
    OnClick = Button37Click
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 594
    Height = 241
    TabOrder = 0
    object ListView1: TListView
      Left = 8
      Top = 40
      Width = 577
      Height = 161
      Columns = <
        item
          Caption = #49324#51060#53944' '#51060#47492
          Width = 287
        end
        item
          Caption = #51452#49548
          Width = 286
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 3
      ViewStyle = vsReport
      OnChange = ListView1Change
    end
    object Edit15: TEdit
      Left = 8
      Top = 8
      Width = 129
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
      Text = #49324#51060#53944' '#51060#47492
    end
    object Edit16: TEdit
      Left = 144
      Top = 8
      Width = 353
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 1
      Text = #49324#51060#53944' '#51452#49548
    end
    object Button39: TButton
      Left = 504
      Top = 8
      Width = 81
      Height = 25
      Caption = #52628#44032
      TabOrder = 2
      OnClick = Button39Click
    end
    object Button1: TButton
      Left = 8
      Top = 208
      Width = 577
      Height = 25
      Caption = #49325#51228
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
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
  end
end
