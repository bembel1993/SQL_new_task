--���������������� T-SQL.
--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @MyChar char(8),
  @MyVarchar varchar,
  @MyDateTime datetime,
  @MyTime time,
  @MyInt int,
  @MySmallInt smallint,
  @MyTinyInt tinyint,
  @MyNumeric numeric(12, 5);
--1.2.	������ ��� ���������� ������������������� � ��������� ����������.
DECLARE @IsChar char(8) = 'Char',
  @IsVarchar varchar(20) = 'How are you'
PRINT @IsChar +'-----' + @ISVARCHAR
--1.3.	���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET, ����� ��  ���� ����������  ��������� ��������, 
--���������� � ���������� ������� SELECT.
DECLARE @IsDateTime datetime,
		@IsTime time,
		@ISCHAR1 VARCHAR(5),
		@SHOW VARCHAR(1000)
SET @IsTime = '23:59:59'
SET @IsDateTime = '31/12/2020'
SET @ISCHAR1 = 'KIX'
SELECT @SHOW = cast(@IsTime as varchar(100))
PRINT @SHOW
PRINT @ISCHAR1
--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, ���������� ���������� ��������� ��������� �������� 
--� ������� ��������� SELECT;
DECLARE @QTY INT, --= (SELECT SUM(QTY) AS INT FROM ORDERS),
		@AMOUNT NUMERIC (12,2) = (SELECT CAST(AVG(AMOUNT) AS NUMERIC(12,2)) FROM ORDERS),
		@MAX TINYINT = (SELECT MAX(QTY) AS TINYINT FROM ORDERS);
PRINT @QTY 
PRINT @AMOUNT 
PRINT @MAX

--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT, �������� ������ �������� 
--���������� ����������� � ������� ��������� PRINT. 
DECLARE @QTY2 VARCHAR(10) = 'POWER', 
		@IsVarchar2 VARCHAR(20) = 'FAST', 
		@IsDateTime2 VARCHAR (20) = 'STRONG'

SELECT @QTY2 'ROW_ONE'; 
	SELECT	@IsVarchar2 'ROW_TWO'; 
		SELECT @IsDateTime2 'ROW_THREE';
PRINT @QTY2 
PRINT @IsVarchar2 
PRINT @IsDateTime2
PRINT CAST(@QTY2 AS VARCHAR(500)) + '->' + CAST(@IsVarchar2 AS VARCHAR(100)) + '-> ' + CAST(@IsDateTime2 AS VARCHAR(300));
PRINT @QTY2 + '->' + @IsVarchar2 + '-> ' + @IsDateTime2
--SET @MyTime = getdate();
--SELECT @MySmallInt = 12;
--SELECT @MyTinyInt = 3;
--SELECT @MyNumeric;
--declare @mychar char(10) ='Welcome'

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. 
--���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, ������� ��������� ��������, ������������ 
--��������� ��������. 
--���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������.
SELECT * FROM ORDERS
SELECT * FROM PRODUCTS
DECLARE @maxprice int, 
		@minprice int, 
		@avgprice int, 
		@QTY_ON INT,
		@AMOUNT1 INT
SET @QTY_ON = (SELECT CAST(COUNT (QTY_ON_HAND) AS INT) FROM PRODUCTS)
PRINT CAST(@QTY_ON AS VARCHAR(20))
SET @maxprice = (select cast(max(price) as decimal (9, 2)) from products);
PRINT 'MAX PRICE-'+ CAST(@MAXPRICE AS VARCHAR(20))
set @minprice = (select cast(min(price) as decimal (9, 2)) from products);
PRINT 'MIN PRICE-'+ CAST(@MINPRICE AS VARCHAR(20))
set @avgprice = (select cast(AVG(price) as decimal (9, 2)) from products);
PRINT 'AVG PRICE-'+CAST(@avgprice AS VARCHAR(20))
IF @avgprice > 10 
PRINT 'QTY PRODUCT = '+CAST(@QTY_ON AS VARCHAR(20))+'; '+'AVG PRICE OF PRODUCT = ' + cast(@avgprice as varchar(10)) + 
'; MAX PRICEOF PRODUCT = ' + cast(@maxprice as varchar(10))
ELSE IF @avgprice < 10 print 'MIN PRICE  OF  PRODUCT = ' + cast(@minprice as varchar(10))
ELSE 
PRINT 'AVERAGE PRICE OF PRODUCT = 10';
PRINT @AVGPRICE
go
print @maxprice
--3.	���������� ���������� ������� ���������� � ������������ ������. 
DECLARE @SHOW2 VARCHAR(100), @NAMECUST VARCHAR(20)
--SELECT @NAMECUST = (SELECT CUST FROM ORDERS) 
--PRINT @NAMECUST
SELECT @SHOW2 =(select count(order_num) as orders_qty from orders where year(order_date)=2008) 
--group by rep;
--PRINT @NAMECUST
PRINT 'QTY ORDERS DEFINITE DATE CONSTITUTE: '+@SHOW2

SELECT * FROM ORDERS
--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
SELECT 
	SUBSTRING(NAME, 0, 2) + '. ' + SUBSTRING(NAME, CHARINDEX(' ', NAME)
	+ 1, LEN(NAME) + CHARINDEX(' ', NAME)) AS SALESREPS 
FROM SALESREPS;

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
select 
	name,
	hire_date
from salesreps
where month(hire_date) = month(dateadd(month, 10, getdate()));

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
select
	name,
	hire_date,
	datediff (year, hire_date, getdate()) as more_than_10_years
from salesreps
where datediff (year, hire_date, getdate()) = 15

--4.4.	����� ��� ������, � ������� �������� ������.
select 
	order_num,
	order_date,
	DATEPART(day, order_date) as day_order
from orders

--5.	������������������ ���������� ��������� IF� ELSE.
declare @x int = 350,
		@y int = 200
if @x > @y 
print 'TRUE'
else print 'FALSE'
go

--6.	������������������ ���������� ��������� CASE.
declare @x int = 30
print 
(case
	when @x = 20 then 'Your 20 year old'
	when @x = 23 then 'Your 23 year old'
	when @x = 27 then 'Your 27 year old'
else 'no suit'
end)
go

--7.	������������������ ���������� ��������� RETURN. 
declare @x int = 27,
		@y int = 23,
		@z int = 45,
		@price int
select @price = @x + @y + @z
print @price
return
go

--8.	����������� ������ � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
--��������� ������� ERROR_NUMBER (��� ��������� ������), ERROR_ES-SAGE (��������� �� ������), 
--ERROR_LINE(��� ��������� ������), ERROR_PROCEDURE (���  ��������� ��� NULL), 
--ERROR_SEVERITY (������� ����������� ������), ERROR_ STATE (����� ������). 
DECLARE @X int = 34, @Y int = 0, @Z int;
BEGIN TRY
 SET @Z = @X/@Y; -- ERR
--PRINT @Z
END TRY
BEGIN CATCH
 PRINT 'Block CATCH'
 PRINT 'ERROR_NUMBER = '+ CAST(ERROR_NUMBER() AS VARCHAR(1000))
 PRINT 'ERROR_MESSAGE = '+ERROR_MESSAGE()
 PRINT 'ERROR_LINE = '+CAST(ERROR_LINE() AS VARCHAR(100))
 PRINT 'ERROR_PROCEDURE = '+CAST(ERROR_PROCEDURE() AS VARCHAR(100))
 PRINT 'ERROR_SEVERITY = '+CAST(ERROR_SEVERITY() AS VARCHAR(100))
 PRINT 'ERROR_STATE = '+CAST(ERROR_STATE() AS VARCHAR(100))
END CATCH
GO

--9.	������� ��������� ��������� ������� �� ���� ��������. 
--�������� ������ (10 �����) � �������������� ��������� WHILE. ������� �� ����������.
CREATE TABLE #TABLE (NUMBER INT, FACTORIAL INT);
--INSERT INTO #TABLE VALUES(10, 1)
SELECT * FROM #TABLE
DROP TABLE #TABLE

DECLARE 
	@number INT, 
	@factorial INT
PRINT 'RANGE:'
SET @factorial = 1;
SET @number = 5;
WHILE @number > 0
    BEGIN
	INSERT INTO #TABLE VALUES(@NUMBER, @FACTORIAL)
        SET @factorial = @factorial * @number
		SET @number = @number - 1
		PRINT @factorial
END;
PRINT 'FACTORIAL EQUAL: '
PRINT @factorial