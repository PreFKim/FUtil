program FUtil;

uses
  windows,
  Forms,
  SysUtils,
  Dialogs,
  Unit1 in 'units\Unit1.pas' {Form1},
  Unit2 in 'units\Unit2.pas' {Form2},
  Unit4 in 'units\Unit4.pas' {Form4},
  Unit5 in 'units\Unit5.pas' {Form5},
  Unit6 in 'units\Unit6.pas' {Form6},
  Unit3 in 'units\Unit3.pas' {Form3},
  Unit7 in 'units\Unit7.pas' {Form7},
  Unit8 in 'units\Unit8.pas' {Form8},
  Unit9 in 'units\Unit9.pas' {Form9},
  Unit10 in 'units\Unit10.pas' {Form10},
  Unit11 in 'units\Unit11.pas' {Form11},
  Unit12 in 'units\Unit12.pas' {Form12},
  Unit13 in 'units\Unit13.pas' {Form13},
  MediaPlayer_TLB in '..\Program Files (x86)\Delphi7SE\Imports\MediaPlayer_TLB.pas',
  Unit14 in 'Units\Unit14.pas' {Form14},
  Unit15 in 'Units\Unit15.pas' {Form15},
  Unit16 in 'Units\Unit16.pas' {Form16},
  WinHttp_TLB in 'Units\WinHttp_TLB.pas';

{$R *.res}





begin
if (LowerCase(ExtractFileName(Application.ExeName)) = LowerCase('FUtil.exe')) then begin
 end
 else
if (LowerCase(ExtractFileName(Application.ExeName)) = LowerCase('FUtil_autorun.exe')) then begin
 end
 else
 begin
     MessageBox(0, '실행된 파일이름이 올바르지 않습니다.'+#13#10+'파일이름을 FUtil.exe 나 FUtil_autonrun.exe로 바꿔주세요', '파일 이름 오류', MB_ICONERROR);
  Halt(0);
  end;
 CreateMutex(nil, False, 'FUtil');
if (GetLastError = ERROR_ALREADY_EXISTS) and (ParamStr(1) <> '-Reboot') then
begin
  MessageBox(0, 'FUtil이 이미 실행중입니다.', '중복실행', MB_ICONERROR);
  Halt(0);
end;
CreateMutex(nil, False, 'FUtil_autorun');
if (GetLastError = ERROR_ALREADY_EXISTS) and (ParamStr(1) <> '-Reboot') then
begin
  MessageBox(0, 'FUtil이 이미 실행중입니다.', '중복실행', MB_ICONERROR);
  Halt(0);
end;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm16, Form16);
  Application.Run;
end.
