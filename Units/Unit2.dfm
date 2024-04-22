object Form2: TForm2
  Left = 652
  Top = 335
  Width = 681
  Height = 616
  AutoSize = True
  Caption = 'FSetups v1.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 665
    Height = 577
    Caption = 'FSetups'
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 8
      Top = 16
      Width = 385
      Height = 137
      Caption = #44221#47196
      TabOrder = 0
      object Edit1: TEdit
        Left = 8
        Top = 44
        Width = 369
        Height = 21
        ReadOnly = True
        TabOrder = 0
        Text = 'C:\'
      end
      object Button3: TButton
        Left = 8
        Top = 72
        Width = 369
        Height = 25
        Caption = #48320#44221
        TabOrder = 1
        OnClick = Button3Click
      end
      object Edit3: TEdit
        Left = 8
        Top = 16
        Width = 369
        Height = 21
        TabOrder = 2
        Text = #54260#45908#51060#47492
      end
      object Button9: TButton
        Left = 8
        Top = 104
        Width = 369
        Height = 25
        Caption = #52572#44540' '#51200#51109#44050' '#52488#44592#54868
        TabOrder = 3
        OnClick = Button9Click
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 153
      Width = 385
      Height = 216
      Caption = #45796#50868#47196#46300'('#45796#50868#48155#51012' '#54028#51068#53356#44592':0KB)'
      TabOrder = 1
      object Button1: TButton
        Left = 8
        Top = 184
        Width = 185
        Height = 25
        Caption = #51200#51109
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 192
        Top = 184
        Width = 185
        Height = 25
        Caption = #48520#47084#50724#44592
        TabOrder = 1
        OnClick = Button2Click
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 16
        Width = 369
        Height = 161
        Caption = #45796#50868#47196#46300#47532#49828#53944'(HTTPS'#51648#50896'X)('#52628#52380':'#51060#44544#47336#49828#48660#47196#44536')'
        TabOrder = 2
        object Edit2: TEdit
          Left = 8
          Top = 108
          Width = 176
          Height = 21
          TabOrder = 0
          Text = #45796#50868#47196#46300#51452#49548
          OnClick = Edit2Click
        end
        object Button4: TButton
          Left = 8
          Top = 132
          Width = 177
          Height = 21
          Caption = #52628#44032
          TabOrder = 1
          OnClick = Button4Click
        end
        object Button5: TButton
          Left = 184
          Top = 132
          Width = 177
          Height = 21
          Caption = #51228#44144
          TabOrder = 2
          OnClick = Button5Click
        end
        object Edit4: TEdit
          Left = 184
          Top = 108
          Width = 177
          Height = 21
          TabOrder = 3
          Text = #54028#51068#51060#47492'('#54869#51109#51088#54252#54632' ex:FS.exe)'
          OnClick = Edit4Click
        end
        object ListView1: TListView
          Left = 8
          Top = 16
          Width = 353
          Height = 89
          Columns = <
            item
              Caption = #45796#50868#47196#46300#51452#49548
              Width = 270
            end
            item
              Caption = #54028#51068#51060#47492
              Width = 60
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 4
          ViewStyle = vsReport
          OnClick = ListView1Click
          OnKeyDown = ListView1KeyDown
        end
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 370
      Width = 385
      Height = 120
      Caption = #45796#50868#47196#46300' '#49345#53468'('#50948':'#51204#52404' '#54028#51068','#48145':'#54788#51228' '#54028#51068')'
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 95
        Width = 103
        Height = 19
        Caption = #45796#50868#47196#46300' '#50756#47308#54980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ProgressBar1: TProgressBar
        Left = 8
        Top = 16
        Width = 369
        Height = 17
        TabOrder = 0
      end
      object ProgressBar2: TProgressBar
        Left = 8
        Top = 40
        Width = 369
        Height = 17
        TabOrder = 1
      end
      object Button6: TButton
        Left = 8
        Top = 64
        Width = 369
        Height = 25
        Caption = #45796#50868#47196#46300
        TabOrder = 2
        OnClick = Button6Click
      end
      object CheckBox1: TCheckBox
        Left = 160
        Top = 96
        Width = 89
        Height = 17
        Caption = #54260#45908#50676#44592
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 3
      end
      object CheckBox2: TCheckBox
        Left = 256
        Top = 96
        Width = 121
        Height = 17
        Caption = #54532#47196#44536#47016#51333#47308
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
    end
    object GroupBox6: TGroupBox
      Left = 8
      Top = 491
      Width = 385
      Height = 80
      Caption = #50508#47548#54032
      TabOrder = 3
      object Button7: TButton
        Left = 8
        Top = 16
        Width = 369
        Height = 25
        Caption = #51228#51089#51088' '#48660#47196#44536
        TabOrder = 0
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 8
        Top = 48
        Width = 369
        Height = 25
        Caption = #49324#50857#48169#48277
        TabOrder = 1
        OnClick = Button8Click
      end
    end
    object GroupBox7: TGroupBox
      Left = 400
      Top = 16
      Width = 257
      Height = 554
      Caption = #51221#48372
      TabOrder = 4
      object Memo1: TMemo
        Left = 8
        Top = 16
        Width = 241
        Height = 345
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Memo2: TMemo
        Left = 8
        Top = 368
        Width = 241
        Height = 177
        Lines.Strings = (
          #50508#47548#54032
          '-'
          '-'
          '-'
          '-'
          '-'
          '-'
          '-'
          '-'
          '-'
          '-'
          '-')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    OnWork = IdHTTP1Work
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.FS'
    Filter = 'FSetups '#45796#50868#47196#46300'|*.FS'
    Left = 48
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.FS'
    Filter = 'FSetups '#45796#50868#47196#46300'|*.FS'
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
    Left = 72
  end
end
