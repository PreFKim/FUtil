unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, sSkinProvider;

type
  TForm5 = class(TForm)
    Button37: TButton;
    TabControl1: TTabControl;
    Edit15: TEdit;
    Edit16: TEdit;
    Button39: TButton;
    ListView1: TListView;
    Button1: TButton;
    Timer1: TTimer;
    sSkinProvider1: TsSkinProvider;
    procedure Button37Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses  Unit7, Unit4;

{$R *.dfm}

procedure TForm5.Button37Click(Sender: TObject);
begin
ReadComponentResFile(form7.edit1.text+'Adress.FUtil', ListView1);
end;

procedure TForm5.Button39Click(Sender: TObject);
begin
with listview1.Items.Add do begin
Caption := string(edit15.text);
SubItems.Add(string(edit16.text));
WriteComponentResFile(form7.edit1.text+'Adress.FUtil', ListView1);
end;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
if listview1.itemindex <> -1 then begin
ListView1.Items.Delete(listview1.Selected.Index);
WriteComponentResFile(form7.edit1.text+'Adress.FUtil', ListView1);
end;
form4.favoritenowpage.Caption := inttostr((form5.listview1.Items.Count-1) div 5 + 1);
form4.Changebtncaption;
end;

procedure TForm5.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
form4.favoriteallpage.Caption := inttostr((form5.listview1.Items.Count-1) div 5 + 1);
form4.changebtncaption;
end;

end.
