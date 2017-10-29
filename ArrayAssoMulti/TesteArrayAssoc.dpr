program TesteArrayAssoc;

uses
  Forms,
  UTesteArrayAssoc in 'UTesteArrayAssoc.pas' {Form1},
  ArrayAssoc in 'ArrayAssoc.pas',
  ArrayAssocClass in 'ArrayAssocClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
