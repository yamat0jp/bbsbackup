object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    635
    299)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 504
    Top = 32
    Width = 90
    Height = 25
    Action = FileOpen1
    Anchors = [akTop, akRight]
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 280
    Width = 635
    Height = 19
    Panels = <>
  end
  object Button2: TButton
    Left = 504
    Top = 80
    Width = 90
    Height = 25
    Action = Action1
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object Button3: TButton
    Left = 504
    Top = 128
    Width = 90
    Height = 25
    Action = FileExit1
    Anchors = [akTop, akRight]
    TabOrder = 3
  end
  object Button4: TButton
    Left = 504
    Top = 176
    Width = 90
    Height = 25
    Action = delete
    Anchors = [akTop, akRight]
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 457
    Height = 280
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 5
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 455
      Height = 189
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Memo1: TMemo
      Left = 1
      Top = 190
      Width = 455
      Height = 89
      Align = alBottom
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitTop = 185
    end
  end
  object ActionList1: TActionList
    Left = 312
    Top = 64
    object FileOpen1: TFileOpen
      Category = #12501#12449#12452#12523
      Caption = #38283#12367'(&O)...'
      Dialog.DefaultExt = 'txt'
      Dialog.Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
      Hint = #38283#12367'|'#26082#23384#12398#12501#12449#12452#12523#12434#38283#12365#12414#12377
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen1Accept
    end
    object FileExit1: TFileExit
      Category = #12501#12449#12452#12523
      Caption = #32066#20102'(&X)'
      Hint = #32066#20102'|'#12450#12503#12522#12465#12540#12471#12519#12531#12434#32066#20102#12375#12414#12377
      ImageIndex = 43
    end
    object Action1: TAction
      Category = #12501#12449#12452#12523
      Caption = 'Action1'
      OnExecute = Action1Execute
    end
    object delete: TAction
      Category = #12501#12449#12452#12523
      Caption = 'delete'
      OnExecute = deleteExecute
    end
  end
  object BbsbackupConnection: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'Database=bbsdata.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 314
    Top = 152
  end
  object FDTable1: TFDTable
    Connection = BbsbackupConnection
    UpdateOptions.UpdateTableName = 'bbs'
    TableName = 'bbs'
    Left = 120
    Top = 152
    object FDTable1dbname: TStringField
      FieldName = 'dbname'
    end
    object FDTable1number: TIntegerField
      FieldName = 'number'
    end
    object FDTable1title: TStringField
      FieldName = 'title'
      Size = 80
    end
    object FDTable1name: TStringField
      FieldName = 'name'
    end
    object FDTable1date: TDateTimeField
      FieldName = 'date'
    end
    object FDTable1raw: TMemoField
      FieldName = 'raw'
      BlobType = ftMemo
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 192
    Top = 152
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 192
    Top = 64
  end
  object BindSourceDB1: TBindSourceDB
    DataSet = FDTable1
    ScopeMappings = <>
    Left = 312
    Top = 224
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 20
    Top = 5
    object LinkControlToField1: TLinkControlToField
      Category = #12463#12452#12483#12463' '#12496#12452#12531#12487#12451#12531#12464
      DataSource = BindSourceDB1
      FieldName = 'RAW'
      Control = Memo1
      Track = False
    end
  end
end
