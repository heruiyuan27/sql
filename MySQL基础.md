# MySQL数据库软件

##安装卸载

参见《MySQL基础.pdf》

##配置

* MySQL服务启动
	1. 手动。
	2. cmd--> services.msc 打开服务的窗口
	3. 使用管理员打开cmd
		* net start mysql : 启动mysql的服务
		* net stop mysql:关闭mysql服务
	
* ==MySQL登录==
	
	1. ==mysql -uroot -p密码== （默认本地MySQL）
	
	2. ==mysql -hip地址 -uroot -p密码== eg：mysql -h192.168.3.10 -uroot -proot
	
  3. mysql --host=ip地址 --user=root --password=连接目标的密码
	
* MySQL退出
	1. exit
	2. quit

* MySQL目录结构
	1. ==MySQL安装目录==：basedir="C:\Program Files\MySQL\\"【服务】
		
		* 配置文件 my.ini
		
		  \#Path to the database root
		
		  datadir="C:/ProgramData/MySQL/MySQL Server 5.5/Data/"
	2. ==MySQL数据目录==：datadir="C:\ProgramData\MySQL\MySQL Server 5.5\data"
	  
	  * 数据库：文件夹
	  
	  * 表：文件
	  
    * 数据：数据
    

![image-20200320152415314](C:\Users\Hery\Desktop\GitHub\sql\MySQL基础.assets\image-20200320152415314.png)
    

# SQL

##定义

Structured Query Language：结构化查询语言

定义了操作所有关系型数据库的规则。每一种数据库(MySQL、Oracle)操作的方式存在不一样的地方，称为“方言”。

##通用语法

SQL 语句可以单行或多行书写，以**分号结尾**。

MySQL 数据库的 SQL 语句**不区分大小写**，**关键字**建议使用**大写**。

3 种注释

* 单行注释: -- 注释内容 或 # 注释内容(mysql 特有) 
* 多行注释: /* 注释 */

##SQL分类
1) DDL(Data Definition Language)数据==定义==语言
	用来定义数据库对象：数据库，表，列等。关键字：create, drop,alter 等

2) DML(Data Manipulation Language)数据==操作==语言
	用来对数据库中表的数据进行增删改。关键字：insert, delete, update 等

3) DQL(Data Query Language)数据==查询==语言
	用来查询数据库中表的记录(数据)。关键字：select, where 等

4) DCL(Data Control Language)数据控制语言(了解)
	用来定义数据库的访问权限和安全级别，及创建用户。关键字：GRANT， REVOKE 等

![image-20200320185941343](C:\Users\Hery\Desktop\GitHub\sql\MySQL基础.assets\image-20200320185941343.png)

#DDL操作数据库、表

##1、操作数据库 CRUD+use

1. **C(Create):创建**

创建数据库：
* ==create database 数据库名称==;
* create database if not exists 数据库名称;
* create database 数据库名称==character set 字符集名==;
* 练习： 创建db4数据库，判断是否存在，并制定字符集为gbk
	* create database if not exists db4 character set gbk;
2. **R(Retrieve)：查询**
* 查询所有数据库的名称:
	* ==show databases==;
* 查询某个数据库的字符集:查询某个数据库的创建语句
	* ==show create database 数据库名称==;
3. **U(Update):修改**
* 修改数据库的字符集
	* ==alter database 数据库名称 character set 字符集名称==;
4. **D(Delete):删除**
* 删除数据库
	* ==drop database 数据库名称==;
* 判断数据库存在，存在再删除
	* drop database if exists 数据库名称;
5. 使用数据库
* 查询当前正在使用的数据库名称
	* ==select database()==;
* 使用数据库
	* ==use 数据库名称==;

##2、操作表CRUD

- 前提：使用某个数据库
	
	use db1；

**********************************************************************

**C(Create):创建**

创建表
==create table student3==(
			id int,
			name varchar(32),
			age int ,
			score double(4,1),
			birthday date,
			insert_time timestamp
		);

**复制表**

==create table 表名 like 被复制的表名==;

<img src="C:\Users\Hery\Desktop\GitHub\sql\MySQL基础.assets\image-20200320201558581.png" alt="image-20200320201558581" style="zoom:80%;" />

**R(Retrieve)：查询**

* ==show tables==; 数据库下的表格
* ==show create table student==;
* ==desc 表名==; 具体表格的结构

**U(Update)：修改**

1. 修改表名
   ```
   alter table 表名 rename to 新的表名;
   ```
   
2. 修改表的字符集	
	```
   alter table 表名 character set 字符集名称;
	```


3. 添加一列

   ```
   alter table 表名 add 列名 数据类型;
   ```

4. 修改列名称 类型

   ```
   alter table 表名 change 列名 新列别 新数据类型;
   alter table 表名 modify 列名 新数据类型;
   ```

5. 删除列W

   ```
   alter table 表名 drop 列名;
   ```

**D(Delete)：删除**

* ==drop table 表名==;
* drop table  if exists 表名 ;

#DML增删改表中数据

1. 添加数据:

   insert into student (id,name) values(1,'sun')    

   insert into student values(5,'zhao','man','tju',60,60);	必须一一匹配

2. 删除数据：

   delete from student where id=4;

   delete from student;	删除所有

3. 更新数据:

   update student set sex='woman';	更新所有

   update student set sex='man' where id=2;

   update student set age=1,address='bj' where id=3;

#DQL查询表中的记录

##语法

select 字段列表or*

from 表名列表

where 条件列表

order by 排序字段 排序方式

group by 分组字段

having 分组之后的条件

limit 分页限定

## 基础查询

select * from student

select name,age from student

select name as 姓名,age as 年龄 from student

select st.name as 姓名,age as 年龄 from student as st 【表别名的使用只在查询过程中，不返回客户机】

------------------------

select address from student

select ==distinct==  address from student不重复

-------------------------------------------

select math+5 from student

select * ,(math+english) as total from student

##条件查询WHERE

比较运算符：
\> 、< 、<= 、>= 、= 、<>

逻辑运算符：

and  或 &&
or  或 || 
not  或 !

------------------------------

BETWEEN...AND  :

​		SELECT * FROM student WHERE age BETWEEN 20 AND 30;

------------------------------

IN( 集合) :

​		SELECT * FROM student WHERE age IN (22,18,25);

------------------------------

LIKE(模糊查询)：

| %      | 匹配任意多个字符串 |
| ------ | ------------------ |
| **_ ** | **匹配一个字符**   |

​		SELECT * FROM student3 WHERE name LIKE '%德%';  

​		SELECT * FROM student3 WHERE name LIKE '%德'; 

​		SELECT * FROM student3 WHERE name LIKE '德%';  

​		SELECT * FROM student3 WHERE name LIKE '_德';  

------------------------------

IS NULL:

​		SELECT * FROM student3 WHERE english IS NULL;  

​		SELECT * FROM student3 WHERE age BETWEEN 20 AND 50 && english ==IS NOT NULL==;

## 排序查询ORDER BY

order by 字段1 排序方式1，字段2 排序方式2...

SELECT * FROM student3 ORDER BY math;
SELECT * FROM student3 ORDER BY english ASC,math DESC;

- 默认ASC升序
- 只有前字段一样，后字段才执行排序

## 聚合函数

- COUNT（主键）
- AVG SUM MIN MAX

SELECT COUNT(id),AVG(math) FROM student3 ;

## 分组查询GROUP BY

group by 字段

分组之后应该查询：字段 和 聚合函数

SELECT sex,AVG(math) 数学平均分,COUNT(id) 人数 FROM student3 

WHERE math>70 GROUP BY sex HAVING 人数>2;

where和having区别

- where在分组前限定，不满足条件不参与分组。having在分组后限定，不满足条件不会被查询出来
- where不跟聚合函数，having可以判断聚合函数

## 分页查询LIMIT

limit 开始的索引 每页显示条数

开始的索引=（当前页-1）*每页显示条数

select * from student limit 0 3

方言

select prod_name from products limit 5,5 【 limit 1,1 代表第二行】

## 计算字段

```
select concat( RTrim(vend_name) , '(' , RTrim(vend_ country) , ')')  as  vend_title  
from vendors
order by vend_names


SELECT prod_ id,
quantity ,
item_ price ,
quantity*item_ price AS expanded_ price
FROM orderitems
WHERE order_ num = 20005 ;【数学运算】
```

