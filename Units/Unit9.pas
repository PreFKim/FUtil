unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, registry, sSkinProvider;

type
  TForm9 = class(TForm)
    GroupBox1: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    ListView1: TListView;
    Button4: TButton;
    Memo2: TMemo;
    Edit1: TEdit;
    Button5: TButton;
    Button6: TButton;
    sSkinProvider1: TsSkinProvider;
    procedure Button1Click(Sender: TObject);
    function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
    function SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

function TForm9.GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create( sKey );
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

function TForm9.SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
var 
reg : TRegIniFile; 
begin 
reg := TRegIniFile.Create( sKey ); 
reg.WriteString('', sItem, sVal + #0 ); 
reg.Free; 
end;

procedure TForm9.Button1Click(Sender: TObject);
var
reg : TRegistry;
List1 : TStringList;
i : integer;
begin
reg := TRegistry.Create;
List1 := TStringList.Create;
with reg do
begin
RootKey := HKEY_CURRENT_USER;
OpenKey('\Software\FUtil\Datetime\', false);
GetValueNames(List1);
end;
listview1.Clear;
for i := 0 to List1.Count -1 do
begin
with listview1.Items.Add do begin
Caption := list1.strings[i];
SubItems.add(reg.ReadString(List1.Strings[i]));
end;
end;
List1.Free;
reg.CloseKey;
reg.Destroy;
end;


procedure TForm9.FormShow(Sender: TObject);
begin
button1.Click;
DateTimePicker1.DateTime := now;
if GetStringFromRegistry('Software'+'\FUtil\Datetime\','FirstSaveDate','') = '' then begin
SaveStringToRegistry('Software'+'\FUtil\Datetime\','FirstSaveDate',FormatDatetime('YYYY-MM-DD', now));
end;
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
if GetStringFromRegistry('Software'+'\FUtil\Datetime\',FormatDatetime('YYYY-MM-DD',DateTimePicker1.Date),'') <> '' then begin
SaveStringToRegistry('Software'+'\FUtil\Datetime\',FormatDatetime('YYYY-MM-DD',DateTimePicker1.Date),GetStringFromRegistry('Software'+'\FUtil\Datetime\',FormatDatetime('YYYY-MM-DD',DateTimePicker1.Date),'')+','+memo1.text);
button1.Click;
memo1.Clear;
end
else
SaveStringToRegistry('Software'+'\FUtil\Datetime\',FormatDatetime('YYYY-MM-DD',DateTimePicker1.Date),memo1.text);
button1.Click;
memo1.Clear;
end;

procedure TForm9.Button3Click(Sender: TObject);
var
reg : TRegistry;
begin
if listview1.Itemindex = -1 then begin
showmessage('항목을 선택해주세요.');
end
else
if listview1.Itemindex <> 0 then begin
Reg := TRegistry.Create;
with reg do
begin
RootKey := HKEY_CURRENT_USER;
OpenKey('\Software\FUtil\Datetime\', false);
DeleteValue(listview1.Selected.Caption);
end;
Reg.CloseKey;
Reg.Free;
button1.Click;
end
else
showmessage('이 항목은 삭제할수 없습니다.');
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
if (button4.Caption = '수정완료') then begin
edit1.SendToBack;
memo2.sendtoback;
edit1.Visible := false;
memo2.Visible := false;
button4.Caption := '수정하기';
button3.Enabled := true;
button5.Enabled := false;
button2.Enabled := true;
SaveStringToRegistry('Software'+'\FUtil\Datetime\',edit1.Text,memo2.text);
end
else
if (listview1.Itemindex = -1) then begin
showmessage('항목을 선택해주세요.');
end
else
if (listview1.Itemindex = 0) then begin
showmessage('이 항목은 수정할수 없습니다.');
end
else
if button4.Caption = '수정하기' then begin
button4.Caption := '수정완료';
edit1.BringToFront;
memo2.BringToFront;
edit1.Visible := true;
memo2.Visible := true;
button5.Enabled := true;
button2.Enabled := false;
button3.Enabled := false;
edit1.text := listview1.Selected.caption;
memo2.Text := listview1.Selected.SubItems.Strings[0];
end;
button1.Click;
end;

procedure TForm9.Button5Click(Sender: TObject);
begin
edit1.SendToBack;
memo2.sendtoback;
edit1.Visible := false;
memo2.Visible := false;
button4.Caption := '수정하기';
button5.Enabled := false;
button2.Enabled := true;
button1.Click;
end;

procedure TForm9.Button6Click(Sender: TObject);
var
i : integer;
begin
for i := 0 to form9.ListView1.Items.Count-1 do begin
if pos(formatdatetime('YYYY-MM-DD',now),form9.ListView1.Items.Item[i].Caption) <> 0 then begin
case Application.MessageBox(pchar('하나의 일정이 발견되었습니다.'+#13#10+'일정내용:'+form9.ListView1.Items.Item[i].SubItems.Strings[0]+#13#10+'삭제하시겠습니까?(Y=삭제 N=취소)'), '일정',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
form9.ListView1.Selected := form9.ListView1.Items[i];
form9.button3.Click;
end;
IDNo:
begin
end;
end;
end;
end;
end;

end.
