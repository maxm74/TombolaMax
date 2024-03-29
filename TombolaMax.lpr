program TombolaMax;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, TombolaMax_Main, tombolamax_generate, tombolamax_info
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormTombola, FormTombola);
  Application.CreateForm(TFormGenerate, FormGenerate);
  Application.CreateForm(TFormInfo, FormInfo);
  Application.Run;
end.

