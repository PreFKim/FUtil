unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,FileCtrl,
  sSkinProvider, sSkinManager, XPMan,shellapi,Registry;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Edit2: TEdit;
    GroupBox4: TGroupBox;
    Button4: TButton;
    Button5: TButton;
    GroupBox5: TGroupBox;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    IdHTTP1: TIdHTTP;
    Button6: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Edit3: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox6: TGroupBox;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    GroupBox7: TGroupBox;
    Memo1: TMemo;
    Edit4: TEdit;
    Memo2: TMemo;
    ListView1: TListView;
    sSkinProvider1: TsSkinProvider;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
    function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
    function Infonmation(Head:string):string;
    function FileSize():string;
    procedure Button9Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Edit4Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  function DownLoadUpdater(AUrl, Outputfilename : string): Boolean;
      { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Dir,ST,FST: String;
  dStream: TFileStream;
  i:integer;
  reg : TRegIniFile;

implementation

uses Unit1;

{$R *.dfm}

function tForm2.FileSize():string;
begin
FST := '0';
if listview1.Items.Count-1 = -1 then begin
GroupBox3.Caption := '다운로드(다운받을 파일크기:0KB)'
end;
for i := 0 to ListView1.Items.Count-1 do begin
try
idhttp1.Head(ListView1.Items[i].Caption);
FST := inttostr(strtoint(FST)+idhttp1.Response.ContentLength);
GroupBox3.Caption := '다운로드(다운받을 파일크기:'+ FST +'KB)'
except on E: Exception do
end;
end;
end;

function TForm2.Infonmation(Head:string):string;
begin
  Memo1.Clear;

  try
    IdHTTP1.Head(Head);
    Memo1.Lines.Add('Server: ' + IdHTTP1.Response.Server);
    Memo1.Lines.Add('Connection: ' + IdHTTP1.Response.Connection);
    Memo1.Lines.Add('CacheControl: ' + IdHTTP1.Response.CacheControl);
    Memo1.Lines.Add('Location: ' + IdHTTP1.Response.Location);
    Memo1.Lines.Add('ContentLength: ' + IntToStr(IdHTTP1.Response.ContentLength)); // 파일 크기
    Memo1.Lines.Add('ContentEncoding: ' + IdHTTP1.Response.ContentEncoding);
    Memo1.Lines.Add('ContentLanguage: ' + IdHTTP1.Response.ContentLanguage);
    Memo1.Lines.Add('ContentType: ' + IdHTTP1.Response.ContentType);
    Memo1.Lines.Add('ContentVersion: ' + IdHTTP1.Response.ContentVersion);
    Memo1.Lines.Add('ResponseText: ' + IdHTTP1.Response.ResponseText);
    Memo1.Lines.Add('CustomHeaders: ' + IdHTTP1.Response.CustomHeaders.Text);
    Memo1.Lines.Add('ProxyConnection: ' + IdHTTP1.Response.ProxyConnection);
    Memo1.Lines.Add('ProxyAuthenticate: ' + IdHTTP1.Response.ProxyAuthenticate.Text);
    Memo1.Lines.Add('WWWAuthenticate: ' + IdHTTP1.Response.WWWAuthenticate.Text);

    // IdHTTP.Response 의 프러퍼티중 일부 파싱을 잘못하여 정보가 들어있지 않은 경우나
    // 최신의 Indy 컴포넌트가 아니어서 Response.LastModified 가 없는경우는
    // 직접 Response.RawHeaders 를 읽어 정보를 알아낼 수 있다
    //Memo1.Lines.Add('LastModified: ' + IdHTTP1.Response.LastModified);
    Memo1.Lines.Add('RawHeaders: ' + IdHTTP1.Response.RawHeaders.Text);
  except on E: Exception do
    Memo1.Lines.Add(E.Message);
  end;
  end;

function TForm2.GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create( sKey );
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

function TForm2.SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
var 
reg : TRegIniFile; 
begin 
reg := TRegIniFile.Create( sKey ); 
reg.WriteString('', sItem, sVal + #0 ); 
reg.Free; 
end; 

function TForm2.DownLoadUpdater(AUrl, Outputfilename : string): Boolean;
begin
Result := True;
try
createdir(edit1.Text+edit3.Text);
dStream := TFileStream.Create(edit1.Text+edit3.Text+'\' + Outputfilename , fmCreate or fmShareExclusive);
idhttp1.Head(AUrl);
progressbar2.Position := 0;
ProgressBar2.max := idhttp1.response.ContentLength;
idHTTP1.Get(AUrl, dStream);
Application.ProcessMessages;
dStream.Free;
except
Result := False;
end;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
if pos('https://',LowerCase(edit2.Text))<>0  then begin
showmessage('https는 지원하지않습니다.');
end
else
if pos('http://',LowerCase(edit2.Text))<>0 then begin
try
idhttp1.Head(edit2.Text);
st := idhttp1.Response.Server;
except on E: Exception do
showmessage('존재하지않는 주소입니다.');
end;
if (st <> '') and (pos('.',edit4.text)<>0) then begin
with listview1.Items.add do begin
Caption := edit2.text;
SubItems.Add(edit4.text);
edit2.Text := '다운로드주소';
edit4.text := '파일이름(확장자포함 ex:FS.exe)';
filesize();
end;
end;
end
else
showmessage('주소나 파일이름을 정확히 입력하거나 HTTP://를붙여주세요');
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
listview1.Items.Delete(listview1.itemindex);
filesize();
end
else
showmessage('삭제할 주소를 지정해주세요');
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
if SaveDialog1.Execute = true then begin
writeComponentResFile(savedialog1.FileName,listview1);
end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
if openDialog1.Execute = true then begin
ReadComponentResFile(opendialog1.FileName,listview1);
ListView1.Columns.Items[0].Width := 270;
ListView1.Columns.Items[1].Width := 60;
filesize();
end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
if SelectDirectory( '다운로드될 경로를 지정해주세요', '경로', Dir ) then
edit1.text := dir+'\';
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
if ListView1.Items.Count = 0 then begin
showmessage('다운로드에 이용될 주소가없습니다.');
button6.enabled := true;
edit1.Enabled := true;
edit3.Enabled := true;
exit;
end
else
progressbar1.Position := 0;
button6.enabled := false;
edit1.Enabled := false;
edit3.Enabled := false;
for i:= 0 to listview1.items.count-1 do begin
if fileExists(edit1.Text+edit3.text+'\'+ListView1.Items[i].SubItems.strings[0]) = true then begin
case Application.MessageBox(pchar(ListView1.Items[i].SubItems.Text+'가이미 있습니다. 덮어쓰시겠습니까?'+#13#10+'(Y=덮어쓰기,N=다운로드취소'), '덮어쓰기',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
DownLoadUpdater(ListView1.Items[i].Caption,ListView1.Items[i].SubItems.strings[0]);
end;
IDNo:
begin
button6.enabled := true;
edit1.Enabled := true;
edit3.Enabled := true;
showmessage('다운로드가 취소되었습니다.');
exit;
end;
end;
end
else
DownLoadUpdater(ListView1.Items[i].Caption,ListView1.Items[i].SubItems.strings[0]);
if progressbar2.Position = progressbar2.Max then begin
progressbar1.Position := progressbar1.Position+1;
progressbar1.max := ListView1.Items.Count;
end;
if (checkbox1.Checked = true) and (i = ListView1.Items.Count-1) then begin
Shellexecute(0, 'open',pchar(edit1.text+edit3.text), nil, nil, SW_SHOWNORMAL);
end;
if (checkbox2.Checked = true) and (i = ListView1.Items.Count-1) then begin
form1.close;
end;
if i = ListView1.Items.Count-1 then begin
button6.enabled := true;
edit1.Enabled := true;
edit3.Enabled := true;
showmessage('다운로드가 완료되었습니다.');
end;
end;
end;

procedure TForm2.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
if (AWorkMode = wmRead) then
begin
ProgressBar2.position := AWorkCount;
end;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
Shellexecute(0, 'open',pchar('http://pref86.egloos.com/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
Shellexecute(0, 'open',pchar('http://pref86.egloos.com/4037340'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
if GetStringFromRegistry('Software'+'\FUtil','Dir','') = '' then begin
end;
if GetStringFromRegistry('Software'+'\FUtil','For','') = '' then begin
end;
if (GetStringFromRegistry('Software'+'\FUtil','Dir','') <> '') and (GetStringFromRegistry('Software'+'\FSetups','For','') <> '') then begin
edit1.text := GetStringFromRegistry('Software'+'\FUtil','Dir','');
edit3.text := GetStringFromRegistry('Software'+'\FUtil','For','');
end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveStringToRegistry('Software'+'\FUtil','Dir',edit1.text);
SaveStringToRegistry('Software'+'\FUtil','For',edit3.text);
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
edit1.text := 'C:\';
edit3.text := '폴더이름';
end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin
Infonmation(ListView1.Selected.Caption);
end;

procedure TForm2.Edit2Click(Sender: TObject);
begin
edit2.Text := '';
end;

procedure TForm2.Edit4Click(Sender: TObject);
begin
edit4.Text := '';
end;

procedure TForm2.ListView1Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
Infonmation(listview1.Items.Item[listview1.itemindex].Caption);
end;
end;

procedure TForm2.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (listview1.itemindex <> -1) and (odd(GetAsyncKeyState(VK_delete))) then begin
listview1.Items.Delete(listview1.itemindex);
filesize();
end;
end;

end.

