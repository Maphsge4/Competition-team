unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, Mask;

type
  TMainForm2 = class(TForm)
    DBGrid1: TDBGrid;        {最大的数据库显示}
    ADODataSetjs: TADODataSet;
    DataSourcejs: TDataSource;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Editjsmc: TEdit;
    Editzbdw: TEdit;
    Editrule: TEdit;
    MaskEditb: TMaskEdit;
    MaskEdite: TMaskEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Button2: TButton;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DBGrid3: TDBGrid;
    ADODataSetdw: TADODataSet;
    DataSourcedw: TDataSource;
    StaticText1: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm2: TMainForm2;

implementation

{$R *.dfm}

procedure TMainForm2.FormClose(Sender: TObject; var Action: TCloseAction);   {关闭窗口时}
begin
  Application.Terminate; {程序退出}
end;

procedure TMainForm2.FormCreate(Sender: TObject);    {窗口创建时}
begin
  with ADOConnection1 do      {连接数据库}
    begin
      Connected := False;
      ConnectionString  := 'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data Source=dataMysql;Initial Catalog=jsfbjzd';
      try
        Connected:=True;
      except
        ShowMessage('not connected');
        raise;
        Exit;
      end;
    end;

  with ADOQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select 队伍名称,队伍代号 from 队伍 where 队伍状态=:ddsh');   {审核队伍的下拉框，初始化}
    Parameters.ParamByName('ddsh').Value:='等待审核';
    open;
    while not eof do
    begin
      ComboBox1.Items.Add(Fieldbyname('队伍名称').AsString+'('+Fieldbyname('队伍代号').AsString+')'); {队伍下拉框}
      next;
    end;
  end;
  {上面的框显示所有竞赛}
  ADODataSetjs.CommandText:='select 竞赛代号,竞赛名称,主办单位,开始时间,结束时间,组队规则 from 竞赛';
  ADODataSetjs.Open;
  {下面的框显示所有队伍}
  ADODataSetdw.CommandText:='select 队伍代号,队伍名称,学生.姓名,竞赛.竞赛代号,指导老师.姓名,队伍状态 from 队伍,学生,竞赛,指导老师 where 学生.学号=队伍.队长学号 and 竞赛.竞赛代号=队伍.竞赛代号 and 指导老师.工号=队伍.指导老师工号';
  ADODataSetdw.Open;
end;

procedure TMainForm2.Button1Click(Sender: TObject);  {发布竞赛}
var
  num:integer;
  jsdh:string;
  jsmc:string;
  zbdw:string;
  begindate:string;
  enddate:string;
  rule:string;
begin
  jsmc:=trim(Editjsmc.Text);
  zbdw:=trim(Editzbdw.Text);
  begindate:=trim(MaskEditb.Text);
  enddate:=trim(MaskEdite.Text);
  rule:=trim(Editrule.Text);

  if (jsmc='') or (zbdw='') or (begindate='') or (enddate='') or (rule='') then
  begin
    ShowMessage('信息没有填写完全');      {信息要填完整}
    exit;
  end;


  with ADOQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select count(*) c from 竞赛');
    open;
    num:=Fieldbyname('c').AsInteger+1;     {竞赛代号增加1}
    jsdh:=inttostr(num);

    SQL.Clear;               {把新设的竞赛信息插入数据库}
    SQL.Add('insert into 竞赛 values (:jsdh,:jsmc,:zbdw,:begindate,:enddate,:rule)');
    Parameters.ParamByName('jsdh').Value:=jsdh;
    Parameters.ParamByName('jsmc').Value:=jsmc;
    Parameters.ParamByName('zbdw').Value:=zbdw;
    Parameters.ParamByName('begindate').Value:=begindate;
    Parameters.ParamByName('enddate').Value:=enddate;
    Parameters.ParamByName('rule').Value:=rule;
    ExecSQL;

    ShowMessage('发布完成');
  end;
  ADODataSetjs.Close;        {显示更新后的竞赛列表}
  ADODataSetjs.CommandText:='select 竞赛代号,竞赛名称,主办单位,开始时间,结束时间,组队规则 from 竞赛';
  ADODataSetjs.Open;
  
end;

procedure TMainForm2.Button2Click(Sender: TObject);  {审核队伍}
var
  strs:TStrings;
  dwdh:string;
  dwxx:string;
begin
  dwxx:=trim(ComboBox1.Text);
  strs:=TStringList.Create;
  strs.Delimiter:='(';
  strs.DelimitedText:=dwxx;
  dwdh:=strs[1];
  dwdh:=copy(dwdh,1,1);  {从下拉框选择的队伍，把它的队伍代号提取出来}

  with ADOQuery1 do      {审核完成后，更新数据库中的数据，重新显示新的}
  begin
    SQL.Clear;
    SQL.Add('update 队伍 set 队伍状态=:zt where 队伍代号=:dwdh');
    Parameters.ParamByName('dwdh').Value:=dwdh;
    Parameters.ParamByName('zt').Value:='审核通过';
    ExecSQL;


    ShowMessage('审核通过');

    ADODataSetdw.Close;
    ADODataSetdw.CommandText:='select 队伍代号,队伍名称,学生.姓名,竞赛.竞赛代号,指导老师.姓名,队伍状态 from 队伍,学生,竞赛,指导老师 where 学生.学号=队伍.队长学号 and 竞赛.竞赛代号=队伍.竞赛代号 and 指导老师.工号=队伍.指导老师工号';
    ADODataSetdw.Open;

    ComboBox1.Clear;
    SQL.Clear;
    SQL.Add('select 队伍名称,队伍代号 from 队伍 where 队伍状态=:ddsh');   {审核队伍的下拉框，初始化}
    Parameters.ParamByName('ddsh').Value:='等待审核';
    open;
    while not eof do
    begin
      ComboBox1.Items.Add(Fieldbyname('队伍名称').AsString+'('+Fieldbyname('队伍代号').AsString+')'); {队伍下拉框}
      next;
    end;
  end;
end;

end.
