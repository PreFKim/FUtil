object Form3rdPartyEditor: TForm3rdPartyEditor
  Left = 260
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '3rd-party controls names'
  ClientHeight = 524
  ClientWidth = 746
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 440
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  object sBitBtn2: TsSpeedButton
    Left = 26
    Top = 487
    Width = 53
    Height = 25
    Caption = 'New'
    Flat = True
    OnClick = sBitBtn2Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sBitBtn3: TsSpeedButton
    Left = 134
    Top = 487
    Width = 73
    Height = 25
    Caption = 'Delete'
    Flat = True
    OnClick = sBitBtn3Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton1: TsSpeedButton
    Left = 82
    Top = 487
    Width = 49
    Height = 25
    Caption = 'Edit'
    Enabled = False
    Flat = True
    OnClick = sSpeedButton1Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton4: TsSpeedButton
    Left = 380
    Top = 487
    Width = 85
    Height = 25
    Caption = 'Save to file'
    Flat = True
    OnClick = sSpeedButton4Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton5: TsSpeedButton
    Left = 470
    Top = 487
    Width = 85
    Height = 25
    Caption = 'Load from file'
    Flat = True
    OnClick = sSpeedButton5Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton6: TsSpeedButton
    Left = 210
    Top = 487
    Width = 74
    Height = 25
    Hint = 'Remove all rows from list'
    Caption = 'Clear all'
    Flat = True
    OnClick = sSpeedButton6Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sListView1: TsListView
    Left = 24
    Top = 24
    Width = 333
    Height = 453
    BoundLabel.Active = True
    BoundLabel.Caption = 
      'List of controls which will be skinned automatically (register s' +
      'ensitive):'
    BoundLabel.Indent = 2
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    Color = clWhite
    Columns = <
      item
        Caption = 'Control class name'
        Width = 160
      end
      item
        AutoSize = True
        Caption = 'Type of skin'
      end>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu1
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = sListView1Change
    OnColumnClick = sListView1ColumnClick
    OnDblClick = sListView1DblClick
  end
  object sBitBtn1: TsBitBtn
    Left = 664
    Top = 487
    Width = 59
    Height = 25
    Cancel = True
    Caption = 'Exit'
    TabOrder = 1
    OnClick = sBitBtn1Click
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 380
    Top = 24
    Width = 343
    Height = 453
    TabOrder = 2
    SkinData.SkinSection = 'GROUPBOX'
    object sSpeedButton2: TsSpeedButton
      Left = 176
      Top = 416
      Width = 145
      Height = 25
      Caption = 'Add selected items'
      Enabled = False
      OnClick = sSpeedButton2Click
      SkinData.SkinSection = 'SPEEDBUTTON'
    end
    object sCheckBox1: TsCheckBox
      Tag = 1
      Left = 177
      Top = 12
      Width = 20
      Height = 20
      AutoSize = False
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = sCheckBox1Click
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object sListBox1: TsListBox
      Left = 16
      Top = 32
      Width = 150
      Height = 409
      Color = clWhite
      ItemHeight = 13
      Items.Strings = (
        'Standard VCL'
        'Standard DB-aware'
        'TNT Controls'
        'Woll2Woll'
        'Virtual Controls'
        'EhLib'
        'Fast/Quick Report'
        'RXLib'
        'JVCL'
        'TMS edits'
        'SynEdits'
        'mxEdits'
        'RichViews'
        'Raize')
      ParentFont = False
      TabOrder = 0
      OnClick = sListBox1Click
      BoundLabel.Active = True
      BoundLabel.Caption = '  Packages :'
      BoundLabel.Indent = 2
      BoundLabel.Layout = sclTopLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
    object sListBox2: TsCheckListBox
      Left = 175
      Top = 32
      Width = 150
      Height = 377
      BorderStyle = bsSingle
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      BoundLabel.Active = True
      BoundLabel.Caption = '         Supported controls :'
      BoundLabel.Indent = 2
      BoundLabel.Layout = sclTopLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
  end
  object sPanel2: TsPanel
    Left = 388
    Top = 12
    Width = 327
    Height = 21
    Caption = 'Predefined controls sets'
    TabOrder = 3
    SkinData.SkinSection = 'TOOLBAR'
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 368
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 420
    Top = 4
    object Addnew1: TMenuItem
      Caption = 'Add new'
      ShortCut = 45
      OnClick = sBitBtn2Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      Enabled = False
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ShortCut = 46
      OnClick = sBitBtn3Click
    end
    object Defaultsettings1: TMenuItem
      Caption = 'Default settings'
      Visible = False
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      ShortCut = 27
      OnClick = sBitBtn1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 220
    Top = 308
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Left = 248
    Top = 308
  end
end
