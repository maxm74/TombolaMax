unit TombolaMax_Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, ExtCtrls, Grids, Buttons, StdCtrls, Spin,
  BCToolBar, BCGameGrid, ColorSpeedButton, BCButtonFocus, BCButton, BGRASpeedButton, BCListBox, BCPanel, BCLabel,
  BGRAImageList;

type

  { TFormTombola }

  TFormTombola = class(TForm)
    BCLabel1: TBCLabel;
    BCLabel2: TBCLabel;
    BCLabel3: TBCLabel;
    BCLabel4: TBCLabel;
    BCLabel5: TBCLabel;
    BCLabel6: TBCLabel;
    BCLabel7: TBCLabel;
    bcTabellone: TBCPanel;
    bcEdit1: TBCPanel;
    BCToolBar1: TBCToolBar;
    BGRAImageList1: TBGRAImageList;
    btEstrai: TBGRASpeedButton;
    btCasuale: TBGRASpeedButton;
    btSelTab1: TBGRASpeedButton;
    btSelTab2: TBGRASpeedButton;
    btSelTab3: TBGRASpeedButton;
    btSelTab4: TBGRASpeedButton;
    btSelTab5: TBGRASpeedButton;
    btSelTab6: TBGRASpeedButton;
    ColorSpeedButton1: TColorSpeedButton;
    edEstratto: TSpinEdit;
    Panel1: TBCPanel;
    tbNew: TToolButton;
    ToolButton1: TToolButton;
    tbGenerate: TToolButton;
    procedure btEstraiClick(Sender: TObject);
    procedure btSelTab1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbGenerateClick(Sender: TObject);
  private
    buttons :array[1..90] of TColorSpeedButton;
    lastDown:TBGRASpeedButton;
  public

  end;

var
  FormTombola: TFormTombola;

implementation

{$R *.lfm}

uses tombolamax_generate;

{ TFormTombola }

procedure TFormTombola.tbGenerateClick(Sender: TObject);
begin
  FormGenerate.ShowModal;
end;

procedure TFormTombola.FormShow(Sender: TObject);
var
   x, y, i, butWidth, butHeight :Integer;

begin
  butHeight :=(bcTabellone.Height-10) div 9;
  butWidth :=(bcTabellone.Width-10) div 10;
  i:=1;

  for y:=0 to 8 do
  for x:=0 to 9 do
  begin
    buttons[i] :=TColorSpeedButton.Create(Self);
    buttons[i].StateNormal.Color:=clWhite;
    buttons[i].StateDisabled.Color:=clSkyBlue;
    buttons[i].Caption:=IntToStr(i);
    buttons[i].ParentFont:=False;
   // buttons[i].Font.Style:=[fsBold];
    buttons[i].Tag:=i;
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
  buttons[edEstratto.Value].StateNormal.Color:=clRed;
//  buttons[edEstratto.Value].StateNormal.BorderWidth:=Trunc(buttons[edEstratto.Value].Width*25/100);
end;

end.

