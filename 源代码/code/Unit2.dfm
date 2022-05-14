object RegisterForm: TRegisterForm
  Left = 1070
  Top = 416
  Caption = #27880#20876
  ClientHeight = 389
  ClientWidth = 445
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 112
    Top = 59
    Width = 42
    Height = 13
    Caption = #29992#25143#21517'  '
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 112
    Top = 99
    Width = 30
    Height = 13
    Caption = #23494#30721'  '
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 112
    Top = 179
    Width = 30
    Height = 13
    Caption = #23398#21495
    Color = clGradientInactiveCaption
    ParentColor = False
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 112
    Top = 227
    Width = 27
    Height = 13
    Caption = #23398#38498' '
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 112
    Top = 275
    Width = 39
    Height = 13
    Caption = #25163#26426#21495' '
    Layout = tlCenter
  end
  object Label6: TLabel
    Left = 112
    Top = 139
    Width = 30
    Height = 13
    Caption = #22995#21517'  '
    Layout = tlCenter
  end
  object ButtonRegister: TButton
    Left = 184
    Top = 328
    Width = 75
    Height = 25
    Caption = #27880#20876
    TabOrder = 0
    OnClick = ButtonRegisterClick
  end
  object EditName: TEdit
    Left = 214
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditPassword: TEdit
    Left = 214
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object MaskEditXh: TMaskEdit
    Left = 215
    Top = 176
    Width = 120
    Height = 21
    EditMask = '0000000000;1;_'
    MaxLength = 10
    TabOrder = 3
    Text = '          '
  end
  object MaskEditSjh: TMaskEdit
    Left = 215
    Top = 272
    Width = 120
    Height = 21
    EditMask = '00000000000;1;_'
    MaxLength = 11
    TabOrder = 4
    Text = '           '
  end
  object EditRName: TEdit
    Left = 214
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object ComboBox1: TComboBox
    Left = 215
    Top = 224
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object StaticText1: TStaticText
    Left = 288
    Top = 372
    Width = 154
    Height = 17
    Caption = #24320#21457#32773#65306#28966#33509#29738' '#40857#38632' '#23380#19990#29831
    TabOrder = 7
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 384
    Top = 120
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data' +
      ' Source=dataMysql;Initial Catalog=mycomp'
    DefaultDatabase = 'mycomp'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 384
    Top = 72
  end
end
