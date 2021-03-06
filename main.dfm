object bookingForm: TbookingForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Corinda Fashion Show - Book a Ticket'
  ClientHeight = 292
  ClientWidth = 757
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline Frame11: TFrame1
    Left = 10
    Top = 37
    Width = 320
    Height = 240
    Color = clAppWorkSpace
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitLeft = 10
    ExplicitTop = 37
  end
  object select_seatLbl: TStaticText
    Left = 8
    Top = 8
    Width = 168
    Height = 23
    Caption = 'Please select your seat(s)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Myriad Pro'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object gridTickets: TStringGrid
    Left = 333
    Top = 37
    Width = 414
    Height = 191
    BiDiMode = bdLeftToRight
    DefaultColWidth = 81
    FixedCols = 0
    RowCount = 7
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentBiDiMode = False
    TabOrder = 2
    OnMouseDown = gridTicketsMouseDown
  end
  object StaticText2: TStaticText
    Left = 333
    Top = 11
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
    Left = 576
    Top = 251
    Width = 98
    Height = 25
    Caption = 'Add Ticket'
    TabOrder = 4
    OnClick = addticketBtnClick
  end
  object proceedBtn: TButton
    Left = 680
    Top = 250
    Width = 69
    Height = 27
    Caption = 'Proceed'
    TabOrder = 7
    OnClick = proceedBtnClick
  end
  object StaticText3: TStaticText
    Left = 336
    Top = 234
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
    Left = 336
    Top = 253
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object StaticText4: TStaticText
    Left = 463
    Top = 234
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
    Left = 463
    Top = 253
    Width = 107
    Height = 21
    TabOrder = 6
  end
end
