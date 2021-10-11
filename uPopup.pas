unit uPopup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmPopup = class(TForm)
    Texte: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    decision:boolean;
  end;

var
  frmPopup: TfrmPopup;

implementation

uses uMain;

{$R *.DFM}

procedure TfrmPopup.Button2Click(Sender: TObject);
begin
decision:=false;
FrmMain.close;
end;

procedure TfrmPopup.Button1Click(Sender: TObject);
begin
FrmMain.cbNiveau.enabled:=false;
FrmMain.Jouer;
FrmPopup.hide;
Decision:=true;
end;

procedure TfrmPopup.FormCreate(Sender: TObject);
begin
decision:=false;
end;

end.
