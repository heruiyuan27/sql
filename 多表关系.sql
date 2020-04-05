/*
cid 旅游线路分类主键，自动增长
cname 旅游线路分类名称非空，唯一，字符串 100
*/
CREATE TABLE tab_category (
	cid INT PRIMARY KEY AUTO_INCREMENT,
	cname VARCHAR(100) NOT NULL UNIQUE
);

/*
rid 旅游线路主键，自动增长
rname 旅游线路名称非空，唯一，字符串 100
price 价格
rdate 上架时间，日期类型
cid 外键，所属分类
*/
CREATE TABLE tab_route(
	rid INT PRIMARY KEY AUTO_INCREMENT,
	rname VARCHAR(100) NOT NULL UNIQUE,
	price DOUBLE,
	rdate DATE,
	cid INT,
	FOREIGN KEY (cid) REFERENCES tab_category(cid)
);

/*创建用户表 tab_user
uid 用户主键，自增长
username 用户名长度 100，唯一，非空
password 密码长度 30，非空
name 真实姓名长度 100
birthday 生日
sex 性别，定长字符串 1
telephone 手机号，字符串 11
email 邮箱，字符串长度 100
*/
CREATE TABLE tab_user (
	uid INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(100) UNIQUE NOT NULL,
	PASSWORD VARCHAR(30) NOT NULL,
	NAME VARCHAR(100),
	birthday DATE,
	sex CHAR(1) DEFAULT '男',
	telephone VARCHAR(11),
	email VARCHAR(100)
);

/*
创建收藏表 tab_favorite
rid 旅游线路 id，外键
date 收藏时间
uid 用户 id，外键
rid 和 uid 不能重复，设置复合主键，同一个用户不能收藏同一个线路两次
*/
CREATE TABLE tab_favorite(
	uid INT,
	rid INT,
	DATE DATETIME,
	-- 创建复合主键
	PRIMARY KEY(uid,rid),
	FOREIGN KEY (rid) REFERENCES tab_route(rid),
	FOREIGN KEY (uid) REFERENCES tab_user(uid)
);