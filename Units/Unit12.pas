unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, MPlayer, Buttons, sSkinProvider;

type
  TForm12 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    DateTimePicker1: TDateTimePicker;
    GroupBox2: TGroupBox;
    checktime: TTimer;
    Button2: TButton;
    ListView1: TListView;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    sSkinProvider1: TsSkinProvider;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure checktimeTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

uses Unit1, Unit13, Unit7;

{$R *.dfm}


procedure TForm12.Button1Click(Sender: TObject);
begin
if (speedbutton1.Down = false) and (speedbutton2.Down = false) and (speedbutton3.Down = false) and (speedbutton4.Down = false) and (speedbutton5.Down = false) and (speedbutton6.Down = false) and (speedbutton7.Down = false) then begin
showmessage('알람이 울려질 요일을 선택해주세요');
end
else
with listview1.Items.add do begin
Caption := formatdatetime('t' ,DateTimePicker1.Time);
subitems.Add('');
if SpeedButton1.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '일';
end;
if SpeedButton2.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '월';
end;
if SpeedButton3.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '화';
end;
if SpeedButton4.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '수';
end;
if SpeedButton5.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '목';
end;
if SpeedButton6.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '금';
end;
if SpeedButton7.Down = true then begin
listview1.Items.Item[index].SubItems.Strings[0] := listview1.Items.Item[index].SubItems.Strings[0] + '토';
end;
speedbutton1.Down := false;
speedbutton2.Down := false;
speedbutton3.Down := false;
speedbutton4.Down := false;
speedbutton5.Down := false;
speedbutton6.Down := false;
speedbutton7.Down := false;
writeComponentResFile(form7.edit1.text+'Alarm.FUtil',form12.ListView1);
end;
end;

procedure TForm12.FormShow(Sender: TObject);
begin
DateTimePicker1.Time := now;
end;

procedure TForm12.checktimeTimer(Sender: TObject);
var
i : integer;
begin
for i := 0 to listview1.Items.Count-1 do begin
if (listview1.Items.Item[i].Caption = formatdatetime('t',now)) and (pos(formatdatetime('ddd',now),listview1.Items.Item[i].SubItems.Strings[0])<>0) and (form13.label1.Caption <> '알람시간:'+formatdatetime('t',now)) then begin
form13.MediaPlayer1.Play;
form13.label1.caption := '알람시간:'+ listview1.Items.Item[i].Caption;
form13.Label1.Width := 553;
form13.Show;
form13.timer1.Enabled := true;
end;
end;
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
if listview1.Itemindex <> -1 then begin
listview1.Selected.Delete;
writeComponentResFile(form7.edit1.text+'Alarm.FUtil',form12.ListView1);
end
else
showmessage('목록중 하나를 선택해주세요');
end;

procedure TForm12.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (odd(GetAsyncKeyState(VK_delete))) and (listview1.itemindex <> -1) then begin
button2.Click;
end;
end;

end.

