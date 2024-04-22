object Form11: TForm11
  Left = 193
  Top = 473
  Width = 241
  Height = 96
  AutoSize = True
  Caption = #48372#51312#52285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 233
    Height = 65
    Caption = #48372#51312#52285
    TabOrder = 0
    object ComboBox1: TComboBox
      Left = 8
      Top = 16
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = #47700#51064#52285
      Items.Strings = (
        #47700#51064#52285
        #45796#50868#47196#45908
        #44036#54200#49892#54665#44592
        #50937#48652#46972#50864#51200
        #50689#49345#51116#49373#44592
        #51068#51221#44288#47532#44592
        #45432#47000#51116#49373#44592
        #50508#46988
        #49444#51221)
    end
    object Button1: TButton
      Left = 152
      Top = 16
      Width = 75
      Height = 20
      Caption = #50676#44592
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 40
      Width = 217
      Height = 20
      Caption = #51333#47308
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Timer1: TTimer
    Interval = 1
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
