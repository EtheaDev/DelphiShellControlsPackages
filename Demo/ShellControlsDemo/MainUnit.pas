unit MainUnit;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Shell.ShellCtrls, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.ToolWin, Vcl.ImgList,
  Vcl.Menus, System.ImageList;

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
    RefreshTimer: TTimer;
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
    procedure RefreshTimerTimer(Sender: TObject);
  private
    FRefreshing: Boolean;
    FWatchedPath: string;
    procedure InitImageListIcons;
    procedure ClearFileInfo;
    procedure EnableNativeDoubleBuffer;
    procedure SyncNotifierRoot;
    procedure RefreshListKeepSelection;
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
  EnableNativeDoubleBuffer;
end;

const
  //Defined here because older CommCtrl units may not have them
  LVS_EX_DOUBLEBUFFER_ = $00010000;
  TVS_EX_DOUBLEBUFFER_ = $0004;
  TVM_SETEXTENDEDSTYLE_ = TV_FIRST + 44;

procedure TMainForm.EnableNativeDoubleBuffer;
begin
  //Let Windows itself paint the list and the tree off-screen (no flicker,
  //no VCL DoubleBuffered side effects on common controls)
  SendMessage(ShellListView.Handle, LVM_SETEXTENDEDLISTVIEWSTYLE,
    LVS_EX_DOUBLEBUFFER_, LVS_EX_DOUBLEBUFFER_);
  SendMessage(ShellTreeView.Handle, TVM_SETEXTENDEDSTYLE_,
    TVS_EX_DOUBLEBUFFER_, TVS_EX_DOUBLEBUFFER_);
end;

procedure TMainForm.SyncNotifierRoot;
var
  LFolder: TShellFolder;
  LPath: string;
begin
  //Watch only the folder that is shown, not the whole C:\ drive
  LPath := '';
  LFolder := ShellTreeView.SelectedFolder;
  if Assigned(LFolder) then
    LPath := LFolder.PathName;
  if (LPath <> '') and not DirectoryExists(LPath) then
    LPath := ''; //virtual folder (This PC, Network...) - nothing to watch
  if SameText(LPath, FWatchedPath) then
    Exit;
  FWatchedPath := LPath;
  RefreshTimer.Enabled := False;
  if FWatchedPath <> '' then
    ShellChangeNotifier.Root := FWatchedPath;
end;

procedure TMainForm.RefreshListKeepSelection;
var
  LSelName: string;
  I: Integer;
begin
  if FRefreshing then
    Exit;
  FRefreshing := True;
  try
    LSelName := '';
    if Assigned(ShellListView.Selected) then
      LSelName := ShellListView.Selected.Caption;
    ShellListView.Items.BeginUpdate;
    try
      ShellListView.Refresh;
    finally
      ShellListView.Items.EndUpdate;
    end;
    EnableNativeDoubleBuffer;
    if LSelName <> '' then
      for I := 0 to ShellListView.Items.Count - 1 do
        if SameText(ShellListView.Items[I].Caption, LSelName) then
        begin
          ShellListView.Items[I].Selected := True;
          ShellListView.Items[I].Focused := True;
          ShellListView.Items[I].MakeVisible(False);
          Break;
        end;
  finally
    FRefreshing := False;
  end;
end;

procedure TMainForm.RefreshTimerTimer(Sender: TObject);
begin
  RefreshTimer.Enabled := False;
  RefreshListKeepSelection;
end;

procedure TMainForm.InitImageListIcons;
begin
  ;
end;

procedure TMainForm.ShellChangeNotifierChange;
begin
  //Many file events arrive in bursts: wait until they stop, then refresh once
  if FWatchedPath = '' then
    Exit;
  RefreshTimer.Enabled := False;
  RefreshTimer.Enabled := True;
end;

procedure TMainForm.ShellListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  LFileName: TFileName;
  LFileType: string;
  LCreation, LChanged: TDateTime;
  LFolder: TShellFolder;
begin
  //OnChange fires for every item (text, image, state) while the list is filled;
  //only a selection change is interesting here
  if FRefreshing or (Change <> ctState) then
    Exit;
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
  EnableNativeDoubleBuffer;
end;

procedure TMainForm.actnBackUpdate(Sender: TObject);
begin
  actnBack.Enabled := (ShellTreeView.SelectedFolder <> nil) and
    (ShellTreeView.SelectedFolder.Level > 0);
  //Runs on idle: keep the change notifier on the folder being shown
  SyncNotifierRoot;
end;

procedure TMainForm.actnBackExecute(Sender: TObject);
begin
    ShellListView.Back();
end;

procedure TMainForm.actnRefreshExecute(Sender: TObject);
begin
  RefreshTimer.Enabled := False;
  RefreshListKeepSelection;
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
