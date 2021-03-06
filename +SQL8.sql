--!!!Data base bembel_lab6_1!!!
--1.	??????????? ????????? DML ???????? ? ?????????????????? 
--????????????????? ?????????: 
--1.1.	??? ?????????? ?????? ????? ????????? ?????? ? ??????? ????? ? ???????
--Audit.
CREATE TABLE AUDIT(
	OFFICE_AT INT,
	CITY_AT VARCHAR(20),
	REGION_AT VARCHAR(20),
	MGR_AT INT,
	TARGET_AT DECIMAL(9, 2),
	SALES DECIMAL(9, 2))

CREATE TRIGGER trigger_ADD_OFFICE
    ON OFFICES AFTER INSERT
    AS
BEGIN
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
	DECLARE @REGION_AT VARCHAR(20)
	DECLARE @MGR_AT INT
	DECLARE @TARGET_AT DECIMAL(9, 2)
	DECLARE @SALES DECIMAL(9, 2)

    SELECT @OFFICE_AT = (SELECT OFFICE FROM INSERTED)
	SELECT @CITY_AT = (SELECT CITY FROM INSERTED)
    SELECT @REGION_AT = (SELECT REGION FROM INSERTED)
    SELECT @MGR_AT = (SELECT MGR FROM INSERTED)
	SELECT @TARGET_AT = (SELECT TARGET FROM INSERTED)
    SELECT @SALES = (SELECT SALES FROM INSERTED)
INSERT INTO AUDIT VALUES(@OFFICE_AT, @CITY_AT, @REGION_AT, @MGR_AT, @TARGET_AT, @SALES)
END

INSERT INTO OFFICES VALUES(88,'GERMANY','EAST',NULL,500000.00,986042.00);
INSERT INTO OFFICES VALUES(46,'NEW JERSAY','Eastern',NULL,875000.00,992637.00);
DELETE FROM OFFICES WHERE OFFICE = 46

DROP TRIGGER trigger_ADD_OFFICE
SELECT * FROM AUDIT

SELECT * FROM OFFICES 

DROP TABLE AUDIT
DROP TABLE CUSTOMERS

--1.2.	??? ?????????? ?????? ????? ????????? ?????? ? ??????????? ??????? ????? ? ??????? Audit.
CREATE TRIGGER trigger_NEW_OFFICE
    ON OFFICES AFTER UPDATE
    AS
BEGIN
    DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
	DECLARE @REGION_AT VARCHAR(20)
	DECLARE @MGR_AT INT
	DECLARE @TARGET_AT DECIMAL(9, 2)
	DECLARE @SALES DECIMAL(9, 2)

    SELECT @OFFICE_AT = (SELECT OFFICE FROM DELETED)
	SELECT @CITY_AT = (SELECT CITY FROM DELETED)
    SELECT @REGION_AT = (SELECT REGION FROM DELETED)
    SELECT @MGR_AT = (SELECT MGR FROM DELETED)
	SELECT @TARGET_AT = (SELECT TARGET FROM DELETED)
    SELECT @SALES = (SELECT SALES FROM DELETED)
INSERT INTO AUDIT VALUES(@OFFICE_AT, @CITY_AT, @REGION_AT, @MGR_AT, @TARGET_AT, @SALES)
PRINT 'UPDATE'
END

UPDATE OFFICES
    SET CITY = 'NY'
    WHERE OFFICE = 13

SELECT * FROM AUDIT
SELECT * FROM OFFICES

DROP TRIGGER trigger_NEW_OFFICE
DELETE FROM AUDIT WHERE OFFICE_AT = 11

--1.3.	??? ???????? ?????? c ????? ????????? ?????? ? ??????? ????? ? ??????? Audit. 
CREATE TRIGGER trigger_DELETE_OFFICE
    ON OFFICES AFTER DELETE
    AS
BEGIN
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
	DECLARE @REGION_AT VARCHAR(20)
	DECLARE @MGR_AT INT
	DECLARE @TARGET_AT DECIMAL(9, 2)
	DECLARE @SALES DECIMAL(9, 2)

    SELECT @OFFICE_AT = (SELECT OFFICE FROM DELETED)
	SELECT @CITY_AT = (SELECT CITY FROM DELETED)
    SELECT @REGION_AT = (SELECT REGION FROM DELETED)
    SELECT @MGR_AT = (SELECT MGR FROM DELETED)
	SELECT @TARGET_AT = (SELECT TARGET FROM DELETED)
    SELECT @SALES = (SELECT SALES FROM DELETED)

INSERT INTO AUDIT VALUES(@OFFICE_AT, @CITY_AT, @REGION_AT, @MGR_AT, @TARGET_AT, @SALES)
PRINT 'DELETE'   
END

DELETE OFFICES WHERE OFFICE = 88

SELECT * FROM AUDIT
SELECT * FROM OFFICES

DROP TRIGGER trigger_DELETE_OFFICE

CREATE TABLE AUDIT(
	OFFICE_AT INT,
	CITY_AT VARCHAR(20),
	REGION_AT VARCHAR(20),
	MGR_AT INT,
	TARGET_AT DECIMAL(9, 2),
	SALES DECIMAL(9, 2))

DROP TABLE AUDIT

--2.	??????????? ??????, ??????? ?????????????, ??? ???????? ??????????? ??????????? ??????????? 
--?? ???????????? AFTER-????????.
CREATE TABLE STORAGE (
	ID INT PRIMARY KEY,
	STRING VARCHAR(10)
)

CREATE TABLE #TEMPORARY_STORAGE (
	ID INT,
	STRING VARCHAR(16)
)

CREATE TRIGGER TRIGGER_S
ON STORAGE
AFTER INSERT
AS
BEGIN
	DECLARE @ID INT, 
			@STRING VARCHAR(10);
	SELECT @ID = (SELECT ID FROM INSERTED);
	SELECT @STRING = (SELECT STRING FROM INSERTED);
	INSERT INTO #TEMPORARY_STORAGE VALUES (@ID, @STRING)
END

INSERT INTO STORAGE VALUES(10, 'SAVE');
INSERT INTO #TEMPORARY_STORAGE VALUES(10, 'SAVE');

SELECT * FROM STORAGE
SELECT * FROM #TEMPORARY_STORAGE

DROP TRIGGER TRIGGER_S
DROP TABLE STORAGE
DROP TABLE #TEMPORARY_STORAGE
/*CREATE TRIGGER after_insert
	ON OFFICES  AFTER INSERT 
AS
BEGIN
IF (SELECT OFFICE FROM INSERTED) > 55
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
	DECLARE @REGION_AT VARCHAR(20)
	DECLARE @MGR_AT INT
	DECLARE @TARGET_AT DECIMAL(9, 2)
	DECLARE @SALES DECIMAL(9, 2)
DELETE FROM AUDIT  WHERE OFFICE_AT = 55;
INSERT INTO AUDIT VALUES(@OFFICE_AT, @CITY_AT, @REGION_AT, @MGR_AT, @TARGET_AT, @SALES)
   
END
SELECT * FROM AUDIT
SELECT * FROM OFFICES
DROP TRIGGER after_insert*/

--3.	 ??????? 3 ????????, ????????????? ?? ??????? ???????? ? ??????? ? ??????????? ??.
CREATE TABLE STORAGE_AD (
	ID_OFFICE INT PRIMARY KEY,
	CITY VARCHAR(10)
)

CREATE TABLE AUDIT2(
	OFFICE_AT INT NOT NULL,
	CITY_AT VARCHAR(20) NOT NULL,
	OPERATION TEXT NOT NULL);
-------------------------------------ONE----------------------------------------------------
CREATE TRIGGER TRIGGER_DELETE_ONE 
	ON STORAGE_AD AFTER DELETE
AS
BEGIN
PRINT 'TRIGGER_DELETE_ONE'
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
--IF @@ROWCOUNT = 1 --??? ??????? ?????????? ?????????? ?????, ???????????? ????????? ????????.
	SELECT @OFFICE_AT = (SELECT ID_OFFICE FROM DELETED)
	SELECT @CITY_AT = (SELECT CITY FROM DELETED)
INSERT INTO AUDIT2 VALUES(@OFFICE_AT, @CITY_AT, 'DELETE_1')
--RETURN
END;
-------------------------------------TWO----------------------------------------------------
CREATE TRIGGER TRIGGER_DELETE_TWO 
	ON STORAGE_AD AFTER DELETE
AS
BEGIN 
PRINT'TRIGGER_DELETE_TWO'
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
--IF @@ROWCOUNT = 1 --??? ??????? ?????????? ?????????? ?????, ???????????? ????????? ????????.
	SELECT @OFFICE_AT = (SELECT ID_OFFICE FROM DELETED)
	SELECT @CITY_AT = (SELECT CITY FROM DELETED)
INSERT INTO AUDIT2 VALUES(@OFFICE_AT, @CITY_AT, 'DELETE_2')
--RETURN
END;
-------------------------------------THREE----------------------------------------------------
CREATE TRIGGER TRIGGER_DELETE_THREE 
	ON STORAGE_AD AFTER DELETE
AS	
BEGIN 
PRINT'TRIGGER_DELETE_THREE'
	DECLARE @OFFICE_AT INT
	DECLARE @CITY_AT VARCHAR(20)
--IF @@ROWCOUNT = 1 --??? ??????? ?????????? ?????????? ?????, ???????????? ????????? ????????.
	SELECT @OFFICE_AT = (SELECT ID_OFFICE FROM DELETED)
	SELECT @CITY_AT = (SELECT CITY FROM DELETED)
INSERT INTO AUDIT2 VALUES(@OFFICE_AT, @CITY_AT, 'DELETE_3')
--RETURN
END;
----------------------------------------------------------------------------------------------
/*GO
CREATE PROCEDURE SAVE_PROCEDURE
		@triggername VARCHAR(30),
		@order VARCHAR(30),
		@stmttype VARCHAR(30)
AS
DECLARE @COUNT INT = 0*/

EXEC sp_settriggerorder @triggername = 'TRIGGER_DELETE_TWO', 
						@order  = 'NONE', 
						@stmttype = 'DELETE'
EXEC sp_settriggerorder @triggername = 'TRIGGER_DELETE_THREE', 
						@order = 'LAST', 
						@stmttype = 'DELETE'
EXEC sp_settriggerorder @triggername = 'TRIGGER_DELETE_ONE', 
						@order = 'FIRST', 
						@stmttype = 'DELETE'

-----------------------------------------------------------------------------------------------
DELETE STORAGE_AD WHERE CITY = 'NEW JERSAY'
DELETE STORAGE_AD WHERE CITY = 'MAYAMI'
DELETE STORAGE_AD WHERE CITY = 'ALABAMA'
--DELETE OFFICES WHERE CITY = 'AUSTRALIA'

INSERT INTO STORAGE_AD VALUES(909,'ALABAMA');
--INSERT INTO OFFICES VALUES(222,'AUSTRALIA','SOUTH_COAST',108, 20000.0, 74000.00);
INSERT INTO STORAGE_AD VALUES(999,'MAYAMI');

SELECT * FROM AUDIT2
SELECT * FROM STORAGE_AD

DROP TABLE STORAGE_AD
DROP TRIGGER TRIGGER_DELETE_ONE
DROP TRIGGER TRIGGER_DELETE_TWO
DROP TRIGGER TRIGGER_DELETE_THREE
DROP PROCEDURE sp_settriggerorder
--4.	??????????? ??????, ???????????????, ??? AFTER-??????? ???????? ?????? ??????????, 
--? ?????? ???????? ??????????? ????????, ???????????????? ???????.
------------SCRIPT 1--------------------------------
INSERT INTO CUSTOMERS VALUES (1992, 'ZERO',101, 95000.0)
--INSERT INTO CUSTOMERS VALUES (1911, 'SSRR',106, 10000.0)
INSERT INTO CUSTOMERS VALUES (1913, 'ONE CORP.',106, 5000.0)

CREATE TRIGGER TR_TRAN
ON CUSTOMERS AFTER INSERT
    AS
BEGIN
BEGIN TRAN
	DECLARE @CUST_NUM INT,
			@COMPANY VARCHAR(20),
			@CUST_REP INT,
			@CREDIT_LIMIT DECIMAL(9, 2)

    SELECT @CUST_NUM = (SELECT CUST_NUM FROM INSERTED)
	SELECT @COMPANY = (SELECT COMPANY FROM INSERTED)
    SELECT @CUST_REP = (SELECT CUST_REP FROM INSERTED)
    SELECT @CREDIT_LIMIT = (SELECT CREDIT_LIMIT FROM INSERTED)
	BEGIN TRY
		IF EXISTS(SELECT *
			FROM INSERTED 
			WHERE CREDIT_LIMIT < 30000.00)
		INSERT INTO AUDIT_CUST VALUES(@CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT)
			SELECT * FROM CUSTOMERS 
			SELECT * FROM AUDIT_CUST
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
	RETURN 
END

SELECT * FROM CUSTOMERS
SELECT * FROM AUDIT_CUST
DROP TRIGGER TR_TRAN
DELETE FROM AUDIT_CUST WHERE CUST_N = 108
DELETE FROM CUSTOMERS WHERE CUST_NUM = 108

CREATE TABLE AUDIT_CUST(
	CUST_N INT,
	CPY VARCHAR(20),
	CUST_R INT,
	CREDIT_LIMIT DECIMAL(9, 2))

------------SCRIPT 2--------------------------------
/*INSERT INTO OFFICES VALUES (108, 'Cyprus','OST', 104, 30000.0, 500000.00)
INSERT INTO OFFICES VALUES (106, 'LA','WEST', 104, 30000.0, 900000.00)

CREATE TRIGGER IF_TRIGGER
ON OFFICES AFTER INSERT
AS
IF @@ROWCOUNT=0
BEGIN
  IF NOT EXISTS(SELECT *
      FROM INSERTED 
      WHERE TARGET > 725000.00)
    BEGIN
     ROLLBACK TRAN
	  SELECT * FROM OFFICES 
    END
	INSERT INTO AUDIT VALUES (77, 'RUS','WEST_COAST', 104, 30000.0, 71000.00)	--???????????? 
	INSERT INTO AUDIT VALUES (709, 'ASIAN','EAST_KING', 104, 30000.0, 870000.00)	--?? ???????????? ? ??????? ?????
	  RETURN
END

DROP TABLE AUDIT
DROP TRIGGER IF_TRIGGER
SELECT * FROM AUDIT

CREATE TABLE AUDIT(
	OFFICE_AT INT,
	CITY_AT VARCHAR(20),
	REGION_AT VARCHAR(20),
	MGR_AT INT,
	TARGET_AT DECIMAL(9, 2),
	SALES DECIMAL(9, 2));*/

--5. ??????? ??????? ?? ?????????? ??? ?????????????. ?????????????????? ????????????????? ????????.
--INSTEAD OF. ??????? ?????????? ?????? ?????????? ??????. ? ??????? ?? AFTER -???????? 
--INSTEAD OF -??????? ????? ???? ????????? ??? ??? ???????, ??? ? ??? ?????????????. 
--??? ?????? ???????? INSERT, UPDATE, DELETE ????? ?????????? ?????? ???? INSTEAD OF -???????.
----------------------------------------
DROP TABLE OFFICES_FOR_VIEW

CREATE TABLE OFFICES_FOR_VIEW(
	OFFICE INT,
	CITY VARCHAR(20),
	SALES INT)

INSERT INTO OFFICES_FOR_VIEW VALUES (11, 'HAMBURG', 95000)
INSERT INTO OFFICES_FOR_VIEW VALUES (12, 'LA', 10000)
INSERT INTO OFFICES_FOR_VIEW VALUES (14, 'TOKYO', 5000)
INSERT INTO OFFICES_FOR_VIEW VALUES (11, 'NY', 95000)
INSERT INTO OFFICES_FOR_VIEW VALUES (12, 'BOSTON', 10000)
INSERT INTO OFFICES_FOR_VIEW VALUES (14, 'HONG KONG', 5000)
------------------------------
GO
CREATE VIEW RELEASED_OFFICES AS
SELECT * 
FROM OFFICES_FOR_VIEW
GO

SELECT * FROM RELEASED_OFFICES

UPDATE RELEASED_OFFICES
    SET CITY = 'RELEASED'
    WHERE SALES < 9000

DROP VIEW RELEASED_OFFICES

--------------------
CREATE TRIGGER UPD_TRIGG
	ON RELEASED_OFFICES INSTEAD OF UPDATE
	AS
BEGIN
UPDATE OFFICES_FOR_VIEW
    SET CITY = 'RELEASED'
    WHERE SALES < 9000
END
-------------------------------------------------------------------------------------------
UPDATE OFFICES_FOR_VIEW
    SET CITY = 'RELEASED'
    WHERE SALES = 5000

SELECT * FROM OFFICES_FOR_VIEW
DROP TRIGGER UPD_TRIGG
-------------------------------------------------------

--6.	??????? ??????? ?????? ???? ??????. ?????????????????? ????????????????? ????????.
-- ??????? SAFETY ?????? ??? ?????? ?? ????????? ??????? ??????? DROP_TABLE ? ???????? ?? ALTER_TABLE
CREATE TRIGGER SAFETY
	ON DATABASE 
	FOR DROP_TABLE, ALTER_TABLE
AS	
	PRINT 'YOU MUST DISABLE TRIGGER "SAFETY" TO DROP OR ALTER TABLES!'
	ROLLBACK;

DROP TRIGGER SAFETY ON ALL SERVER
--SYS.TRIGGER_EVENT_TYPES - ?????????? ?? ????? ?????? ?? ?????? ??????? ??? ?????? ???????, ?? ??????? ??????????? ???????.
SELECT * FROM SYS.TRIGGER_EVENT_TYPES 
WHERE parent_type = 10024 or type = 10024

ALTER TABLE dbo.OFFICES_FOR_VIEW ADD DOB DATETIME

--7.	??????? ??? ????????.
--SELECT Concat('DROP TRIGGER ', IF_TRIGGER ) FROM  DBO.OFFICES;
DROP TRIGGER trigger_ADD_OFFICE
DROP TRIGGER trigger_NEW_OFFICE
DROP TRIGGER trigger_DELETE_OFFICE
DROP TRIGGER TRIGGER_S
DROP TRIGGER TRIGGER_DELETE_ONE
DROP TRIGGER TRIGGER_DELETE_TWO
DROP TRIGGER TRIGGER_DELETE_THREE
DROP TRIGGER UPD_TRIGG