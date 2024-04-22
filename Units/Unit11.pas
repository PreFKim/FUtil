unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sSkinProvider;

type
  TForm11 = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    sSkinProvider1: TsSkinProvider;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
begin
if combobox1.Itemindex = -1 then begin
showmessage('보이게할 창을 선택하여주세요');
end;
if combobox1.Itemindex = 0 then begin
form1.d1.Click;
end;
if combobox1.Itemindex = 1 then begin
form1.button1.Click;
end;
if combobox1.Itemindex = 2 then begin
form1.button2.Click;
end;
if combobox1.Itemindex = 3 then begin
form1.button3.Click;
end;
if combobox1.Itemindex = 4 then begin
form1.button5.Click;
end;
if combobox1.Itemindex = 5 then begin
form1.button6.Click;
end;
if combobox1.Itemindex = 6 then begin
form1.button7.Click;
end;
if combobox1.Itemindex = 7 then begin
form1.button8.Click;
end;
if combobox1.Itemindex = 8 then begin
form1.button4.Click;
end;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
form1.N2.Click;
end;

procedure TForm11.Timer1Timer(Sender: TObject);
begin
if Form11.Left <> (screen.width - Form11.width) then begin
Form11.Left:= (screen.width - Form11.width);
end;
if Form11.Top <> (screen.Height - Form11.Height)-39 then begin
Form11.Top:= (screen.Height - Form11.Height)-39;
end;
end;

procedure TForm11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
showmessage('메인창을 다시 보이게 하시려면 우클릭해주세요');
end;

end.
