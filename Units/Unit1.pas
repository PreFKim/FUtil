unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sSkinManager, Menus, XPMan,registry,
  OleCtrls, SHDocVw,shellapi, OleServer, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, sSkinProvider, IdRawBase,
  IdRawClient,IdIcmpClient,httpapp,winhttp_tlb;

  const
  WM_NOTIFYICON = WM_USER + 333;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    Label1: TLabel;
    Label2: TLabel;
    Button5: TButton;
    Button6: TButton;
    GroupBox2: TGroupBox;
    WebBrowser1: TWebBrowser;
    Button7: TButton;
    PopupMenu1: TPopupMenu;
    d1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    Button8: TButton;
    IdHTTP1: TIdHTTP;
    C1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    Button9: TButton;
    Button10: TButton;
    GroupBox4: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Button11: TButton;
    Button12: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button13: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
    function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure d1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
    { Private declarations }
    NotifyIcnData : TNotifyIconData;
    hMainIcon : HICON;
    procedure ClickTrayIcon(var msg: TMessage); message WM_NOTIFYICON;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3,  Unit7, Unit8, Unit9, Unit10, Unit11, Unit12,
  Unit13, Unit15, Unit4, Unit16;

{$R *.dfm}

function DelFolder(Folder: string): Boolean;
var
  WhichFile: TSHFileOpStruct;
begin
  ZeroMemory(@WhichFile, SizeOf(WhichFile));
  with WhichFile do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(Folder + #0);
  end;
  Result := (0 = ShFileOperation(WhichFile));
end;

function Parsing(Const MainString,First,Second:string):String;
var
stmp: String;
begin
stmp := MainString;
stmp := Copy(stmp,POS(First,stmp) + length(First),length(stmp));
result := Copy(stmp,1,POS(Second,sTmp)-1);
end;

procedure TForm1.ClickTrayIcon(var msg: TMessage);
var
    pt: TPoint;
begin
  case msg.lparam of
   {WM_LBUTTONDOWN : (왼쪽마우스를 클릭할시)
    WM_LBUTTONDBLCLK : (왼쪽마우스 더블클릭시)
    WM_LBUTTONUP :(왼쪽마우스에서 손을땔시)
    WM_RBUTTONDOWN : (오른쪽마우스를 클릭할시)
    WM_RBUTTONDBLCLK : (오른쪽마우스 더블클릭시)
    WM_RBUTTONUP : (오른쪽마우스에서 손을땔시)
    WM_MOUSEMOVE : (마우스를 움직일시)
    }
    WM_LBUTTONDOWN :
    begin
    D1.ClICK;
    end;
    WM_RBUTTONDOWN :
      begin
        GetCursorPos(pt);
        PopupMenu1.Popup(pt.x, pt.y);
      end;
  end;
end;

function TForm1.SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
var
reg : TRegIniFile;
begin
reg := TRegIniFile.Create( sKey );
reg.WriteString('', sItem, sVal + #0 );
reg.Free;
end;

function TForm1.GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create( sKey );
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

function GetRegistryValue(AD,name:string): string;
var
  Registry: TRegistry;
begin
  Registry:=TRegistry.Create;
  Registry.RootKey:=HKEY_LOCAL_MACHINE;
  Registry.OpenKey(AD,False);
  Result :=Registry.ReadString(name);
  Registry.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
form2.show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
form4.show;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
form7.show;
end;

procedure TForm1.FormShow(Sender: TObject);
var
i : integer;
dStream : TFileStream;
begin
if GetStringFromRegistry('Software'+'\FUtil','Defaultdir','') <> '' then begin
form7.Edit1.text := GetStringFromRegistry('Software'+'\FUtil','Defaultdir','');
end;
createdir(form7.edit1.text);
Copyfile(pchar(ExtractFilePath(Application.ExeName)+ExtractFileName(Application.ExeName)),pchar(form7.edit1.text+'FUtil_autorun.exe'),false);
if ParamStr(1) = '-Reboot' then begin
sleep(1000);
MessageBox(0, 'Reboot모드로 실행하셨습니다.', 'Reboot', MB_ICONinformation);
end;
if fileexists(form7.edit1.text+'alarmclock.wav') = false then begin
dStream := TFileStream.Create(form7.edit1.text+'alarmclock.wav', fmCreate or fmShareExclusive);
idhttp1.Head('http://pds25.egloos.com/pds/201404/05/09/alarmclock.wav');
idHTTP1.Get('http://pds25.egloos.com/pds/201404/05/09/alarmclock.wav', dStream);
Application.ProcessMessages;
application.Terminate;
shellexecute(0,0,pchar(form7.edit1.text+'FUtil_autorun.exe'),pchar('-Reboot'),nil,SW_SHOWNORMAL);
exit;
end;
if fileexists(form7.edit1.text+'alarmclock.wav') = true then begin
form13.MediaPlayer1.FileName := form7.edit1.text+'alarmclock.wav';
form13.MediaPlayer1.Open;
end;
if fileexists(form7.edit1.text+'Alarmsave.FUtil') = true then begin
renamefile(form7.edit1.text+'Alarmsave.FUtil',form7.edit1.text+'Alarm.FUtil');
end;
if (GetStringFromRegistry('Software'+'\FUtil','Deletedir','') <> '') and (GetStringFromRegistry('Software'+'\FUtil','Changedir','') = 'O') then begin
if GetStringFromRegistry('Software'+'\FUtil','Deletedir','') = ExtractFilePath(Application.ExeName) then begin
application.Terminate;
shellexecute(0,0,pchar(GetStringFromRegistry('Software'+'\FUtil','Defaultdir','')+'FUtil_autorun.exe'),pchar('-Reboot'),nil,SW_SHOWNORMAL);
exit;
end
else
DelFolder(GetStringFromRegistry('Software'+'\FUtil','Deletedir',''));
SaveStringToRegistry('Software'+'\FUtil','Changedir','X');
end;
end;
if GetStringFromRegistry('Software'+'\FUtil','2Height','') <> '' then begin
form3.ClientHeight := strtoint(GetStringFromRegistry('Software'+'\FUtil','2Height',''));
form7.Edit2.Text := GetStringFromRegistry('Software'+'\FUtil','2Height','');
end;
if GetStringFromRegistry('Software'+'\FUtil','2Width','') <> '' then begin
form3.ClientWidth := strtoint(GetStringFromRegistry('Software'+'\FUtil','2Width',''));
form7.Edit3.Text := GetStringFromRegistry('Software'+'\FUtil','2Width','');
end;
if GetStringFromRegistry('Software'+'\FUtil','4Height','') <> '' then begin
form4.ClientHeight := strtoint(GetStringFromRegistry('Software'+'\FUtil','4Height',''));
form7.Edit4.Text := GetStringFromRegistry('Software'+'\FUtil','4Height','');
end;
if GetStringFromRegistry('Software'+'\FUtil','4Width','') <> '' then begin
form4.ClientWidth := strtoint(GetStringFromRegistry('Software'+'\FUtil','4Width',''));
form7.Edit5.Text := GetStringFromRegistry('Software'+'\FUtil','4Width','');
end;
if GetStringFromRegistry('Software'+'\FUtil','Trayicon','') = 'O' then begin
form7.RadioButton3.Checked := true;
end;
if GetStringFromRegistry('Software'+'\FUtil','Autorun','') = 'O' then begin
form7.RadioButton1.Checked := true;
end;
if fileexists(form7.edit1.text+'Alarm.FUtil') = true then begin
ReadComponentResFile(form7.edit1.text+'Alarm.FUtil',form12.ListView1);
end;
if GetStringFromRegistry('Software'+'\FUtil','Startmenu','') <> '1' then begin
case MessageBox(0,pchar('시작메뉴에 FUtil.lnk를 생성하시겠습니까?(Y=생성 N=취소)'), '일정',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
createdir('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FUtil');
form7.Button6.Click;
IDNO:
end;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') <> '' then begin
form7.ComboBox1.ItemIndex := strtoint(GetStringFromRegistry('Software'+'\FUtil','Execform',''));
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '1' then begin
button1.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '2' then begin
button2.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '3' then begin
button3.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '4' then begin
button5.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '5' then begin
button6.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '6' then begin
button7.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','Execform','') = '7' then begin
button8.click;
end;
if GetStringFromRegistry('Software'+'\FUtil','2Autosave','') = '1' then begin
form7.CheckBox1.Checked := true;
end;
if GetStringFromRegistry('Software'+'\FUtil','4Autosave','') = '1' then begin
form7.CheckBox2.Checked := true;
end;
form9.Button1.Click;
for i := 0 to form9.ListView1.Items.Count-1 do
if pos(formatdatetime('YYYY-MM-DD',now),form9.ListView1.Items.Item[i].Caption) <> 0 then begin //검색
case MessageBox(0,pchar('오늘의 일정이 발견되었습니다.'+#13#10+'일정내용:'+form9.ListView1.Items.Item[i].SubItems.Strings[0]+#13#10+'삭제하시겠습니까?(Y=삭제 N=취소)'), '일정',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
form9.ListView1.Selected := form9.ListView1.Items[i];
form9.button3.Click;
end;
IDNo:
end;
end;
if GetStringFromRegistry('Software'+'\FUtil','ID','') <> '' then begin
edit1.Text := GetStringFromRegistry('Software'+'\FUtil','ID','');
checkbox1.Checked :=true;
end;
if GetStringFromRegistry('Software'+'\FUtil','PW','') <> '' then begin
edit2.Text := GetStringFromRegistry('Software'+'\FUtil','PW','');
checkbox2.Checked :=true;
end;
if GetStringFromRegistry('Software'+'\FUtil','lnkCreate','') <> '1' then begin
case MessageBox(0,pchar('바탕화면에 FUtil.lnk를 생성하시겠습니까?(Y=생성 N=취소)'), '일정',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
form7.button3.Click;
IDNo:
end;
end;
label1.Caption := GetRegistryValue('SOFTWARE\Microsoft\Windows NT\CurrentVersion','ProductName')+' '+GetRegistryValue('SOFTWARE\Microsoft\Windows NT\CurrentVersion','CSDVersion')+'빌드:'+GetRegistryValue('SOFTWARE\Microsoft\Windows NT\CurrentVersion','CurrentBuild');
SaveStringToRegistry('Software'+'\FUtil','Startmenu','1');
SaveStringToRegistry('Software'+'\FUtil','lnkCreate','1');
end;


procedure TForm1.Button5Click(Sender: TObject);
begin
form8.show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if form7.RadioButton3.Checked = true then begin
Action := caNone;
hide;
form11.show;
end;
if form7.RadioButton4.Checked = true then begin
case MessageBox(0,pchar('FUtil을 종료하시겠습니까?'), 'EXIT',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
n2.Click;
end;
IDNO:                                             
begin
Action := caNone;
end;
end;
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
groupbox1.Caption := Formatdatetime('(YYYY년 MM월 DD일 TT)',now);
if label1.Width > 170 then begin
label1.Width := 170;
end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
form9.show;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
iconData    : TNotifyIconData;
begin
  // System Tray에 Icon 표시
  hMainIcon := LoadIcon(MainInstance, 'MAINICON');
  Shell_NotifyIcon(NIM_DELETE, @NotifyIcnData);
  with NotifyIcnData do
  begin
    cbSize            := sizeof(TNotifyIconData);
    Wnd               := handle;
    uID               := 11111;
    uFlags            := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage  := WM_NOTIFYICON;
    hIcon             := HMainIcon;
    szTip             := 'FUtil이 실행중입니다.';
  end;
  Shell_NotifyIcon(NIM_ADD, @NotifyIcnData);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
form8.Timer1.Enabled := false;
Shell_NotifyIcon(NIM_DELETE, @NotifyIcnData);
Application.Terminate;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
form7.Show;
end;

procedure TForm1.d1Click(Sender: TObject);
begin
form1.Show;
form11.Hide;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
form12.show;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
if GetStringFromRegistry('Software'+'\FUtil','SkinNum','') <> '' then begin
form7.ComboBox2.ItemIndex := strtoint(GetStringFromRegistry('Software'+'\FUtil','SkinNum',''));
form7.Button4.Click;
end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
vermemo : string;
begin
vermemo := idhttp1.Get('http://pref86.egloos.com/4135192');
vermemo := parsing(vermemo,'<p>Version:','<br/>');
if LowerCase(vermemo) <> LowerCase('R3') then begin
if fileexists(form7.edit1.text+'Setups.exe') = true then begin
case messagebox(0,pchar('새 버전이 발견되었습니다.(새버전:'+vermemo+')'+#13#10+'다운로드 하시겠습니까?'),'Update',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
begin
shellexecute(0,0,pchar(form7.edit1.text+'Setups.exe'),pchar(''),nil,SW_SHOWNORMAL);
application.Terminate;
end;
end;
end;
if fileexists(form7.edit1.text+'Setups.exe') = false then begin
showmessage('Setup.exe 파일이 존재하지않습니다.');
application.Terminate;
end;
end
else
showmessage('다운로드할 버전이 없습니다.');
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
if checkbox1.Checked = true then begin
SaveStringToRegistry('Software'+'\FUtil','ID',edit1.text);
end;
if checkbox2.Checked = true then begin
SaveStringToRegistry('Software'+'\FUtil','PW',edit2.text);
end;
if button11.Caption = '로그아웃' then begin
edit1.Enabled := true;
edit2.Enabled := true;
button11.Caption := '로그인';
form7.groupbox14.Enabled := false;
button13.Enabled := false;
showmessage('로그아웃 하셨습니다.');
exit;
end;
if button11.Caption = '로그인' then begin
 WinHttp := coWinHttpRequest.Create;
 WinHttp.Open('GET', 'http://futil.dothome.co.kr/login.php?id='+httpencode(Edit1.Text)+'&ps='+httpencode(Edit2.Text), False);
 WinHttp.Send('');
 if WinHttp.ResponseText = 'Login success!' then begin
  ShowMessage('로그인 하셨습니다.');
  edit1.Enabled := false;
  edit2.Enabled := false;
  button13.Enabled := true;
  button11.Caption := '로그아웃';
  form7.groupbox14.Enabled := true;
  exit;
 end
 else
  edit1.Enabled := true;
  edit2.Enabled := true;
  button11.Caption := '로그인';
  ShowMessage('ID또는 PW를 재확인 해주세요.');
end;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
button11.Caption := '로그인';
edit1.Enabled := true;
edit2.Enabled := true;
form7.groupbox14.Enabled := false;
button13.Enabled := false;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
form16.show;
form16.Button3.click;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
if button10.Caption = '로그인(Show)' then begin
groupbox4.Visible := true;
button10.Caption := '로그인(Hide)';
exit;
end;
if button10.Caption = '로그인(Hide)' then begin
Groupbox4.Visible := false;
button10.Caption := '로그인(Show)';
end;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
WinHttp := coWinHttpRequest.Create;
 WinHttp.Open('GET', 'http://futil.dothome.co.kr/checkid.php?id='+httpencode(Edit1.Text), False);
 WinHttp.Send('');
 if pos('Use',winhttp.ResponseText) <>  0 then begin
 WinHttp := coWinHttpRequest.Create;
 WinHttp.Open('GET', 'http://futil.dothome.co.kr/unjoin.php?id='+httpencode(Edit1.Text), False);
 WinHttp.Send('');
 if pos('delete',WinHttp.ResponseText) <> 0 then begin
 ShowMessage('회원탈퇴가 완료되었습니다.');
 button11.Click;
 end;
 if pos('no folder',WinHttp.ResponseText) <> 0 then begin
 ShowMessage('존재하지 않는 회원입니다.');
 button11.Click;
 end;
end;
end;

end.


