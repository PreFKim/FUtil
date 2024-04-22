unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, MPlayer, StdCtrls,WMPLib_TLB, OleCtrls,
  sSkinProvider;

type
  TForm8 = class(TForm)
    GroupBox1: TGroupBox;
    WindowsMediaPlayer1: TWindowsMediaPlayer;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    sSkinProvider1: TsSkinProvider;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure WindowsMediaPlayer1StatusChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm8.Timer1Timer(Sender: TObject);
begin
groupbox1.width := WindowsMediaPlayer1.Width+16;
GroupBox2.Top := WindowsMediaPlayer1.Height+23;
groupbox1.Height := GroupBox2.Top+53;
GroupBox2.Width := GroupBox1.Width-14;
button2.width := (GroupBox2.Width-29 div 2);
button2.width := (button2.Width div 2)-(7 div 2);
button1.Width := button2.Width;
button2.Left := button1.Width+13;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
WindowsMediaPlayer1.fullScreen := true;
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute = true then begin
WindowsMediaPlayer1.URL := OpenDialog1.FileName;
end;
end;

procedure TForm8.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if label1.Caption = '변경됨' then begin
case application.MessageBox(pchar('현제 실행된 영상을 종료하시겠습니까?(현제 창은 종료됩니다.)'), 'EXIT',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
label1.Caption := '중지';
WindowsMediaPlayer1.close;
button2.Enabled := false;
end;
IDNo:
end;
end;
end;

procedure TForm8.WindowsMediaPlayer1StatusChange(Sender: TObject);
begin
if pos('재생 중',windowsmediaplayer1.status) <> 0 then begin
label1.Caption := '변경됨';
button2.Enabled := true;
end;
if windowsmediaplayer1.status ='중지됨' then begin
label1.Caption := '중지';
button2.Enabled := false;
end;
end;

end.

