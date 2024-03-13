unit TombolaMax_Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, ExtCtrls,
  Buttons, Spin, BCToolBar, ColorSpeedButton, BGRASpeedButton, BCListBox, BCPanel,
  BCLabel, BGRAImageList;

type

  { TFormTombola }

  TFormTombola = class(TForm)
    lbEstrattoUltimo: TBCLabel;
    btGioca2: TBGRASpeedButton;
    btGioca3: TBGRASpeedButton;
    btGioca4: TBGRASpeedButton;
    btGioca5: TBGRASpeedButton;
    btGioca0: TBGRASpeedButton;
    btEstraiCasuale: TBGRASpeedButton;
    btEstrai: TBGRASpeedButton;
    btEstraiAnnulla: TBGRASpeedButton;
    edEstratto: TSpinEdit;
    lbEstratto: TBCLabel;
    lbEstratto1: TBCLabel;
    lbEstrattoUltimi: TBCLabel;
    lbEstratto2: TBCLabel;
    lbEstratto3: TBCLabel;
    BCLabel7: TBCLabel;
    bcTabellone: TBCPanel;
    bcEdit1: TBCPanel;
    BCToolBar1: TBCToolBar;
    BGRAImageList1: TBGRAImageList;
    btSelTab1: TBGRASpeedButton;
    btSelTab2: TBGRASpeedButton;
    btSelTab3: TBGRASpeedButton;
    btSelTab4: TBGRASpeedButton;
    btSelTab5: TBGRASpeedButton;
    btSelTab6: TBGRASpeedButton;
    ColorSpeedButton1: TColorSpeedButton;
    lbGioca: TBCLabel;
    Panel1: TBCPanel;
    tbNew: TToolButton;
    ToolButton1: TToolButton;
    tbGenerate: TToolButton;
    ToolButton2: TToolButton;
    tbInfo: TToolButton;
    procedure btEstraiAnnullaClick(Sender: TObject);
    procedure btEstraiCasualeClick(Sender: TObject);
    procedure btGioca2Click(Sender: TObject);
    procedure btEstraiClick(Sender: TObject);
    procedure btSelTab1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tbGenerateClick(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
    procedure tbInfoClick(Sender: TObject);
  private
    buttons :array[1..90] of TColorSpeedButton;
    lastDown:TBGRASpeedButton;
    cEstratti:Integer;
    Estratti:array[0..3] of Integer;
    NumeriDisponibili:array of Integer;

  public

  end;

var
  FormTombola: TFormTombola;

implementation

{$R *.lfm}

uses tombolamax_generate, tombolamax_info;

{ TFormTombola }

procedure TFormTombola.tbGenerateClick(Sender: TObject);
begin
  FormGenerate.ShowModal;
end;

procedure TFormTombola.tbNewClick(Sender: TObject);
var
   i:Integer;

begin
  cEstratti :=0;
  FillChar(Estratti, sizeof(Estratti), 0);

  SetLength(NumeriDisponibili, 90);
  for i:=0 to 89 do NumeriDisponibili[i] :=i+1;

  lbEstrattoUltimo.Visible:=False;
  lbEstratto.Caption:='';
  lbEstrattoUltimi.Visible:=False;
  lbEstratto1.Caption:='';
  lbEstratto2.Caption:='';
  lbEstratto3.Caption:='';
  lbGioca.Visible:=False;
  lbGioca.Caption:='Si gioca per: Ambo';
  edEstratto.Value:=1;
  btGioca2.Down:=False;
  btGioca3.Down:=False;
  btGioca4.Down:=False;
  btGioca5.Down:=False;
  btGioca0.Down:=False;
  btSelTab1.Down:=False;
  btSelTab2.Down:=False;
  btSelTab3.Down:=False;
  btSelTab4.Down:=False;
  btSelTab5.Down:=False;
  btSelTab6.Down:=False;
  for i:=1 to 90 do
  begin
    buttons[i].Enabled:=True;
    buttons[i].StateNormal.Color:=clWhite;
    buttons[i].Tag :=0; //Non estratto
  end;
end;

procedure TFormTombola.tbInfoClick(Sender: TObject);
begin
  FormInfo.ShowModal;
end;

procedure TFormTombola.FormCreate(Sender: TObject);
var
   x, y, i :Integer;

begin
  FillChar(estratti, sizeof(estratti), 0);

  SetLength(NumeriDisponibili, 90);
  for i:=0 to 89 do NumeriDisponibili[i] :=i+1;

  i:=1;
  for y:=0 to 8 do
  for x:=0 to 9 do
  begin
    buttons[i] :=TColorSpeedButton.Create(Self);
    buttons[i].StateNormal.Color:=clWhite;
    buttons[i].StateDisabled.Color:=clSkyBlue;
    buttons[i].Caption:=IntToStr(i);
    buttons[i].ParentFont:=False;
    buttons[i].Tag:=0;  //Non estratto
    buttons[i].Parent :=bcTabellone;
    inc(i);
  end;
end;

procedure TFormTombola.FormResize(Sender: TObject);
var
   x, y, i, butWidth, butHeight :Integer;

begin
  butHeight :=(bcTabellone.Height-14) div 9;
  butWidth :=(bcTabellone.Width-12) div 10;

  i:=1;
  for y:=0 to 8 do
  for x:=0 to 9 do
  begin
    buttons[i].Top :=y*butHeight+7;
    buttons[i].Left :=x*butWidth+7;
    if (y>5)
    then buttons[i].Top :=buttons[i].Top+4
    else if (y>2) then buttons[i].Top :=buttons[i].Top+2;
    if (x>4) then buttons[i].Left :=buttons[i].Left+2;
    buttons[i].Width:=butWidth;
    buttons[i].Height:=butHeight;
    buttons[i].Font.Height:=Trunc(buttons[i].Height*75/100);
    inc(i);
  end;
end;

procedure TFormTombola.btSelTab1Click(Sender: TObject);
var
   curBt:TBGRASpeedButton;

   procedure EnableTabGroup(G :Integer; AEnabled:Boolean);
   var
      i :Integer;

   begin
     Case G of
     1:begin
         for i:=1 to 5 do buttons[i].Enabled:=AEnabled;
         for i:=11 to 15 do buttons[i].Enabled:=AEnabled;
         for i:=21 to 25 do buttons[i].Enabled:=AEnabled;
       end;
     2:begin
         for i:=6 to 10 do buttons[i].Enabled:=AEnabled;
         for i:=16 to 20 do buttons[i].Enabled:=AEnabled;
         for i:=26 to 30 do buttons[i].Enabled:=AEnabled;
       end;
     3:begin
         for i:=31 to 35 do buttons[i].Enabled:=AEnabled;
         for i:=41 to 45 do buttons[i].Enabled:=AEnabled;
         for i:=51 to 55 do buttons[i].Enabled:=AEnabled;
       end;
     4:begin
         for i:=36 to 40 do buttons[i].Enabled:=AEnabled;
         for i:=46 to 50 do buttons[i].Enabled:=AEnabled;
         for i:=56 to 60 do buttons[i].Enabled:=AEnabled;
       end;
     5:begin
         for i:=61 to 65 do buttons[i].Enabled:=AEnabled;
         for i:=71 to 75 do buttons[i].Enabled:=AEnabled;
         for i:=81 to 85 do buttons[i].Enabled:=AEnabled;
       end;
     6:begin
         for i:=66 to 70 do buttons[i].Enabled:=AEnabled;
         for i:=76 to 80 do buttons[i].Enabled:=AEnabled;
         for i:=86 to 90 do buttons[i].Enabled:=AEnabled;
       end;
     end;
   end;

begin
  curBt :=TBGRASpeedButton(Sender);

  if lastDown<>nil then EnableTabGroup(lastDown.Tag, True);

  EnableTabGroup(curBt.Tag, not(curBt.Down));

  if curBt.Down
  then lastDown :=curBt
  else lastDown :=nil;
end;

procedure TFormTombola.btEstraiClick(Sender: TObject);
begin
  if (buttons[edEstratto.Value].Tag = 0) then
  begin
    Inc(cEstratti);
    lbEstrattoUltimi.Visible :=(cEstratti>1);
    if (cEstratti>1) then
    begin;
      if (Estratti[0] > 0) then
      begin
        Estratti[3] :=Estratti[2];
        Estratti[2] :=Estratti[1];
        Estratti[1] :=Estratti[0];
      end;

      if (Estratti[1]<>0) then lbEstratto1.Caption :=IntToStr(Estratti[1]) else lbEstratto1.Caption :='';
      if (Estratti[2]<>0) then lbEstratto2.Caption :=IntToStr(Estratti[2]) else lbEstratto2.Caption :='';
      if (Estratti[3]<>0) then lbEstratto3.Caption :=IntToStr(Estratti[3]) else lbEstratto3.Caption :='';
    end;
    Estratti[0] :=edEstratto.Value;

    buttons[edEstratto.Value].StateNormal.Color :=clRed;
    buttons[edEstratto.Value].Tag := 1;
    lbEstrattoUltimo.Visible :=True;
    lbEstratto.Caption :=IntToStr(edEstratto.Value);
  end
  else MessageDlg('Numero '+IntToStr(edEstratto.Value)+' già estratto', mtError, [mbOk], 0);
end;

procedure TFormTombola.btGioca2Click(Sender: TObject);
begin
  if TBGRASpeedButton(Sender).Down then
  begin
    Case TBGRASpeedButton(Sender).Tag of
     0:lbGioca.Caption:='Si gioca per: Tombolino';
     2:lbGioca.Caption:='Si gioca per: Terno';
     3:lbGioca.Caption:='Si gioca per: Quaterna';
     4:lbGioca.Caption:='Si gioca per: Cinquina';
     5:lbGioca.Caption:='Si gioca per: Tombola';
     end;
    lbGioca.Visible :=True
  end
  else lbGioca.Visible :=False;
end;

procedure TFormTombola.btEstraiCasualeClick(Sender: TObject);
var
   iNumero, Numero :Integer;

begin
  if (NumeriDisponibili<>nil)
  then begin
         Randomize;
         iNumero :=Random(Length(NumeriDisponibili));
         Numero :=NumeriDisponibili[iNumero];
         Delete(NumeriDisponibili, iNumero, 1);
         edEstratto.Value:=Numero;
         btEstraiClick(nil);
       end
  else begin
         if (MessageDlg('Numeri Finiti :'+#13#10+'Vuoi iniziare una Nuova Partita ?', mtConfirmation, [mbYes, mbNo], 0)=mrYes)
         then tbNewClick(nil);
       end;
end;

procedure TFormTombola.btEstraiAnnullaClick(Sender: TObject);
var
   iNumero, pNumero, Numero:Integer;
   fNumero:Boolean;

begin
  Numero :=Estratti[0];
  if (Numero > 0) then
  begin
    buttons[Numero].StateNormal.Color :=clWhite;
    buttons[Numero].Tag :=0;
    lbEstratto.Caption :='';

    pNumero :=Numero-1; //Presunta posizione originaria
    fNumero :=False;
    for iNumero:=0 to High(NumeriDisponibili) do
      if (NumeriDisponibili[iNumero] = Numero)
      then begin
             fNumero :=True;
             break;
           end
       else if (NumeriDisponibili[iNumero] < Numero) then pNumero :=iNumero;

    if (fNumero=False) then
    begin
      if (pNumero+1 > High(NumeriDisponibili))
      then begin
             SetLength(NumeriDisponibili, Length(NumeriDisponibili)+1);
             NumeriDisponibili[High(NumeriDisponibili)] :=Numero;
           end
      else Insert(Numero, NumeriDisponibili, pNumero+1);
    end;

    Estratti[0] :=0;
  end;
end;

end.

