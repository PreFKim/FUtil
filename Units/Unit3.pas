unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, XPMan,shellapi, sSkinProvider, Menus,
  ExtCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Button5: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button6: TButton;
    Button7: TButton;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    sSkinProvider1: TsSkinProvider;
    ListBox1: TListBox;
    unknownlist: TMemo;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Timer1: TTimer;
    N6: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    function GetFileDir(DS:string):string;
    procedure FormShow(Sender: TObject);
    function checkingfile():string;
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
 IM:string;
 i:integer;
 Form3: TForm3;

implementation

uses Unit7;


{$R *.dfm}


function tform3.GetFileDir(DS:string):string;
var
strLAnswer : TStringList;
i : Integer;
begin
listbox1.Clear;
strLAnswer := TStringList.Create;
ExtractStrings(['\'], [], pchar(DS), strLAnswer);
for i := 0 to strLAnswer.Count-1 do listbox1.Items.Add(strLAnswer[i]);
listbox1.Items.Delete(listbox1.items.count-1);
for i := 0 to listbox1.items.count-1 do begin
result := result + listbox1.Items.Strings[i] + '\';
end;
end;

function tform3.checkingfile():string;
var
count : integer;
Number : Tmemo;
begin
for i := 0 to listview1.Items.Count-1 do
if fileexists(listview1.Items.Item[i].SubItems.Strings[0]) = false then begin
count := Count + 1;
unknownlist.Lines.add(listview1.Items.Item[i].SubItems.Strings[0]);
end;
if unknownlist.Lines.Count <> 0 then begin
showmessage(inttostr(count)+'개의 알수없는 경로가 발견되었습니다.'+#13#10+unknownlist.Text);
end;
end;


procedure TForm3.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute = true then begin
IM:= inputbox('이름','표시될 이름을 적어주세요'+#13#10+'현제 프로그램경로:'+#13#10+OpenDialog1.FileName,'표시될 이름');
with listview1.Items.add do begin
Caption := im;
SubItems.Add(OpenDialog1.FileName);
OpenDialog1.FileName := '';
end;
writeComponentResFile({ExtractFilePath(Application.ExeName)+}form7.edit1.text+'Simple.FUtil',listview1);
end;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
IM:= inputbox('이름','수정될 이름을 적어주세요',listview1.Selected.Caption);
listview1.Selected.Caption := im;
writeComponentResFile({ExtractFilePath(Application.ExeName)+}form7.edit1.text+'Simple.FUtil',listview1);
end
else
showmessage('수정시킬 아이템을 클릭하세요');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
listview1.Items.Delete(listview1.Selected.Index);
writeComponentResFile({ExtractFilePath(Application.ExeName)+}form7.edit1.text+'Simple.FUtil',listview1);
end
else
showmessage('삭제할 아이템을 지정해주세요');
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
if fileexists(listview1.Selected.SubItems[0]) = true then begin
setcurrentdir(GetFileDir(listview1.Selected.SubItems[0]));
shellexecute(0,0,pchar(listview1.Selected.SubItems[0]),nil,nil,SW_SHOWNORMAL);
writeComponentResFile(form7.edit1.text+'Simple.FUtil',listview1);
end
else
showmessage('현제 경로에 파일이 존재하지않습니다.');
end
else
showmessage('실행할 파일의 아이템을 지정해주세요');
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
opendialog1.filename := listview1.Selected.SubItems[0];
if OpenDialog1.Execute = true then begin
listview1.Selected.SubItems.Strings[0] := opendialog1.filename;
writeComponentResFile(form7.edit1.text+'Simple.FUtil',listview1);
end;
end;
if listview1.itemindex = -1 then begin
showmessage('수정시킬 아이템을 클릭하세요');
end;
end;

procedure TForm3.ListView1DblClick(Sender: TObject);
begin
button3.Click;
end;

procedure TForm3.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (odd(GetAsyncKeyState(VK_delete))) and (listview1.itemindex <> -1) then begin
button2.Click;
end;
if (key = 13) and (listview1.itemindex <> -1) then begin
button3.Click;
end;
end;

procedure TForm3.Button6Click(Sender: TObject);
var
 vPoint: TPoint;
begin
for i := 0 to listview1.Items.Count-1 do begin
if pos(LowerCase(edit1.Text),LowerCase(listview1.Items.Item[i].Caption)) <> 0 then begin
listview1.Itemindex := i;
vPoint := ListView1.Items[i].GetPosition;
Listview1.Scroll(0, vPoint.Y - ListView1.Height div 2 );
listview1.SetFocus;
label1.Caption := inttostr(i);
button7.Enabled := true;
button6.Enabled := false;
exit;
end;
if i = listview1.Items.Count-1 then begin
button7.Enabled := false;
button6.Enabled := true;
label1.Caption := '0';
showmessage('검색결과가 없습니다.');
end;
end;
end;

procedure TForm3.Button7Click(Sender: TObject);
var
 vPoint: TPoint;
begin
if listview1.Items.Count-1 < strtoint(label1.Caption)+1 then begin
button6.Enabled := true;
button7.Enabled := false;
showmessage('검색결과가 없습니다.');
label1.Caption := '0';
exit;
end;
for i := strtoint(label1.Caption)+1 to listview1.Items.Count-1 do begin
if pos(LowerCase(edit1.Text),LowerCase(listview1.Items.Item[i].Caption)) <> 0 then begin
listview1.Itemindex := i;
vPoint := ListView1.Items[i].GetPosition;
Listview1.Scroll(0, vPoint.Y - ListView1.Height div 2 );
listview1.SetFocus;
label1.Caption := inttostr(i);
button7.Enabled := true;
button6.Enabled := false;
exit;
end;
if (pos(LowerCase(edit1.Text),LowerCase(listview1.Items.Item[i].Caption)) = 0) and (i = listview1.Items.Count-1) then begin
button6.Enabled := true;
button7.Enabled := false;
showmessage('검색결과가 없습니다.');
label1.Caption := '0';
end;
end;
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 13) and (button6.Enabled = true) then begin
button6.Click;
end
else
if (key = 13) and (button7.Enabled = true) then begin
button7.Click;
end;
end;

procedure TForm3.Edit1Click(Sender: TObject);
begin
edit1.text := '';
end;

procedure TForm3.Edit1Change(Sender: TObject);
begin
button6.Enabled := true;
button7.Enabled := false;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
unknownlist.Clear;
if fileexists(form7.edit1.text+'Simple.FUtil') = true then begin
ReadComponentResFile(form7.edit1.text+'Simple.FUtil',listview1);
listview1.Columns.Items[0].Width := 278;
listview1.Columns.Items[1].Width := 278;
listview1.Left := 8;
listview1.Top := 16;
listview1.Font.Charset := DEFAULT_CHARSET;
listview1.Font.Height := -11;
listview1.Font.Name := 'Tahoma';
listview1.Font.size := 11;
listview1.Font.Style := [fsbold];
listview1.Visible := true;
end;
checkingfile;
end;

procedure TForm3.N1Click(Sender: TObject);
begin
Button3.Click;
end;

procedure TForm3.N2Click(Sender: TObject);
begin
Button2.click;
end;

procedure TForm3.N3Click(Sender: TObject);
begin
Button4.click;
end;

procedure TForm3.N4Click(Sender: TObject);
begin
button5.Click;
end;

procedure TForm3.FormResize(Sender: TObject);
begin
if groupbox2.Height <> form3.ClientHeight - 50 then begin
groupbox2.Height := form3.ClientHeight - 50;
end;
if listview1.Height <> groupbox2.Height - 48 then begin
listview1.Height := groupbox2.Height - 48;
end;
if button1.Top <> listview1.Height + 17 then begin
button1.Top := listview1.Height + 17;
end;
if button2.Top <> listview1.Height + 17 then begin
button2.Top := listview1.Height + 17;
end;
if button3.Top <> listview1.Height + 17 then begin
button3.Top := listview1.Height + 17;
end;
if button4.Top <> listview1.Height + 17 then begin
button4.Top := listview1.Height + 17;
end;
if button5.Top <> listview1.Height + 17 then begin
button5.Top := listview1.Height + 17;
end;
if groupbox1.Top <> groupbox2.Height + 1 then begin
groupbox1.Top := groupbox2.Height + 1;
end;
if groupbox1.Width <> form3.ClientWidth then begin
groupbox1.Width := form3.ClientWidth;
end;
if groupbox2.Width <> form3.ClientWidth then begin
groupbox2.Width := form3.ClientWidth;
end;
if button1.Width <> (groupbox2.Width - 16) div 5 then begin
button1.Width := (groupbox2.Width - 16) div 5;
end;
if button2.Width <> (groupbox2.Width - 16) div 5 then begin
button2.Width := (groupbox2.Width - 16) div 5
end;
if button3.Width <> (groupbox2.Width - 16) div 5 then begin
button3.Width := (groupbox2.Width - 16) div 5;
end;
if button4.Width <> (groupbox2.Width - 16) div 5 then begin
button4.Width := (groupbox2.Width - 16) div 5;
end;
if button5.Width <> (groupbox2.Width - 16) div 5 then begin
button5.Width := (groupbox2.Width - 16) div 5;
end;
if button2.Left <> button1.Left + button1.Width then begin
button2.Left := button1.Left + button1.Width;
end;
if button3.Left <> button2.Left + button2.Width then begin
button3.Left := button2.Left + button2.Width;
end;
if button4.Left <> button3.Left + button3.Width then begin
button4.Left := button3.Left + button3.Width;
end;
if button5.Left <> button4.Left + button4.Width then begin
button5.Left := button4.Left + button4.Width;
end;
if listview1.Width <> groupbox2.Width - 16 then begin
listview1.Width := groupbox2.Width - 16;
end;
if edit1.Width <> groupbox1.Width - 176 then begin
edit1.Width := groupbox1.Width - 176;
end;
if button6.left <> edit1.Width + 15 then begin
button6.left := edit1.Width + 15;
end;
if button7.left <> button6.Width + button6.Left + 5 then begin
button7.left := button6.Width + button6.Left + 5;
end;
if form7.CheckBox1.Checked = true then begin
form7.Edit2.Text := inttostr(form3.clientheight);
form7.Edit3.Text := inttostr(form3.ClientWidth);
form7.button8.click;
end;
if form7.CheckBox1.Checked = false then begin
form7.Edit2.Text := inttostr(form3.clientheight);
form7.Edit3.Text := inttostr(form3.ClientWidth);
end;
end;

procedure TForm3.N5Click(Sender: TObject);
begin
shellexecute(0,'',pchar(GetFileDir(listview1.Selected.SubItems[0])),'',nil,SW_SHOWNORMAL);
end;

procedure TForm3.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  var
  i : integer;
  begin
for i := 0 to unknownlist.Lines.Count do begin
 if (item.subitems[0] = unknownlist.Lines.Strings[i]) then
  ListView1.Canvas.Brush.Color := clred;
end;
end;

end.


