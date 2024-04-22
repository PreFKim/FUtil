object Form4: TForm4
  Left = 283
  Top = 132
  AutoScroll = False
  Caption = 'FBrowser ('#49884#44036#44228#49328#51473')'
  ClientHeight = 531
  ClientWidth = 1155
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 37
    Width = 1160
    Height = 497
    ActivePage = TabSheet1
    MultiLine = True
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = #12288
      object WebBrowser1: TWebBrowser
        Left = 0
        Top = 32
        Width = 1153
        Height = 433
        TabStop = False
        TabOrder = 0
        OnProgressChange = WebBrowser1ProgressChange
        ControlData = {
          4C0000002A770000C02C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E12620E000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Button1: TButton
        Left = 1056
        Top = 8
        Width = 95
        Height = 20
        Caption = #54869#51064
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 8
        Top = 8
        Width = 41
        Height = 20
        Caption = #9664
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 48
        Top = 8
        Width = 41
        Height = 20
        Caption = #9654
        TabOrder = 3
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 96
        Top = 8
        Width = 73
        Height = 20
        Caption = #49352#47196#44256#52840
        TabOrder = 4
        OnClick = Button4Click
      end
      object ProgressBar1: TProgressBar
        Left = 966
        Top = 0
        Width = 179
        Height = 8
        TabOrder = 5
      end
      object ComboBox1: TComboBox
        Left = 176
        Top = 8
        Width = 873
        Height = 21
        BiDiMode = bdLeftToRight
        ItemHeight = 13
        ParentBiDiMode = False
        TabOrder = 6
        OnEnter = ComboBox1Enter
        OnKeyDown = ComboBox1KeyDown
      end
    end
    object TabSheet2: TTabSheet
      ImageIndex = 1
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 1160
    Height = 37
    TabOrder = 1
    object favoriteallpage: TLabel
      Left = 552
      Top = 50
      Width = 6
      Height = 13
      Caption = '1'
    end
    object favoritenowpage: TLabel
      Left = 560
      Top = 50
      Width = 6
      Height = 13
      Caption = '1'
    end
    object favoritebutton1: TButton
      Left = 8
      Top = 8
      Width = 218
      Height = 25
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = favoritebutton1Click
    end
    object favoritebutton2: TButton
      Left = 224
      Top = 8
      Width = 218
      Height = 25
      PopupMenu = PopupMenu2
      TabOrder = 1
      OnClick = favoritebutton2Click
    end
    object favoritebutton3: TButton
      Left = 440
      Top = 8
      Width = 218
      Height = 25
      PopupMenu = PopupMenu3
      TabOrder = 2
      OnClick = favoritebutton3Click
    end
    object favoritebutton4: TButton
      Left = 656
      Top = 8
      Width = 218
      Height = 25
      PopupMenu = PopupMenu4
      TabOrder = 3
      OnClick = favoritebutton4Click
    end
    object favoritebutton5: TButton
      Left = 872
      Top = 8
      Width = 218
      Height = 25
      PopupMenu = PopupMenu5
      TabOrder = 4
      OnClick = favoritebutton5Click
    end
    object towordfavorite: TButton
      Left = 1128
      Top = 8
      Width = 25
      Height = 25
      Caption = #9654
      Enabled = False
      TabOrder = 5
      OnClick = towordfavoriteClick
    end
    object backwordfavorite: TButton
      Left = 1104
      Top = 8
      Width = 25
      Height = 25
      Caption = #9664
      Enabled = False
      TabOrder = 6
      OnClick = backwordfavoriteClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 32
    Width = 225
    Height = 97
    Caption = #49688#51221
    TabOrder = 2
    Visible = False
    object buttonnumber: TLabel
      Left = 184
      Top = 100
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 209
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 8
      Top = 40
      Width = 209
      Height = 21
      TabOrder = 1
    end
    object Button5: TButton
      Left = 8
      Top = 64
      Width = 75
      Height = 25
      Caption = #49688#51221
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 140
      Top = 64
      Width = 75
      Height = 25
      Caption = #52712#49548
      TabOrder = 3
      OnClick = Button6Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 60
    object n1: TMenuItem
      Caption = #51600#44200#52286#44592' '#52628#44032
      OnClick = n1Click
    end
    object n2: TMenuItem
      Caption = #50741#49496
      object N3: TMenuItem
        Caption = #52572#44540#50640' '#44036#49324#51060#53944
        OnClick = N3Click
      end
    end
  end
  object hotkeytimer: TTimer
    Interval = 500
    OnTimer = hotkeytimerTimer
    Left = 32
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 96
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
  object PopupMenu1: TPopupMenu
    Left = 164
    Top = 65533
    object N4: TMenuItem
      Caption = #51060#46041
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #49688#51221
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #49325#51228
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #52712#49548
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 200
    object N8: TMenuItem
      Caption = #50676#44592
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = #49688#51221
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #49325#51228
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #52712#49548
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 232
    object MenuItem1: TMenuItem
      Caption = #50676#44592
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = #49688#51221
      OnClick = MenuItem2Click
    end
    object MenuItem3: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem3Click
    end
    object MenuItem4: TMenuItem
      Caption = #52712#49548
    end
  end
  object PopupMenu4: TPopupMenu
    Left = 264
    object MenuItem5: TMenuItem
      Caption = #50676#44592
      OnClick = MenuItem5Click
    end
    object MenuItem6: TMenuItem
      Caption = #49688#51221
      OnClick = MenuItem6Click
    end
    object MenuItem7: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem7Click
    end
    object MenuItem8: TMenuItem
      Caption = #52712#49548
    end
  end
  object PopupMenu5: TPopupMenu
    Left = 304
    object MenuItem9: TMenuItem
      Caption = #50676#44592
      OnClick = MenuItem9Click
    end
    object MenuItem10: TMenuItem
      Caption = #49688#51221
      OnClick = MenuItem10Click
    end
    object MenuItem11: TMenuItem
      Caption = #49325#51228
      OnClick = MenuItem11Click
    end
    object MenuItem12: TMenuItem
      Caption = #52712#49548
    end
  end
end
