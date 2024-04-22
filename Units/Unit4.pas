unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sComboBox, OleCtrls, SHDocVw, ComCtrls, ExtCtrls,
  Menus, sSkinProvider;

type
  TForm4 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    MainMenu1: TMainMenu;
    n1: TMenuItem;
    n2: TMenuItem;
    N3: TMenuItem;
    hotkeytimer: TTimer;
    Timer2: TTimer;
    ProgressBar1: TProgressBar;
    favoritebutton1: TButton;
    GroupBox1: TGroupBox;
    favoritebutton2: TButton;
    favoritebutton3: TButton;
    favoritebutton4: TButton;
    favoritebutton5: TButton;
    towordfavorite: TButton;
    backwordfavorite: TButton;
    favoriteallpage: TLabel;
    favoritenowpage: TLabel;
    sSkinProvider1: TsSkinProvider;
    PopupMenu1: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Button5: TButton;
    Button6: TButton;
    buttonnumber: TLabel;
    PopupMenu2: TPopupMenu;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    PopupMenu3: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu4: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    PopupMenu5: TPopupMenu;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    TabSheet2: TTabSheet;
    ComboBox1: TComboBox;
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure hotkeytimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure WebBrowser1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Changebtncaption();
    procedure towordfavoriteClick(Sender: TObject);
    procedure backwordfavoriteClick(Sender: TObject);
    procedure favoritebutton1Click(Sender: TObject);
    procedure favoritebutton2Click(Sender: TObject);
    procedure favoritebutton3Click(Sender: TObject);
    procedure favoritebutton4Click(Sender: TObject);
    procedure favoritebutton5Click(Sender: TObject);
    procedure n1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure gobuttonclick(sender:tobject);
    procedure backbuttonclick(sender:tobject);
    procedure fowardbuttonclick(sender:tobject);
    procedure referebuttonclick(sender:tobject);
    procedure siteEnter(sender:tobject);
    procedure sitekeydown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
    procedure progresschange(Sender: TObject; Progress,
  ProgressMax: Integer);
    function addgofavorite(index:integer):string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  addwebbrowser : array[0..999] of twebbrowser;
  addtabsheet : array[0..999] of ttabsheet;
  addbackbutton : array[0..999] of tbutton;
  addfowardbutton : array[0..999] of tbutton;
  addreferebutton : array[0..999] of tbutton;
  addgobutton : array[0..999] of tbutton;
  addsitecombobox : array[0..999] of tcombobox;
  addprogressbar : array[0..999] of tprogressbar;
  i : integer;

implementation

uses Unit5, Unit6, Unit7;

{$R *.dfm}

procedure tform4.Changebtncaption();
begin
{listview1.Items.Item[strtoint(label2.Caption)*버튼의 갯수+버튼의 순서 - (버튼의 갯수+1)].Caption
EX)버튼이 11개 일때 위에서 3번째 버튼
listview1.Items.Item[strtoint(label2.Caption)*11+3-(11+1)].Caption
=listview1.Items.Item[strtoint(label2.Caption)*11-9.Caption}
backwordfavorite.Enabled := false;
towordfavorite.Enabled := false;
if strtoint(favoritenowpage.Caption) > strtoint(favoriteallpage.Caption) then begin
favoritenowpage.Caption := favoriteallpage.Caption;
end;
if strtoint(favoritenowpage.Caption) > strtoint(favoriteallpage.Caption) then begin
backwordfavorite.Enabled := true;
end;
if strtoint(favoritenowpage.Caption) < strtoint(favoriteallpage.Caption) then begin
towordfavorite.Enabled := true;
end;
if (favoritenowpage.Caption <> '1') and (favoritenowpage.Caption = favoriteallpage.Caption) then begin
backwordfavorite.enabled := true;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-5]) <> -1 then begin
favoritebutton1.Caption := form5.listview1.Items.Item[strtoint(favoritenowpage.caption)*5-5].Caption;
favoritebutton1.Enabled := True;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-4]) <> -1 then begin
favoritebutton2.caption := form5.listview1.Items.Item[strtoint(favoritenowpage.caption)*5-4].Caption;
favoritebutton2.Enabled := True;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-3]) <> -1 then begin
favoritebutton3.Caption := form5.listview1.Items.Item[strtoint(favoritenowpage.caption)*5-3].Caption;
favoritebutton3.Enabled := True;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-2]) <> -1 then begin
favoritebutton4.Caption := form5.listview1.Items.Item[strtoint(favoritenowpage.caption)*5-2].Caption;
favoritebutton4.Enabled := True;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-1]) <> -1 then begin
favoritebutton5.Caption := form5.listview1.Items.Item[strtoint(favoritenowpage.caption)*5-1].Caption;
favoritebutton5.Enabled := True;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-5]) = -1 then begin
favoritebutton1.Caption := '';
favoritebutton1.Enabled := false;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-4]) = -1 then begin
favoritebutton2.Caption := '';
favoritebutton2.Enabled := false;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-3]) = -1 then begin
favoritebutton3.Caption := '';
favoritebutton3.Enabled := false;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-2]) = -1 then begin
favoritebutton4.Caption := '';
favoritebutton4.Enabled := false;
end;
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.caption)*5-1]) = -1 then begin
favoritebutton5.Caption := '';
favoritebutton5.Enabled := false;
end;
end;

function Changenames(itemindex:string):string;
begin
if form5.ListView1.Items.IndexOf(form5.ListView1.Items.Item[strtoint(itemindex)]) <> -1 then begin
form5.ListView1.Items.Item[strtoint(itemindex)].Caption := form4.edit1.text;
form5.ListView1.Items.Item[strtoint(itemindex)].subitems[0] := form4.edit2.text;
end;
form4.favoriteallpage.Caption := inttostr((form5.listview1.Items.Count-1) div 5 + 1);
form4.changebtncaption;
end;


function deletefavorite(index:integer):string;
begin
if form5.ListView1.Items.IndexOf(form5.ListView1.Items.Item[strtoint(form4.favoriteallpage.Caption)*5-index]) <> -1 then begin
form5.ListView1.ItemIndex := strtoint(form4.favoriteallpage.Caption)*5-index;
form5.button1.click;
end;
form4.favoriteallpage.Caption := inttostr((form5.listview1.Items.Count-1) div 5 + 1);
form4.changebtncaption;
end;

function editfavorite(index:integer):string;
begin
if form5.ListView1.Items.IndexOf(form5.ListView1.Items.Item[strtoint(form4.favoriteallpage.Caption)*5-index]) <> -1 then begin
form4.groupbox2.Visible := true;
form4.edit1.Text := form5.ListView1.Items.Item[strtoint(form4.favoriteallpage.Caption)*5-index].Caption;
form4.edit2.text := form5.ListView1.Items.Item[strtoint(form4.favoriteallpage.Caption)*5-index].subitems[0];
form4.buttonnumber.Caption := inttostr(strtoint(form4.favoriteallpage.Caption)*5-index);
end;
end;

function gofavorite(index:integer):string;
begin
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(form4.favoritenowpage.Caption)*5-index]) <> -1 then begin
form4.webbrowser1.Navigate(form5.ListView1.Items.Item[strtoint(form4.favoritenowpage.Caption)*5-index].subitems[0]);
end;
end;

function tform4.addgofavorite(index:integer):string;
begin
if form5.listview1.Items.IndexOf(form5.listview1.Items[strtoint(favoritenowpage.Caption)*5-index]) <> -1 then begin
addwebbrowser[PageControl1.tabindex].Navigate(form5.listview1.Items[strtoint(favoritenowpage.Caption)*5-index].SubItems[0]);
end;
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
webbrowser1.Refresh;
webbrowser1.SetFocus;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
form4.WebBrowser1.GoBack;
webbrowser1.SetFocus;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
form4.WebBrowser1.GoForward;
webbrowser1.SetFocus;
end;

procedure TForm4.N3Click(Sender: TObject);
begin
form6.show;
end;

procedure TForm4.hotkeytimerTimer(Sender: TObject);
begin
if odd(getasynckeystate(VK_F5)) and (form4.Visible = true) and (pagecontrol1.TabIndex = 0) then begin
button4.Click;
end;
if odd(getasynckeystate(VK_F5)) and (form4.Visible = true) and (pagecontrol1.TabIndex <> 0) then begin
addreferebutton[pagecontrol1.TabIndex].Click;
end;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
if FileExists(form7.edit1.text+'Adress.FUtil') = true then begin
form5.button37.Click;
Changebtncaption;
end;
if FileExists(form7.edit1.text+'LS.FUtil') = true then begin
ReadComponentResFile(form7.edit1.text+'LS.FUtil', form6.Listbox1);
end;
end;

procedure TForm4.Timer2Timer(Sender: TObject);
begin
form4.Caption := 'FBrowser' + ' '+formatdatetime('[(현재시간:(' + 'yyyy-mm-dd hh:mm:ss)]',now);
end;

procedure TForm4.WebBrowser1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
progressbar1.Max := progressmax;
progressbar1.Position := progress;
if progressmax = progress then begin
TabSheet1.Caption := copy(webbrowser1.LocationName,0,15);
if length(TabSheet1.Caption) > 15 then begin
TabSheet1.Caption := TabSheet1.Caption+'...';
end;
combobox1.text := webbrowser1.LocationURL;
end;
end;

procedure TForm4.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 13) then begin
button1.Click;
end;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
form4.WebBrowser1.Navigate(combobox1.text);
webbrowser1.SetFocus;
if (pos('Http://'+combobox1.Text,form6.ListBox1.Items.Text) <> 0) or (pos(combobox1.Text,form6.ListBox1.Items.Text) = 0) then begin
form6.ListBox1.AddItem(combobox1.Text,nil);
WriteComponentResFile(form7.edit1.text+'LS.FUtil', form6.Listbox1);
end;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
form5.Close;
form6.Close;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
webbrowser1.GoHome;
end;

procedure TForm4.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
if form7.CheckBox2.Checked = true then begin
form7.Edit4.Text := inttostr(form4.clientheight);
form7.Edit5.Text := inttostr(form4.ClientWidth);
form7.button10.click;
end;
if form7.CheckBox2.Checked = false then begin
form7.Edit4.Text := inttostr(form4.clientheight);
form7.Edit5.Text := inttostr(form4.ClientWidth);
end;
end;

procedure TForm4.FormResize(Sender: TObject);
begin
if progressbar1.Left <> form4.ClientWidth-186 then begin
progressbar1.Left := form4.ClientWidth-186;
end;
if webbrowser1.Width <> form4.ClientWidth-7 then begin
webbrowser1.Width := form4.ClientWidth-7;
end;
if pagecontrol1.Width <> form4.ClientWidth-1 then begin
pagecontrol1.Width := form4.ClientWidth-1;
end;
if webbrowser1.Height <> form4.ClientHeight-2 then begin
webbrowser1.Height := form4.ClientHeight-2;
end;
if pagecontrol1.Height <> form4.ClientHeight-1 then begin
pagecontrol1.Height := form4.ClientHeight-1;
end;
if button1.Left <> form4.ClientWidth-105 then begin
button1.Left := form4.ClientWidth-105;
end;
if combobox1.Width <>  button1.Left-183 then begin
combobox1.Width :=  button1.Left-183;
end;
if groupbox1.Width <> form4.ClientWidth then begin
groupbox1.Width := form4.ClientWidth;
end;
if favoritebutton1.Width <> (groupbox1.Width-66) div 5 then begin
favoritebutton1.Width := (Groupbox1.Width-66) div 5;
end;
if favoritebutton2.Width <> (groupbox1.Width-66) div 5 then begin
favoritebutton2.Width := (Groupbox1.Width-66) div 5;
end;
if favoritebutton3.Width <> (groupbox1.Width-66) div 5 then begin
favoritebutton3.Width := (Groupbox1.Width-66) div 5;
end;
if favoritebutton4.Width <> (groupbox1.Width-66) div 5 then begin
favoritebutton4.Width := (Groupbox1.Width-66) div 5;
end;
if favoritebutton5.Width <> (groupbox1.Width-66) div 5 then begin
favoritebutton5.Width := (Groupbox1.Width-66) div 5;
end;
if towordfavorite.Left <> groupbox1.Width - 33 then begin
towordfavorite.Left := groupbox1.Width - 33
end;
if backwordfavorite.Left <> groupbox1.Width - 58 then begin
backwordfavorite.Left := groupbox1.Width - 58
end;
if favoritebutton2.Left <> favoritebutton1.Width+favoritebutton1.Left then begin
favoritebutton2.Left := favoritebutton1.Width+favoritebutton1.Left;
end;
if favoritebutton3.Left <> favoritebutton2.Width+favoritebutton2.Left then begin
favoritebutton3.Left := favoritebutton2.Width+favoritebutton2.Left;
end;
if favoritebutton4.Left <> favoritebutton3.Width+favoritebutton3.Left then begin
favoritebutton4.Left := favoritebutton3.Width+favoritebutton3.Left;
end;
if favoritebutton5.Left <> favoritebutton4.Width+favoritebutton4.Left then begin
favoritebutton5.Left := favoritebutton4.Width+favoritebutton4.Left;
end;
if GroupBox2.Width <> favoritebutton1.Width then begin
GroupBox2.Width := favoritebutton1.Width;
end;
if edit1.Width <> groupbox2.Width-16 then begin
edit1.Width := groupbox2.Width-16;
edit2.Width := groupbox2.Width-16;
button6.left := groupbox2.Width-85;
end;
end;

procedure TForm4.towordfavoriteClick(Sender: TObject);
begin
favoritenowpage.Caption := inttostr(strtoint(favoritenowpage.Caption)+1);
changebtncaption;
end;

procedure TForm4.backwordfavoriteClick(Sender: TObject);
begin
favoritenowpage.Caption := inttostr(strtoint(favoritenowpage.Caption)-1);
changebtncaption;
end;

procedure TForm4.favoritebutton1Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
gofavorite(5);
end;
if pagecontrol1.TabIndex <> 0 then begin
addgofavorite(5);
end;
end;

procedure TForm4.favoritebutton2Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
gofavorite(4);
end;
if pagecontrol1.TabIndex <> 0 then begin
addgofavorite(4);
end;
end;

procedure TForm4.favoritebutton3Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
gofavorite(3);
end;
if pagecontrol1.TabIndex <> 0 then begin
addgofavorite(3);
end;
end;

procedure TForm4.favoritebutton4Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
gofavorite(2);
end;
if pagecontrol1.TabIndex <> 0 then begin
addgofavorite(2);
end;
end;

procedure TForm4.favoritebutton5Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
gofavorite(1);
end;
if pagecontrol1.TabIndex <> 0 then begin
addgofavorite(1);
end;
end;

procedure TForm4.n1Click(Sender: TObject);
begin
if pagecontrol1.TabIndex = 0 then begin
form5.edit15.Text := webbrowser1.LocationName;
form5.edit16.text := webbrowser1.LocationURL;
form5.Button39.Click;
end;
if pagecontrol1.TabIndex <> 0 then begin
form5.edit15.Text := addwebbrowser[pagecontrol1.tabindex].LocationName;
form5.edit16.text := addwebbrowser[pagecontrol1.tabindex].Locationurl;
form5.Button39.Click;
end;
end;

procedure TForm4.N4Click(Sender: TObject);
begin
favoritebutton1.Click;
end;

procedure TForm4.N5Click(Sender: TObject);
begin
groupbox2.Left := favoritebutton1.Left;
editfavorite(5);
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
groupbox2.visible := false;
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
Changenames(buttonnumber.caption);
groupbox2.Visible := false;
end;

procedure TForm4.N6Click(Sender: TObject);
begin
deletefavorite(5);
changebtncaption;
end;

procedure TForm4.N8Click(Sender: TObject);
begin
favoritebutton2.Click;
end;

procedure TForm4.N9Click(Sender: TObject);
begin
groupbox2.Left := favoritebutton2.Left;
editfavorite(4);
end;

procedure TForm4.N10Click(Sender: TObject);
begin
deletefavorite(4);
end;

procedure TForm4.MenuItem1Click(Sender: TObject);
begin
favoritebutton3.Click;
end;

procedure TForm4.MenuItem2Click(Sender: TObject);
begin
groupbox2.Left := favoritebutton2.Left;
editfavorite(3);
end;

procedure TForm4.MenuItem3Click(Sender: TObject);
begin
deletefavorite(3);
end;

procedure TForm4.MenuItem5Click(Sender: TObject);
begin
favoritebutton4.Click;
end;

procedure TForm4.MenuItem6Click(Sender: TObject);
begin
groupbox2.Left := favoritebutton2.Left;
editfavorite(2);
end;

procedure TForm4.MenuItem7Click(Sender: TObject);
begin
deletefavorite(2);
end;

procedure TForm4.MenuItem9Click(Sender: TObject);
begin
favoritebutton5.Click;
end;

procedure TForm4.MenuItem10Click(Sender: TObject);
begin
groupbox2.Left := favoritebutton2.Left;
editfavorite(1);
end;

procedure TForm4.MenuItem11Click(Sender: TObject);
begin
deletefavorite(1);
end;

procedure TForm4.ComboBox1Enter(Sender: TObject);
begin
combobox1.Items := form6.ListBox1.Items;
end;

procedure tform4.gobuttonclick(sender:tobject);
begin
addwebbrowser[pagecontrol1.tabindex].Navigate(addsitecombobox[pagecontrol1.tabindex].Text);
addwebbrowser[pagecontrol1.tabindex].SetFocus;
if (pos('Http://'+combobox1.Text,form6.ListBox1.Items.Text) <> 0) or (pos(combobox1.Text,form6.ListBox1.Items.Text) = 0) then begin
form6.ListBox1.AddItem(combobox1.Text,nil);
WriteComponentResFile('LS.FUtil', form6.Listbox1);
end;
end;

procedure tform4.backbuttonclick(sender:tobject);
begin
addwebbrowser[pagecontrol1.tabindex].GoBack;
addwebbrowser[pagecontrol1.tabindex].SetFocus;
end;

procedure tform4.fowardbuttonclick(sender:tobject);
begin
addwebbrowser[pagecontrol1.tabindex].GoForward;
addwebbrowser[pagecontrol1.tabindex].SetFocus;
end;

procedure tform4.referebuttonclick(sender:tobject);
begin
addwebbrowser[pagecontrol1.tabindex].refresh;
addwebbrowser[pagecontrol1.tabindex].SetFocus;
end;

procedure tform4.siteenter(sender:tobject);
begin
addsitecombobox[pagecontrol1.tabindex].Items := form6.ListBox1.Items;
end;

procedure tform4.sitekeydown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = 13) then
addgobutton[pagecontrol1.tabindex].click;
end;

procedure Tform4.progresschange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
addprogressbar[pagecontrol1.tabindex].Max := progressmax;
addprogressbar[pagecontrol1.tabindex].Position := progress;
if progressmax = progress then begin
pagecontrol1.Pages[pagecontrol1.TabIndex].Caption := copy(addwebbrowser[pagecontrol1.TabIndex].LocationName,0,15);
if length(pagecontrol1.Pages[pagecontrol1.TabIndex].Caption) > 15 then begin
pagecontrol1.Pages[pagecontrol1.TabIndex].Caption := pagecontrol1.Pages[pagecontrol1.TabIndex].Caption+'...'
end;
addsitecombobox[pagecontrol1.TabIndex].text := addwebbrowser[pagecontrol1.TabIndex].LocationURL;
end;
end;

procedure TForm4.PageControl1Change(Sender: TObject);
begin
if pagecontrol1.TabIndex = pagecontrol1.PageCount-1 then begin
  addtabsheet[pagecontrol1.TabIndex] := ttabsheet.Create(Self);
  addtabsheet[pagecontrol1.TabIndex].PageControl := pagecontrol1;
  addwebbrowser[pagecontrol1.TabIndex] := twebbrowser.Create(Self);
  Tcontrol(addwebbrowser[pagecontrol1.TabIndex]).Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addwebbrowser[pagecontrol1.TabIndex].GoHome;
  addwebbrowser[pagecontrol1.TabIndex].Top := 32;
  addwebbrowser[pagecontrol1.TabIndex].Width := form4.ClientWidth-7;
  addwebbrowser[pagecontrol1.TabIndex].Height := form4.ClientHeight-2;
  addwebbrowser[pagecontrol1.TabIndex].OnProgressChange := progresschange;
  addbackbutton[pagecontrol1.TabIndex] := tbutton.Create(self);
  addbackbutton[pagecontrol1.TabIndex].Caption := '◀';
  addbackbutton[pagecontrol1.TabIndex].Left := 8;
  addbackbutton[pagecontrol1.TabIndex].Top := 8;
  addbackbutton[pagecontrol1.TabIndex].Width := 41;
  addbackbutton[pagecontrol1.TabIndex].Height := 20;
  addbackbutton[pagecontrol1.TabIndex].OnClick := backbuttonclick;
  addbackbutton[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addgobutton[pagecontrol1.TabIndex] := tbutton.Create(self);
  addgobutton[pagecontrol1.TabIndex].Caption := '확인';
  addgobutton[pagecontrol1.TabIndex].Left := form4.ClientWidth-105;
  addgobutton[pagecontrol1.TabIndex].Top := 8;
  addgobutton[pagecontrol1.TabIndex].Width := 89;
  addgobutton[pagecontrol1.TabIndex].Height := 20;
  addgobutton[pagecontrol1.TabIndex].OnClick := gobuttonclick;
  addgobutton[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addfowardbutton[pagecontrol1.TabIndex] := tbutton.Create(self);
  addfowardbutton[pagecontrol1.TabIndex].Caption := '▶';
  addfowardbutton[pagecontrol1.TabIndex].Left := 48;
  addfowardbutton[pagecontrol1.TabIndex].Top := 8;
  addfowardbutton[pagecontrol1.TabIndex].Width := 41;
  addfowardbutton[pagecontrol1.TabIndex].Height := 20;
  addfowardbutton[pagecontrol1.TabIndex].OnClick := fowardbuttonclick;
  addfowardbutton[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addreferebutton[pagecontrol1.TabIndex] := tbutton.Create(self);
  addreferebutton[pagecontrol1.TabIndex].Caption := '새로고침';
  addreferebutton[pagecontrol1.TabIndex].Left := 96;
  addreferebutton[pagecontrol1.TabIndex].Top := 8;
  addreferebutton[pagecontrol1.TabIndex].Width := 73;
  addreferebutton[pagecontrol1.TabIndex].Height := 20;
  addreferebutton[pagecontrol1.TabIndex].OnClick := referebuttonclick;
  addreferebutton[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addsitecombobox[pagecontrol1.TabIndex] := tcombobox.Create(self);
  addsitecombobox[pagecontrol1.TabIndex].Left := 176;
  addsitecombobox[pagecontrol1.TabIndex].Top := 8;
  addsitecombobox[pagecontrol1.TabIndex].Width := button1.Left-183;
  addsitecombobox[pagecontrol1.TabIndex].Height := 20;
  addsitecombobox[pagecontrol1.TabIndex].Onenter := siteEnter;
  addsitecombobox[pagecontrol1.TabIndex].OnKeyDown := sitekeydown;
  addsitecombobox[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  addprogressbar[pagecontrol1.TabIndex] := tprogressbar.Create(self);
  addprogressbar[pagecontrol1.TabIndex].Left := form4.ClientWidth-186;
  addprogressbar[pagecontrol1.TabIndex].Top := -2;
  addprogressbar[pagecontrol1.TabIndex].Width := 179;
  addprogressbar[pagecontrol1.TabIndex].Height := 10;
  addprogressbar[pagecontrol1.TabIndex].Parent := pagecontrol1.Pages[pagecontrol1.TabIndex];
  end;
end;

end.
