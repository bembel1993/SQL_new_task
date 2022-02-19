--1.	Разработать хранимые процедуры: 
--1.1.	Добавления нового клиента; при попытке дублирования данных — 
--вывести сообщение об ошибке.
--------------------VERSION 1-----------------------------------------------------
--1.CREATE PROCEDURE
GO
ALTER PROCEDURE CUST_ADD
		@CUST_NUM INT,
		@COMPANY VARCHAR(20),
		@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
AS
DECLARE @COUNT INT = 0
BEGIN 
	BEGIN TRY
		INSERT INTO CUSTOMERS (CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT)
			VALUES (@CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT)
	END TRY
	BEGIN CATCH
		SET @COUNT = -1
		--PRINT 'ERROR! THIS CUST IS ADD'
	IF ERROR_NUMBER() = 2627
	PRINT 'ERROR! THIS CUST IS ADD'
	ELSE IF  ERROR_NUMBER() = 547
	PRINT 'NO SALESREPS'
	--PRINT ERROR_NUMBER()
	END CATCH
	RETURN @COUNT;
END
---?????
INSERT INTO CUSTOMERS VALUES (1320, 'SIEMENS', 60, 12000)
--26/27 PK
--547/ FK
--DROP PROCEDURE CUST_ADD  
GO  
------------------ADD CUST------------------------------
--2.INIT VARIABLE
DECLARE @CUST_NUM INT,
		@COMPANY VARCHAR(25),
		@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
SET @CUST_NUM = 1320 --1321
SET @COMPANY = 'SIEMENSSIEMENSSIEMENSSIEMENS'
SET @CUST_REP = 106 --60
SET @CREDIT_LIMIT = 12000

EXEC CUST_ADD @CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT --ИСПОЛНЕНИЕ ПРОЦЕДУРЫ-УКАЗАННЫЕ ПЕРЕМЕННЫЕ ПЕРЕДАЮТ СВОИ ЗНАЧЕНИЯ ТАБЛИЦЕ CUSTOMERS
GO
----------------------------------------------------------
--3.VIEW
SELECT * FROM CUSTOMERS
WHERE CUST_NUM = 1321
DELETE FROM CUSTOMERS
------------------------------------------------
/*create procedure SelCust
as
declare @rc int = 0
begin
	select * from CUSTOMERS
	if @@rowcount = 0 set @rc = -1
	return @rc
end

declare @code int = 15;
exec @code = SelCust;
print 'Code = ' + cast(@code as varchar(10));

go*/
----------------VERSION 2-----------------------------------------------------------------
GO
CREATE PROCEDURE SelectCust 
				@cust_num INTEGER, 
				@company varchar(20), 
				@cust_rep integer, 
				@credit_limit decimal(5, 2)
    AS SELECT cust_num, company, cust_rep, credit_limit
    FROM customers

--DROP PROCEDURE SelectCust  
------------------------------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION
		insert into CUSTOMERS values(3101, 'LUX', 116,60000.00);
		insert into CUSTOMERS values(3101, 'LUX', 116,60000.00);
    COMMIT TRANSACTION
    PRINT 'Транзакция выполнена'
END TRY
BEGIN CATCH
    ROLLBACK
        PRINT 'Отмена транзакции';
    THROW
END CATCH

EXEC SelectCust
---------------------
SELECT * FROM CUSTOMERS
-------------------------------------------------------------------------------

--1.2.	Поиска клиента по части названия; если такого не нашлось — вывести сообщение.
ALTER PROCEDURE COMPSERCH 
				@COMPANY NVARCHAR(30)
	AS
	BEGIN
		SELECT * 
		FROM CUSTOMERS
		SELECT COMPANY 
		FROM CUSTOMERS WHERE COMPANY LIKE ('%INC%')
		--FROM CUSTOMERS WHERE COMPANY LIKE ('%'+@COMPANY+'%')
		IF @@ROWCOUNT = 0
		PRINT 'NOT FOUND CUST'
	END
GO

--DROP PROCEDURE COMPSERCH
DECLARE 
		@COMPANY VARCHAR(25)
--SET @COMPANY = 'MFG'

EXEC COMPSERCH @COMPANY

SELECT *
FROM CUSTOMERS

--1.3.	Обновления данных клиента.
CREATE PROCEDURE UPDATECUSTS
		--@CUST_NUM INT = NULL,
		@COMPANY VARCHAR(20) = 'RELEASED',
		--@CUST_REP INT = NULL,
		@CREDIT_LIMIT DECIMAL(9, 2) = NULL
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

    -- Insert statements for procedure here
       UPDATE CUSTOMERS 
	   SET --CUST_NUM = @CUST_NUM, 
	    COMPANY = @COMPANY,
           --CUST_REP = @CUST_REP, 
		CREDIT_LIMIT = @CREDIT_LIMIT 
	   WHERE CREDIT_LIMIT < 15000
END

EXEC UPDATECUSTS

SELECT * FROM CUSTOMERS
/*DECLARE --@CUST_NUM INT,
		@COMPANY VARCHAR(25),
		--@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
--SET @CUST_NUM = 1321 --1321
SET @COMPANY = 'RELEASED'
--SET @CUST_REP = 106 --60
SET @CREDIT_LIMIT = 0000*/

--1.4.	Удаления данных о клиенте; если у клиента есть заказы, и его нельзя удалить — вывести сообщение. 
--2.	Вызвать разработанные процедуры с различными параметрами для демонстрации.

--3.	Разработать пользовательские функции: 
--3.1.	Подсчитать количество заказов сотрудника в определенный период. Если такого сотрудника нет — вернуть -1. 
--Если сотрудник есть, а заказов нет — вернуть 0.

/*GO
CREATE FUNCTION ComputeCosts (@percent INT = 10)
    RETURNS DECIMAL(16, 2)
    BEGIN
        DECLARE @addCosts DEC (14,2), @sumBudget DEC(16,2)
        SELECT @sumBudget = SUM (Budget) FROM Project
        SET @addCosts = @sumBudget * @percent/100
        RETURN @addCosts
    END*/
-------------------------------------------------------------
SELECT * FROM SALESREPS
SELECT * FROM ORDERS
SELECT * FROM CUSTOMERS

--3.1.	Подсчитать количество заказов сотрудника в определенный период. Если такого сотрудника нет — вернуть -1. 
--Если сотрудник есть, а заказов нет — вернуть 0.
CREATE FUNCTION COUNT_ORDERS_OF_SALESREPS 
	(@REP INT, @ORDER_DATE_BEFORE DATE,
	@ORDER_DATE_AFTER DATE) RETURNS INT
BEGIN
	--DECLARE @NO_SALESREPS INT = -1
	--DECLARE @AVAILABLE_SALESREPS INT = 0
	DECLARE @DEFINITE_ORDER_DATE INT = 0
	--IF (SELECT REP 
		--FROM ORDERS 
		--WHERE REP != @REP) IS NULL*/
	--RETURN @NO_SALESREPS
	/*ELSE IF (SELECT REP
			 FROM ORDERS
			 WHERE REP = @REP) IS NULL*/
	--RETURN @DEFINITE_ORDER_DATE
	--DECLARE @DEFINITE_ORDER_DATE INT
	SET @DEFINITE_ORDER_DATE = (SELECT COUNT(ORDER_NUM)
							FROM ORDERS 
							WHERE REP = @REP AND ORDER_DATE BETWEEN @ORDER_DATE_BEFORE AND @ORDER_DATE_AFTER)			
	RETURN @DEFINITE_ORDER_DATE

END

DROP FUNCTION COUNT_ORDERS_OF_SALESREPS

DECLARE @REP INT
	SET @REP = [DBO].COUNT_ORDERS_OF_SALESREPS(108, '2008-02-02', '2008-02-15')
	SELECT CUST, ORDER_DATE, REP, DBO.COUNT_ORDERS_OF_SALESREPS(REP, '2008-02-02', '2008-02-15') AS COUNT_ORDER_DATE
	FROM ORDERS
	GROUP BY CUST, REP, ORDER_DATE
PRINT 'RESULT ' + CAST(@REP AS VARCHAR(10))
---------------------------------------------------------------------------------------------------------------------

--3.2.	Подсчитать количество товаров различных производителей ценой выше указанной. 
SELECT * FROM PRODUCTS
SELECT * FROM ORDERS
GO
CREATE FUNCTION QTY_PRODUCTS_DIFFERENT_COMPANY(@PRICE INT)
			RETURNS INT
    BEGIN
        DECLARE  @PRODUCT_QTY INT
		SELECT @PRODUCT_QTY = COUNT(P.DESCRIPTION) 
		FROM PRODUCTS P LEFT JOIN ORDERS O
		ON O.MFR = P.MFR_ID
		WHERE P.PRICE > @PRICE
		RETURN @PRODUCT_QTY
    END
GO
----
SELECT *
		FROM PRODUCTS P LEFT JOIN ORDERS O
		ON O.MFR = P.MFR_ID
		WHERE P.PRICE > 2750
----SHOW_1-----
DECLARE @QTY INT;
SET @QTY = [DBO].QTY_PRODUCTS_DIFFERENT_COMPANY(2750)
SELECT MFR_ID, QTY_ON_HAND, DBO.QTY_PRODUCTS_DIFFERENT_COMPANY(2750) AS COUNT_PRICE
FROM PRODUCTS
PRINT 'RESULT ' + CAST(@QTY AS VARCHAR(10))
-----SHOW_2-----
SELECT MFR_ID, PRICE, DBO.QTY_PRODUCTS_DIFFERENT_COMPANY(2500) AS COUNT_PRICE
    FROM PRODUCTS
    WHERE PRICE > dbo.QTY_PRODUCTS_DIFFERENT_COMPANY(2500);

	SELECT * FROM PRODUCTS

DROP FUNCTION QTY_PRODUCTS_DIFFERENT_COMPANY

--3.3.	Подсчитать количество заказанных товаров для определенного производителя.
SELECT * FROM ORDERS
WHERE MFR = 'REI'

GO
CREATE FUNCTION ORDERS_QTY () 
				RETURNS INT
BEGIN 
	DECLARE @QTYORD INT = (SELECT COUNT(ORDER_NUM) FROM ORDERS WHERE MFR = 'REI')
	RETURN @QTYORD;
END
GO
-----
DECLARE @SHOW_ORDER INT = DBO.ORDERS_QTY();
PRINT 'SHOW ORDER FOR A CERTAIN MANUFACTURER = ' + CAST(@SHOW_ORDER AS VARCHAR(10));
GO
-----

DROP FUNCTION ORDERS_QTY

--4.	Вызвать разработанные функции различными способами с различными параметрами для демонстрации.
