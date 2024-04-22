object Form9: TForm9
  Left = 429
  Top = 177
  Width = 649
  Height = 424
  AutoSize = True
  Caption = #51068#51221#44288#47532#44592
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
    Width = 641
    Height = 393
    Caption = #51068#51221#54364
    TabOrder = 0
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 185
      Height = 21
      ReadOnly = True
      TabOrder = 8
      Text = #49884#44036
      Visible = False
    end
    object Memo2: TMemo
      Left = 8
      Top = 40
      Width = 185
      Height = 313
      Lines.Strings = (
        #49688#51221)
      ScrollBars = ssVertical
      TabOrder = 7
      Visible = False
    end
    object DateTimePicker1: TDateTimePicker
      Left = 8
      Top = 16
      Width = 186
      Height = 21
      Date = 41708.748415335650000000
      Time = 41708.748415335650000000
      TabOrder = 0
    end
    object Button1: TButton
      Left = 552
      Top = 16
      Width = 79
      Height = 21
      Caption = #49352#47196#44256#52840
      TabOrder = 1
      OnClick = Button1Click
    end
    object Memo1: TMemo
      Left = 8
      Top = 40
      Width = 186
      Height = 313
      Lines.Strings = (
        #51068#51221#54364)
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object Button2: TButton
      Left = 200
      Top = 16
      Width = 75
      Height = 21
      Caption = #52628#44032#54616#44592
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 288
      Top = 16
      Width = 75
      Height = 21
      Caption = #49325#51228#54616#44592
      TabOrder = 4
      OnClick = Button3Click
    end
    object ListView1: TListView
      Left = 200
      Top = 40
      Width = 433
      Height = 313
      Columns = <
        item
          AutoSize = True
          Caption = #45216#51676
        end
        item
          AutoSize = True
          Caption = #51068#51221
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 5
      ViewStyle = vsReport
    end
    object Button4: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 21
      Caption = #49688#51221#54616#44592
      TabOrder = 6
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 464
      Top = 16
      Width = 75
      Height = 21
      Caption = #49688#51221#52712#49548
      Enabled = False
      TabOrder = 9
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 8
      Top = 360
      Width = 625
      Height = 25
      Caption = #50724#45720' '#51068#51221' '#54869#51064
      TabOrder = 10
      OnClick = Button6Click
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
