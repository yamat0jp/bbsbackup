unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ExtCtrls, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TTokenState = (dbname, dbKey, dbValue, recKey, recValue);

  TRecInfo = record
    dbname, title, name, raw: string;
    number: integer;
    date: TDateTime;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    ActionList1: TActionList;
    FileOpen1: TFileOpen;
    StatusBar1: TStatusBar;
    Button2: TButton;
    FileExit1: TFileExit;
    Button3: TButton;
    Action1: TAction;
    BbsbackupConnection: TFDConnection;
    FDTable1: TFDTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Button4: TButton;
    delete: TAction;
    Panel1: TPanel;
    Memo1: TMemo;
    FDTable1number: TIntegerField;
    FDTable1date: TDateTimeField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    FDTable1raw: TWideStringField;
    FDTable1dbname: TWideStringField;
    FDTable1title: TWideStringField;
    FDTable1name: TWideStringField;
    procedure FileOpen1Accept(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure deleteExecute(Sender: TObject);
  private
    { Private êÈåæ }
    state: TTokenState;
    info: TRecInfo;
    dump: string;
    procedure main(str: string);
    procedure infoData(str: string);
    function countRec: string;
  public
    { Public êÈåæ }
    mem: TMemoryStream;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses System.UITypes;

procedure TForm1.Action1Execute(Sender: TObject);
const
  a = 800 * 2;
var
  i, j: integer;
  buf: TBytes;
  str: PChar;
  enc: TEncoding;
begin
  SetLength(buf, a);
  mem.Position := 0;
  state := dbname;
  enc := nil;
  while mem.Position < mem.size - 1 do
  begin
    i := mem.Read(Pointer(buf)^, a);
    if enc = nil then
      enc.GetBufferEncoding(mem.Memory, enc);
    str := PChar(enc.Convert(enc, TEncoding.Unicode, buf));
    main(Copy(str, 1, i div SizeOf(Char)));
  end;
  Finalize(buf);
  StatusBar1.Panels[1].Text := countRec;
end;

function TForm1.countRec: string;
begin
  FDTable1.Last;
  result := 'RecordCount : ' + IntToStr(FDTable1.RecordCount);
end;

procedure TForm1.deleteExecute(Sender: TObject);
begin
  if MessageDlg('çÌèúÇµÇ‹Ç∑Ç™ÇÊÇÎÇµÇ¢Ç≈Ç∑Ç©', mtWarning, [mbOK, mbCancel], 0) = mrOK then
    while FDTable1.Eof = false do
      FDTable1.delete;
  StatusBar1.Panels[2].Text := countRec;
end;

procedure TForm1.FileOpen1Accept(Sender: TObject);
var
  s: string;
begin
  s := FileOpen1.Dialog.FileName;
  mem.LoadFromFile(s);
  StatusBar1.Panels[0].Text := s;
  StatusBar1.Hint:=s;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mem := TMemoryStream.Create;
  if FDTable1.Exists = false then
    FDTable1.CreateTable;
  FDTable1.Open;
  StatusBar1.Panels[1].Text := countRec;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  mem.Free;
end;

procedure TForm1.infoData(str: string);
var
  i: integer;
  key, value: string;
begin
  i := Pos(':', str);
  key := Copy(str, 2, i - 3);
  if key = 'number' then
  begin
    value := Copy(str, i + 2, Length(str) - i - 1);
    info.number := StrToInt(value);
  end
  else
  begin
    value := Copy(str, i + 3, Length(str) - i - 3);
    if key = 'title' then
      info.title := value
    else if key = 'name' then
      info.name := value
    else if key = 'raw' then
      info.raw := StringReplace(value, '\r\n', #13#10,
        [rfReplaceAll, rfIgnoreCase])
    else if key = 'date' then
      info.date := StrToDateTime(value);
  end;
end;

procedure TForm1.main(str: string);
var
  i, cnt: integer;
  blob: TStream;
  x: Boolean;
begin
  if dump <> '' then
  begin
    str := dump + str;
    x := true;
    cnt := 1;
  end;
  for i := Length(dump) + 1 to Length(str) do
    case str[i] of
      ':':
        if state = dbKey then
        begin
          state := dbValue;
          info.dbname := Copy(str, cnt + 1, i - cnt - 2);
        end
        else if state = recKey then
          state := recValue;
      '{':
        begin
          if state = dbValue then
          begin
            state := recKey;
            x := true;
          end
          else if state = dbname then
            state := dbKey;
          cnt := i + 1;
        end;
      '}':
        if state = recValue then
        begin
          state := dbValue;
          infoData(Copy(str, cnt, i - cnt));
          x := false;
          FDTable1.AppendRecord([info.dbname, info.number, info.title,
            info.name, info.date, info.raw]);
        end;
      ']':
        state := dbname;
      ',':
        begin
          if state = dbname then
            state := dbKey
          else if state = recValue then
          begin
            state := recKey;
            infoData(Copy(str, cnt, i - cnt));
          end;
          cnt := i + 2;
        end;
    end;
  if x = true then
    dump := Copy(str, cnt, Length(str))
  else
    dump := '';
end;

end.
