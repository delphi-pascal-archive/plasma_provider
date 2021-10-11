unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,math, ComCtrls, Buttons;

type
  TCellule = record
           pos:tpoint;
           taille:smallint;
           Naissance:integer;
           fixe:boolean;
           Out:boolean;
           ExpansionPossible:boolean;
           end;
  TSortie = record
          debut,fin:tpoint;
          sens:boolean;
          end;
  TfrmMain = class(TForm)
    PbPieces: TImage;
    TimerVanne: TTimer;
    GroupBox1: TGroupBox;
    cbNiveau: TComboBox;
    GroupBox3: TGroupBox;
    PbSelection: TPaintBox;
    GroupBox7: TGroupBox;
    chkSuperposition: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edtDepartVanne: TEdit;
    UpDown1: TUpDown;
    btnVanne: TButton;
    GroupBox6: TGroupBox;
    Memo1: TMemo;
    GroupBox8: TGroupBox;
    BtnAide: TButton;
    GroupBox4: TGroupBox;
    BtnGod: TButton;
    Vanne: TProgressBar;
    PbPlayGround: TPaintBox;
    Cuve: TProgressBar;
    Cuve2: TProgressBar;
    imgLiaison2: TImage;
    imgLiaison: TImage;
    Image: TImage;
    BtnGo: TSpeedButton;
    BtnStop: TSpeedButton;
    procedure DessineBackground;
    procedure DessineCellules;
    procedure jouer;
    Procedure Initialiser;
    Procedure Expansion;
    function EssayerExpansion(x,y:integer):boolean;
    procedure btnVanneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Reactiver;
    procedure TirerPiece(i:integer);
    procedure pbPlayGroundDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Dessinerconduite(x,y:integer);
    procedure pbPlayGroundDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure BtnGodClick(Sender: TObject);
    function VerifierSortie(x,y:integer):boolean;
    procedure TimerVanneTimer(Sender: TObject);
    procedure FairePivoter(shift:tshiftstate);
    procedure PbPlayGroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtDepartVanneChange(Sender: TObject);
    procedure PbPlayGroundPaint(Sender: TObject);
    procedure stopper;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChargerNIveau(niveau:string);
    Procedure InitMatrice;
    procedure cbNiveauChange(Sender: TObject);
    procedure PbSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnGoClick(Sender: TObject);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnAideClick(Sender: TObject);
    procedure GroupBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnStopClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Plasma:array[1..170000] of Tcellule;
    NbCellule:integer;
    Temps:integer;
    NbCelluleFixe:integer;
    TenterDeMonter,stop:boolean;
    tempint:integer;
    Sortie,sortie2:TSortie;
    NbSortie,NbSortie2:integer;
    Trigger:integer;
    TempsVanne:integer;
    piece:integer;
    TempCanvas:Tcanvas;
    Matrice:array[1..10]of array[1..10] of smallint;
    AncX,AncY:integer;
    AncNbCelluleFixe:integer;
    AncNbSortie,AncNbSortie2:integer;
  end;

var
  frmMain: TfrmMain;

implementation

uses uPopup, uAide;

//uses Unit1;

{$R *.DFM}

function BitmapToRegion(bmp: TBitmap; TransparentColor: TColor = clBlack;
  RedTol: Byte = 1; GreenTol: Byte = 1; BlueTol: Byte = 1): HRGN;
const
  AllocUnit = 100;
type
  PRectArray = ^TRectArray;
  TRectArray = array[0..(MaxInt div SizeOf(TRect)) - 1] of TRect;
var
  pr: PRectArray; // used to access the rects array of RgnData by index
  h: HRGN; // Handles to regions
  RgnData: PRgnData; // Pointer to structure RGNDATA used to create regions
  lr, lg, lb, hr, hg, hb: Byte; // values for lowest and hightest trans. colors
  x, y, x0: Integer; // coordinates of current rect of visible pixels
  b: PByteArray; // used to easy the task of testing the byte pixels (R,G,B)
  ScanLinePtr: Pointer; // Pointer to current ScanLine being scanned
  ScanLineInc: Integer; // Offset to next bitmap scanline (can be negative)
  maxRects: Cardinal; // Number of rects to realloc memory by chunks of AllocUnit
begin
  Result := 0;
  { Keep on hand lowest and highest values for the "transparent" pixels }
  lr := GetRValue(TransparentColor);
  lg := GetGValue(TransparentColor);
  lb := GetBValue(TransparentColor);
  hr := Min($FF, lr + RedTol);
  hg := Min($FF, lg + GreenTol);
  hb := Min($FF, lb + BlueTol);
  { ensures that the pixel format is 32-bits per pixel }
  bmp.PixelFormat := pf32bit;
  { alloc initial region data }
  maxRects := AllocUnit;
  GetMem(RgnData, SizeOf(RGNDATAHEADER) + (SizeOf(TRect) * maxRects));
  try
    with RgnData^.rdh do
    begin
      dwSize := SizeOf(RGNDATAHEADER);
      iType := RDH_RECTANGLES;
      nCount := 0;
      nRgnSize := 0;
      SetRect(rcBound, MAXLONG, MAXLONG, 0, 0);
    end;
    { scan each bitmap row - the orientation doesn't matter (Bottom-up or not) }
    ScanLinePtr := bmp.ScanLine[0];
    ScanLineInc := Integer(bmp.ScanLine[1]) - Integer(ScanLinePtr);
    for y := 0 to bmp.Height - 1 do
    begin
      x := 0;
      while x < bmp.Width do
      begin
        x0 := x;
        while x < bmp.Width do
        begin
          b := @PByteArray(ScanLinePtr)[x * SizeOf(TRGBQuad)];
          // BGR-RGB: Windows 32bpp BMPs are made of BGRa quads (not RGBa)
          if (b[2] >= lr) and (b[2] <= hr) and
            (b[1] >= lg) and (b[1] <= hg) and
            (b[0] >= lb) and (b[0] <= hb) then
            Break; // pixel is transparent
          Inc(x);
        end;
        { test to see if we have a non-transparent area in the image }
        if x > x0 then
        begin
          { increase RgnData by AllocUnit rects if we exceeds maxRects }
          if RgnData^.rdh.nCount >= maxRects then
          begin
            Inc(maxRects, AllocUnit);
            ReallocMem(RgnData, SizeOf(RGNDATAHEADER) + (SizeOf(TRect) * MaxRects));
          end;
          { Add the rect (x0, y)-(x, y+1) as a new visible area in the region }
          pr := @RgnData^.Buffer; // Buffer is an array of rects
          with RgnData^.rdh do
          begin
            SetRect(pr[nCount], x0, y, x, y + 1);
            { adjust the bound rectangle of the region if we are "out-of-bounds" }
            if x0 < rcBound.Left then
              rcBound.Left := x0;
            if y < rcBound.Top then
              rcBound.Top := y;
            if x > rcBound.Right then
              rcBound.Right := x;
            if y + 1 > rcBound.Bottom then
              rcBound.Bottom := y + 1;
            Inc(nCount);
          end;
        end; // if x > x0
        { Need to create the region by muliple calls to ExtCreateRegion, 'cause }
        { it will fail on Windows 98 if the number of rectangles is too large   }
        if RgnData^.rdh.nCount = 2000 then
        begin
          h := ExtCreateRegion(nil, SizeOf(RGNDATAHEADER) + (SizeOf(TRect) *
            maxRects), RgnData^);
          if Result > 0 then
          begin // Expand the current region
            CombineRgn(Result, Result, h, RGN_OR);
            DeleteObject(h);
          end
          else // First region, assign it to Result
            Result := h;
          RgnData^.rdh.nCount := 0;
          SetRect(RgnData^.rdh.rcBound, MAXLONG, MAXLONG, 0, 0);
        end;
        Inc(x);
      end; // scan every sample byte of the image
      Inc(Integer(ScanLinePtr), ScanLineInc);
    end;
    { need to call ExCreateRegion one more time because we could have left    }
    { a RgnData with less than 2000 rects, so it wasn't yet created/combined  }
    h := ExtCreateRegion(nil, SizeOf(RGNDATAHEADER) + (SizeOf(TRect) * MaxRects),
      RgnData^);
    if Result > 0 then
    begin
      CombineRgn(Result, Result, h, RGN_OR);
      DeleteObject(h);
    end
    else
      Result := h;
  finally
    FreeMem(RgnData, SizeOf(RGNDATAHEADER) + (SizeOf(TRect) * MaxRects));
  end;
end;

procedure TfrmMain.InitMatrice;
var
   i,j:integer;
begin
for i:=1 to 10 do
    for j:=1 to 10 do
        begin
        Matrice[i][j]:=0;
        end;
end;

procedure TfrmMain.Initialiser;
var
   i:integer;
begin
Vanne.max:=Trigger;
TempsVanne:=0;
TimerVanne.interval:=1000;
NbSortie:=0;
NbSortie2:=0;
NbCellule:=1;
temps:=1;
NbCelluleFixe:=1;
for i:=1 to 170000 do
    begin
    Plasma[i].pos.x:=2;
    Plasma[i].pos.y:=20;
    Plasma[i].taille:=2;
    Plasma[i].Naissance:=1;
    Plasma[i].fixe:=false;
    Plasma[i].Out:=false;
    Plasma[i].ExpansionPossible:=true;
    end;
end;

procedure TfrmMain.DessineBackground;
begin
with pbPlayGround do
     begin
     canvas.brush.style:=bssolid;
     canvas.brush.color:=clblack;
     canvas.Pen.color:=clblack;
     canvas.rectangle(1,1,width-1,height-1);
     application.processmessages;
     end;
end;

procedure TfrmMain.DessineCellules;
var
   i:integer;
begin
for i:=1 to NbCellule do
    begin
    with pbPlayGround.canvas do
         begin
         brush.style:=bssolid;
         brush.color:=cllime;
         Pen.color:=cllime;
         Pixels[Plasma[i].pos.x,Plasma[i].pos.y]:=cllime;
         end;
    end;
end;

function TfrmMain.VerifierSortie(x,y:integer):boolean;
begin
result:=false;
if sortie.sens=true then
   begin
   if (x>sortie.debut.x) and (x<Sortie.fin.x) and
      (y=Sortie.debut.y) then
      begin
      inc(NbSortie);
      result:=true;
      end;
   if (x>sortie2.debut.x) and (x<Sortie2.fin.x) and
      (y=Sortie2.debut.y) then
      begin
      inc(NbSortie2);
      result:=true;
      end;
   end;

end;

function TfrmMain.EssayerExpansion(x,y:integer):boolean;
begin
result:=false;
if verifierSortie(x,y)=true then
      begin
      result:=true;
      exit;
      end;
if (x<1) or (y<1) or (x>pbPlayGround.width) or (y>pbPlayGround.width) then
   begin
   exit;
   end;
if pbPlayGround.canvas.pixels[ x , y ] = clBlack then
       begin
       inc(NbCellule);
       Plasma[NbCellule].pos.x:=x;
       Plasma[NbCellule].pos.y:=y;
       Plasma[NbCellule].Taille:=Plasma[1].taille;
       Plasma[NbCellule].Naissance:=temps;
       pbPlayGround.canvas.Pixels[Plasma[NbCellule].pos.x,Plasma[NbCellule].pos.y]:=cllime;
       result:=true;
       end;
end;

procedure TfrmMain.Reactiver;
var
   i:integer;
begin
{for i:=NbCellule downto 1 do
    begin
    if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y-1)=true then exit;
    end; }
for i:=NbCellule downto 1 do
    begin
    if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y-1)=true then exit;
    if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y+1)=true then
       begin
       Plasma[i].fixe:=false;
       exit;
       end;
    end;
end;

Procedure TfrmMain.Expansion;
label move;
var
   i:integer;
   bool:boolean;
   CurrentNbCellule:integer;

begin
CurrentNbCellule:=NbCellule;
bool:=true;
TenterDemonter:=false;
Reactiver;
if NBCelluleFixe=NbCellule then
   begin
   Reactiver;
   TenterDeMonter:=true;
   end;
for i:=NbCelluleFixe to CurrentNbCellule do
    begin
    if (plasma[i].fixe=true) and (bool=true) then
       begin
       NbCelluleFixe:=i;
       end
    else
        bool:=false;
    if plasma[i].fixe=false then
       begin

       if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y+1)=false then
          begin

          if EssayerExpansion(Plasma[i].pos.x-1,Plasma[i].pos.y+1)=false then
             begin

             if EssayerExpansion(Plasma[i].pos.x+1,Plasma[i].pos.y+1)=false then
                begin

                if EssayerExpansion(Plasma[i].pos.x-1,Plasma[i].pos.y)=false then
                   begin

                   if EssayerExpansion(Plasma[i].pos.x+1,Plasma[i].pos.y)=false then
                      begin
                     
                      Plasma[i].fixe:=true;
                      if TenterDeMonter=true then
                         begin
                         if EssayerExpansion(Plasma[i].pos.x-1,Plasma[i].pos.y-1)=false then
                         if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y-1)=false then
                          if  EssayerExpansion(Plasma[i].pos.x+1,Plasma[i].pos.y-1)=false then;

                         end;
                      end;
                   end;
                end;
             end;
          end;
       // etoile
       {if EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y-2)=false then
       if EssayerExpansion(Plasma[i].pos.x-2,Plasma[i].pos.y)=false then
       if EssayerExpansion(Plasma[i].pos.x+2,Plasma[i].pos.y)=false then
          EssayerExpansion(Plasma[i].pos.x,Plasma[i].pos.y+2);}
       end;
    end;
end;

procedure TfrmMAin.stopper;
begin
TimerVanne.enabled:=false;
stop:=true;
edtDepartVanne.Enabled:=true;
cbNiveau.enabled:=true;
vanne.position:=0;
end;


procedure TfrmMain.Jouer;
begin
//InitMatrice;
cbniveauchange(self);
edtDepartVanne.Enabled:=false;
//DessineBackground;
Initialiser;
DessineCellules;
TirerPiece(0);
{with PbPlayground do
     begin
     canvas.pen.color:=clblack;
     Canvas.brush.color:=clblack;
     canvas.brush.style:=bssolid;
     canvas.moveto(sortie.debut.x,sortie.debut.y);
     canvas.lineto(Sortie.fin.x,sortie.fin.y);
     end;  }
TimerVanne.enabled:=true;
end;

procedure TfrmMain.btnVanneClick(Sender: TObject);
var
   i:longint;
   Diff,diff2:integer;
begin
stop:=false;
for i:=1 to 30000 do
    begin
    sleep(1);
    Application.ProcessMessages;
    if stop=true then
       exit;
    TenterDeMonter:=false;
    Expansion;
    inc(temps);
    //DessineCellules;
{    Edit3.text:=inttostr(nbsortie);}
    if nbsortie<=Cuve.Max then
       Cuve.position:=nbsortie;
    diff2:=-AncNbSortie2+NbSortie2;
    diff:=-AncNbSortie+NbSortie;
    //
    if (diff<>16) and (diff2<>16) then  // fuite de plasma
       begin
       Nbsortie:=0;
       NbSortie2:=0;
       end;

    AncNbSortie2:=NbSortie2;
    AncNbSortie:=NbSortie;

    if nbsortie2<=Cuve2.Max then
       Cuve2.position:=nbsortie2;
    if Nbcellulefixe>20000 then
       begin
       Stopper;
       FrmPopup.Texte.Caption:='Fuite de plasma ou conduite trop longue, vous avez perdu !';
       FrmPopup.Button1.Caption:='Replay';
       FrmPopup.Button2.caption:='Exit';
       FrmPopup.show;
       exit;
       end;
    if (NbSortie>=Cuve.max) and (NbSortie2>=Cuve2.Max) then
       begin
       FrmPopup.Texte.Caption:='Bravo, la livraison de plasma est arrivé';
       FrmPopup.Button1.Caption:='New Game';
       FrmPopup.Button2.caption:='Exit';
       FrmPopup.show;
       Stopper;
       if FrmMain.CbNiveau.ItemIndex<3 then
              FrmMain.CbNiveau.ItemIndex:=FrmMain.CbNiveau.ItemIndex+1
       else
           FrmMain.CbNiveau.ItemIndex:=0;
       exit;
       end;
    end;
       FrmPopup.Texte.Caption:=':(';
       FrmPopup.Button1.Caption:='Replay';
       FrmPopup.Button2.caption:='Exit';
       FrmPopup.show;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
AncX:=0;
AncY:=0;
InitMatrice;
tempint:=0;
stop:=false;
Sortie.sens:=true;
trigger:=60;
temps:=0;
cbNiveau.itemIndex:=0;
cbniveauchange(self);
end;

procedure TfrmMain.TirerPiece(i:integer);
var
   sourcerect,destrect:trect;
begin
if i=0 then
   i:=random(10)+1;
piece:=i;
SourceRect.Left:=40*(i-1);
Sourcerect.Top:=0;
SourceRect.Right:=40*i;
SourceRect.Bottom:=40;
DestRect.Left:=0;
DestRect.Right:=40;
DestRect.Top:=0;
DestRect.Bottom:=40;
PbSelection.Canvas.CopyRect(DestRect,PbPieces.canvas,SourceRect);
end;

procedure TfrmMain.FairePivoter(shift:tshiftstate);
begin
if ssright in shift then
   begin
   if piece<=2 then
      begin
      if piece=1 then piece:=2 else piece:=1;
      end
   else if piece<=6 then
        begin
        if piece<>6 then piece:=piece+1 else piece:=3;
        end
   else if piece<=10 then
        begin
        if piece<>10 then piece:=piece+1 else piece:=7;
        end;
   TirerPiece(piece);
   end;
end;

procedure TfrmMain.Dessinerconduite(x,y:integer);
var
   sourcerect,destrect:trect;
begin
SourceRect.Left:=0;
Sourcerect.Top:=0;
SourceRect.Right:=40;
SourceRect.Bottom:=40;
DestRect.Left:=40*(x-1);
DestRect.Right:=40*x;
DestRect.Top:=40*(y-1);
DestRect.Bottom:=40*y;
pbPlayGround.Canvas.CopyRect(DestRect,PbSelection.canvas,SourceRect);
end;

procedure TfrmMain.pbPlayGroundDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:=source is TPaintbox;
end;

procedure TfrmMain.pbPlayGroundDragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var
   IntX,intY:integer;
begin
intX:=floor(x/40)+1;
intY:=floor(y/40)+1;
if Matrice[intX,intY]=2 then exit;
if (matrice[intX,intY]=0) or (chksuperposition.checked=true) then
   begin
   Dessinerconduite(intx,inty);
   TirerPiece(0);
   matrice[intX,intY]:=1;
   end;
end;

procedure TfrmMain.BtnGodClick(Sender: TObject);
begin
with pbPlayGround do
     begin
     if dragmode=dmAutomatic then
        begin
        dragmode:=dmManual;
        BtnGod.caption:='GOD';
        end
     else
         begin
         dragmode:=dmautomatic;
         BtnGod.Caption:='Normal';
         end;
     end;
end;

procedure TfrmMain.TimerVanneTimer(Sender: TObject);
begin
inc(tempsVanne);
Vanne.position:=TempsVanne;
if tempsVanne>Trigger then
   begin
   BtnVanneClick(self);
   TimerVanne.enabled:=false;
   end;
end;



procedure TfrmMain.PbPlayGroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Fairepivoter(shift);
end;

procedure TfrmMain.edtDepartVanneChange(Sender: TObject);
begin
Trigger:=strtoint(edtDepartVanne.text);
end;

procedure TfrmMain.PbPlayGroundPaint(Sender: TObject);
begin
 CbNiveauChange(self);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 Stopper;
end;

procedure TfrmMain.ChargerNiveau(niveau:string);
var
   ARect:Trect;
begin
ARect := Rect(0, 0, PBPlayground.Width, PBPlayground.Height);
Image.picture.LoadFromFile(niveau);
PbPlayGround.Canvas.CopyRect(AREct,Image.canvas,ARect);
end;

procedure TfrmMain.cbNiveauChange(Sender: TObject);
var
   i:integer;
begin
InitMatrice;
Cuve2.position:=0;
Cuve.position:=0;
Cuve2.visible:=false;
cuve.visible:=false;
imgLiaison.visible:=false;
imgLiaison2.visible:=false;
//initialiser;
if (cbniveau.itemindex=2) or (cbniveau.itemindex=3) then
   begin
      ChargerNiveau('.\bmp\Niv3.bmp');
   for i:=1 to 7 do
       Matrice[i,3]:=2;
   for i:=5 to 10 do
       Matrice[i,7]:=2;
   end;
if (cbNiveau.itemindex=0) or (cbNiveau.itemindex=2) then
   begin
   Sortie.debut.x:=370;
   Sortie.debut.y:=399;
   Sortie.fin.x:=390;
   Sortie.fin.y:=399;
   Sortie2.debut.x:=10;
   Sortie2.debut.y:=399;
   Sortie2.fin.x:=9;
   Sortie2.fin.y:=399;
   imgLiaison.visible:=true;
   imgLiaison2.visible:=false;
   Cuve.visible:=true;
   Cuve2.visible:=false;
   DessineBackground;
   if (cbniveau.itemindex=2) then
      begin
      ChargerNiveau('.\bmp\Niv3.bmp');
      for i:=1 to 7 do
          Matrice[i,3]:=2;
      for i:=5 to 10 do
          Matrice[i,7]:=2;
      end;
   TirerPiece(1);
   DessinerConduite(1,1);
   Matrice[1,1]:=2;
   TirerPiece(2);
   DessinerConduite(10,10);
   Matrice[10,10]:=2;
   Cuve2.Max:=0;
   ImgLiaison.repaint;
   Cuve.repaint;
   end;
if (cbniveau.itemindex=1) or (cbniveau.itemindex=3) then
   begin
   Sortie.debut.x:=370;
   Sortie.debut.y:=399;
   Sortie.fin.x:=390;
   Sortie.fin.y:=399;
   Sortie2.debut.x:=10;
   Sortie2.debut.y:=399;
   Sortie2.fin.x:=30;
   Sortie2.fin.y:=399;
   imgLiaison2.visible:=true;
   imgLiaison.visible:=true;
   Cuve.visible:=true;
   Cuve2.visible:=true;
   DessineBackground;
   if (cbniveau.itemindex=3) then
      begin
      ChargerNiveau('.\bmp\Niv3.bmp');
      for i:=1 to 7 do
          Matrice[i,3]:=2;
      for i:=5 to 10 do
          Matrice[i,7]:=2;
      end;

   TirerPiece(1);
   DessinerConduite(1,1);
   Matrice[1,1]:=2;
   TirerPiece(2);
   DessinerConduite(10,10);
   Matrice[10,10]:=2;
   TirerPiece(2);
   DessinerConduite(1,10);
   Matrice[1,10]:=2;
   Cuve2.max:=10000;
   ImgLiaison2.repaint;
   Cuve2.repaint;
   ImgLiaison.repaint;
   Cuve.repaint;
   end;

end;

procedure TfrmMain.PbSelectionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Fairepivoter(shift);
end;

procedure TfrmMain.BtnGOClick(Sender: TObject);
begin
cbNiveau.enabled:=false;
Jouer;

end;

procedure TfrmMain.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if ssleft in shift then
   //if (abs(AncX-mouse.cursorpos.X)>2) and (abs(AncY-mouse.cursorpos.Y)>2) then
   begin
   FrmMain.top:=FrmMain.top-AncY+mouse.cursorpos.Y;
   FrmMain.left:=FrmMain.left-AncX+mouse.cursorpos.X;
   end;
AncX:=mouse.cursorpos.X;
AncY:=mouse.cursorpos.Y;
end;

procedure TfrmMain.BtnAideClick(Sender: TObject);
begin
FrmMain.visible:=false;
frmAide.show;
//FrmMAin.enabled:=false;
end;

procedure TfrmMain.GroupBox3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Fairepivoter(shift);
end;

procedure TfrmMain.BtnStopClick(Sender: TObject);
begin
Stopper;
end;

end.
