unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, sSkinManager, XPMan,registry,TLhelp32,shellapi, ShFolder,ShlObj, ActiveX, ComObj,IdException,FileCtrl;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label6: TLabel;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Label5: TLabel;
    Label7: TLabel;
    sSkinManager1: TsSkinManager;
    saveaworkcount: TLabel;
    CheckBox1: TCheckBox;
    Label8: TLabel;
    IdHTTP1: TIdHTTP;
    GroupBox2: TGroupBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
    Button4: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    FUtilurl: TEdit;
    parsingmemo: TMemo;
    FUtilVersion: TEdit;
    wavfile: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure Button4Click(Sender: TObject);
  private
  function DownLoadUpdater(AUrl, Outputfilename : string): Boolean;
  function checkingFiles():integer;
  function SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
  function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
  procedure Startmenu();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create( sKey );
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

function KillProcess(const ProcName: String): Boolean;
var
  Process32: TProcessEntry32;
  SHandle:   THandle;
  Next:      Boolean;
  hProcess: THandle;
  i: Integer;
begin
  Result:=True;
  Process32.dwSize       :=SizeOf(TProcessEntry32);
  Process32.th32ProcessID:=0;
  SHandle                :=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  // 종료하고자 하는 프로세스가 실행중인지 확인하는 의미와 함께...
  if Process32First(SHandle, Process32) then begin
    repeat
      Next:=Process32Next(SHandle, Process32);
      if AnsiCompareText(Process32.szExeFile, Trim(ProcName))=0 then break;
    until not Next;
  end;
  CloseHandle(SHandle);
  // 프로세스가 실행중이라면 Open & Terminate
  if Process32.th32ProcessID<>0 then begin
    hProcess:=OpenProcess(PROCESS_TERMINATE, True, Process32.th32ProcessID);
    if hProcess<>0 then begin
      if not TerminateProcess(hProcess, 0) then Result:=False;
    end
    // 프로세스 열기 실패
    else Result:=False;
    CloseHandle(hProcess);
  end // if Process32.th32ProcessID<>0
  else Result:=False;
  closehandle(hprocess);
end;

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

function GetSystemDirectory(Dir: Integer): String;
var Path: PChar;
begin
Result:='';
GetMem(Path, MAX_PATH);
SHGetFolderPath(0, Dir, 0, 0, Path);
Result:=Copy(Path, 0, Length(Path));
FreeMem(Path);
end;

function Parsing(Const MainString,First,Second:string):String;
var
stmp: String;
begin
stmp := MainString;
stmp := Copy(stmp,POS(First,stmp) + length(First),length(stmp));
result := Copy(stmp,1,POS(Second,sTmp)-1);
end;

function TForm1.SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
var
reg : TRegIniFile;
begin
reg := TRegIniFile.Create( sKey );
reg.WriteString('', sItem, sVal + #0 );
reg.Free;
end;

function TForm1.checkingFiles():integer;
begin
idhttp1.Head(FUtilurl.Text);
progressbar1.Max := idhttp1.response.ContentLength;
idhttp1.Head(Wavfile.text);
progressbar1.Max := progressbar1.Max + idhttp1.response.ContentLength;
end;

function TForm1.DownLoadUpdater(AUrl, Outputfilename : string): Boolean;
var
dStream : TFileStream;
begin
Result := True;
try
createdir(edit1.text);
label4.Caption := outputfilename + '를 설치중';
dStream := TFileStream.Create(edit1.text + Outputfilename , fmCreate or fmShareExclusive);
idhttp1.Head(AUrl);
progressbar2.Position := 0;
ProgressBar2.max := idhttp1.response.ContentLength;
idHTTP1.Get(AUrl, dStream);
Application.ProcessMessages;
saveaworkcount.caption := inttostr(idhttp1.response.ContentLength);
dStream.Free;
label4.Caption := '완료';
except
Result := False;
end;
end;

procedure tform1.Startmenu();
var
MyObject: IUnknown;
MySLink: IShellLink;
MyPFile: IPersistFile;
begin
MyObject:=CreateComObject(CLSID_ShellLink);
MySLink:=MyObject as IShellLink;
MyPFile:=MyObject as IPersistFile;
with MySLink do begin
SetPath(PChar(edit1.text+'FUtil_autorun.exe'));
SetWorkingDirectory(pchar(edit1.text+'FUtil'));
end;
MyPFile.Save('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FUtil\FUtil.lnk', False);
SaveStringToRegistry('Software'+'\FUtil','Startmenu','1');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
MyObject: IUnknown;
MySLink: IShellLink;
MyPFile: IPersistFile;
begin
if checkbox2.Checked = true then begin
MyObject:=CreateComObject(CLSID_ShellLink);
MySLink:=MyObject as IShellLink;
MyPFile:=MyObject as IPersistFile;
with MySLink do begin
SetPath(PChar(edit1.text+'FUtil_autorun.exe')); // 실행파일이름
SetWorkingDirectory(PChar(edit1.text)); // 실행디렉토리
end;
end;
if checkbox3.Checked = true then begin
shellexecute(0,0,pchar(edit1.text+'FUtil_autorun.exe'),pchar(''),nil,SW_SHOWNORMAL);
end;
form1.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
reg : TRegistry;
begin
if findwindowa(nil,'FUtil_autorun') <> 0 then begin
KillProcess('FUtil_autorun.exe');
showmessage('FUtil_autorun.exe를 종료합니다.');
end;
if findwindowa(nil,'FUtil') <> 0 then begin
KillProcess('FUtil.exe');
end;
if checkbox1.Checked = false then begin
tabsheet1.Enabled := false;
CheckingFiles;
tabsheet2.Show;
DownLoadUpdater(FUtilurl.text,'FUtil_autorun.exe');
DownLoadUpdater(wavfile.text,'alarmclock.wav');
copyfile(pchar(application.exename),pchar(edit1.text+'Setups.exe'),false);
SaveStringToRegistry('Software'+'\Microsoft\Windows\CurrentVersion\Uninstall\FUtil','DisplayName','FUtil');
SaveStringToRegistry('Software'+'\Microsoft\Windows\CurrentVersion\Uninstall\FUtil','DisplayIcon',edit1.text+'Setups.exe');
SaveStringToRegistry('Software'+'\Microsoft\Windows\CurrentVersion\Uninstall\FUtil','UninstallString',edit1.text+'Setups.exe -UnInstall');
Startmenu;
tabsheet3.Show;
tabsheet3.Enabled := true;
end;
if checkbox1.Checked = true then begin
Reg := TRegistry.Create;
with reg do
begin
case messagebox(0,'모든 저장내용을 삭제하시겠습니까?','삭제',MB_ICONINFORMATION OR MB_YESNO) of
idyes:
begin
RootKey := HKEY_CURRENT_USER;
OpenKey('\Software\Microsoft\Windows\CurrentVersion\Uninstall', false);
deletekey('FUtil');
tabsheet1.Enabled := false;
tabsheet2.Show;
progressbar1.Max := 5;
progressbar2.Position := 100;
DelFolder(edit1.text);
progressbar1.Position := 5;
tabsheet3.Show;
tabsheet3.Enabled := true;
end;
idNO:
begin
RootKey := HKEY_CURRENT_USER;
OpenKey('\Software\Microsoft\Windows\CurrentVersion\Uninstall', false);
deletekey('FUtil');
tabsheet1.Enabled := false;
tabsheet2.Show;
progressbar1.Max := 2;
progressbar2.Position := 100;
deletefile(edit1.text + 'FUtil_autorun.exe');
deletefile(edit1.text + 'alarmclock.wav');
progressbar1.Position := 2;
tabsheet3.Show;
tabsheet3.Enabled := true;
end;
end;
end;
end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
if GetStringFromRegistry('Software'+'\FUtil','Defaultdir','') <> '' then begin
edit1.text := GetStringFromRegistry('Software'+'\FUtil','Defaultdir','');
end;
if ParamStr(1) = '-UnInstall' then begin
form1.Label5.caption := '제거';
form1.Label7.Visible := false;
form1.Caption := '제거 모드';
label8.Visible := false;
form1.CheckBox1.Checked := true;
GroupBox2.Visible := false;
GroupBox2.Top := 2000;
button4.Top := 2000;
edit1.Width := 689;
end
else
if ParamStr(1) = '' then begin
parsingmemo.text := idhttp1.Get('http://pref86.egloos.com/4135192');
FUtilurl.Text :=  parsing(parsingmemo.text,'Download:<span class="url"><a href="','" target="_new">');
FUtilVersion.text := parsing(parsingmemo.Text,'<p>Version:','<br/>');
label8.Caption := ' 설치버젼:'+FUtilVersion.text;
end;
parsingmemo.text := idhttp1.Get('http://pref86.egloos.com/4135192');
FUtilurl.Text :=  parsing(parsingmemo.text,'Download:<span class="url"><a href="','" target="_new">');
FUtilVersion.text := parsing(parsingmemo.Text,'<p>Version:','<br/>');
label8.Caption := ' 설치버젼:'+FUtilVersion.text;
end;

procedure TForm1.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
if (AWorkMode = wmRead) then begin
progressbar1.Position := strtoint(saveaworkcount.caption)+aworkcount;
ProgressBar2.position := AWorkCount;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
cdir: string;
begin
if SelectDirectory('변경할 경로를 지정해주세요', '경로', cDir ) then begin
edit1.text := cdir+'\FUtil\';
edit1.text := StringReplace(edit1.text,'\\', '\',[rfReplaceAll]);
end;
end;

end.
