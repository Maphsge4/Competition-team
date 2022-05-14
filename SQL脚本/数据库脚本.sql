# C:\Program Files\MySQL\MySQL Server 8.0\bin
# mysql -uroot -p2053446sx  -Dmysql < C:\Users\59757\Desktop\数据库脚本.sql
create database mycomp;
use mycomp;

create table 学生
(
    姓名   varchar(10) not null,
    学号   char(10)    primary key,
    学院代号 char(3)    not null,
    手机号  char(11)    not null
);

create table 队伍
(
    队伍代号   char(5)     primary key,
    队伍名称   varchar(20) not null,
    队长学号   char(10)    not null,
    竞赛代号   char(5)     not null,
    指导老师工号 char(10)   not null,
    队伍状态   char(10)    not null
);

create table 队伍构成
(
    队伍代号 char(5)  not null,
    成员学号 char(10) not null,
    primary key (队伍代号, 成员学号)
);

create table 队伍申请
(
    队伍代号 char(5)  not null,
    成员学号 char(10) not null,
    primary key (队伍代号, 成员学号)
);


create table 竞赛
(
    竞赛代号 char(5) primary key,
    竞赛名称 varchar(50) not null,
    主办单位 varchar(30),
    开始时间 date        not null,
    结束时间 date        not null,
    组队规则 varchar(50) not null
);

create table 指导老师
(
    姓名   varchar(10) not null,
    工号   char(10) primary key,
    学院代号 char(3)     not null,
    手机号  char(11)    not null,
    职称   varchar(10) not null
);

create table 学院
(
    学院代号 char(3) primary key,
    学院名称 varchar(20) not null
);


create table 用户
(
    用户名 varchar(20) primary key,
    密码  varchar(20) not null,
    学号  char(10),
    角色  char(1)     not null
);

insert into 学生 values
('焦若琪','2019210001','001','15600007855'),
('孔世璇','2019210002','001','15600003655'),
('龙雨','2019210003','001','13200006645'),
('王一博','2019210004','001','18800001254'),
('蔡徐坤','2019210005','001','13300008545'),
('肖战','2019210006','002','15000009845'),
('易烊千玺','2019210007','002','15100005252'),
('赵雷','2019210008','002','18800003508'),
('周杰伦','2019210009','002','18800009987'),
('林俊杰','2019210010','002','15600002366'),
('李荣浩','2019210011','003','15600006624'),
('邓紫棋','2019210012','003','13200003218'),
('欧阳娜娜','2019210013','003','13200005512'),
('迪丽热巴','2019210014','003','15600005647'),
('古力娜扎','2019210015','003','13200008426'),
('佟丽娅','2019210016','004','15600005897'),
('张子枫','2019210017','004','15600007451'),
('贾乃亮','2019210018','004','13200008754'),
('马冬梅','2019210019','004','13200008740'),
('沈腾','2019210020','004','15600005648'),
('贾玲','2019217890','004','19800003211'),
('kane','2019213890','001','16700008900');


insert into 学院
values ('001', '计算机学院'),
       ('003', '自动化学院'),
       ('002', '经管学院'),
       ('004', '人文学院');


insert into 竞赛
values ('1', '企业模拟大赛', '北京邮电大学经济管理学院', '2020-05-14', '2021-01-01', '1-3人'),
       ('2', '雏雁计划', '北京邮电大学叶培大学院', '2020-09-10', '2021-01-31', '1-5人'),
       ('3', '英语竞赛', '外研社', '2020-04-01', '2020-09-01', '1-2人');


insert into 指导老师
values ('王合江', '1000800001', '001', '13200007454', '教授'),
('丁玲玲','1000800002','001','15600006322','讲师'),
('李文强','1000800003','002','15600007785','副教授'),
('林长英','1000800004','003','18800006544','副教授'),
('范永红','1000800005','004','18800007189','助教');


insert into 队伍
values
    ('1', '美女与工具人', '2019210002', '1', '1000800001', '组队中'),
    ('2', '工具人与工具人', '2019210005', '1', '1000800002', '组队中'),
    ('3', '工具人与美女', '2019210001', '2', '1000800003', '审核通过');


insert into 队伍构成
values
    ('1', '2019210002'),
    ('1', '2019210010'),
    ('2', '2019210004'),
    ('2', '2019210005'),
    ('2', '2019210014'),
    ('2', '2019210015'),
    ('3', '2019210001'),
    ('3', '2019210002');

insert into 队伍申请
values
    ('1', '2019213890'),
    ('1', '2019217890'),
    ('2', '2019210020');

alter table 学生
    add constraint FK_xs_xydh foreign key (学院代号) references 学院 (学院代号) on delete cascade on update cascade;
alter table 队伍
    add constraint FK_dw_dzxh foreign key (队长学号) references 学生 (学号) on delete cascade on update cascade;
alter table 队伍
    add constraint FK_dw_jsdh foreign key (竞赛代号) references 竞赛 (竞赛代号) on delete cascade on update cascade;
alter table 队伍
    add constraint FK_dw_zdgh foreign key (指导老师工号) references 指导老师 (工号) on delete cascade on update cascade;
alter table 指导老师
    add constraint FK_zdls_xydh foreign key (学院代号) references 学院 (学院代号) on delete cascade on update cascade;
alter table 队伍构成
    add constraint FK_dwgc_dwdh foreign key (队伍代号) references 队伍 (队伍代号) on delete cascade on update cascade;
alter table 队伍构成
    add constraint FK_dwgc_cyxh foreign key (成员学号) references 学生 (学号) on delete cascade on update cascade;


insert into 用户
values ('jrq', '123', '2019210001', '0'),
       ('ksx', '123', '2019210002', '0'),
       ('ly', '123', '2019210003', '1');


