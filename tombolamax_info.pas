unit tombolamax_info;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, BCButton, BCLabel;

type

  { TFormInfo }

  TFormInfo = class(TForm)
    btOk: TBCButton;
    lbEstratto1: TBCLabel;
    lbEstratto2: TBCLabel;
    lbEstratto3: TBCLabel;
    procedure btOkClick(Sender: TObject);
  private

  public

  end;

var
  FormInfo: TFormInfo;

implementation

{$R *.lfm}

{ TFormInfo }

procedure TFormInfo.btOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

end.

