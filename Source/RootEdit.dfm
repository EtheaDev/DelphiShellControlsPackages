object RootPathEditDlg: TRootPathEditDlg
  Left = 446
  Top = 190
  Caption = 'Select Root Path'
  ClientHeight = 217
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    424
    217)
  PixelsPerInch = 96
  TextHeight = 17
  object StandardGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 404
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    DesignSize = (
      404
      80)
    object cbFolderType: TComboBox
      Left = 20
      Top = 30
      Width = 364
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object rbUseFolder: TRadioButton
      Left = 20
      Top = 4
      Width = 155
      Height = 21
      Caption = 'Use Standard &Folder'
      TabOrder = 1
      OnClick = rbUseFolderClick
    end
  end
  object PathGroupBox: TGroupBox
    Left = 8
    Top = 94
    Width = 404
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    DesignSize = (
      404
      70)
    object ePath: TEdit
      Left = 17
      Top = 31
      Width = 327
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'C:\'
    end
    object btnBrowse: TButton
      Left = 350
      Top = 30
      Width = 34
      Height = 30
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object rbUsePath: TRadioButton
      Left = 20
      Top = 4
      Width = 90
      Height = 21
      Caption = 'Use &Path'
      TabOrder = 2
      OnClick = rbUsePathClick
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 176
    Width = 424
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      424
      41)
    object OKButton: TButton
      Left = 222
      Top = 5
      Width = 92
      Height = 31
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object CancelButton: TButton
      Left = 320
      Top = 5
      Width = 92
      Height = 31
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = CancelButtonClick
    end
  end
end
