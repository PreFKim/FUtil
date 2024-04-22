object Form7: TForm7
  Left = 1231
  Top = 160
  AutoScroll = False
  AutoSize = True
  Caption = #49444#51221
  ClientHeight = 241
  ClientWidth = 249
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 249
    Height = 241
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #51068#48152
      object GroupBox9: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 49
        Caption = #54268#49828#53416
        TabOrder = 0
        object ComboBox2: TComboBox
          Left = 8
          Top = 20
          Width = 145
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ItemIndex = 0
          ParentFont = False
          TabOrder = 0
          Text = #49828#53416#50630#51020
          OnDblClick = ComboBox2DblClick
          Items.Strings = (
            #49828#53416#50630#51020
            'FUtil '#44592#48376#49828#53416'(Dark)'
            'FUtil '#44592#48376#49828#53416'(Bringht)'
            'FUtil '#44592#48376#49828#53416'('#44396')'
            #50952#46020#50864'8'#49828#53416'('#54868#51060#53944')'
            #50952#46020#50864'8'#49828#53416'('#48660#47001')')
        end
        object Button4: TButton
          Left = 160
          Top = 16
          Width = 75
          Height = 25
          Caption = #51201#50857
          TabOrder = 1
          OnClick = Button4Click
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 54
        Width = 241
        Height = 51
        Caption = #48148#47196#44032#44592#49373#49457
        TabOrder = 1
        object Button3: TButton
          Left = 8
          Top = 16
          Width = 111
          Height = 27
          Caption = #48148#53461#54868#47732#50640' '#49373#49457
          TabOrder = 0
          OnClick = Button3Click
        end
        object Button6: TButton
          Left = 124
          Top = 16
          Width = 111
          Height = 27
          Caption = #49884#51089#47700#45684#50640' '#49373#49457
          TabOrder = 1
          OnClick = Button6Click
        end
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 110
        Width = 241
        Height = 51
        Caption = 'FUtil '#54260#45908#50676#44592
        TabOrder = 2
        object Button2: TButton
          Left = 8
          Top = 16
          Width = 225
          Height = 27
          Caption = #50676#44592
          TabOrder = 0
          OnClick = Button2Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #54268#53356#44592
      ImageIndex = 1
      object GroupBox11: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 73
        Caption = #44036#54200#49892#54665#44592
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 16
          Width = 34
          Height = 19
          Caption = #49464#47196':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 120
          Top = 16
          Width = 34
          Height = 19
          Caption = #44032#47196':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Edit2: TEdit
          Left = 48
          Top = 16
          Width = 73
          Height = 21
          ReadOnly = True
          TabOrder = 0
          Text = '275'
        end
        object Edit3: TEdit
          Left = 160
          Top = 16
          Width = 73
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '577'
        end
        object Button7: TButton
          Left = 8
          Top = 40
          Width = 105
          Height = 25
          Caption = #44592#48376#44050
          TabOrder = 2
          OnClick = Button7Click
        end
        object Button8: TButton
          Left = 128
          Top = 40
          Width = 105
          Height = 25
          Caption = #51200#51109
          TabOrder = 3
          OnClick = Button8Click
        end
        object CheckBox1: TCheckBox
          Left = 160
          Top = 0
          Width = 73
          Height = 17
          Caption = #51088#46041#51200#51109
          TabOrder = 4
          OnClick = CheckBox1Click
        end
      end
      object GroupBox13: TGroupBox
        Left = 0
        Top = 72
        Width = 241
        Height = 73
        Caption = #50937#48652#46972#50864#51200
        TabOrder = 1
        object Label6: TLabel
          Left = 8
          Top = 16
          Width = 34
          Height = 19
          Caption = #49464#47196':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 120
          Top = 16
          Width = 34
          Height = 19
          Caption = #44032#47196':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Edit4: TEdit
          Left = 48
          Top = 16
          Width = 73
          Height = 21
          ReadOnly = True
          TabOrder = 0
          Text = '655'
        end
        object Edit5: TEdit
          Left = 160
          Top = 16
          Width = 73
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '998'
        end
        object Button9: TButton
          Left = 8
          Top = 40
          Width = 105
          Height = 25
          Caption = #44592#48376#44050
          TabOrder = 2
          OnClick = Button9Click
        end
        object Button10: TButton
          Left = 128
          Top = 40
          Width = 105
          Height = 25
          Caption = #51200#51109
          TabOrder = 3
          OnClick = Button10Click
        end
        object CheckBox2: TCheckBox
          Left = 160
          Top = 0
          Width = 73
          Height = 17
          Caption = #51088#46041#51200#51109
          TabOrder = 4
          OnClick = CheckBox2Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #49884#49828#53596
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 0
        Top = 49
        Width = 241
        Height = 51
        Caption = #50952#46020#50864' '#49892#54665#49884' '#49892#54665#50668#48512
        TabOrder = 0
        object RadioButton1: TRadioButton
          Left = 8
          Top = 16
          Width = 153
          Height = 17
          Caption = 'FUtil'#51012' '#49892#54665#54633#45768#45796'.'
          TabOrder = 0
          OnClick = RadioButton1Click
        end
        object RadioButton2: TRadioButton
          Left = 8
          Top = 32
          Width = 161
          Height = 17
          Caption = 'FUtil'#51012' '#49892#54665#54616#51648' '#50506#49845#45768#45796'.'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = RadioButton2Click
        end
        object GroupBox4: TGroupBox
          Left = 168
          Top = 8
          Width = 65
          Height = 41
          Caption = #49892#54665#50668#48512
          TabOrder = 2
          object Label1: TLabel
            Left = 24
            Top = 16
            Width = 13
            Height = 23
            Caption = 'X'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 104
        Width = 241
        Height = 51
        Caption = #51333#47308#49884' '#53944#47112#51060
        TabOrder = 1
        object GroupBox6: TGroupBox
          Left = 184
          Top = 8
          Width = 49
          Height = 41
          Caption = #50500#51060#53080
          TabOrder = 0
          object Label2: TLabel
            Left = 16
            Top = 16
            Width = 13
            Height = 23
            Caption = 'X'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object RadioButton3: TRadioButton
          Left = 8
          Top = 16
          Width = 169
          Height = 17
          Caption = #53944#47112#51060#50500#51060#53080#51012' '#49324#50857#54633#45768#45796'.'
          TabOrder = 1
          OnClick = RadioButton3Click
        end
        object RadioButton4: TRadioButton
          Left = 8
          Top = 32
          Width = 169
          Height = 17
          Caption = #49324#50857#54616#51648#50506#44256' '#51333#47308#54633#45768#45796'.'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = RadioButton4Click
        end
      end
      object GroupBox10: TGroupBox
        Left = 0
        Top = 2
        Width = 241
        Height = 45
        Caption = #49444#52824#54260#45908
        TabOrder = 2
        object Button5: TButton
          Left = 160
          Top = 16
          Width = 75
          Height = 25
          Caption = #48320#44221
          TabOrder = 0
          OnClick = Button5Click
        end
        object Edit1: TEdit
          Left = 8
          Top = 19
          Width = 137
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = 'C:\Windows\FUtil\'
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 156
        Width = 241
        Height = 49
        Caption = #54532#47196#44536#47016#51012' '#53420#49884' '#53020#51656#44163
        TabOrder = 3
        object Button1: TButton
          Left = 158
          Top = 16
          Width = 75
          Height = 25
          Caption = #51201#50857
          TabOrder = 0
          OnClick = Button1Click
        end
        object ComboBox1: TComboBox
          Left = 8
          Top = 20
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = '-'#50630#51020'-'
          OnDblClick = ComboBox1DblClick
          Items.Strings = (
            '-'#50630#51020'-'
            #45796#50868#47196#45908
            #44036#54200#49892#54665#44592
            #50937#48652#46972#50864#51200
            #50689#49345#51116#49373#44592
            #51068#51221#44288#47532#44592
            #45432#47000#51116#49373#44592
            #50508#46988)
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #53364#46972#50864#46300
      ImageIndex = 3
      object GroupBox14: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 49
        Caption = #44036#54200#49892#54665#44592'('#47196#44536#51064#54596#50836')'
        Enabled = False
        TabOrder = 0
        object Button11: TButton
          Left = 8
          Top = 16
          Width = 113
          Height = 25
          Caption = #51200#51109#54616#44592
          TabOrder = 0
          OnClick = Button11Click
        end
        object Button12: TButton
          Left = 128
          Top = 16
          Width = 107
          Height = 25
          Caption = #48520#47084#50724#44592
          TabOrder = 1
          OnClick = Button12Click
        end
      end
      object Memo1: TMemo
        Left = 8
        Top = 216
        Width = 225
        Height = 17
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
      end
      object ListView1: TListView
        Left = 8
        Top = 216
        Width = 225
        Height = 16
        Columns = <
          item
          end
          item
          end>
        TabOrder = 2
        ViewStyle = vsReport
        Visible = False
      end
      object GroupBox15: TGroupBox
        Left = 0
        Top = 54
        Width = 241
        Height = 49
        Caption = #50508#46988'('#47196#44536#51064#54596#50836')'
        Enabled = False
        TabOrder = 3
        object Button13: TButton
          Left = 8
          Top = 16
          Width = 113
          Height = 25
          Caption = #51200#51109#54616#44592
          TabOrder = 0
        end
        object Button14: TButton
          Left = 128
          Top = 16
          Width = 105
          Height = 25
          Caption = #48520#47084#50724#44592
          TabOrder = 1
        end
      end
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
    Top = 16
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
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
    Left = 24
    Top = 16
  end
end
