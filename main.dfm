object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 282
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline Frame11: TFrame1
    Left = 8
    Top = 37
    Width = 320
    Height = 240
    Color = clAppWorkSpace
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 37
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 8
    Width = 158
    Height = 23
    Caption = 'Please select your seats'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Myriad Pro'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object gridTickets: TStringGrid
    Left = 331
    Top = 37
    Width = 414
    Height = 134
    BiDiMode = bdLeftToRight
    DefaultColWidth = 81
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentBiDiMode = False
    TabOrder = 2
    OnMouseDown = gridTicketsMouseDown
  end
  object StaticText2: TStaticText
    Left = 331
    Top = 8
    Width = 63
    Height = 23
    Caption = 'Ticket(s):'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Myriad Pro'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object addticketBtn: TButton
    Left = 670
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Add Ticket'
    TabOrder = 4
    OnClick = addticketBtnClick
  end
  object proceedBtn: TButton
    Left = 601
    Top = 247
    Width = 144
    Height = 27
    Caption = 'Proceed'
    TabOrder = 7
  end
  object StaticText3: TStaticText
    Left = 382
    Top = 183
    Width = 99
    Height = 20
    Caption = 'Guest'#39's full name:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Myriad Pro'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object guestnameEdit: TEdit
    Left = 382
    Top = 202
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object StaticText4: TStaticText
    Left = 537
    Top = 183
    Width = 88
    Height = 20
    Caption = 'Phone number:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Myriad Pro'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object phonenumEdit: TEdit
    Left = 537
    Top = 202
    Width = 107
    Height = 21
    TabOrder = 6
  end
  object mainConnection: TSQLConnection
    DriverName = 'Sqlite'
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver210.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver210.bpl'
      'FailIfMissing=True'
      'Database=main.db')
    Left = 256
    Top = 240
  end
end