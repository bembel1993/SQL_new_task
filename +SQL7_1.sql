--1.����������� ������, ��������������� ������ � ������ ������� ����������.
--������� ���������� - ������ ����� ��������� ���������� INSERT, UPDATE ��� DELETE ��� ������� ����������.
BEGIN TRY 
	BEGIN TRANSACTION
		INSERT INTO CUSTOMERS VALUES(2100, 'Apple', 106, 70000.00);
		--insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
    COMMIT TRANSACTION
    PRINT 'TRANSACT EXECUTE'
END TRY
BEGIN CATCH
    ROLLBACK
        PRINT 'TRANSACT CANCELED';
    THROW
END CATCH

SELECT * FROM CUSTOMERS
----------------------------------------------------
BEGIN TRANSACTION
    UPDATE SALESREPS --INSTRUCTION UPDATE
        SET NAME = 'GEORG SMITH'
        WHERE EMPL_NUM = 101
    IF (@@ERROR <> 0) --@@error-���������� ����������
        ROLLBACK
    UPDATE ORDERS
        SET ORDER_DATE = '2010'
        WHERE MFR = 'ACI'
	IF (@@ERROR <> 0)
        ROLLBACK
	DELETE FROM ORDERS --INSTRUCTION DELETE
		WHERE AMOUNT = 600
	IF (@@ERROR <>0)
		ROLLBACK
COMMIT TRANSACTION

SELECT * FROM ORDERS
SELECT * FROM SALESREPS

--2.����������� ������, ��������������� �������� ACID ����� ����������. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
--ACID (Atomicity - �����������, consistency - ���������������, isolation - ���������������, durability - ���������) 
--��� ����������� ����� �������, ������� �����������, ���������� ����������.
SELECT * FROM CUSTOMERS

BEGIN TRAN
	DELETE FROM CUSTOMERS 
	WHERE CUST_NUM = 2101
ROLLBACK TRAN
BEGIN TRAN
	INSERT INTO CUSTOMERS VALUES (2133, 'ASUS', 107, 72000.00);
COMMIT TRAN
----------------------------------------------------------------
BEGIN TRANSACTION    
BEGIN TRY  
    -- Generate a constraint violation error.  
    DELETE FROM OFFICES  
    WHERE OFFICE = 12  
END TRY  
BEGIN CATCH  
	SELECT   
        ERROR_NUMBER() AS ErrorNumber,		--���������� ����� ������
        ERROR_SEVERITY() AS ErrorSeverity,  --���������� �������� ����������� ������
        ERROR_STATE() AS ErrorState,		--���������� ����� ��������� ��� ������
        ERROR_PROCEDURE() AS ErrorProcedure,--���������� ��� �������� ��������� ��� ��������  
        ERROR_LINE() AS ErrorLine,			--���������� ����� ������, � ������� ��������� ������,
        ERROR_MESSAGE() AS ErrorMessage		--���������� ����� ��������� �� ������
    IF @@TRANCOUNT > 0						--���������� ���������� ���������� BEGIN TRANSACTION, ������� ��������� � ������� ����������.
        ROLLBACK TRANSACTION;  
END CATCH  
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
SELECT * FROM OFFICES
SELECT * FROM SALESREPS

--3.����������� ������, ��������������� ���������� ��������� SAVETRAN. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
SELECT * FROM CUSTOMERS

BEGIN TRY
BEGIN TRAN FIRST_ONE
	INSERT INTO CUSTOMERS
		VALUES (3333, 'NOKIA', 107, 100000.00)
		SAVE TRAN FIRSTCUST --������������� ����� ���������� ������ ����������.
	UPDATE CUSTOMERS
		SET COMPANY = 'APPLE'
		WHERE CUST_NUM = 3333
		ROLLBACK TRAN FIRSTCUST
COMMIT TRAN FIRST_ONE
END TRY
BEGIN CATCH
	SELECT 'ERROR'
END CATCH

--4.����������� ��� ������� A � B. ������������������ ����������������, ��������������� � 
--��������� ������. �������� �������� ������� ���������������. -������� �������� ������ ������������ ������ � ����������
-- ��������������� ������ - ��� ����� ���� ������� ��������� ������ ��������� ���, � ������ ������� 
							--�������� ��� ������ ����� ����� ���������� ������ ������� ��������. �������� ���� ������ ����� ������.
--��������� ������ - ���������������� �������� ������ ����� ���������� ������ ��������
					--���������� ������� ����� ����� ��� ������ ������
					--��������� �������������� ��������� ������, ������� ����������� ������� ������������
					--�������� ���� ������ ����� �������
--���������������� ������ - ������� ������ -������ ���������������� ������
--READ UNCOMMITED �� ��������� �������� ������ ������ ����������
--���������� �� ������ � �� �������� ����������
--��������� ��������:
--------------------------------------------------------------------
--������� ������ - ������ ������, ����������� ��� ���������� �����������, ������� ������������ �� ������������ (���������).
--1--A-TRAN_2
BEGIN TRAN
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
--2--B-TRAN_1
BEGIN TRAN
UPDATE PRODUCTS
SET PRICE = PRICE + 5
WHERE PRODUCT_ID = '41001'
--3--A-TRAN_2
BEGIN TRAN
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
--4--B-TRAN_1
ROLLBACK
-------------
BEGIN TRAN
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
---------------------------------------------------------------------
--������������� ������ - ��� ��������� ������ � ������ ����� ���������� ����� ����������� ������ ����������� �����������.
--1--B-TRAN_1
BEGIN TRAN B1
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
--2--A-TRAN_2
BEGIN TRAN A2
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
--3--B-TRAN_1
--BEGIN TRAN
UPDATE PRODUCTS
SET PRICE = PRICE + 5
WHERE PRODUCT_ID = '41001'
COMMIT
--4--A-TRAN_2
BEGIN TRAN A2
SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID = '41001'
----------------
ROLLBACK

----------------------------------------------------------------------
--��������� ������ - ��� ��������� ������ � ������ ����� ���������� ���� � �� �� ������� ���� ������ ��������� �����.
--1--B-TRAN_1
BEGIN TRAN
SELECT COUNT(CUST_NUM)
FROM CUSTOMERS
--2--A-TRAN_2
BEGIN TRAN
INSERT INTO CUSTOMERS VALUES(1001, 'HUAWEI', 110, 10000)
COMMIT
--3--B-TRAN_1
BEGIN TRAN
SELECT COUNT(CUST_NUM)
FROM CUSTOMERS

SELECT COUNT(CUST_NUM)
FROM CUSTOMERS

ROLLBACK
----------------------------------------------------------------------
SELECT * FROM CUSTOMERS
SELECT * FROM OFFICES
SELECT * FROM PRODUCTS
--������ ����������������� READ-UNCOMMITTED | 0: ���� �������� � ������� �������, ��������������� ������� � ��������� �������
--INSERT INTO CUSTOMERS VALUES (1111, 'CORPORATION', 110, 72000.00);

--������ ���������� READ-COMMITTED | 1: ������ �������� ������� ������, ���� ��������������� ������, ��������� ������

--����������� ������ REPEATABLE-READ | 2: ������ �������� �������� ������, �������������� ������, ���������� ������, 
--������ �������� �� ���������, ������������ �������� MMVC ��� ���������� ���������� ������

--������������ SERIALIZABLE | 3: ������ ������� ������, ��������������� ������, ��������� ������, ����� ���������� 
--������������ ����������, �� ��������� ���������������� ����������, ����� ������ ������������������
--1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- QTY ROWS

--SELECT * FROM CUSTOMERS
--2
BEGIN TRAN  -- ��������� ������������ ���������� - ��� ������������ ���������� �������� ���� �� �����
DELETE FROM CUSTOMERS WHERE CUST_NUM = 3333 -- ������� ������ �� �������
--3
SELECT COUNT(*) FROM CUSTOMERS -- ���������: , ���������������� ������
SELECT * FROM CUSTOMERS
--4
ROLLBACK TRAN -- ���������� ����������
--5
SELECT COUNT(*) FROM CUSTOMERS -- ���������: , ����� ������ ���������� �
COMMIT TRAN
----- �������, ��� ������� ��������������� READ COMMITTED �� ��������� ���������������� ������
--RED COMMITED 
--���������� ��������� �������� ������ �� ������� ����������� ���������� ��� ������ ������
--�������� ������� �������� �� ���������
--��������:
--������������� ������
--��������� ������ 
-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- ��������� ����������, ���������: 
 
--  8
SELECT COUNT(*) FROM CUSTOMERS -- ���������: ��������, ����������������� ������ ���
 
-- 10
SELECT COUNT(*) FROM CUSTOMERS -- ����� ����� ������ ���������� 
--COMMIT TRAN
--- 7
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM CUSTOMERS WHERE CUST_NUM=1111 -- ������� ������ �� �������

--- 9
ROLLBACK TRAN -- ���������� ����������
-------------------------------------------------------
--��������������� ������
--��� ����� ���� ������� ��������� ������ ��������� ���, � ������ ������� 
--�������� ��� ������ ����� ����� ���������� ������ ������� ��������. �������� ���� ������ ����� ������.
--11
SELECT * FROM OFFICES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES
-- 12
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE CITY = 'MOSCOW' -- ������� ������ �� �������
COMMIT TRAN

-- 13
SELECT COUNT(*) FROM OFFICES -- ���������: 
-- ���� ������ ���������� ������� ������, ������ ������ ����������� ��-�������.
COMMIT TRAN
----- �������, ��� ������� ��������������� REPEATABLE READ �� ��������� ��������������� ������
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- ������ ������
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������: 17
--- 15
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE = 26 -- ������� ������ �� �������, ��������� - ��������
-- 16
COMMIT TRAN -- ����� ����� �������� ���������� � � ���� � 
--- ����� ����������:1 - ������ ���������� ��������� ��������
--- 17
COMMIT TRAN -- ��������� ����������
-----------------------------
SELECT * FROM CUSTOMERS


/*SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM OFFICES -- A: 
 
SELECT * FROM OFFICES -- B: 
COMMIT TRAN*/

--5.	����������� ������, ��������������� �������� ��������� ����������. 
GO
/* SELECT statement built using a subquery. */
BEGIN TRAN
	SELECT 
		NAME, 
		AGE
	FROM SALESREPS
	WHERE AGE <
		(SELECT AGE 
		FROM SALESREPS
		WHERE AGE = 33)
COMMIT TRAN
GO

SELECT * FROM SALESREPS
--------------------------------------------------
SELECT * FROM PRODUCTS

BEGIN TRAN T1
	INSERT PRODUCTS
	VALUES ('SSS', '12XX3', 'RECIVER', 1000, 5)
	SAVE TRAN SSS
			BEGIN TRAN T2
				INSERT PRODUCTS
				VALUES ('SSX', '12Y3Y', 'AMPLIFIER', 4000, 2)
				COMMIT TRAN T2
ROLLBACK TRAN SSS
COMMIT TRAN T1