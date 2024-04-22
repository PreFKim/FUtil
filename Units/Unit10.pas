
unit Unit10;

interface

uses
  Windows, Messages, SysUtils,  Forms,
  Buttons, ShellAPI, ComCtrls,
  ExtCtrls, Controls, Classes, Dialogs, StdCtrls, sSkinProvider;


type
  TForm10 = class(TForm)
    sSkinProvider1: TsSkinProvider;
  private
    FTimeFormat: String;
    FSongTitle: String;
    FTitlePos: Integer;
    FFirstShowDone: Boolean;
    procedure WMDropFile(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure OpenNextFile;
    function RoundFreq(N: Integer): Integer;
  protected
  public
    FFileNames: TStrings;
  end;

var
  Form10: TForm10;

implementation

{$R *.DFM}

procedure TForm10.WMDropFile(var Msg: TWMDropFiles);
begin
end;

procedure TForm10.OpenNextFile;
begin
end;




procedure AddInfos(InfoName, Info: String);
begin
  end;


function TForm10.RoundFreq(N: Integer): Integer;
begin
end;

end.
