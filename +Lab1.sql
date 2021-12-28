/* Таблица подразделений */
CREATE TABLE user02_DEPT
(
  DEPTNO INT NOT NULL,
  DNAME  VARCHAR(14) NOT NULL,
  LOC    VARCHAR(10)
);

CREATE TABLE USER02_BEST
(
	IDBESTNO INT NOT NULL,
	NAME VARCHAR(16) NOT NULL,
);

INSERT INTO USER02_BEST VALUES (1,'REAL')

ALTER TABLE USER02_BEST
	ADD CONSTRAINT USER02_BEST_PK PRIMARY KEY (IDBESTNO)

SELECT *
FROM USER02_BEST

ALTER TABLE user02_DEPT
  ADD CONSTRAINT user02_DEPT_PK PRIMARY KEY (DEPTNO);--сделать столбец DEPTNO первичным ключем

ALTER TABLE user02_DEPT
  ADD CONSTRAINT user02_DEPT_UK UNIQUE (DNAME);--добавить ограничение уникальности 

/* Таблица сотрудников */
CREATE TABLE user02_EMP
(
  EMPNO    INT NOT NULL,
  ENAME    VARCHAR(10) NOT NULL,
  JOB      VARCHAR(15),
  MGR      INT,
  HIREDATE DATE,
  SAL      INT,
  COMM     INT,
  DEPTNO   INT,
  IDBESTNO INT
);
ALTER TABLE USER02_EMP
	ADD CONSTRAINT USER02_EMP_IDBEST_FK FOREIGN KEY (IDBESTNO)
	REFERENCES USER02_EMP (EMPNO)

	SELECT *
	FROM USER02_EMP

ALTER TABLE user02_EMP--ALTER TABLE - используется для изменения структуры таблицы
  ADD CONSTRAINT user02_EMP_PK PRIMARY KEY (EMPNO);--добавляет ограничение первичного ключа на номер

ALTER TABLE user02_EMP
  ADD CONSTRAINT user02_EMP_UK UNIQUE (ENAME);--создает ограничение уникального имени

ALTER TABLE user02_EMP
  ADD CONSTRAINT user02_EMP_DEPT_FK FOREIGN KEY (DEPTNO)
  REFERENCES user02_DEPT (DEPTNO);--создает внешний ключ для связи двух таблиц

ALTER TABLE user02_EMP
  ADD CONSTRAINT user02_EMP_MGR_FK FOREIGN KEY (MGR)
  REFERENCES user02_EMP (EMPNO);--создает внешний ключ для связи двух таблиц

  
/* Таблица вилок зарплат */
CREATE TABLE user02_SALGRADE (
 GRADE               INT NOT NULL,
 LOSAL               INT,
 HISAL               INT);

ALTER TABLE user02_SALGRADE
  ADD CONSTRAINT user02_SALGRADE_PK PRIMARY KEY (GRADE);

/* Данные по подразделениям */
INSERT INTO user02_DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO user02_DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO user02_DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO user02_DEPT VALUES (40,'OPERATIONS','BOSTON');

/* Данные по сотрудникам */
INSERT INTO user02_EMP VALUES (7839,'KING','PRESIDENT',NULL,'2011-09-11',5000,NULL,10, 1);
INSERT INTO user02_EMP VALUES (7698,'BLAKE','MANAGER',7839,'2014-01-31',2850,NULL,30, NULL);
INSERT INTO user02_EMP VALUES (7782,'CLARK','MANAGER',7839,'2013-02-21',2450,NULL,10, NULL);
INSERT INTO user02_EMP VALUES (7566,'JONES','MANAGER',7839,'2017-09-19',2975,NULL,20, NULL);
INSERT INTO user02_EMP VALUES (7654,'MARTIN','SALESMAN',7698,'2017-09-11',1250,400,30, 2);
INSERT INTO user02_EMP VALUES (7499,'ALLEN','SALESMAN',7698,'2017-09-11',1600,300,30, 3);
INSERT INTO user02_EMP VALUES (7844,'TURNER','SALESMAN',7698,'2017-03-22',1500,0,30);
INSERT INTO user02_EMP VALUES (7900,'JAMES','CLERK',7698,'2016-11-11',950,NULL,30);
INSERT INTO user02_EMP VALUES (7521,'WARD','SALESMAN',7698,'2015-07-17',1250,500,30);
INSERT INTO user02_EMP VALUES (7902,'FORD','ANALYST',7566,'2017-03-11',3000,NULL,20);
INSERT INTO user02_EMP VALUES (7369,'SMITH','CLERK',7902,'2012-09-17',800,NULL,20);
INSERT INTO user02_EMP VALUES (7788,'SCOTT','ANALYST',7566,'2017-01-11',3000,NULL,20);
INSERT INTO user02_EMP VALUES (7876,'ADAMS','CLERK',7788,'2018-07-13',1100,NULL,20);
INSERT INTO user02_EMP VALUES (7934,'MILLER','CLERK',7782,'2018-03-12',1300,NULL,10);

/* Данные по уровням зарплат */
INSERT INTO user02_SALGRADE VALUES (1,700,1200);
INSERT INTO user02_SALGRADE VALUES (2,1201,1400);
INSERT INTO user02_SALGRADE VALUES (3,1401,2000);
INSERT INTO user02_SALGRADE VALUES (4,2001,3000);
INSERT INTO user02_SALGRADE VALUES (5,3001,9999);
------------------------------------------
--Выбрать заказ, сделанный в определенный период.
SELECT HIREDATE
FROM user02_EMP
WHERE HIREDATE = '2015-07-17'

--Выбрать начальников 
SELECT ENAME, JOB, MGR 
FROM user02_EMP
WHERE MGR IS NULL

-- НАЙТИ ОФИС С ОКОНЧАНИЕМ ING
SELECT *
FROM USER02_DEPT
WHERE DNAME LIKE '%ING'
 
-- СУММА ЗАРАБОТКА
SELECT SUM(SAL) AS SAL_FOR_EMPNO  
FROM user02_EMP

SELECT AVG(SAL) AS AVG_SAL
FROM USER02_EMP
--
UPDATE user02_EMP
SET SAL=1000
WHERE SAL = 5000
--
DELETE user02_EMP
WHERE SAL = 800 AND SAL = 800
--
SELECT ENAME, SAL
FROM user02_EMP
WHERE SAL = 1000
----------------------------------------
------------------------------------------
SELECT * 
FROM USER02_DEPT
------------------------------------------
SELECT *
FROM USER02_EMP
------------------------------------------
SELECT *
FROM user02_SALGRADE
------------------------------------------
-------------OPERATORS
-- DML
-- SELECT
-- INSERT

-- UPDATE
UPDATE user02_SALGRADE
SET HISAL = 9000
WHERE GRADE = 5

UPDATE user02_SALGRADE
SET HISAL = 9999
WHERE GRADE = 5

UPDATE user02_EMP--изменить работу сотрудника на указанную 
SET JOB = 'PROGRAMER'
WHERE ENAME = 'MILLER'

DELETE user02_EMP--удалить сотрудника
WHERE ENAME = 'MILLER'

SELECT *
FROM user02_EMP

-- DDL
-- DROP
DROP TABLE user02_SALGRADE -- удаление таблицы

SELECT *
FROM user02_SALGRADE

-- DEL
-- GRANT
-- REVOKE
-- DENY

-- TRL
-- BEGIN TRAN
-- COMMIT
-- ROLLBACK

-- определение фамили сотрудника, зарплаты которых выше 2000;
select empno, [ENAME]
from [dbo].[user02_EMP]
order by hiredate asc;

SELECT ENAME, SAL, EMPNO
FROM user02_EMP
WHERE SAL>'2000'
ORDER BY SAL ASC

-- определить фамилии сотрудников из отдела 20;
select empno, [ENAME], hiredate
from [dbo].[user02_EMP]
where [DEPTNO]=20

SELECT ENAME, DEPTNO, SAL, COMM
FROM USER02_EMP
WHERE DEPTNO = 20
ORDER BY SAL

-- найти сотрудника, чьим начальником является сотрудник 7839;
select empno, [ENAME], mgr, hiredate
from [dbo].[user02_EMP]
where [mgr]=7839;

SELECT ENAME, MGR
FROM user02_EMP
WHERE MGR = 7839

-- сортировка сотрудников их дате найма;
select *
from [dbo].[user02_EMP]
order by  hiredate desc;

SELECT ENAME, HIREDATE
FROM USER02_EMP
ORDER BY HIREDATE ASC

-- найти отделы, которые находятся в Далласе
select DNAME, LOC
from user02_DEPT
where LOC = 'DALLAS';

------------------------------------
EXEC SP_HELP USER02_DEPT --- ИНФОРМАЦИЯ О ТАБЛИЦЕ
