object Form4: TForm4
  Left = 788
  Top = 138
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #35774#32622
  ClientHeight = 452
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 24
    Top = 17
    Width = 345
    Height = 65
    Caption = #20851#20110
    TabOrder = 0
    object Label1: TLabel
      Left = 88
      Top = 16
      Width = 161
      Height = 13
      AutoSize = False
      Caption = #29256#26412#65306'DesktopX 1.1  Build1201'
    end
    object Label2: TLabel
      Left = 248
      Top = 48
      Width = 88
      Height = 13
      AutoSize = False
      Caption = 'Author:Grant Liu'
    end
  end
  object GroupBox2: TGroupBox
    Left = 24
    Top = 168
    Width = 345
    Height = 105
    Caption = #22825#27668
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #26356#26032#38388#38548#65306
    end
    object Label4: TLabel
      Left = 136
      Top = 24
      Width = 57
      Height = 13
      AutoSize = False
      Caption = #20998#38047
    end
    object Label7: TLabel
      Left = 8
      Top = 56
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #22320#21306#65306
    end
    object Label8: TLabel
      Left = 104
      Top = 56
      Width = 12
      Height = 13
      Caption = #30465
    end
    object Label9: TLabel
      Left = 184
      Top = 56
      Width = 25
      Height = 13
      AutoSize = False
      Caption = #24066
    end
    object Label10: TLabel
      Left = 8
      Top = 80
      Width = 329
      Height = 13
      AutoSize = False
      Caption = #35831#21153#24517#22312#30465#24066#20013#36755#20837#24744#25152#22312#22320#21306#30340#27721#35821#25340#38899#65281
    end
    object Edit1: TEdit
      Left = 80
      Top = 16
      Width = 49
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 3
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
    object Edit3: TEdit
      Left = 48
      Top = 48
      Width = 49
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 30
      TabOrder = 1
      OnKeyPress = Edit3KeyPress
    end
    object Edit4: TEdit
      Left = 128
      Top = 48
      Width = 49
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 30
      TabOrder = 2
      OnKeyPress = Edit4KeyPress
    end
  end
  object GroupBox3: TGroupBox
    Left = 24
    Top = 296
    Width = 345
    Height = 65
    Caption = #32929#24066
    TabOrder = 2
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #26356#26032#38388#38548#65306
    end
    object Label6: TLabel
      Left = 136
      Top = 24
      Width = 12
      Height = 13
      AutoSize = False
      Caption = #31186
    end
    object Edit2: TEdit
      Left = 80
      Top = 16
      Width = 49
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 3
      TabOrder = 0
      OnKeyPress = Edit2KeyPress
    end
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 384
    Width = 129
    Height = 17
    Caption = #24320#26426#33258#21160#21551#21160
    TabOrder = 3
  end
  object Button2: TButton
    Left = 272
    Top = 376
    Width = 97
    Height = 33
    Caption = #30830#23450
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox4: TGroupBox
    Left = 24
    Top = 88
    Width = 345
    Height = 73
    Caption = #25972#28857#25253#26102
    TabOrder = 5
    object Label11: TLabel
      Left = 224
      Top = 32
      Width = 12
      Height = 13
      Caption = #33267
    end
    object Label12: TLabel
      Left = 288
      Top = 32
      Width = 12
      Height = 13
      Caption = #26102
    end
    object Edit5: TEdit
      Left = 184
      Top = 32
      Width = 33
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 2
      TabOrder = 0
      OnKeyPress = Edit5KeyPress
    end
    object Edit6: TEdit
      Left = 248
      Top = 32
      Width = 33
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      MaxLength = 2
      TabOrder = 1
      OnKeyPress = Edit6KeyPress
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 32
      Width = 137
      Height = 17
      Caption = #24320#21551#25972#28857#25253#26102
      TabOrder = 2
      OnClick = CheckBox2Click
    end
  end
end
