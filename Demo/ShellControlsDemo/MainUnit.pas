unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.ToolWin, Vcl.ImgList,
  Vcl.Menus;

type
  TMainForm = class(TForm)
    ClientPanel: TPanel;
    LeftPanel: TPanel;
    ShellComboBox: TShellComboBox;
    ShellTreeView: TShellTreeView;
    VertSplitter: TSplitter;
    CenterPanel: TPanel;
    ShellListView: TShellListView;
    ActionList: TActionList;
    actnBack: TAction;
    actnRefresh: TAction;
    actnSorted: TAction;
    ImageList: TImageList;
    FileInfo: TPanel;
    PaintBox: TPaintBox;
    StatusBar: TStatusBar;
    RightSplitter: TSplitter;
    FileNameLabel: TLabel;
    PathLabel: TLabel;
    LastChangeLabel: TLabel;
    CreationLabel: TLabel;
    DisplayNameLabel: TLabel;
    TopPanel: TPanel;
    ToolBar: TToolBar;
    tbBack: TToolButton;
    tbRefresh: TToolButton;
    tbSorted: TToolButton;
    ViewStyle: TRadioGroup;
    tpSep: TToolButton;
    PopupMenu: TPopupMenu;
    Back1: TMenuItem;
    Refresh1: TMenuItem;
    Sorted1: TMenuItem;
    ShellChangeNotifier: TShellChangeNotifier;
    procedure ViewStyleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actnBackUpdate(Sender: TObject);
    procedure actnBackExecute(Sender: TObject);
    procedure actnRefreshExecute(Sender: TObject);
    procedure actnSortedUpdate(Sender: TObject);
    procedure actnSortedExecute(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure ShellListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ShellListViewExit(Sender: TObject);
    procedure ShellChangeNotifierChange;
  private
    procedure InitImageListIcons;
    procedure ClearFileInfo;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Winapi.CommCtrl
  , Winapi.ShlObj
  , Vcl.Shell.Utils
  , System.TypInfo
  ;

type
  TNTFolders = (rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu, rfCommonStartup);

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: TViewStyle;
  LViewStyleName: string;
begin
  for I := Low(TViewStyle) to High(TViewStyle) do
  begin
    LViewStyleName := GetEnumName(TypeInfo(TViewStyle), Ord(I));
    ViewStyle.Items.Add(LViewStyleName);
  end;
  ViewStyle.ItemIndex := 0;

  Caption := Application.Title;
  ClearFileInfo;
  InitImageListIcons;
  DisplayNameLabel.Font.Height := Round(Self.Font.Height * 1.6);
  DisplayNameLabel.Font.Style := [TFontStyle.fsBold];
  PathLabel.Font.Height := Round(Self.Font.Height * 1.2);
end;

procedure TMainForm.InitImageListIcons;
begin
  ;
end;

procedure TMainForm.ShellChangeNotifierChange;
begin
  actnRefresh.Execute;
end;

procedure TMainForm.ShellListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  LFileName: TFileName;
  LFileType: string;
  LCreation, LChanged: TDateTime;
  LFolder: TShellFolder;
begin
  LFolder := ShellListView.SelectedFolder;
  if Assigned(LFolder) then
  begin
    DisplayNameLabel.Caption := LFolder.DisplayName;
    StatusBar.SimpleText := LFolder.PathName;
    if LFolder.IsFolder then
    begin
      FileNameLabel.Caption := '';
      PathLabel.Caption := LFolder.PathName;
      LastChangeLabel.Caption := '';
      CreationLabel.Caption := '';
    end
    else
    begin
      LFileName := LFolder.PathName;
      FileNameLabel.Caption := ExtractFileName(LFolder.PathName);
      PathLabel.Caption := ExtractFilePath(LFolder.PathName);
      GetFileSummary(LFileName, LFileType, LCreation, LChanged);
      LastChangeLabel.Caption := Format('Last Changed: %s', [DateTimeToStr(LChanged)]);
      CreationLabel.Caption := Format('Creation Date: %s', [DateTimeToStr(LCreation)]);
    end;
  end
  else
    ClearFileInfo;
  PaintBox.Invalidate;
end;

procedure TMainForm.ShellListViewExit(Sender: TObject);
begin
  ClearFileInfo;
  PaintBox.Invalidate;
end;

procedure TMainForm.PaintBoxPaint(Sender: TObject);
var
  LFolder: TShellFolder;
  LIcon: TIcon;
  LRect: TRect;
  LItem: PItemIDLIst;
begin
  LRect := TRect.Create(0,0,PaintBox.Width,PaintBox.Height);
  LIcon := TIcon.Create;
  try
    //Retrieve Icon from current file
    LFolder := ShellListView.SelectedFolder;
    if Assigned(LFolder) and ShellListView.Focused then
    begin
      LItem := LFolder.AbsoluteID;
      LIcon.Handle := GetAssociatedIcon(LItem, True, False);
      PaintBox.Canvas.StretchDraw(LRect, LIcon);
    end
    else
    begin
      PaintBox.Canvas.Brush.Color := FileInfo.Color;
      PaintBox.Canvas.Pen.Style := psSolid;
      PaintBox.Canvas.FillRect(LRect);
    end;
  finally
    LIcon.Free;
  end;
end;

procedure TMainForm.ViewStyleClick(Sender: TObject);
begin
  ShellListView.ViewStyle := TViewStyle(ViewStyle.ItemIndex);
end;

procedure TMainForm.actnBackUpdate(Sender: TObject);
begin
  actnBack.Enabled := (ShellTreeView.SelectedFolder <> nil) and
    (ShellTreeView.SelectedFolder.Level > 0);
end;

procedure TMainForm.actnBackExecute(Sender: TObject);
begin
    ShellListView.Back();
end;

procedure TMainForm.actnRefreshExecute(Sender: TObject);
begin
    ShellListView.Refresh();
end;

procedure TMainForm.actnSortedUpdate(Sender: TObject);
begin
  actnSorted.Checked := ShellListView.Sorted;
end;

procedure TMainForm.ClearFileInfo;
begin
  DisplayNameLabel.Caption := '';
  FileNameLabel.Caption := '';
  PathLabel.Caption := '';
  LastChangeLabel.Caption := '';
  CreationLabel.Caption := '';
end;

procedure TMainForm.actnSortedExecute(Sender: TObject);
begin
  ShellListView.Sorted := actnSorted.Checked;
end;

initialization
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

end.
