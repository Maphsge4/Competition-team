unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls,
  Unit5, DBCtrls, ExtCtrls;

type
  TMainForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    ADODataSetjs: TADODataSet;
    DBGrid1: TDBGrid;
    DataSourcejs: TDataSource;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Editdwmc: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    ADODataSetzdls: TADODataSet;
    DataSourcezdls: TDataSource;
    DBGrid2: TDBGrid;
    ADODataSetdw: TADODataSet;
    DataSourcedw: TDataSource;
    DBGrid3: TDBGrid;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    ComboBox4: TComboBox;
    Button3: TButton;
    Button4: TButton;
    RadioGroup1: TRadioGroup;
    GroupBox4: TGroupBox;
    ComboBox5: TComboBox;
    DBGrid4: TDBGrid;
    Button5: TButton;
    DataSourcedwgc: TDataSource;
    ADODataSetdwgc: TADODataSet;
    Button6: TButton;
    StaticText1: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm1: TMainForm1;

implementation

{$R *.dfm}

procedure TMainForm1.FormClose(Sender: TObject; var Action: TCloseAction);  {关闭窗口时}
begin
  Application.Terminate; {程序退出}
end;

procedure TMainForm1.FormCreate(Sender: TObject);   {窗口初始化时}
begin
  with ADOConnection1 do       {连接数据库}
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
    
  MainForm1.Caption:='竞赛发布及组队系统--当前用户:'+wdxh;    {窗口的标题，显示用户学号}

  with ADOQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select 竞赛代号 from 竞赛');
    open;
    while not eof do
    begin
      ComboBox1.Items.Add(Fieldbyname('竞赛代号').AsString);  {“参加竞赛”下拉框}
      next;
    end;
    
    SQL.Clear;
    SQL.Add('select 姓名,工号 from 指导老师');
    open;
    while not eof do   {“指导老师”下拉框}
    begin
      ComboBox2.Items.Add(Fieldbyname('姓名').AsString+'('+Fieldbyname('工号').AsString+')');
      next;
    end;

    SQL.Clear;
    SQL.Add('select 队伍名称,队伍代号 from 队伍');
    open;

    while not eof do
    begin
      {“申请加入队伍”下拉框}
      ComboBox3.Items.Add(Fieldbyname('队伍名称').AsString+'('+Fieldbyname('队伍代号').AsString+')');
      {“查看队伍组成”下拉框}
      ComboBox5.Items.Add(Fieldbyname('队伍名称').AsString+'('+Fieldbyname('队伍代号').AsString+')');
      next;
    end;

    SQL.Clear;
    SQL.Add('select 姓名,学生.学号 as 学生学号,队伍.队伍代号 from 队伍申请,学生,队伍 where 学生.学号=队伍申请.成员学号 and 队伍申请.队伍代号=队伍.队伍代号 and 队伍.队长学号=:wdxh');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    open;
    wddwdh:=Fieldbyname('队伍代号').AsString;
    while not eof do    {“处理入队申请”下拉框，只有队长才能显示}
    begin
      ComboBox4.Items.Add(Fieldbyname('姓名').AsString+'('+Fieldbyname('学生学号').AsString+')');  {入队申请下拉框}
      next;
    end;
  end;

  {从上到下数据库的三个框}
  ADODataSetjs.CommandText:='select 竞赛代号,竞赛名称,主办单位,开始时间,结束时间,组队规则 from 竞赛';
  ADODataSetjs.Open;
  ADODataSetzdls.CommandText:='select 指导老师.姓名, 工号, 学院名称, 手机号, 职称 from 指导老师,学院 where 指导老师.学院代号=学院.学院代号';
  ADODataSetzdls.Open;
  ADODataSetdw.CommandText:='select 队伍代号,队伍名称,学生.姓名 as 学生姓名,竞赛.竞赛代号,指导老师.姓名 as 指导老师姓名,队伍状态 from 队伍,学生,竞赛,指导老师 where 学生.学号=队伍.队长学号 and 竞赛.竞赛代号=队伍.竞赛代号 and 指导老师.工号=队伍.指导老师工号';
  ADODataSetdw.Open;

  with ADOQuery1 do       {显示我作为队长的队伍的队伍状态。非队长永远显示“组队中”}
  begin
    SQL.Clear;
    SQL.Add('select 队伍状态 from 队伍 where 队长学号=:wdxh');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    open;
    if Fieldbyname('队伍状态').AsString='审核通过' then
    begin
      RadioGroup1.ItemIndex:=1;
    end
    else
    begin
      RadioGroup1.ItemIndex:=0;
    end;
  end;
end;



procedure TMainForm1.Button1Click(Sender: TObject);   {创建队伍}
var
  dwmc:string;
  lsxx:string;
  strs:TStrings;
  dwsl:integer;
  dwdh:string;
  jsdh:string;
  zdgh:string;
begin
  dwmc:=trim(Editdwmc.Text);
  jsdh:=trim(ComboBox1.Text);
  lsxx:=trim(ComboBox2.Text);
  if (dwmc='') or (jsdh='') or (lsxx='') then
  begin
    ShowMessage('信息未填写完全');       {信息不能为空}
    exit;
  end;


  with ADOQuery1 do
  begin
    {创建队伍}
    SQL.Clear;
    SQL.Add('select count(*) c from 队伍');
    open;
    dwsl:=Fieldbyname('c').AsInteger+1;
    dwdh:=inttostr(dwsl);      {队伍号+1}

    strs:=TStringList.Create;
    strs.Delimiter := '(';
    strs.DelimitedText:=lsxx;
    zdgh:=strs[1];
    zdgh:=copy(zdgh,1,10);

    SQL.Clear;
    SQL.Add('insert into 队伍 values (:dwdh,:dwmc,:dzxh,:jsdh,:zdgh,:zt)');
    Parameters.ParamByName('dwdh').Value:=dwdh;
    Parameters.ParamByName('dwmc').Value:=dwmc;
    Parameters.ParamByName('dzxh').Value:=wdxh;
    Parameters.ParamByName('jsdh').Value:=jsdh;
    Parameters.ParamByName('zdgh').Value:=zdgh;
    Parameters.ParamByName('zt').Value:='组队中';
    ExecSQL;
  end;
  
  ShowMessage('创建成功');

  with ADODataSetdw do
  begin
    Close;     {创建成功后重新显示现在所有队伍}
    CommandText:='select 队伍代号,队伍名称,学生.姓名 as 学生姓名,竞赛.竞赛代号,指导老师.姓名 as 指导老师姓名,队伍状态 from 队伍,学生,竞赛,指导老师 where 学生.学号=队伍.队长学号 and 竞赛.竞赛代号=队伍.竞赛代号 and 指导老师.工号=队伍.指导老师工号';
    Open;
  end;

  with ADOQuery1 do
  begin
    SQL.Clear;        {把新创建的队伍写入数据库}
    SQL.Add('insert into 队伍构成 values (:dwdh,:wdxh)');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    Parameters.ParamByName('dwdh').Value:=dwdh;
    ExecSQL;
  end;

end;

procedure TMainForm1.Button2Click(Sender: TObject);  {提交申请按钮}
var
  dwxx:string;
  dwdh:string;
  strs:TStrings;
begin
  dwxx:=trim(ComboBox3.Text);
  with ADOQuery1 do
  begin
    strs:=TStringList.Create;
    strs.Delimiter := '(';
    strs.DelimitedText:=dwxx;
    dwdh:=strs[1];
    dwdh:=copy(dwdh,1,1);      {提取出选择加入的队伍号}

    SQL.Clear;
    SQL.Add('insert into 队伍申请 values (:dwdh,:wdxh)');       {在数据库中记录申请}
    Parameters.ParamByName('wdxh').Value:=wdxh;
    Parameters.ParamByName('dwdh').Value:=dwdh;
    ExecSQL;

    ShowMessage('提交成功');
  end;
end;

procedure TMainForm1.Button3Click(Sender: TObject);   {同意入队申请}
var
  xx:string;
  xh:string;
  strs:TStrings;
//  dwdh:string;
begin
  xx:=trim(ComboBox4.Text);           {啥都没选就点同意}
  if xx='' then
  begin
    ShowMessage('申请人为空');
    exit;
  end;
  strs:=TStringList.Create;
  strs.Delimiter := '(';
  strs.DelimitedText:=xx;
  xh:=strs[1];
  xh:=copy(xh,1,10);


  with ADOQuery1 do
  begin
    {把新入队的人写入数据库，删除他的申请}
    SQL.Clear;
    SQL.Add('insert into 队伍构成 values (:dwdh,:cyxh)');
    Parameters.ParamByName('dwdh').Value:=wddwdh;
    Parameters.ParamByName('cyxh').Value:=xh;
    ExecSQL;

    SQL.Clear;
    SQL.Add('delete from 队伍申请 where 队伍代号=:dwdh and 成员学号=:cyxh');
    Parameters.ParamByName('dwdh').Value:=wddwdh;
    Parameters.ParamByName('cyxh').Value:=xh;
    ExecSQL;
    
    ShowMessage('已同意');

    ComboBox4.Clear;      {入队申请下拉框没有这个人了}
    SQL.Clear;
    SQL.Add('select 姓名,学生.学号 as 学号 from 队伍申请,学生,队伍 where 学生.学号=队伍申请.成员学号 and 队伍申请.队伍代号=队伍.队伍代号 and 队伍.队长学号=:wdxh');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    open;
    while not eof do
    begin
      ComboBox4.Items.Add(Fieldbyname('姓名').AsString+'('+Fieldbyname('学号').AsString+')');
      next;
    end;
    
  end;
end;

procedure TMainForm1.Button4Click(Sender: TObject);   {拒绝入队申请}
var
  xx:string;
  xh:string;
  strs:TStrings;
//  dwdh:string;
begin
  xx:=trim(ComboBox4.Text);       {啥都没选就点拒绝}
  if xx='' then
  begin
    ShowMessage('申请人为空');
    exit;
  end;
  strs:=TStringList.Create;
  strs.Delimiter := '(';
  strs.DelimitedText:=xx;
  xh:=strs[1];
  xh:=copy(xh,1,10);
  with ADOQuery1 do
  begin
    {在数据库中删除他的申请}
    SQL.Clear;
    SQL.Add('delete from 队伍申请 where 队伍代号=:dwdh and 成员学号=:cyxh');
    Parameters.ParamByName('dwdh').Value:=wddwdh;
    Parameters.ParamByName('cyxh').Value:=xh;
    ExecSQL;

    ShowMessage('已拒绝');
    ComboBox4.Clear;

    SQL.Clear;     {入队申请下拉框没有这个人了}
    SQL.Add('select 姓名,学生.学号 as 学生学号 from 队伍申请,学生,队伍 where 学生.学号=队伍申请.成员学号 and 队伍申请.队伍代号=队伍.队伍代号 and 队伍.队长学号=:wdxh');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    open;
    while not eof do
    begin
      ComboBox4.Items.Add(Fieldbyname('姓名').AsString+'('+Fieldbyname('学生学号').AsString+')');
      next;
    end;
  end;

end;

procedure TMainForm1.Button5Click(Sender: TObject);  {最右边查看队伍组成}
var
  dwdh:string;
  dwxx:string;
  strs:TStrings;
begin
  dwxx:=trim(ComboBox5.Text);
  strs:=TStringList.Create;
  strs.Delimiter:='(';
  strs.DelimitedText:=dwxx;
  dwdh:=strs[1];
  dwdh:=copy(dwdh,1,1);   {提取下拉框中你选择的队伍的队伍代号}

  with ADODataSetdwgc do
  begin
    Close;
    CommandText:='select 姓名,成员学号 from 队伍构成,学生 where 学生.学号=成员学号 and 队伍代号=:dwdh';
    Parameters.ParamByName('dwdh').Value:=dwdh;
    Open;
  end;
end;

procedure TMainForm1.Button6Click(Sender: TObject);

begin

  with ADOQuery1 do      {提交审核申请后，更新数据库中的数据，重新显示“等待审核”}
  begin
    SQL.Clear;
    SQL.Add('update 队伍 set 队伍状态=:zt where 队长学号=:wdxh');
    Parameters.ParamByName('wdxh').Value:=wdxh;
    Parameters.ParamByName('zt').Value:='等待审核';
    ExecSQL;
  end;

  ShowMessage('提交审核成功');

  with ADODataSetdw do
  begin
    Close;     {创建成功后重新显示现在所有队伍}
    CommandText:='select 队伍代号,队伍名称,学生.姓名 as 学生姓名,竞赛.竞赛代号,指导老师.姓名 as 指导老师姓名,队伍状态 from 队伍,学生,竞赛,指导老师 where 学生.学号=队伍.队长学号 and 竞赛.竞赛代号=队伍.竞赛代号 and 指导老师.工号=队伍.指导老师工号';
    Open;
  end;


end;

end.
