unit tombolamax_generate;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Variants, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs, ExtCtrls, LR_DSet, LR_Class,
  BCButton, BCTrackbarUpdown, BCLabel, BGRASpeedButton, BCListBox;

type
  TColonna = record
    Min, Max, Tot :Integer;
  end;

  TCartella = array[0..8, 1..3] of Integer;

  TGruppoCartelle = array [1..6] of TCartella;

  { TFormGenerate }

  TFormGenerate = class(TForm)
    BCLabel1: TBCLabel;
    BCLabel2: TBCLabel;
    BCLabel3: TBCLabel;
    frReportCartelleBack: TfrReport;
    ImageNumeri: TImage;
    ImageCartella: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    panSfondo: TBCPaperPanel;
    btPictureNumeri: TBGRASpeedButton;
    btPictureCartella: TBGRASpeedButton;
    cbBackImage: TCheckBox;
    edPictureCartella: TEdit;
    edTitolo: TEdit;
    edPictureNumeri: TEdit;
    frReportCartelle: TfrReport;
    totCartelle: TBCTrackbarUpdown;
    btGenerate: TBCButton;
    frCartelle: TfrUserDataset;
    procedure btPictureNumeriClick(Sender: TObject);
    procedure cbBackImageChange(Sender: TObject);
    procedure frReportCartelleAfterPrint(Sender: TfrReport);
    procedure frReportCartelleEnterRect(Memo: TStringList; View: TfrView);
    procedure frReportCartelleGetValue(const ParName: String; var ParValue: Variant);
    procedure btGenerateClick(Sender: TObject);
    procedure frCartelleCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frCartelleFirst(Sender: TObject);
    procedure frCartelleNext(Sender: TObject);
    procedure totCartelleEnter(Sender: TObject);
  private
    pictureNumeri, pictureCartella :String;
    curCartella :Integer;
    Cartelle: array of TCartella;
    Duplicati, DuplicatiCon : array of Integer;
    FrontPrinted :Boolean;

    function CreaGruppoCartelle: TGruppoCartelle;
    function InDuplicati(NumCartella: Integer):Boolean;

  public

  end;

var
  FormGenerate: TFormGenerate;
  myPath: String='';

implementation

{$R *.lfm}

{ TFormGenerate }

procedure TFormGenerate.btGenerateClick(Sender: TObject);
var
  i, k, j, NumGruppi,
  NumCartInizio :Integer;
  curGruppo :TGruppoCartelle;
  //duplicates:Boolean;
  msg:String;

begin
  FrontPrinted :=False;
  totCartelleEnter(nil);
  Application.ProcessMessages;

  NumGruppi :=totCartelle.Value div 6;
  SetLength(Cartelle, totCartelle.Value);
  SetLength(Duplicati, 0);
  SetLength(DuplicatiCon, 0);

  for i := 0 to NumGruppi-1 do
  begin
    NumCartInizio :=i*6;
    curGruppo :=CreaGruppoCartelle;

    (*
    repeat
    duplicates :=False;
    curGruppo :=CreaGruppoCartelle;

    for k :=1 to 6 do
      for j:=1 to 6 do
      if CompareMem(@curGruppo[k], @lastGruppo[j], Length(TCartella)) then
      begin
        duplicates :=True;
        Break;
      end;

    if duplicates then
    begin
      //ShowMessage('DUPLICATI');
      Sleep(Random(50));
      Randomize;
    end;

    until not(duplicates);
    *)
    for k :=0 to 5 do Cartelle[NumCartInizio+k] :=curGruppo[k+1];

    //lastGruppo :=curGruppo;
  end;

  for k :=Low(Cartelle) to High(Cartelle)-1 do
  begin
   for j:=k+1 to High(Cartelle) do
     if CompareMem(@Cartelle[k], @Cartelle[j], Sizeof(TCartella)) then
     begin
       SetLength(Duplicati, Length(Duplicati) + 1);
       Duplicati[High(Duplicati)] := j;
       SetLength(DuplicatiCon, Length(DuplicatiCon) + 1);
       DuplicatiCon[High(DuplicatiCon)] := k;
     end;
  end;

  if Length(Duplicati)>0 then
  begin
    msg:='';
    for i:=Low(Duplicati) to High(Duplicati) do msg:=msg+#13#10+IntToStr(DuplicatiCon[i]+1)+' e '+IntToStr(Duplicati[i]+1);
    ShowMessage('DUPLICATI '+ msg);
  end;

  frReportCartelle.LoadFromFile(myPath+'report\report4.lrf');
  frReportCartelle.ShowReport;
  if FrontPrinted and cbBackImage.Checked then
  begin
    if (MessageDlg('Inserisci di nuovo le Cartelle nella Stampante per Stampare Il retro', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
    begin
      frReportCartelleBack.LoadFromFile(myPath+'report\report4-back.lrf');
      frReportCartelleBack.ShowReport;
    end;
  end;
end;

procedure TFormGenerate.frReportCartelleGetValue(const ParName: String; var ParValue: Variant);
var
   iPos :Integer;
   Riga, Colonna, Numero :Integer;

begin
  iPos :=Pos(',', ParName);
  if iPos>0
  then begin
         Riga :=StrToInt(Copy(ParName, 1, iPos-1));
         Colonna :=StrToInt(Copy(ParName, iPos+1, 255));
         Numero :=Cartelle[curCartella][Colonna, Riga];
         if (Numero>0)
         then ParValue :=IntToStr(Numero)
         else ParValue:='';
       end
  else begin
         if ParName='NUMCART'
         then ParValue :=IntToStr(curCartella+1)
         else
         if ParName='TITOLO'
         then ParValue :=edTitolo.Text
         else ParValue :='';
       end;
end;

procedure TFormGenerate.frReportCartelleEnterRect(Memo: TStringList; View: TfrView);
begin
  if View.Name = 'PictureNumeri'
  then begin if FileExists(pictureNumeri) then (View as TfrPictureView).Picture.LoadFromFile(pictureNumeri); end
  else
  if View.Name = 'PictureCartella'
  then begin if FileExists(pictureCartella) then (View as TfrPictureView).Picture.LoadFromFile(pictureCartella); end;
end;

procedure TFormGenerate.btPictureNumeriClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute
  then if (Sender=btPictureNumeri)
       then begin
              pictureNumeri:=OpenPictureDialog.FileName;
              edPictureNumeri.Text:=pictureNumeri;
              ImageNumeri.Picture.LoadFromFile(pictureNumeri);
            end
       else begin
              pictureCartella:=OpenPictureDialog.FileName;
              edpictureCartella.Text:=pictureCartella;
              ImageCartella.Picture.LoadFromFile(pictureCartella);
            end;
end;

procedure TFormGenerate.cbBackImageChange(Sender: TObject);
begin
  if cbBackImage.Checked
  then begin
         panSfondo.Enabled:=True;
         edPictureCartella.Text:='';
         pictureCartella:='';
         btPictureCartella.Click;
       end;
end;

procedure TFormGenerate.frReportCartelleAfterPrint(Sender: TfrReport);
begin
  FrontPrinted :=True;
end;

procedure TFormGenerate.frCartelleCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := (curCartella>High(Cartelle));
end;

procedure TFormGenerate.frCartelleFirst(Sender: TObject);
var
   Eof:Boolean;

begin
  curCartella :=Low(Cartelle);
  Eof := False;
  while inDuplicati(curCartella) and not(Eof) do
  begin
    Inc(curCartella);
    Eof := (curCartella>High(Cartelle));
    if Eof then frReportCartelle.Terminated:=True;
  end;
end;

procedure TFormGenerate.frCartelleNext(Sender: TObject);
var
   Eof:Boolean;

begin
  repeat
    Inc(curCartella);
    Eof := (curCartella>High(Cartelle));
    if Eof then frReportCartelle.Terminated:=True;
  until not(inDuplicati(curCartella)) or Eof;
end;

procedure TFormGenerate.totCartelleEnter(Sender: TObject);
begin
   if (totCartelle.Value mod 12 <> 0)
   then totCartelle.Value :=((totCartelle.Value div 12)+1)*12;
end;

function TFormGenerate.CreaGruppoCartelle: TGruppoCartelle;
var
   Colonne :array[0..8] of TColonna;
   Numeri  :array[1..90] of Integer;
   i, k,
   Colonna, Appoggio,
   DaInvertire1, DaInvertire2,
   Cartella :Integer;
   Posizione, OrdineCartella : array[1..6] of Integer;

begin
   Sleep(Random(50)+Random(10)); //Avoid the same ranseed of previous Group
   Randomize;

   for i := 1 to 90 do Numeri[i] := i;
   FillChar(Result, Sizeof(Result), 0);

   for Colonna := 0 to 8 do
   begin
      Colonne[Colonna].Min := 0 + Colonna * 10;
      Colonne[Colonna].Max := 9 + Colonna * 10;
      Colonne[Colonna].Tot := 10;
    end;

   Colonne[0].Min := 1;
   Colonne[0].Tot := 9;
   Colonne[8].Max := 90;
   Colonne[8].Tot := 11;

   for Colonna := 0 to 8 do
     for i := 1 to 100 do
     begin
       DaInvertire1 := Random(Colonne[Colonna].Tot)+1;
       DaInvertire2 := Random(Colonne[Colonna].Tot)+1;
       Appoggio := Numeri[DaInvertire1 + Colonne[Colonna].Min - 1];
       Numeri[DaInvertire1 + Colonne[Colonna].Min - 1] := Numeri[DaInvertire2 + Colonne[Colonna].Min - 1];
       Numeri[DaInvertire2 + Colonne[Colonna].Min - 1] := Appoggio;
     end;

   for i := 1 to 6 do Posizione[i] := Random(3)+1;

   Cartella := 1;

   for Colonna := 0 to 8 do
     for i := Colonne[Colonna].Min to Colonne[Colonna].Max do
     begin
       Result[Cartella, Colonna, Posizione[Cartella]] := Numeri[i];

       Posizione[Cartella] := Posizione[Cartella] + 1;
       if (Posizione[Cartella] > 3) then Posizione[Cartella] := 1;

       Cartella := Cartella + 1;
       if (Cartella > 6) Then Cartella := 1;
     end;

   i:=1;
   while (i<=6) do
   begin
     OrdineCartella[i] := Random(6)+1;
     for k := 1 to i - 1 do
     begin
       if OrdineCartella[i] = OrdineCartella[k] then
       begin
         i := i - 1;
         break;
       end;
     end;
     Inc(i);
   end;
end;

function TFormGenerate.InDuplicati(NumCartella: Integer): Boolean;
var
   i :Integer;

begin
  Result :=False;
  for i :=Low(Duplicati) to High(Duplicati) do
  begin
    Result := (NumCartella=Duplicati[i]);
    if Result then break;
  end;
end;

initialization
  {$ifopt D+}
     //myPath :='..\..\';
     myPath:= ExpandFileName(ExtractFilePath(ParamStr(0)));
  {$else}
     myPath:= ExtractFilePath(ParamStr(0));
  {$endif}


end.

