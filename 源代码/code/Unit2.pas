unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DB, ADODB;


type
  TRegisterForm = class(TForm)
    {左列六个标签}
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;

    ButtonRegister: TButton;

    EditName: TEdit;
    EditPassword: TEdit;
    MaskEditXh: TMaskEdit;      {限制用户只能按照既定的输入格式输入}
    MaskEditSjh: TMaskEdit;
    EditRName: TEdit;
    ComboBox1: TComboBox;       {下拉取值框}

    ADOQuery1: TADOQuery;
    ADOConnection1: TADOConnection;
    StaticText1: TStaticText;

    procedure ButtonRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegisterForm: TRegisterForm;

implementation

{$R *.dfm}


procedure TRegisterForm.ButtonRegisterClick(Sender: TObject);
var
  username:string;
  password:string;
  realname:string;
  xh:string;
  xydh:string;
  sjh:string;
begin
  username:=trim(EditName.Text);
  password:=trim(EditPassword.Text);
  realname:=trim(EditRName.Text);
  xh:=trim(MaskEditXh.Text);
  sjh:=trim(MaskEditSjh.Text);
  if (username='') or (password='') then     {用户名或者密码不可以为空}
  begin                                  {其他信息也不能为空，放在ADOQuery1中实现}
    ShowMessage('用户名或密码为空');
    exit;
  end;

  with ADOQuery1 do
     begin
     SQL.Clear;
     SQL.Add('select * from 用户 where 用户名=:username');
     Parameters.ParamByName('username').Value:=username;
     open;
     if not(ADOQuery1.IsEmpty) then
     begin
       ShowMessage('用户已存在');      {不能存在这个用户名}
       exit;
     end;

     SQL.Clear;
     SQL.Add('select 学院代号 from 学院 where 学院名称=:xymc');
     Parameters.ParamByName('xymc').Value:= ComboBox1.Text;
     open;
     xydh:=Fieldbyname('学院代号').AsString;
          
     if (xydh='') or (realname='') or (xh='') or (sjh='') then
     begin
       ShowMessage('信息未填写完全');      {其他信息也不能为空}
       exit;
     end;

     SQL.Clear;        {在数据库中插入新注册的这个用户信息}
     SQL.Add('insert into 用户 values(:username,:password,:xh,:therole)');
     Parameters.ParamByName('username').Value:=username;
     Parameters.ParamByName('password').Value:=password;
     Parameters.ParamByName('xh').Value:=xh;
     Parameters.ParamByName('therole').Value:='0';
     ExecSQL;

     SQL.Clear;
     SQL.Add('insert into 学生 values(:xm,:xh,:xydh,:sjh)');
     Parameters.ParamByName('xm').Value:=realname;
     Parameters.ParamByName('xh').Value:=xh;
     Parameters.ParamByName('xydh').Value:=xydh;
     Parameters.ParamByName('sjh').Value:=sjh;
     ExecSQL;
     ShowMessage('注册成功');
     RegisterForm.Hide;
  end;
end;


procedure TRegisterForm.FormCreate(Sender: TObject);   {页面初始化时的操作}
var xymc:string;
begin
  with ADOConnection1 do            {1. 连接数据库}
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
     SQL.Add('select 学院名称 from 学院');      {2. 搜索下拉框需要展示什么信息}
     open;
     while not eof do
     begin
        xymc:=Fieldbyname('学院名称').AsString;
        next;
        ComboBox1.Items.Add(xymc);
     end;
   end;
end;

end.
