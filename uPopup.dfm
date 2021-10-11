object frmPopup: TfrmPopup
  Left = 405
  Top = 350
  BorderStyle = bsNone
  Caption = 'frmPopup'
  ClientHeight = 64
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Texte: TLabel
    Left = 0
    Top = 8
    Width = 273
    Height = 25
    AutoSize = False
    Caption = 'Texte'
  end
  object Button1: TButton
    Left = 0
    Top = 40
    Width = 137
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 40
    Width = 139
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
end
