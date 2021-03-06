--1.	??????????? ???????? ?????????: 
--1.1.	?????????? ?????? ???????; ??? ??????? ???????????? ?????? ? 
--??????? ????????? ?? ??????.
--------------------VERSION 1-----------------------------------------------------
--1.CREATE PROCEDURE
GO
CREATE PROCEDURE CUST_ADD
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
SET @CUST_NUM = 1325 --1321
SET @COMPANY = 'DIALOG'
SET @CUST_REP = 106 --60
SET @CREDIT_LIMIT = 12000

EXEC CUST_ADD @CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT --?????????? ?????????-????????? ?????????? ???????? ???? ???????? ??????? CUSTOMERS
GO
----------------------------------------------------------
--3.VIEW
SELECT * FROM CUSTOMERS
WHERE CUST_NUM = 1321
DELETE FROM CUSTOMERS
------------------------------------------------

--1.2.	?????? ??????? ?? ????? ????????; ???? ?????? ?? ??????? ? ??????? ?????????.
CREATE PROCEDURE COMPSERCH 
				@COMPANY NVARCHAR(30)
	AS
	BEGIN
		SELECT * 
		FROM CUSTOMERS
		SELECT COMPANY 
		FROM CUSTOMERS 
		WHERE COMPANY LIKE ('%INC%') 
			--AND COMPANY LIKE ('%CORP%')
			--AND COMPANY LIKE ('%'+@COMPANY+'%')
		--FROM CUSTOMERS WHERE COMPANY LIKE ('%'+@COMPANY+'%')
		IF @@ROWCOUNT = 0
		PRINT 'NOT FOUND CUST'
	END
GO

--DROP PROCEDURE COMPSERCH
DECLARE @COMPANY VARCHAR(25)
--SET @COMPANY = 'MFG'
EXEC COMPSERCH @COMPANY

SELECT *
FROM CUSTOMERS

--1.3.	?????????? ?????? ???????.
DROP PROCEDURE UPDATE_CUSTS

CREATE PROCEDURE UPDATE_CUSTS
		@COMPANY VARCHAR(20),
		@CREDIT_LIMIT DECIMAL(9, 2)
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       --SET NOCOUNT ON;
    -- Insert statements for procedure here
       UPDATE CUSTOMERS 
	   SET CREDIT_LIMIT = @CREDIT_LIMIT  
	   WHERE COMPANY = @COMPANY			
END

DECLARE @CO VARCHAR(20) = 'Acme Mfg.', 
		@CR DECIMAL(9, 2) = 55000;

EXEC UPDATE_CUSTS @CO, @CR

SELECT * FROM CUSTOMERS

--DROP PROCEDURE UPDATECUSTS
/*DECLARE --@CUST_NUM INT,
		@COMPANY VARCHAR(25),
		--@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
--SET @CUST_NUM = 1321 --1321
SET @COMPANY = 'RELEASED'
--SET @CUST_REP = 106 --60
SET @CREDIT_LIMIT = 0000*/

--1.4.	???????? ?????? ? ???????; ???? ? ??????? ???? ??????, ? ??? ?????? ??????? ? ??????? ?????????.
INSERT INTO CUSTOMERS VALUES (1111, 'HP', 106, 10000.00)
--INSERT INTO ORDERS VALUES (13234, '2010-01-01', 1111, 106, 'ACI', '23XXP', 3, 20000.00)
--????????? ? ??????? lab_6
ALTER PROCEDURE DROP_DATA_CUSTOMERS
		@DROP_DATA_CUSTOMERS_WITH_NAME VARCHAR(30),
		@COUNT_DELETE VARCHAR(30) OUTPUT
AS
BEGIN
    DECLARE @CREDIT_LIMIT INT 
    DECLARE @CUST_NUM INT
    SET @CREDIT_LIMIT = (SELECT COUNT(*) FROM CUSTOMERS WHERE COMPANY = @DROP_DATA_CUSTOMERS_WITH_NAME)
    IF @CREDIT_LIMIT=0 
    RETURN

	SET @COUNT_DELETE = (SELECT C.COMPANY 
						 FROM CUSTOMERS C LEFT JOIN ORDERS O
						 ON C.CUST_NUM = O.CUST
						 WHERE C.COMPANY = @DROP_DATA_CUSTOMERS_WITH_NAME)
    
	SET @CUST_NUM = (SELECT O.CUST 
					 FROM CUSTOMERS C LEFT JOIN ORDERS O
					 ON C.CUST_NUM = O.CUST
					 WHERE C.COMPANY = @DROP_DATA_CUSTOMERS_WITH_NAME)
    DELETE FROM CUSTOMERS WHERE COMPANY = @DROP_DATA_CUSTOMERS_WITH_NAME
	SELECT * FROM CUSTOMERS
END
GO

DECLARE @RESULT INT = 0
DECLARE @COMPANY VARCHAR(25) = 'HP'
DECLARE @COUNT_DELETE VARCHAR(30)= @COMPANY

EXEC DROP_DATA_CUSTOMERS @COMPANY, @COUNT_DELETE
PRINT 'DELETE CUSTOMERS IS: ' + @COUNT_DELETE

DELETE FROM CUSTOMERS WHERE CUST_NUM = 2117

SELECT * FROM CUSTOMERS
SELECT *FROM ORDERS
--------------------------------
CREATE PROCEDURE DELETE_CUST 
		@CUST_NUM INT 
AS
DECLARE @COUNT_OF_ORDERS INT
BEGIN
	SET @COUNT_OF_ORDERS = (SELECT COUNT(ORDER_NUM)
	FROM ORDERS
	WHERE CUST = @CUST_NUM)
	IF @COUNT_OF_ORDERS = 0
	DELETE FROM CUSTOMERS WHERE CUST_NUM = @CUST_NUM
	ELSE PRINT'???? ???????? ????? ??????, ??????? ?? ????? ???? ?????? '
END

DECLARE @CN INT = 1111
EXEC DELETE_CUST @CN

DROP PROCEDURE DROP_DATA_CUSTOMERS
--2.	??????? ????????????? ????????? ? ?????????? ??????????? ??? ????????????.

--3.	??????????? ???????????????? ???????: 
--3.1.	?????????? ?????????? ??????? ?????????? ? ???????????? ??????. 
--???? ?????? ?????????? ??? ? ??????? -1. 
--???? ????????? ????, ? ??????? ??? ? ??????? 0.
SELECT * FROM SALESREPS
SELECT *FROM ORDERS
--INSERT INTO CUSTOMERS VALUES (1111, 'HP', 106, 10000.00)
INSERT INTO SALESREPS VALUES (111, 'ALEX R', 43, 12, 'Sales Rep', '2005-10-12', 104, 50000, 50678)
DELETE FROM SALESREPS WHERE EMPL_NUM = 111

GO

CREATE FUNCTION COUNT_ORDERS_OF_SALESREP 
				(@REP INT, 
				 @START_DATE DATE,
				 @END_DATE DATE) 
RETURNS INT
BEGIN
	DECLARE @COUNT_OF_ORDERS INT;
	DECLARE @SALESREP INT = 0;
	SET @SALESREP = (SELECT COUNT(EMPL_NUM)
					 FROM SALESREPS
					 WHERE EMPL_NUM = @REP);
	IF @SALESREP = 0
	SET @COUNT_OF_ORDERS = -1
	ELSE
		SET @COUNT_OF_ORDERS = (SELECT COUNT(ORDER_NUM) 
								FROM ORDERS
								WHERE REP = @REP AND ORDER_DATE BETWEEN @START_DATE AND @END_DATE);
	RETURN @COUNT_OF_ORDERS
END
GO

SELECT * FROM ORDERS
--------------CALL FUNCTION-----------------------
DROP FUNCTION COUNT_ORDERS_OF_SALESREP

DECLARE @REP INT = DBO.COUNT_ORDERS_OF_SALESREP(106, '2007-02-02', '2008-02-15')
PRINT 'RESULT OF ORDERS IN THE DATA RANGE: ' + CAST(@REP AS VARCHAR(10))

--------------PROCEDURE FOR THIS TASK-------------------------------
/*ALTER PROCEDURE COUNT_ORDERS_OF_SALESREPS_1 
	@REP INT, 
	@ORDER_DATE_BEFORE DATE,
	@ORDER_DATE_AFTER DATE,
	@COUNT INT OUTPUT
AS
DECLARE @DEFINITE_ORDER_DATE INT = 0;
BEGIN
	SELECT COUNT(ORDER_NUM) AS ORDERS_QTY
	FROM ORDERS 
	WHERE REP = @REP AND ORDER_DATE BETWEEN @ORDER_DATE_BEFORE AND @ORDER_DATE_AFTER
	SET @COUNT = (SELECT COUNT(*) FROM ORDERS WHERE REP = @REP AND ORDER_DATE BETWEEN @ORDER_DATE_BEFORE AND @ORDER_DATE_AFTER)
	IF @DEFINITE_ORDER_DATE = 0
	--PRINT '-1'
	RETURN -1
	RETURN @DEFINITE_ORDER_DATE
END
----CALL PROCEDURE------
DECLARE @RESULT INT = 15
DECLARE @QTY_IN_THE_DATA_RANGE INT = 0
DECLARE @REP INT = 108
DECLARE @ORDER_DATE_BEFORE DATE = '2008-02-02'
DECLARE @ORDER_DATE_AFTER DATE = '2008-02-15'
EXEC @RESULT = COUNT_ORDERS_OF_SALESREPS_1 @REP, @ORDER_DATE_BEFORE, @ORDER_DATE_AFTER, @QTY_IN_THE_DATA_RANGE OUTPUT
--PRINT 'RESULT:  ' + CAST(@RESULT AS VARCHAR(30))
PRINT 'QTY OF ORDERS IN THE DATA RANGE: ' + CAST(@QTY_IN_THE_DATA_RANGE AS VARCHAR(10))*/

	--IF (SELECT REP 
		--FROM ORDERS 
		--WHERE REP != @REP) IS NULL*/
	--RETURN @NO_SALESREPS
	/*ELSE IF (SELECT REP
			 FROM ORDERS
			 WHERE REP = @REP) IS NULL*/
	--RETURN @DEFINITE_ORDER_DATE
	--DECLARE @DEFINITE_ORDER_DATE INT
	--SET @DEFINITE_ORDER_DATE = (SELECT COUNT(ORDER_NUM)
		--					FROM ORDERS 
			--				WHERE REP = @REP AND ORDER_DATE BETWEEN @ORDER_DATE_BEFORE AND @ORDER_DATE_AFTER)			
--END
---------------------------------------------------------------------------------------------------------------------

--3.2.	?????????? ?????????? ??????? ????????? ?????????????? ????? ???? ?????????. 
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
DECLARE @QTY INT = DBO.QTY_PRODUCTS_DIFFERENT_COMPANY(2750)
PRINT 'RESULT QTY OF PRODUCTS WHERE PRICE MORE THAN SET: ' + CAST(@QTY AS VARCHAR(10))

-----SHOW_2-----
SELECT MFR_ID, PRICE, DBO.QTY_PRODUCTS_DIFFERENT_COMPANY(2500) AS COUNT_PRICE
    FROM PRODUCTS
    WHERE PRICE > dbo.QTY_PRODUCTS_DIFFERENT_COMPANY(2500);
-----------------------------
	SELECT * FROM PRODUCTS

DROP FUNCTION QTY_PRODUCTS_DIFFERENT_COMPANY

--3.3.	?????????? ?????????? ?????????? ??????? ??? ????????????? ?????????????.
SELECT * FROM ORDERS
WHERE MFR = 'REI'

GO
CREATE FUNCTION ORDERS_QTY () 
				RETURNS INT
BEGIN 
	DECLARE @QTYORD INT = --(SELECT COUNT(ORDER_NUM) FROM ORDERS WHERE MFR = 'REI')
	(SELECT SUM(QTY) FROM ORDERS WHERE MFR = 'REI')
	RETURN @QTYORD;
END
GO
-----
DECLARE @SHOW_ORDER INT = DBO.ORDERS_QTY();
PRINT 'SHOW ORDER FOR A CERTAIN MANUFACTURER = ' + CAST(@SHOW_ORDER AS VARCHAR(10));
GO
-----

DROP FUNCTION ORDERS_QTY

--4.	??????? ????????????? ??????? ?????????? ????????? ? ?????????? ??????????? ??? ????????????.
