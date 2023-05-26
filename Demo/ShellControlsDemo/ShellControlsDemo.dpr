program ShellControlsDemo;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Shell.Utils in '..\..\Source\Vcl.Shell.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.ActionUpdateDelay := 50;
  Application.Title := 'VCL Shell Controls Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
