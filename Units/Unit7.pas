unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, registry, shellapi, ShlObj, ShFolder, ActiveX, ComObj,
  sSkinProvider, acTitleBar, sSkinManager, ImgList, acAlphaImageList,FileCtrl,
  ComCtrls, ExtCtrls,winhttp_tlb,httpapp, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm7 = class(TForm)
    sSkinProvider1: TsSkinProvider;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox9: TGroupBox;
    ComboBox2: TComboBox;
    Button4: TButton;
    GroupBox8: TGroupBox;
    Button3: TButton;
    Button6: TButton;
    GroupBox7: TGroupBox;
    Button2: TButton;
    GroupBox10: TGroupBox;
    Button5: TButton;
    Edit1: TEdit;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label2: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    GroupBox11: TGroupBox;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    GroupBox13: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Button9: TButton;
    Button10: TButton;
    CheckBox2: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox14: TGroupBox;
    Button11: TButton;
    Button12: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    ListView1: TListView;
    GroupBox15: TGroupBox;
    Button13: TButton;
    Button14: TButton;
    GroupBox2: TGroupBox;
    Button1: TButton;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    function SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
    function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox2DblClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ComboBox1DblClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    function savecloudfile(listview : Tlistview):string;
    function loadcloudfile(listview : Tlistview;filename:string):string;
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;
  Loading: boolean;
  a:tmemo;
  WinHttp: IWinHttpRequest;

implementation

uses Unit1, Unit14, Unit3, Unit4, Unit12;

{$R *.dfm}

function tform7.loadcloudfile(listview : Tlistview;filename :string):string;
var
i : integer;
begin
WinHttp := coWinHttpRequest.Create;
WinHttp.Open('GET', 'http://futil.dothome.co.kr/checkCF.php?id='+httpencode(form1.Edit1.Text)+'&filename='+httpencode(filename), False);
WinHttp.Send('');
showmessage(winhttp.ResponseText);
if pos('Use',winhttp.ResponseText) <> 0 then begin
memo1.Text := idhttp1.Get('http://futil.dothome.co.kr/Member/'+httpencode(form1.edit1.text)+'/'+filename);
for i:= 0 to (memo1.Lines.Count-1) div 2 do begin
with listview1.Items.Add do begin
caption := memo1.Lines.Strings[0];
subitems.Add(memo1.Lines.Strings[1]);
memo1.Lines.Delete(0);
memo1.Lines.Delete(0);
end;
end;
listview.Items := listview1.Items;
listview.Visible :=true;
writeComponentResFile(form7.edit1.text+filename+'.FUtil',listview);
showmessage('성공적으로 불러왔습니다.');
end
else
showmessage('불러오지 못하였습니다.');
end;
                                                
function tform7.savecloudfile(listview : Tlistview):string;
var
i : integer;
begin
memo1.Clear;
listview1.Items := listview.Items;
for i := 0 to listview1.Items.Count-1 do begin
memo1.Lines.add(listview1.Items.Item[0].caption);
memo1.Lines.add(listview1.Items.Item[0].subitems.strings[0]);
listview1.Items.Item[0].Delete;
end;
WinHttp := coWinHttpRequest.Create;
WinHttp.Open('GET', 'http://futil.dothome.co.kr/simple.php?id='+httpencode(form1.Edit1.Text)+'&lists='+httpencode(memo1.text), False);
WinHttp.Send('');
showmessage('성공적으로 저장하였습니다.');
end;

function CopyFolder(const fromFolder, toFolder: string): Boolean;
var
  WhichFile: TSHFileOpStruct;
begin
  ZeroMemory(@WhichFile, SizeOf(WhichFile));
  with WhichFile do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY or FOF_NOCONFIRMATION;
    pFrom  := PChar(fromFolder + #0);
    pTo    := PChar(toFolder)
  end;
  Result := (0 = ShFileOperation(WhichFile));
end;

function TForm7.SaveStringToRegistry( sKey, sItem, sVal : string ) : string;
var
reg : TRegIniFile;
begin
reg := TRegIniFile.Create( sKey );
reg.WriteString('', sItem, sVal + #0 );
reg.Free;
end;

function TForm7.GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create( sKey );
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
if combobox1.ItemIndex = -1 then begin
showmessage('정확히 선택해주세요');
end
else
SaveStringToRegistry('Software'+'\FUtil','Execform',inttostr(combobox1.Itemindex));
showmessage('적용되었습니다.');
end;

procedure TForm7.RadioButton1Click(Sender: TObject);
begin
//ExtractFilePath(Application.ExeName); 현제 파일 경로 ExtractFileName(Application.ExeName);현제 파일 이름
Copyfile(pchar(ExtractFilePath(Application.ExeName)+ExtractFileName(Application.ExeName)),pchar(form7.edit1.text+'FUtil_autorun.exe'),false);
SaveStringToRegistry('Software'+'\Microsoft\Windows\CurrentVersion\Run','FUtil',form7.edit1.text+'FUtil_autorun.exe');
SaveStringToRegistry('Software'+'\FUtil','Autorun','O');
Label1.Caption := GetStringFromRegistry('Software'+'\FUtil','Autorun','');
end;

procedure TForm7.RadioButton2Click(Sender: TObject);
var
reg : TRegistry;
begin
Reg := TRegistry.Create;
with reg do
begin
RootKey := HKEY_CURRENT_USER;
OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', false);
DeleteValue('FUtil');
end;
Reg.CloseKey;
Reg.Free;
SaveStringToRegistry('Software'+'\FUtil','Autorun','X');
Label1.Caption := GetStringFromRegistry('Software'+'\FUtil','Autorun','');
end;

procedure TForm7.RadioButton3Click(Sender: TObject);
begin
SaveStringToRegistry('Software'+'\FUtil','Trayicon','O');
Label2.Caption := GetStringFromRegistry('Software'+'\FUtil','Trayicon','');
end;

procedure TForm7.RadioButton4Click(Sender: TObject);
begin
SaveStringToRegistry('Software'+'\FUtil','Trayicon','X');
Label2.Caption := GetStringFromRegistry('Software'+'\FUtil','Trayicon','');
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
shellexecute(0,0,pchar(form7.edit1.text),pchar(''),nil,SW_SHOWNORMAL);
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

procedure TForm7.Button3Click(Sender: TObject);
var
MyObject: IUnknown;
MySLink: IShellLink;
MyPFile: IPersistFile;
begin
MyObject:=CreateComObject(CLSID_ShellLink);
MySLink:=MyObject as IShellLink;
MyPFile:=MyObject as IPersistFile;
// 바로가기 파일 설정
with MySLink do begin
//GetSystemDirectory(36) windows 폴더 말해주기
//SetArguments('FUtil.exe'); 파일 경로 뒤에 -Futil같은거 //파일 파라미터
SetPath(PChar(edit1.text+'FUtil_autorun.exe')); // 실행파일이름
SetWorkingDirectory(pchar(edit1.text+'FUtil')); // 실행디렉토리
end;
// 바탕화면에 바로가기 파일 저장
MyPFile.Save(PWChar(WideString(GetSystemDirectory(CSIDL_DESKTOP)+'\FUtil.lnk')), False);
showmessage('('+GetSystemDirectory(CSIDL_DESKTOP)+')'+'에 FUtil.lnk를 생성하였습니다.');
end;

procedure TForm7.Button4Click(Sender: TObject);
begin
if combobox2.ItemIndex = 1 then begin
form1.sSkinManager1.Active := true;
form1.sSkinManager1.SkinName := 'iOS dark (internal)';
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
if combobox2.ItemIndex = 2 then begin
form1.sSkinManager1.Active := true;
form1.sSkinManager1.SkinName := 'GPlus (internal)';
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
if combobox2.ItemIndex = 3 then begin
form1.sSkinManager1.Active := true;
form1.sSkinManager1.SkinName := 'Calcium (internal)';
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
if combobox2.ItemIndex = 4 then begin
form1.sSkinManager1.Active := true;
form1.sSkinManager1.SkinName := 'AlterMetro (internal)';
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
if combobox2.ItemIndex = 5 then begin
form1.sSkinManager1.Active := true;
form1.sSkinManager1.SkinName := 'DarkMetro (internal)';
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
if combobox2.ItemIndex = 0 then begin
form1.sSkinManager1.Active := false;
SaveStringToRegistry('Software'+'\FUtil','SkinNum',inttostr(combobox2.ItemIndex));
end;
end;

procedure TForm7.ComboBox2DblClick(Sender: TObject);
begin
if combobox2.ItemIndex = combobox2.Items.Count-1 then begin
combobox2.ItemIndex := 0;
end
else
combobox2.ItemIndex := combobox2.ItemIndex+1;
end;

procedure TForm7.Button5Click(Sender: TObject);
var
cdir,ddir : string;
begin
if SelectDirectory('변경할 경로를 지정해주세요', '경로', cDir ) then begin
case Application.MessageBox(pchar('경로를 변경하시겠습니까?'), '변경',MB_ICONINFORMATION OR MB_YESNO) of //질문
Id_Yes:
begin
ddir := edit1.text;
edit1.text := cdir+'\FUtil\';
edit1.text := StringReplace(edit1.text,'\\', '\',[rfReplaceAll]);
CopyFolder(ddir,edit1.text);
SaveStringToRegistry('Software'+'\FUtil','deletedir',ddir);
SaveStringToRegistry('Software'+'\FUtil','Defaultdir',edit1.text);
SaveStringToRegistry('Software'+'\FUtil','changedir','O');
RadioButton1.Checked := false;
RadioButton1.Checked := true;
case MessageBox(0,pchar('경로가 변경되려면 FUtil을 재시작해야합니다. 하시겠습니까?(Y=재시작 N=취소)'), '일정',MB_ICONINFORMATION OR MB_YESNO) of
IDYES:
//여기서 재시작하는 함수 집어넣어야함

end;
ID_no:
showmessage('다음 실행시 경로가 변경됩니다.');
begin
end;
end;
end;
end;

procedure TForm7.Button6Click(Sender: TObject);
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
SetWorkingDirectory(pchar(edit1.text));
end;
MyPFile.Save('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FUtil\FUtil.lnk', False);
showmessage('시작메뉴에 FUtil.lnk를 생성하였습니다.');
end;

procedure TForm7.Button7Click(Sender: TObject);
begin
edit2.Text := '275';
edit3.text := '577';
button8.Click;
end;

procedure TForm7.Button8Click(Sender: TObject);
begin
form3.ClientHeight := strtoint(edit2.text);
form3.ClientWidth := strtoint(edit3.text);
SaveStringToRegistry('Software'+'\FUtil','2Height',edit2.text);
SaveStringToRegistry('Software'+'\FUtil','2Width',edit3.text);
end;

procedure TForm7.ComboBox1DblClick(Sender: TObject);
begin
if combobox1.ItemIndex = combobox1.Items.Count-1 then begin
combobox1.ItemIndex := 0;
end
else
combobox1.ItemIndex := combobox1.ItemIndex+1;
end;

procedure TForm7.CheckBox1Click(Sender: TObject);
begin
if checkbox1.checked = true then begin
SaveStringToRegistry('Software'+'\FUtil','2Autosave','1');
end;
if checkbox1.checked = false then begin
SaveStringToRegistry('Software'+'\FUtil','2Autosave','0');
end;
end;

procedure TForm7.Button10Click(Sender: TObject);
begin
form4.ClientHeight := strtoint(edit4.text);
form4.ClientWidth := strtoint(edit5.text);
SaveStringToRegistry('Software'+'\FUtil','4Height',edit4.text);
SaveStringToRegistry('Software'+'\FUtil','4Width',edit5.text);
end;

procedure TForm7.Button9Click(Sender: TObject);
begin
edit4.Text := '655';
edit5.text := '998';
button10.Click;
end;

procedure TForm7.CheckBox2Click(Sender: TObject);
begin
if checkbox2.checked = true then begin
SaveStringToRegistry('Software'+'\FUtil','4Autosave','1');
end;
if checkbox2.checked = false then begin
SaveStringToRegistry('Software'+'\FUtil','4Autosave','0');
end;
end;

procedure TForm7.Button11Click(Sender: TObject);
begin
savecloudfile(form3.ListView1);
end;

procedure TForm7.Button12Click(Sender: TObject);
begin
loadcloudfile(form3.ListView1,'simple');
end;

end.
