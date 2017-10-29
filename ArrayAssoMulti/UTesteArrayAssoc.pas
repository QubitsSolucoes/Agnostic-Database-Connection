unit UTesteArrayAssoc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnArray: TButton;
    procedure btnArrayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ArrayAssoc;

{$R *.dfm}

procedure TForm1.btnArrayClick(Sender: TObject);
var
  ArrayAssocBi: TArrayAssocBi;
  Verify: Boolean;
begin
  ArrayAssocBi['String']['Teste'] := 'outro teste';
  ArrayAssocBi['String']['Teste2'] := 'STr6';
  ArrayAssocBi['String 2']['teste3'] := 'Str5';
  ArrayAssocBi['String 2']['teste4'] := 'Str4';
  ArrayAssocBi['String 4']['teste4'] := 'Str4';

  Showmessage(ArrayAssocBi['String']['Teste']);
  Showmessage(ArrayAssocBi['String 2']['teste3']);
  Showmessage(ArrayAssocBi['String 4']['teste4']);
end;

end.
