# 多表查询

* 查询语法：
	select
		列名列表
	from
		表名列表
	where....
* 笛卡尔积：
	* 有两个集合A,B .取这两个集合的所有组成情况。
	* 要完成多表查询，需要消除无用的数据

##内连接查询

隐式内连接：使用where条件消除无用数据

```mysql
SELECT
	t1.`NAME`,
	t1.`gender`,
	t1.`salary`,
	t2.`NAME`
FROM
	emp t1,
	dept t2
WHERE
	t1.`dept_id`=t2.`id`;
```

显式内连接：select 字段列表 from 表名1 [inner] join 表名2 on 条件

```mysql
SELECT * FROM emp INNER JOIN dept ON emp.dept_id = dept.id;	
SELECT * FROM emp JOIN dept ON emp.dept_id = dept.id;	
```

内连接查询：

从哪些表中查询数据条件是什么查询哪些字段

## 外连接查询

1. 左外连接：
* 语法：select 字段列表 from 表1 left [outer] join 表2 on 条件；
* 查询的是左表所有数据以及其交集部分。
* 例子：
-- 查询所有员工信息，如果员工有部门，则查询部门名称，没有部门，则不显示部门名称
SELECT 	t1.*,t2.`name` FROM emp t1 LEFT JOIN dept t2 ON t1.`dept_id` = t2.`id`;
2. 右外连接：
* 语法：select 字段列表 from 表1 right [outer] join 表2 on 条件；
* 查询的是右表所有数据以及其交集部分。
* 例子：
SELECT * FROM dept t2 RIGHT JOIN emp t1 ON t1.`dept_id` = t2.`id`;

## 子查询

概念：查询中嵌套查询，称嵌套查询为子查询。

1. 子查询的结果是单行单列的：

   子查询可以作为条件，使用运算符去判断。 运算符： > >= < <= =

   ```mysql
   SELECT * FROM emp WHERE emp.`salary`<(SELECT AVG(salary) FROM emp);
   ```

2. 子查询的结果是多行单列的：

   子查询可以作为条件，使用运算符in来判断

   ```mysql
   SELECT * FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE NAME = '财务部' OR NAME = '市场部');
   ```

3. 子查询的结果是多行多列的：

   子查询可以作为一张虚拟表参与查询

   ```mysql
   SELECT * FROM dept t1 ,(SELECT * FROM emp WHERE emp.`join_date` > '2011-11-11') t2
   WHERE t1.id = t2.dept_id;
   
   - 普通内连接
   SELECT * FROM emp t1,dept t2 
   WHERE t1.`dept_id` = t2.`id` AND t1.`join_date` > '2011-11-11'
   ```

```mysql
-- 4.查询员工姓名，工资，职务名称，职务描述，部门名称，部门位置，工资等级
SELECT 
	t1.`ename`,
	t1.`salary`,
	t2.`jname`,
	t2.`description`,
	t3.`dname`,
	t3.`loc`,
	t4.`grade`
FROM 
	emp t1,
	job t2,
	dept t3,
	salarygrade t4
WHERE
	t1.`job_id` = t2.`id`
	AND t1.`dept_id`=t3.`id`
	AND t1.`salary` BETWEEN t4.`losalary` AND t4.`hisalary`;


```

```mysql
-- 5.查询出部门编号、部门名称、部门位置、部门人数
SELECT 
	dept.`id`,
    dept.`dname`,
    dept.`loc`,
    m.total
FROM 
	dept,
	(SELECT emp.`dept_id`,COUNT(id) total FROM emp GROUP BY dept_id)m
WHERE dept.`id`=m.dept_id;
```

```mysql
-- 6.查询所有员工的姓名及其直接上级的姓名,没有领导的员工也需要查询
SELECT t1.`ename`,t1.`mgr`,t2.`id`,t2.`ename`
FROM emp t1,emp t2
WHERE t1.`mgr`=t2.`id`;
--
SELECT t1.`ename`,t1.`mgr`,t2.`id`,t2.`ename`
FROM emp t1 LEFT JOIN emp t2
ON t1.`mgr`=t2.`id`;
```

## 组合查询

```mysql
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5
UNION
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN (1001 ,1002)
ORDER BY vend_id, prod_price;
```

#事务

##事务的基本介绍
概念：如果一个包含多个步骤的业务操作，被事务管理，那么这些操作要么同时成功，要么同时失败。

开启事务： start transaction;
回滚：rollback;
提交：commit;

事务提交的两种方式：

- 自动提交：

  - mysql就是自动提交的
  - 一条DML(增删改)语句会自动提交一次事务。

- 手动提交：

  - Oracle 数据库默认是手动提交事务
  - 需要先开启事务，再提交	

查看事务的默认提交方式：SELECT @@autocommit; -- 1 代表自动提交  0 代表手动提交
修改默认提交方式： set @@autocommit = 0;

##事务的四大特征

1. 原子性：是不可分割的最小操作单位，要么同时成功，要么同时失败。

2. 持久性：当事务提交或回滚后，数据库会持久化的保存数据。

3. 隔离性：多个事务之间。相互独立。

4. 一致性：事务操作前后，数据总量不变
	

	
##事务的隔离级别（了解）
概念：多个事务之间隔离的，相互独立的。但是如果多个事务操作同一批数据，则会引发一些问题，设置不同的隔离级别就可以解决这些问题。

存在问题：
1. 脏读：一个事务，读取到另一个事务中没有提交的数据
2. 不可重复读(虚读)：在同一个事务中，两次读取到的数据不一样。
3. 幻读：一个事务操作(DML)数据表中所有记录，另一个事务添加了一条数据，则第一个事务查询不到自己的修改。【mysql无法演示】

隔离级别：

1. read uncommitted：读未提交
		* 产生的问题：脏读、不可重复读、幻读
2. read committed：读已提交 （Oracle）
  * 产生的问题：不可重复读、幻读
3. repeatable read：可重复读 （MySQL默认）
  * 产生的问题：幻读
4. serializable：串行化
  * 可以解决所有的问题
5. 注意：隔离级别从小到大安全性越来越高，但是效率越来越低
6. 数据库查询隔离级别：
  * select @@tx_isolation;
7. 数据库设置隔离级别：
  * set global transaction isolation level  级别字符串;

```mysql
CREATE TABLE account (
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(10),
	balance DOUBLE
);
-- 添加数据
INSERT INTO account (NAME, balance) VALUES ('zhangsan', 1000), ('lisi', 1000);
				
UPDATE account SET balance =1000 ;

SELECT @@autocommit;

--

SELECT @@tx_isolation;
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
UPDATE account SET balance = balance - 500 WHERE NAME = 'zhangsan';
UPDATE account SET balance = balance + 500 WHERE NAME = 'lisi';
COMMIT;
ROLLBACK;
```

# DCL

SQL分类：
1. DDL：操作数据库和表
2. DML：增删改表中数据
3. DQL：查询表中数据
4. DCL：管理用户，授权

##管理用户

1. 添加用户：

语法：CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';

* 通配符： % 表示可以在任意主机使用用户登录数据库

2. 删除用户：

语法：DROP USER '用户名'@'主机名';

3. 修改用户密码：

UPDATE USER SET PASSWORD = PASSWORD('新密码') WHERE USER = '用户名';
**UPDATE USER SET PASSWORD = PASSWORD('abc') WHERE USER = 'lisi';**

SET PASSWORD FOR '用户名'@'主机名' = PASSWORD('新密码');
**SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123');**

```
* mysql中忘记了root用户的密码？
1. cmd -- > net stop mysql 停止mysql服务  【需要管理员运行该cmd
2. 使用无验证方式启动mysql服务： mysqld --skip-grant-tables
3. 打开新的cmd窗口,直接输入mysql命令，敲回车。就可以登录成功
4. use mysql;
5. update user set password = password('你的新密码') where user = 'root';
6. 关闭两个窗口
7. 打开任务管理器，手动结束mysqld.exe 的进程
8. 启动mysql服务
9. 使用新密码登录。
```

4. 查询用户：
	USE myql;
	SELECT * FROM USER;

##权限管理

 查询权限：

```
SHOW GRANTS FOR '用户名'@'主机名';
SHOW GRANTS FOR 'lisi'@'%';
```

授予权限：

```
grant 权限列表 on 数据库名.表名 to '用户名'@'主机名';
GRANT ALL ON *.* TO 'zhangsan'@'localhost';
```

撤销权限：	

	revoke 权限列表 on 数据库名.表名 from '用户名'@'主机名';
	REVOKE UPDATE ON db3.`account` FROM 'lisi'@'%';