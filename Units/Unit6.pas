unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, sSkinProvider;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    sSkinProvider1: TsSkinProvider;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses Unit7;

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
listbox1.Clear;
WriteComponentResFile('LS.FUtil', form6.Listbox1);
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
listbox1.Items.Delete(listbox1.ItemIndex);
WriteComponentResFile('LS.FUtil', form6.Listbox1);
end;

end.
