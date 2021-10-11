program Plasma;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  XPTheme in 'XPTheme.pas',
  uPopup in 'uPopup.pas' {frmPopup},
  uAide in 'uAide.pas' {frmAide};

{$R *.RES}
{$R bitmap.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPopup, frmPopup);
  Application.CreateForm(TfrmAide, frmAide);
  Application.Run;
end.
