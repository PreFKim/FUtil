unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WinHttp_TLB, ExtCtrls,shellapi, httpapp;

type
  TForm16 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    PaintBox1: TPaintBox;
    Edit4: TEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form16: TForm16;
  Rnd1, Rnd2, Rnd3, Rnd4, Rnd5, Rnd6: String;
  RndX, RndY: Integer;
  WinHttp: IWinHttpRequest;

implementation

{$R *.dfm}

procedure TForm16.Button3Click(Sender: TObject);
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
RndX := Random(20);
RndY := Random(2);
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
edit4.Clear;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
 if length(edit2.Text) < 7 then begin
 showmessage('비밀번호를 7글자 이상 적어주세요');
 exit;
 end;
 if (Edit2.Text <> Edit3.Text) then begin
  ShowMessage('비밀번호가 일치하지 않습니다.');
  exit;
 end;
 if LowerCase(Edit4.Text) <> LowerCase(Rnd1) + LowerCase(Rnd2) + LowerCase(Rnd3) + LowerCase(Rnd4) + LowerCase(Rnd5) + LowerCase(Rnd6) then begin
  showmessage('자동 가입 방지 문자를 다시 확인해주십시오.');
  button3.Click;
  exit;
 end;
 WinHttp := coWinHttpRequest.Create;
 WinHttp.Open('GET', 'http://futil.dothome.co.kr/join.php?id='+httpencode(Edit1.Text)+'&pw='+httpencode(Edit2.Text), False);
 WinHttp.Send('');
 ShowMessage('회원가입 완료');
 form16.Close;
end;

procedure TForm16.Button2Click(Sender: TObject);
begin
if (edit1.Text <> '') and (length(edit1.text) >= 4) and (length(edit1.text) <= 16)  then begin
 WinHttp := coWinHttpRequest.Create;
 WinHttp.Open('GET', 'http://futil.dothome.co.kr/checkid.php?id='+httpencode(Edit1.Text), False);
 WinHttp.Send('');
 if pos('Noid',winhttp.ResponseText) <>  0 then begin
 showmessage('현재 ID('+edit1.text+')를 사용하실수있습니다.');
 button1.Enabled := true;
 exit;
 end;
 showmessage('현재 ID('+edit1.text+')가 사용중입니다.');
 button1.Enabled := false;
end
else
showmessage('아이디는 4~16글자 사이로 사용해주세요');
end;

procedure TForm16.Edit1Change(Sender: TObject);
begin
button1.Enabled := false;
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
edit1.Clear;
edit2.Clear;
edit3.Clear;
edit4.Clear;
button1.Enabled := false;
end;

end.
