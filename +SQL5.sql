--Программирование T-SQL.
--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @MyChar char(8),
  @MyVarchar varchar,
  @MyDateTime datetime,
  @MyTime time,
  @MyInt int,
  @MySmallInt smallint,
  @MyTinyInt tinyint,
  @MyNumeric numeric(12, 5);
--1.2.	первые две переменные проинициализировать в операторе объявления.
DECLARE @IsChar char(8) = 'Char',
  @IsVarchar varchar(20) = 'How are you'
PRINT @IsChar +'-----' + @ISVARCHAR
--1.3.	присвоить  произвольные значения следующим двум переменным с помощью оператора SET, одной из  этих переменных  присвоить значение, 
--полученное в результате запроса SELECT.
DECLARE @IsDateTime DATETIME,
		@IsTime TIME,
		@ISCHAR1 VARCHAR(5),
		@SHOW VARCHAR(1000),
		@SHOW_ONE VARCHAR(1000)
SET @IsDateTime = CAST('2020/12/10 23:59:59' AS DATETIME)
SET @IsTime = '23:59:59'
SET @ISCHAR1 = 'KIX'
SELECT @SHOW = CAST(@IsTime AS VARCHAR(100))
--SELECT @SHOW_ONE=CAST(@IsDateTime AS VARCHAR(1000))
PRINT @SHOW
PRINT @IsDateTime
PRINT @ISCHAR1
SELECT @IsDateTime

--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения, оставшимся переменным присвоить некоторые значения 
--с помощью оператора SELECT;
DECLARE @QTY INT, --= (SELECT SUM(QTY) AS INT FROM ORDERS),
		@AMOUNT NUMERIC (12,2) = (
				SELECT CAST(AVG(AMOUNT) AS NUMERIC(12,2)) 
				FROM ORDERS),
		@MAX TINYINT = (
				SELECT MAX(QTY) AS TINYINT 
				FROM ORDERS);
PRINT @QTY 
PRINT @AMOUNT 
PRINT @MAX

--1.5.	значения половины переменных вывести с помощью оператора SELECT, значения другой половины 
--переменных распечатать с помощью оператора PRINT. 
DECLARE @QTY2 VARCHAR(10) = 'POWER', 
		@IsVarchar2 VARCHAR(20) = 'FAST', 
		@IsDateTime2 VARCHAR (20) = 'STRONG'

SELECT @QTY2 'ROW_ONE'; 
	SELECT	@IsVarchar2 'ROW_TWO'; 
		SELECT @IsDateTime2 'ROW_THREE';
PRINT @QTY2 
PRINT @IsVarchar2 
PRINT @IsDateTime2
--PRINT CAST(@QTY2 AS VARCHAR(500)) + '->' + CAST(@IsVarchar2 AS VARCHAR(100)) + '-> ' + CAST(@IsDateTime2 AS VARCHAR(300));
--PRINT @QTY2 + '->' + @IsVarchar2 + '-> ' + @IsDateTime2
--SET @MyTime = getdate();
--SELECT @MySmallInt = 12;
--SELECT @MyTinyInt = 3;
--SELECT @MyNumeric;
--declare @mychar char(10) ='Welcome'

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. 
--Если средняя стоимость продукта превышает 10, то вывести количество продуктов, среднюю стоимость продукта, максимальную 
--стоимость продукта. 
--Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта.
SELECT * FROM ORDERS
SELECT * FROM PRODUCTS

DECLARE @maxprice int, 
		@minprice int, 
		@avgprice int, 
		@QTY_ON INT,
		@AMOUNT1 INT
SET @QTY_ON = (SELECT CAST(COUNT (QTY_ON_HAND) AS INT) FROM PRODUCTS) --COUNT - ВОЗВРАЩАЕТ КОЛИЧЕСТВО СТРОК
PRINT CAST(@QTY_ON AS VARCHAR(20))
SET @maxprice = (SELECT cast(max(price) as decimal (9, 2)) from products);
PRINT 'MAX PRICE-'+ CAST(@MAXPRICE AS VARCHAR(20))
SET @minprice = (SELECT cast(min(price) as decimal (9, 2)) from products);
PRINT 'MIN PRICE-'+ CAST(@MINPRICE AS VARCHAR(20))
SET @avgprice = (SELECT cast(AVG(price) as decimal (9, 2)) from products);
PRINT 'AVG PRICE-'+CAST(@avgprice AS VARCHAR(20))
----
IF @avgprice > 10 
PRINT 'AVGPRICE > 10: QTY PRODUCT = '+CAST(@QTY_ON AS VARCHAR(20))+'; '+'AVG PRICE OF PRODUCT = ' + cast(@avgprice AS VARCHAR(10)) + 
'; MAX PRICEOF PRODUCT = ' + CAST(@maxprice AS VARCHAR(10))
ELSE IF @avgprice < 10 
PRINT 'AVGPRICE < 10: MIN PRICE  OF  PRODUCT = ' + CAST(@minprice AS VARCHAR(10))
ELSE 
PRINT 'AVERAGE PRICE OF PRODUCT = 10';
PRINT @AVGPRICE

print @maxprice

--3.	Подсчитать количество заказов сотрудника в определенный период. 
DECLARE 
	@SHOW2 VARCHAR(100), 
	@NAMECUST VARCHAR(20)
--SELECT @NAMECUST = (SELECT CUST FROM ORDERS) 
--PRINT @NAMECUST
SELECT @SHOW2 =(SELECT COUNT(ORDER_NUM) AS ORDERS_QTY 
				FROM ORDERS 
				WHERE YEAR(ORDER_DATE)=2008) 
--group by rep;
--PRINT @NAMECUST
PRINT 'QTY ORDERS DEFINITE DATE CONSTITUTE: '+@SHOW2

SELECT * FROM ORDERS

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы. SUBSTRING - ИЗВЛЕКАЕТ СТРОКУ ЗАДАННОЙ ДЛИНЫ 
												--SUBSTRING (Expression, Starting Position, Total Length)
												--CHARINDEX: возвращает индекс, по которому находится первое вхождение подстроки в строке.
												--LEN возвращает количество символов, закодированных в данном строковом выражении
SELECT 
	SUBSTRING(NAME, 0, 2) + '. ' + SUBSTRING(NAME, CHARINDEX(' ', NAME) + 1, LEN(NAME) + CHARINDEX(' ', NAME)) AS SALESREPS, 
	NAME,
	SUBSTRING (NAME, 0, 2) + '. ' + SUBSTRING(NAME, CHARINDEX(' ', NAME) + 1, LEN(NAME)) AS SALESREPS_TWO
FROM SALESREPS;
-------------------
SELECT
	NAME,
	LEFT (NAME, 1) AS FN, CHARINDEX(' ', NAME) + 1 AS SP
FROM SALESREPS

SELECT
	NAME,
	LEFT (NAME, 1) +'. '+ SUBSTRING(NAME, CHARINDEX(' ', NAME) + 1, 1) + '. ' AS INITIALS
FROM SALESREPS

DECLARE @NAME 
SELECT
	NAME,
	LEFT (NAME, 1) +'. '+ SUBSTRING(NAME, CHARINDEX(' ', NAME) + 1, 1) + '. ' AS INITIALS
FROM SALESREPS

SELECT *
FROM SALESREPS

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
--DATEADD (datepart, number, date) возвращает значение типа datetime, 
--которое получается добавлением к дате date количества интервалов 
--типа datepart, равного number (целое число). 
--Например, мы можем к заданной дате добавить любое число лет, дней, часов, минут и т. д.
-- GETDATE() возвращает текущую локальную дату и время
-- на основе системных часов в виде объекта datetime
SELECT 
	NAME,
	HIRE_DATE
FROM SALESREPS
WHERE MONTH(HIRE_DATE) = MONTH(DATEADD(MONTH, 5, GETDATE()));

--4.3.	поиск сотрудников, которые проработали более 10 лет.
--DATEDIFF возвращает разность между двумя значениями даты в зависимости от указанного интервала
-- GETDATE возвращает системную дату и время
SELECT 
	NAME,
	HIRE_DATE,
	DATEDIFF (YEAR, HIRE_DATE, GETDATE()) AS MORE_THAN_10_YEAR
FROM SALESREPS
WHERE DATEDIFF (YEAR, HIRE_DATE, GETDATE()) > 10

--4.4.	поиск дня недели, в который делались заказы.
-- DATEPART() возвращает часть даты в виде числа
SELECT 
	ORDER_NUM,
	ORDER_DATE,
	DATEPART(DAY, ORDER_DATE) AS DAY_ORDER
FROM ORDERS

--5.	Продемонстрировать применение оператора IF… ELSE.
DECLARE @X INT = 350,
		@Y INT = 200
IF @X > @Y 
PRINT 'TRUE'
ELSE PRINT 'FALSE'

--6.	Продемонстрировать применение оператора CASE.
DECLARE @X INT = 23
PRINT 
(CASE
	WHEN @X = 20 THEN 'Your 20 year old'
	WHEN @X = 23 THEN 'Your 23 year old'
	WHEN @X = 27 THEN 'Your 27 year old'
ELSE 'NO SUIT'
END)


--7.	Продемонстрировать применение оператора RETURN. 
DECLARE @X INT = 27,
		@Y INT = 23,
		@Z INT = 45,
		@PRICE INT
SELECT @PRICE = @X + @Y + @Z
PRINT @PRICE
RETURN

--8.	Разработать скрипт с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ERROR_NUMBER (код последней ошибки), ERROR_ES-SAGE (сообщение об ошибке), 
--ERROR_LINE(код последней ошибки), ERROR_PROCEDURE (имя  процедуры или NULL), 
--ERROR_SEVERITY (уровень серьезности ошибки), ERROR_ STATE (метка ошибки). 
DECLARE 
	@X INT = 34, 
	@Y INT = 0, 
	@Z INT;
BEGIN TRY
 SET @Z = @X/@Y; -- ERR
--PRINT @Z
END TRY
BEGIN CATCH
 PRINT 'Block CATCH'
 PRINT 'ERROR_NUMBER = '+ CAST(ERROR_NUMBER() AS VARCHAR(1000)) --ERROR_NUMBER (код последней ошибки)
 PRINT 'ERROR_MESSAGE = '+ERROR_MESSAGE()						--ERROR_MESSAGE (сообщение об ошибке)
 PRINT 'ERROR_LINE = '+CAST(ERROR_LINE() AS VARCHAR(100))		--ERROR_LINE(код последней ошибки)
 PRINT 'ERROR_PROCEDURE = '+CAST(ERROR_PROCEDURE() AS VARCHAR(100)) --ERROR_PROCEDURE (имя  процедуры или NULL)
 PRINT 'ERROR_SEVERITY = '+CAST(ERROR_SEVERITY() AS VARCHAR(100))	--ERROR_SEVERITY (уровень серьезности ошибки)
 PRINT 'ERROR_STATE = '+CAST(ERROR_STATE() AS VARCHAR(100))			--ERROR_ STATE (метка ошибки)
END CATCH

--9.	Создать локальную временную таблицу из трех столбцов. 
--Добавить данные (10 строк) с использованием оператора WHILE. Вывести ее содержимое.
CREATE TABLE #TABLE (X INT, A INT, SUMM INT);
DROP TABLE #TABLE

DECLARE 
	@X INT = 0,
	@A INT = 0,
	@Y INT = 10,
	@Z INT = 0
PRINT 'RANGE'
WHILE (@X<@Y AND @A<@Y)
BEGIN
	INSERT INTO #TABLE VALUES(@X, @A, @Z) 
		PRINT @X;
		PRINT @A
		SET @X = @X+1
		SET @A = @A+1
		SET @Z = @X+@A
		END
	PRINT @Z
GO

SELECT * FROM #TABLE
------------------------------------------
CREATE TABLE #TABLE_TWO (NUMBER INT, FACTORIAL INT)
DROP TABLE #TABLE_TWO

DECLARE 
	@NUMBER INT, 
	@FACTORIAL INT
PRINT 'RANGE:'
SET @FACTORIAL = 1;
SET @NUMBER = 5;
WHILE @NUMBER > 0
    BEGIN
	INSERT INTO #TABLE_TWO VALUES(@NUMBER, @FACTORIAL)
        SET @FACTORIAL = @FACTORIAL * @NUMBER
		SET @NUMBER = @NUMBER - 1
		PRINT @FACTORIAL
END;
PRINT 'FACTORIAL EQUAL: '
PRINT @FACTORIAL

SELECT * FROM #TABLE_TWO