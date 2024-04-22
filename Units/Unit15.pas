unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm15 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Memo1: TMemo;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

function Parsing(Const MainString,First,Second:string):String;
var
stmp: String;
begin
stmp := MainString;
stmp := Copy(stmp,POS(First,stmp) + length(First),length(stmp));
result := Copy(stmp,1,POS(Second,sTmp)-1);
if result = '' then begin
result := '검색된 결과가 없습니다.';
end;
end;

procedure TForm15.Button1Click(Sender: TObject);
begin
edit3.Text := parsing(memo1.Text,edit1.text,edit2.Text);
end;

procedure TForm15.Memo1Click(Sender: TObject);
begin
memo1.Text := '';
end;

procedure TForm15.Edit1Click(Sender: TObject);
begin
edit1.Text := '';
end;

procedure TForm15.Edit2Click(Sender: TObject);
begin
edit2.Text := '';
end;

end.
 