unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,shellapi;

type
  TForm14 = class(TForm)
    PaintBox1: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form14: TForm14;
  Rnd1, Rnd2, Rnd3, Rnd4, Rnd5, Rnd6: String;
  RndX, RndY: Integer;

implementation

{$R *.dfm}

procedure TForm14.Button1Click(Sender: TObject);
begin
RndX := 0;
RndY := 0;
Rnd1 := String(PChar(Nil));
Rnd2 := String(PChar(Nil));
Rnd3 := String(PChar(Nil));
Rnd4 := String(PChar(Nil));
Rnd5 := String(PChar(Nil));
Rnd6 := String(PChar(Nil));
PaintBox1.Canvas.FillRect(ClientRect);
Randomize;
RndX := Random(64);
RndY := Random(64);
Rnd1 := Chr(Integer(Random(26) + $41));
Rnd2 := Chr(Integer(Random(26) + $41));
Rnd3 := Chr(Integer(Random(26) + $41));
Rnd4 := Chr(Integer(Random(26) + $41));
Rnd5 := Chr(Integer(Random(26) + $41));
Rnd6 := Chr(Integer(Random(26) + $41));
PaintBox1.Canvas.TextOut(RndX, RndY, Rnd1);
PaintBox1.Canvas.TextOut(RndX + 32, RndY, Rnd2);
PaintBox1.Canvas.TextOut(RndX + 64, RndY, Rnd3);
PaintBox1.Canvas.TextOut(RndX + 96, RndY, Rnd4);
PaintBox1.Canvas.TextOut(RndX + 128, RndY, Rnd5);
PaintBox1.Canvas.TextOut(RndX + 160, RndY, Rnd6);
end;

procedure TForm14.Timer1Timer(Sender: TObject);
begin
Button1.Click;
Timer1.Enabled := False;
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
if LowerCase(Edit1.Text) = LowerCase(Rnd1) + LowerCase(Rnd2) + LowerCase(Rnd3) + LowerCase(Rnd4) + LowerCase(Rnd5) + LowerCase(Rnd6) then
begin
ShowMessage('성공');
end
else
begin
ShowMessage('실패');
end;
end;

procedure TForm14.FormActivate(Sender: TObject);
begin
form14.Button1.Click;
end;

procedure TForm14.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 13) then begin
button2.Click;
end;
end;

end.
