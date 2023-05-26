{**************************************************************************}
{                                                                          }
{       Delphi Visual Component Library                                    }
{                                                                          }
{ Copyright (c) 1995-2010 Embarcadero Technologies, Inc.                   }
{                                                                          }
{ You may only use this software if you are an authorized licensee         }
{ of Delphi, C++Builder or RAD Studio (Embarcadero Products).              }
{ This software is considered a Redistributable as defined under           }
{ the software license agreement that comes with the Embarcadero Products  }
{ and is subject to that software license agreement.                       }
{                                                                          }
{**************************************************************************}
unit RootEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DesignIntf, DesignEditors, StdCtrls, ExtCtrls, ShellCtrls;

type
  TRootPathEditDlg = class(TForm)
    StandardGroupBox: TGroupBox;
    cbFolderType: TComboBox;
    PathGroupBox: TGroupBox;
    ePath: TEdit;
    btnBrowse: TButton;
    rbUseFolder: TRadioButton;
    rbUsePath: TRadioButton;
    BottomPanel: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    procedure rbUseFolderClick(Sender: TObject);
    procedure rbUsePathClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    procedure UpdateState;
  public
  end;

  TRootProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TRootEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
  end;

implementation

{$R *.dfm}

uses TypInfo, FileCtrl, Vcl.Themes, ToolsAPI, BrandingAPI
  {$IF (CompilerVersion >= 32.0)}, IDETheme.Utils{$IFEND};
resourcestring
  SPickRootPath = 'Please select a root path';
  SEditRoot = 'E&dit Root';

const
  NTFolders = [rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu,
               rfCommonStartup];

function PathIsCSIDL(Value: string): Boolean;
begin
  Result := GetEnumValue(TypeInfo(TRootFolder), Value) >= 0;
end;

function RootPathEditor(Value : string): string;
begin
  Result := Value;
  with TRootPathEditDlg.Create(Application) do
  try
    rbUseFolder.Checked := PathIsCSIDL(Result);
    rbUsePath.Checked := not rbUseFolder.Checked;
    if not PathIsCSIDL(Result) then
    begin
      cbFolderType.ItemIndex := 0;
      ePath.Text := Result;
    end
    else
      cbFolderType.ItemIndex := cbFolderType.Items.IndexOf(Result);

    UpdateState;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if rbUsePath.Checked then
        Result := ePath.Text
      else
        Result := cbFolderType.Items[cbFolderType.ItemIndex];
    end;
  finally
    Free;
  end;
end;

{ TRootProperty }

procedure TRootProperty.Edit;
begin
  SetStrValue(RootPathEditor(GetStrValue));
end;

function TRootProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{ TRootPathEditDlg }

procedure TRootPathEditDlg.FormCreate(Sender: TObject);
var
  FT: TRootFolder;
{$IF (CompilerVersion >= 32.0)}
  LStyle: TCustomStyleServices;
{$IFEND}
begin
  inherited;
{$IF (CompilerVersion >= 32.0)}
  {$IF (CompilerVersion <= 34.0)}
  if UseThemeFont then
    Self.Font.Assign(GetThemeFont);
  {$IFEND}
  {$IF CompilerVersion > 34.0}
  if TIDEThemeMetrics.Font.Enabled then
    Self.Font.Assign(TIDEThemeMetrics.Font.GetFont);
  {$IFEND}

  if ThemeProperties <> nil then
  begin
    LStyle := ThemeProperties.StyleServices;
    StyleElements := StyleElements - [seClient];
    Color := LStyle.GetSystemColor(clWindow);
    BottomPanel.StyleElements := BottomPanel.StyleElements - [seClient];
    BottomPanel.ParentBackground := False;
    BottomPanel.Color := LStyle.GetSystemColor(clBtnFace);
    IDEThemeManager.RegisterFormClass(TRootPathEditDlg);
    ThemeProperties.ApplyTheme(Self);
  end;
{$IFEND}
  for FT := Low(TRootFolder) to High(TRootFolder) do
    if not ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and (FT in NTFolders)) then
      cbFolderType.Items.Add(GetEnumName(TypeInfo(TRootFolder), Ord(FT)));
  cbFolderType.ItemIndex := 0;
end;

procedure TRootPathEditDlg.UpdateState;
begin
  cbFolderType.Enabled := rbUseFolder.Checked;
  ePath.Enabled := not rbUseFolder.Checked;
  btnBrowse.Enabled := ePath.Enabled;
end;

procedure TRootPathEditDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRootPathEditDlg.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TRootPathEditDlg.rbUseFolderClick(Sender: TObject);
begin
  rbUsePath.Checked := not rbUseFolder.Checked;
  UpdateState;
end;

procedure TRootPathEditDlg.rbUsePathClick(Sender: TObject);
begin
  rbUseFolder.Checked := not rbUsePath.Checked;
  UpdateState;
end;

procedure TRootPathEditDlg.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TRootPathEditDlg.btnBrowseClick(Sender: TObject);
var
  Path : widestring;
  Dir : string;
begin
  Path := ePath.Text;
  Dir := ePath.Text;
  if SelectDirectory( SPickRootPath, '', Dir ) then
    ePath.Text := Dir;
end;

{ TRootEditor }

procedure TRootEditor.ExecuteVerb(Index: Integer);

  procedure EditRoot;
  const
    SRoot = 'root';
  var
    Path : string;
  begin
    Path := RootPathEditor(GetPropValue(Component, SRoot, True));
    SetPropValue(Component, SRoot, Path);
    Designer.Modified;
  end;

begin

  case Index of
  0 : EditRoot;
  end;
end;

function TRootEditor.GetVerb(Index: Integer): String;
begin
  case Index of
  0 : Result := SEditRoot;
  end;
end;

function TRootEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
