--1.	������� ��� ������� ��� ������ ���� ������.
--SP_HELPINDEX ��������� �������� �������� ��������, ��������� � �������� ��������
EXEC SP_HELPINDEX 'CUSTOMERS';
EXEC SP_HELPINDEX 'OFFICES';
EXEC SP_HELPINDEX 'ORDERS';
EXEC SP_HELPINDEX 'PRODUCTS';
EXEC SP_HELPINDEX 'SALESREPS';

--2.	�������� ������ ��� ������� ��� ������ ������� � ����������������� ��� ����������.
CREATE INDEX #MANAGER2 ON OFFICES(MGR);
SELECT COUNT(*) 
FROM OFFICES 
WHERE OFFICE BETWEEN 11 AND 13 AND MGR = 104; --���������� �������� 1

SELECT * FROM OFFICES

DROP INDEX #MANAGER
--3.	�������� ������ ��� ������� ��� ���������� �������� � ����������������� ��� ����������.
CREATE INDEX #INFO4 ON SALESREPS(NAME,AGE);
SELECT NAME, AGE 
FROM SALESREPS
WHERE AGE<33;

SELECT * FROM SALESREPS WHERE AGE<33;

--4.	�������� ����������� ������ ��� ������� � ����������������� ��� ����������.
--CREATE INDEX #AMOUNT ON [DBO].[ORDERS]([AMOUNT]) WHERE [AMOUNT]>3978.00; --������ ������������ ��� ����������� �����
--SELECT [ORDER_NUM], [AMOUNT] FROM [ORDERS] WHERE [AMOUNT] = 1896;
--SELECT * FROM ORDERS WHERE AMOUNT = 1896

--DROP INDEX #AMOUNT ON [DBO].[ORDERS];

/*CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] INDEX index_name
    ON table_name (column1 [ASC | DESC] ,...)
        [ INCLUDE ( column_name [ ,... ] ) ]
        
[WITH
    [FILLFACTOR=n]
    [[, ] PAD_INDEX = {ON | OFF}]*/
	--index_name ������ ��� ������������ �������.
	--������ ����� ������� ��� ������ ��� ������ �������� ����� �������, ������������ ���������� table_name.
	--�������, ��� �������� ��������� ������, ����������� ���������� column1.

CREATE NONCLUSTERED INDEX #FILTERINDEX8 
    ON ORDERS (AMOUNT, ORDER_DATE)
	SELECT AMOUNT, ORDER_DATE  
	FROM ORDERS 
    WHERE AMOUNT > 22500 AND ORDER_DATE > '2008-01-30';

GO  
SELECT AMOUNT, ORDER_DATE  
FROM ORDERS 
WHERE AMOUNT = 45000 AND ORDER_DATE > '2008-01-30' ;  
GO  

GO  
SELECT * FROM ORDERS 
    WITH ( INDEX ( #FILTERINDEX8 ) )   
WHERE AMOUNT IN (45000);   
GO 
--������ ��������� ������ �������� ������ � ����� ��� ���������� ������� ��� ������

--5.	�������� ������ �������� ��� ������� � ����������������� ��� ����������.
CREATE INDEX #ALLCOLLUMN2 
ON CUSTOMERS(CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT);
SELECT * FROM CUSTOMERS; --������ �������� - ��� ������ , ���������� ��� �������, ���������� �� �������.

--6.	�������� ������ ��� ������� � ����������� ������ � ����������������� ��� ����������.
SELECT DISTINCT SALESREPS.NAME, 
				CUSTOMERS.COMPANY
	FROM ORDERS, CUSTOMERS, SALESREPS
	WHERE ORDERS.REP = SALESREPS.EMPL_NUM 
    AND ORDERS.CUST=CUSTOMERS.CUST_NUM
SELECT * FROM ORDERS;
EXEC SP_HELPINDEX 'ORDERS'; --������� ��� ������� �������� �������� � SQL ���������� � ���� ��������� �����.
CREATE INDEX #REQUEST3 ON ORDERS(ORDER_DATE, ORDER_NUM);
------------------------------------------------------
-----������� ����������, ������� ����������� ����� � ��� �� �����������.
SELECT DISTINCT 
	OR1.CUST, OR1.REP
FROM ORDERS OR1
JOIN ORDERS OR2 ON OR1.CUST=OR2.CUST
WHERE OR1.REP != OR2.REP
ORDER BY CUST ASC

SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;
exec sp_helpindex 'ORDERS';

CREATE INDEX #REQUEST2 ON ORDERS(CUST,REP);

-------������� ���� ����������� �� ���������� ������� � ������������� �� ��������� Quota.
--Select name, empl_num, rep_office, region, quota 
--from salesreps s 
--left join offices ofi on rep_office=office
--where region='Eastern' order by Quota desc;

--SELECT * FROM OFFICES;
--SELECT * FROM SALESREPS;
--exec sp_helpindex 'OFFICES';
--exec sp_helpindex 'SALESREPS';
----SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB3'), OBJECT_ID('OFFICES'), NULL,NULL,NULL);
----SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB3'), OBJECT_ID('SALESREPS'), NULL,NULL,NULL);

--CREATE INDEX #region ON OFFICES(OFFICE) where REGION='EASTERN';
--CREATE INDEX #QUOTA ON SALESREPS(QUOTA, REP_OFFICE);

--DROP INDEX ix_empid ON Employee;

--7.	�������� ��������� �������� ��� ������� � ����������������� �� ����������� � �������������.
CREATE TABLE #OFFIC
(	OF_1 int IDENTITY(1,1),
	CITY_1 VARCHAR(100),
	REG_1 varchar(100),
	MGR_1 INT,
	TARG_1 DECIMAL(5, 2),
	SAL_1 DECIMAL(5, 2));

CREATE NONCLUSTERED INDEX #TMP_TBL_3 ON #OFFIC(MGR_1)
SELECT * FROM CUSTOMERS

SELECT * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB9'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)

ALTER INDEX #TMP_TBL_3 ON #OFFIC REORGANIZE
SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB9'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)

--ALTER INDEX #TMP_TBL_3 ON #OFFIC REBUILD WITH (ONLINE=OFF)
--SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('tempdb'), OBJECT_ID('#OFFIC'), NULL,NULL,NULL)

--8.	��� ��������, ������������� � ������������ ������ � 3, �������� � ��������������� ����� ��������.
GO
CREATE VIEW VIEWCUST3
    AS SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT
    FROM CUSTOMERS
	WHERE COMPANY = 'FIRST CORP.'   ----�� ��� ������
GO

--9.	�������� ������� ��� ����������� �������� �� ������������ ������ � 3.
--10.	�������� ����������� ������� ��� ���� ������ ������ ��������.

exec SP_HELPINDEX '���_��';

CREATE INDEX #TRAINING ON ���_��(���_��������);

EXEC SP_HELPINDEX 'HUMAN_RESURCES_DEPARTMEN';
CREATE INDEX #TRAINING1 ON HUMAN_RESURCES_DEPARTMEN(NAMEFL);

SET SHOWPLAN_XML ON;
SET STATISTICS XML ON