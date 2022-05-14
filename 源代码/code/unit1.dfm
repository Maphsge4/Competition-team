object LoginForm: TLoginForm
  Left = 982
  Top = 194
  Caption = #30331#24405' '
  ClientHeight = 379
  ClientWidth = 479
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 128
    Width = 42
    Height = 13
    Caption = #29992#25143#21517'  '
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 120
    Top = 176
    Width = 30
    Height = 13
    Caption = #23494#30721'  '
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 147
    Top = 32
    Width = 192
    Height = 33
    Caption = #31454#36187#32452#38431#31995#32479
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = #40657#20307
    Font.Style = []
    ParentFont = False
  end
  object ButtonLogin: TButton
    Left = 120
    Top = 304
    Width = 75
    Height = 25
    Caption = #30331#24405
    TabOrder = 0
    OnClick = ButtonLoginClick
  end
  object ButtonRegister: TButton
    Left = 294
    Top = 304
    Width = 75
    Height = 25
    Caption = #27880#20876
    TabOrder = 1
    OnClick = ButtonRegisterClick
  end
  object EditName: TEdit
    Left = 248
    Top = 125
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object EditPassword: TEdit
    Left = 248
    Top = 173
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object RadioGroup1: TRadioGroup
    Left = 120
    Top = 232
    Width = 249
    Height = 49
    Caption = #30331#24405#35282#33394
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #23398#29983
      #31649#29702#21592)
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 389
    Top = 360
    Width = 88
    Height = 17
    Caption = #24320#21457#32773#65306#40635#26216#32724
    TabOrder = 5
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data' +
      ' Source=dataMySQL;Initial Catalog=mycomp'
    DefaultDatabase = 'mycomp'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 424
    Top = 56
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 432
    Top = 120
  end
end
