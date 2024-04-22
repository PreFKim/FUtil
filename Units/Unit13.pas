unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MPlayer, sSkinProvider;

type
  TForm13 = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    sSkinProvider1: TsSkinProvider;
    MediaPlayer1: TMediaPlayer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;

implementation

uses Unit12;

{$R *.dfm}

procedure TForm13.Button1Click(Sender: TObject);
begin
timer1.Enabled := false;
MediaPlayer1.Stop;
form13.Close;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
timer1.Enabled := false;
MediaPlayer1.Stop;
end;

procedure TForm13.Timer1Timer(Sender: TObject);
begin
MediaPlayer1.Play;
end;

end.
