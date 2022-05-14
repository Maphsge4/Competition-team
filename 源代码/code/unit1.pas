unit unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Unit2, Unit3, Unit4, Unit5, DB, ADODB, ExtCtrls;

type
  TLoginForm = class(TForm)
    ButtonLogin: TButton;       {登录按钮}
    ButtonRegister: TButton;    {注册按钮}
    Label1: TLabel;             {“用户名”}
    Label2: TLabel;             {“密码”}
    EditName: TEdit;            {填用户名}
    EditPassword: TEdit;        {填密码}
    ADOConnection1: TADOConnection;    {连接数据库}
    ADOQuery1: TADOQuery;       {数据库请求}
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    StaticText1: TStaticText;    {选择角色}
    procedure ButtonRegisterClick(Sender: TObject); {点击注册}
    procedure ButtonLoginClick(Sender: TObject); {点击登录}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;


implementation

{$R *.dfm}



procedure TLoginForm.ButtonRegisterClick(Sender: TObject);  {显示注册页面}
begin
  RegisterForm.show;     {跳到unit2}
end;

procedure TLoginForm.ButtonLoginClick(Sender: TObject);  {点击登录，显示新页面}
var
  username:string;
  password:string;
  realpassword:string;
begin
  username:=trim(EditName.Text);
  password:=trim(EditPassword.Text);
  if (username='') or (password='') then     {如果有没填的就点了登录}
  begin
    ShowMessage('信息未填写完全');
    exit;
  end;

  with ADOConnection1 do          {连接数据库}
    begin
      Connected := False;
      ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data Source=dataMysql;Initial Catalog=jsfbjzd';
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
    SQL.Add('select 学号,密码,角色 from 用户 where 用户名=:username');
    Parameters.ParamByName('username').Value:=username;
    open;
    wdxh:=Fieldbyname('学号').AsString;
    if IsEmpty then
      begin
        ShowMessage('用户不存在');    {数据库里没有这个用户名}
        exit;
      end
    else    {找到这个用户了}
      begin
        realpassword:=Fieldbyname('密码').AsString;
        if realpassword<>password then       {密码不匹配}
          begin
            ShowMessage('密码错误');
            exit;
          end;

        if (RadioGroup1.Items[RadioGroup1.ItemIndex]='学生') and (Fieldbyname('角色').AsString='0') then
        begin
          Application.CreateForm(TMainForm1, MainForm1);   {学生登录，跳转到unit3}
          MainForm1.Show;
          LoginForm.Hide;
        end
        else if (RadioGroup1.Items[RadioGroup1.ItemIndex]='管理员') and (Fieldbyname('角色').AsString='1') then
        begin
          Application.CreateForm(TMainForm2, MainForm2);
          MainForm2.Show;          {管理员登录，跳转到unit4}
          LoginForm.Hide;
        end
        else
        begin
          ShowMessage('角色错误');    {不能越权访问}
        end;

      end;
  end;

end;

end.
