unit uAide;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmAide = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAide: TfrmAide;

implementation

uses uMain;

{$R *.DFM}

procedure TfrmAide.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FrmMain.visible:=true;
end;

procedure TfrmAide.Button1Click(Sender: TObject);
begin
frmAide.Close;
end;

end.
