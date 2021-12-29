--2.	Âûïîëíèòå DML îïåðàöèè:
--2.1.	Ñîçäàéòå òàáëèöó Àóäèò (äàòà, îïåðàöèÿ, ïðîèçâîäèòåëü, êîä)  îíà áóäåò èñïîëüçîâàòüñÿ äëÿ êîíòðîëÿ çàïèñè â òàáëèöó PRODUCTS.
SELECT * FROM PRODUCTS
-----------------------------------------------
CREATE TABLE AUDIT (DATE_ID DATE, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE VARCHAR(8)) -- ÒÀÁËÈÖÀ ÀÓÄÈÒ

 SELECT * FROM AUDIT
--2.2.	Äîáàâüòå âî âðåìåííóþ òàáëèöó âñå òîâàðû.
CREATE TABLE #AUDIT6 (MFR_ID CHAR(3), PRODUCT_ID CHAR(5), DESCRIPTION VARCHAR(20), PRICE MONEY, QTY_ON_HAND INTEGER)

INSERT INTO #AUDIT6 (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE , QTY_ON_HAND) SELECT MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND
 FROM PRODUCTS

 SELECT * FROM #AUDIT6
---------------------------------------------------
INSERT INTO #AUDIT3
SELECT ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT
FROM Orders

SELECT * FROM #AUDIT3 WHERE CUST = 2102
SELECT * FROM ORDERS
SELECT * FROM PRODUCTS
SELECT * FROM CUSTOMERS
--2.3.	Äîáàâüòå â ýòó æå âðåìåííóþ òàáëèöó çàïèñü î òîâàðå, èñïîëüçóÿ îãðàíè÷åíèÿ NULL è DEFAULT.
--ALTER TABLE îáåñïå÷èâàåò âîçìîæíîñòü èçìåíÿòü ñòðóêòóðó ñóùåñòâóþùåé òàáëèöû. 
			--Íàïðèìåð, ìîæíî äîáàâëÿòü èëè óäàëÿòü ñòîëáöû, ñîçäàâàòü èëè óíè÷òîæàòü èíäåêñû èëè 
			--ïåðåèìåíîâûâàòü ñòîëáöû ëèáî ñàìó òàáëèöó.
ALTER TABLE #AUDIT6 ADD CONSTRAINT PRICE
DEFAULT 100 FOR PRICE; --DEFAULT - ÇÍÀ×ÅÍÈÅ ÏÎ ÓÌÎË×ÀÍÈÞ

INSERT INTO #AUDIT6 (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE , QTY_ON_HAND)
VALUES ('STR', '33TRX', '_xXx_', default, 3333);

SELECT * FROM #AUDIT6

--2.4.	Äîáàâüòå â ýòó æå âðåìåííóþ òàáëèöó çàïèñü î òîâàðå, è îäíîâðåìåííî äîáàâüòå ýòè æå äàííûå â òàáëèöó àóäèòà 
	--	(â ñòîëáöå îïåðàöèÿ óêàæèòå INSERT, â ñòîëáöå äàòû  òåêóùóþ äàòó).
INSERT INTO #AUDIT6 (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE , QTY_ON_HAND)
	OUTPUT inserted.PRODUCT_ID, inserted.MFR_ID INTO AUDIT(OPERATION, MANUFACTURER )
	VALUES ('WOW', 'TR', 'YYY', 10000, 1000);

	--DATE_ID DATE, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE VARCHAR(8)

--2.5.	Îáíîâèòå äàííûå î òîâàðàõ âî âðåìåííîé òàáëèöå  äîáàâüòå 20% ê öåíå.
UPDATE #AUDIT6 SET PRICE = ((PRICE/100)*20)+PRICE --(AMOUNT/100)*20
SELECT * FROM #AUDIT6
SELECT * FROM AUDIT
--2.6.	Îáíîâèòå äàííûå î òîâàðàõ, êîòîðûå çàêàçûâàëà First Corp. âî âðåìåííîé òàáëèöå  äîáàâüòå 10% ê öåíå.
UPDATE #AUDIT6 SET PRICE = ((PRICE/100)*10) + PRICE 
	WHERE PRODUCT_ID = (SELECT PRODUCT_ID 
					FROM CUSTOMERS C JOIN ORDERS O
					ON C.CUST_NUM = O.CUST 
					JOIN PRODUCTS P
					ON O.PRODUCT = P.PRODUCT_ID
					WHERE COMPANY = 'First Corp.')
--SELECT CUST, AMOUNT FROM #AUDIT3 WHERE CUST = 2102
		
SELECT * FROM #AUDIT6 WHERE PRODUCT_ID = '41004' -- PRICE ADD TO FIRST CORP.
SELECT * FROM ORDERS WHERE CUST = 2102
--2.7.	Îáíîâèòå äàííûå î òîâàðå âî âðåìåííîé òàáëèöå, è îäíîâðåìåííî äîáàâüòå ýòè æå äàííûå â òàáëèöó àóäèòà 
	--	(â ñòîëáöå îïåðàöèÿ óêàæèòå UPDATE, â ñòîëáöå äàòû  òåêóùóþ äàòó).

--2.8.	Óäàëèòå òîâàðû, êîòîðûå çàêàçûâàëà First Corp. âî âðåìåííîé òàáëèöå.
DELETE FROM #AUDIT6  
WHERE PRODUCT_ID = (SELECT PRODUCT_ID 
					FROM CUSTOMERS C JOIN ORDERS O
					ON C.CUST_NUM = O.CUST 
					JOIN PRODUCTS P
					ON O.PRODUCT = P.PRODUCT_ID
					WHERE COMPANY = 'First Corp.')

SELECT * FROM #AUDIT6 WHERE PRODUCT_ID = '41004'
--------------------------------------------------------------
DELETE #AUDIT3 WHERE CUST = 2102 -- 2102 ID FIRST CORP.
SELECT * FROM #AUDIT3 WHERE CUST = 2102

--2.9.	Óäàëèòå äàííûå î êàêîì-ëèáî òîâàðå âî âðåìåííîé òàáëèöå, è îäíîâðåìåííî äîáàâüòå ýòè äàííûå â òàáëèöó àóäèòà 
		--(â ñòîëáöå îïåðàöèÿ óêàæèòå DELETE, â ñòîëáöå äàòû  òåêóùóþ äàòó).
DELETE FROM #AUDIT6 
	OUTPUT GETDATE(), DELETED.PRODUCT_ID, DELETED.MFR_ID INTO AUDIT(DATE_ID, OPERATION, MANUFACTURER )
	WHERE MFR_ID = 'BIC';
SELECT * FROM AUDIT
	
----------------------------------------------------------------------------------------------------------------
DELETE #AUDIT3 WHERE ORDER_NUM = 112961 
    SET #AUDIT4
----------------------------------------------------------------------------------------------------------------
/*--2.1
CREATE TABLE #AUDIT2 (DATE_ID DATE, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE INT, PRODUCT INT DEFAULT NULL);
-----
--CREATE TABLE #AUDIT3 (ORDER_NUM INT, ORDER_DATE DATE, CUST INT, 
	--					REP INT, MFR VARCHAR(10), PRODUCT VARCHAR(20), QTY INT, AMOUNT DECIMAL (9, 2))
-----
SELECT * FROM #AUDIT3
--2.2
/*SELECT PRODUCT, 
        --SUM(ProductCount) AS TotalCount, 
        --SUM(ProductCount * Price) AS TotalSum
INTO #AUDIT2 
FROM Orders
--GROUP BY PRODUCT*/
 
/*INSERT INTO #AUDIT3
SELECT ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT
FROM Orders
--GROUP BY ORDER_NUM*/

INSERT INTO PRODUCTS (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND)
VALUES ('ACI', '41007', 'Test Product', default, null);

ALTER TABLE PRODUCTS ADD CONSTRAINT def_price 
		DEFAULT 100 FOR PRICE;*/

--3.	Ñîçäàéòå ïðåäñòàâëåíèÿ:
--3.1.	Ïîêóïàòåëåé, ó êîòîðûõ åñòü çàêàçû âûøå îïðåäåëåííîé ñóììû.
--Ïðåäñòàâëåíèå  âèðòóàëüíàÿ òàáëèöà, ïðåäñòàâëÿþùàÿ ñîáîé ïîèìåíîâàííûé çàïðîñ, 
				--êîòîðûé áóäåò ïîäñòàâëåí êàê ïîäçàïðîñ ïðè èñïîëüçîâàíèè ïðåäñòàâëåíèÿ. 
				--Â îòëè÷èå îò îáû÷íûõ òàáëèö ðåëÿöèîííûõ áàç äàííûõ, ïðåäñòàâëåíèå íå ÿâëÿåòñÿ 
				--ñàìîñòîÿòåëüíîé ÷àñòüþ íàáîðà äàííûõ, õðàíÿùåãîñÿ â áàçå. 
GO
CREATE VIEW HIGH_SALES AS
SELECT * 
FROM SALESREPS WHERE SALES>200000

SELECT * FROM HIGH_SALES

DROP VIEW HIGH_SALES
GO

--3.2.	Ñîòðóäíèêîâ, ó êîòîðûõ îôèñû íàõîäÿòñÿ â âîñòî÷íîì ðåãèîíå.
GO
CREATE VIEW EAST_OFFICES AS
SELECT 
	O.MGR,
	O.REGION
FROM SALESREPS S JOIN OFFICES O
ON S.MANAGER = O.MGR
WHERE REGION = 'EASTERN'

SELECT DISTINCT* FROM EAST_OFFICES

DROP VIEW EAST_OFFICES

SELECT * FROM OFFICES WHERE REGION = 'EASTERN'
SELECT * FROM SALESREPS

--3.3.	Çàêàçû, îôîðìëåííûå â 2008 ãîäó.
GO
CREATE VIEW ORDERS_2008 
AS
SELECT ORDER_NUM, 
		ORDER_DATE
FROM ORDERS
WHERE YEAR(ORDER_DATE) = 2008

SELECT * FROM ORDERS_2008

DROP VIEW ORDERS_2008

SELECT * FROM ORDERS

--3.4.	Ñîòðóäíèêè, êîòîðûå íå îôîðìèëè íè îäíîãî çàêàçà.
CREATE VIEW QUOTA_NULL
AS
SELECT 
	O.REP,
	S.QUOTA
FROM ORDERS O JOIN SALESREPS S
ON O.REP = S.MANAGER 
WHERE QUOTA IS NULL

SELECT DISTINCT * FROM QUOTA_NULL

DROP VIEW QUOTA_NULL

SELECT * FROM SALESREPS

--3.5.	Ñàìûé ïîïóëÿðíûé òîâàð.
CREATE VIEW TOP_PRODUCT
AS
SELECT 
	MAX (QTY) AS MAS_QTY
FROM ORDERS

SELECT * FROM TOP_PRODUCT

SELECT * FROM PRODUCTS
SELECT * FROM ORDERS

--4.	Ïðîäåìîíñòðèðóéòå ïðèìåíåíèå DML îïåðàöèé íàä ïðåäñòàâëåíèÿìè.
--ÏÐÅÄÑÒÀÂËÅÍÈß - ýòî ïðåäîïðåäåëåííûé çàïðîñ, õðàíÿùèéñÿ â áàçå äàííûõ, 
				--êîòîðûé âûãëÿäèò ïîäîáíî îáû÷íîé òàáëèöå è íå òðåáóåò äëÿ ñâîåãî õðàíåíèÿ äèñêîâîé ïàìÿòè. 
				--Äëÿ õðàíåíèÿ ïðåäñòàâëåíèÿ èñïîëüçóåòñÿ òîëüêî îïåðàòèâíàÿ ïàìÿòü. 
CREATE  VIEW DEMO_VIEW_CUST 
AS
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT 
FROM CUSTOMERS
WHERE COMPANY = 'First Corp.'

SELECT * FROM DEMO_VIEW_CUST

DROP VIEW DEMO_VIEW_CUST

--5.	Ïðîäåìîíñòðèðóéòå è îáúÿñíèòå ïðèìåíåíèå îïöèé CHECK OPTION è SCHEMABINDING.

CREATE  VIEW DEMO_VIEW3
AS
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT 
FROM CUSTOMERS
WHERE COMPANY = 'First Corp.'
WITH CHECK OPTION --WITH CHECK OPTION çàïðåùàåò èçìåíåíèå ñòðîê, êîòîðûõ íåò â ïîäçàïðîñå

INSERT INTO DEMO_VIEW3 VALUES (2102,'xXx', 101, 10000.00)

SELECT * FROM DEMO_VIEW3

DROP VIEW DEMO_VIEW3
------------------------------------------------------------------------
DROP VIEW Best_Sales;
GO

CREATE VIEW Best_Sales AS
SELECT  * FROM SALESREPS 
WHERE [SALES]>200000
WITH CHECK OPTION --WITH CHECK OPTION çàïðåùàåò èçìåíåíèå ñòðîê, êîòîðûõ íåò â ïîäçàïðîñå
GO

INSERT INTO Best_Sales (EMPL_NUM, NAME, HIRE_DATE, SALES)
	VALUES (133, 'John Bon Jovi', '2019-11-14', 10000); -- îøèáêà!

SELECT * FROM BEST_SALES

--6.	Ïðîäåìîíñòðèðóéòå ïðèìåð ïðèìåíåíèÿ îïåðàöèé íàä ìíîæåñòâàìè.
--7.	Ïðîäåìîíñòðèðóéòå ïðèìåíåíèå êîìàíäû TRUNCATE.
TRUNCATE TABLE AUDIT --TRUNCATE  îïåðàöèÿ ìãíîâåííîãî óäàëåíèÿ âñåõ ñòðîê â òàáëèöå
SELECT * FROM AUDIT

--8.	Íàïèøèòå ñêðèïò èç àíàëîãè÷íûõ çàïðîñîâ ê áàçå äàííûõ ïî âàðèàíòó. Â êà÷åñòâå êîììåíòàðèÿ óêàæèòå óñëîâèå çàïðîñà.
--9.	Ïðîäåìîíñòðèðóéòå îáà ñêðèïòà ïðåïîäàâàòåëþ.


--------ÏÏ.1.21------------------
--1.1.	Âûáðàòü âñå çàêàçû, âûïîëíåííûå îïðåäåëåííûì ïîêóïàòåëåì.
SELECT *
FROM ORDERS
WHERE CUST = (
	SELECT CUST_NUM 
	FROM CUSTOMERS
	WHERE COMPANY = 'Ace International'
)

SELECT *
FROM CUSTOMERS

--1.2.	Âûáðàòü âñåõ ïîêóïàòåëåé â ïîðÿäêå óìåíüøåíèÿ îáøåé ñòîèìîñòè çàêàçîâ.
SELECT 
	C.COMPANY, 
	GENERAL_AMOUNT_OF_ORDERS = (
		SELECT SUM(O.AMOUNT)
		FROM ORDERS O
		WHERE O.CUST = C.CUST_NUM
	)
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
ORDER BY GENERAL_AMOUNT_OF_ORDERS DESC

SELECT *
FROM ORDERS
--1.3.	Âûáðàòü âñå çàêàçû, êîòîðûå îôîðìëÿëèñü ìåíåäæåðàìè èç âîñòî÷íîãî ðåãèîíà.
SELECT 
	S.NAME,
	S.MANAGER,
	O.REGION
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.MANAGER = O.MGR
WHERE MANAGER IN (
	SELECT S.MANAGER
	FROM SALESREPS S LEFT JOIN OFFICES O
	ON S.MANAGER = O.MGR
	WHERE REGION LIKE 'EASTERN' 
)

SELECT *
FROM OFFICES
SELECT *
FROM SALESREPS

--1.4.	Íàéòè îïèñàíèÿ òîâàðîâ, ïðèîáðåòåííûå ïîêóïàòåëåì First Corp.
SELECT *
FROM PRODUCTS
WHERE PRODUCT_ID IN (
	SELECT PRODUCT
	FROM ORDERS 
	WHERE CUST = (
		SELECT CUST_NUM 
		FROM CUSTOMERS
		WHERE COMPANY = 'First Corp.'
	)
)
----------------------?
SELECT 
	O.CUST,
	C.COMPANY,
	O.PRODUCT AS ID_PRODUCT_FROM_ORDERS,
	P.PRODUCT_ID,
	P.MFR_ID,
	P.DESCRIPTION,
	P.PRICE,
	P.QTY_ON_HAND
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT 
JOIN CUSTOMERS C
ON O.CUST = C.CUST_NUM
WHERE P.PRODUCT_ID IN (
	SELECT 
		PRODUCT
	FROM ORDERS
	WHERE CUST = (
		SELECT CUST_NUM 
		FROM CUSTOMERS
		WHERE COMPANY = 'First Corp.'
	)
)
---------------------------------?
SELECT *
FROM PRODUCTS
SELECT *
FROM CUSTOMERS
SELECT *
FROM ORDERS

--1.5.	Âûáðàòü âñåõ ñîòðóäíèêîâ èç Âîñòî÷íîãî ðåãèîíà è îòñîðòèðîâàòü ïî ïàðàìåòðó Quota.
SELECT 
	S.MANAGER,
	O.REGION,
	S.QUOTA AS SORTING_QUOTA
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.MANAGER = O.MGR
WHERE S.MANAGER in (
	SELECT MGR
	FROM OFFICES
	WHERE REGION LIKE 'EASTERN'
)
ORDER BY QUOTA DESC

SELECT *
FROM SALESREPS
SELECT * 
FROM OFFICES

--1.6.	Âûáðàòü çàêàçû, ñóììà êîòîðûõ áîëüøå ñðåäíåãî çíà÷åíèÿ.
SELECT *
FROM ORDERS 
WHERE AMOUNT > (
	SELECT AVG(AMOUNT) AS AVG_AMOUNT
	FROM ORDERS 
)
ORDER BY AMOUNT DESC

--1.7.	Âûáðàòü ìåíåäæåðîâ, êîòîðûå îáñëóæèâàëè îäíèõ è òåõ æå ïîêóïàòåëåé.
SELECT 
	FIRST.REP,
	SECOND.REP,
	FIRST.CUST
FROM ORDERS FIRST, 
	ORDERS SECOND
WHERE FIRST.CUST = SECOND.CUST AND FIRST.REP > SECOND.REP

--1.8.	Âûáðàòü ïîêóïàòåëåé ñ îäèíàêîâûì êðåäèòíûì ëèìèòîì.
SELECT 
	FIRST.CREDIT_LIMIT,
	FIRST.CUST_NUM AS FIRST_CUST_NUM,
	SECOND.CUST_NUM AS SECOND_CUST_NUM,
	FIRST.COMPANY
FROM CUSTOMERS FIRST,
	CUSTOMERS SECOND
WHERE FIRST.CREDIT_LIMIT = SECOND.CREDIT_LIMIT AND FIRST.CUST_NUM > SECOND.CUST_NUM

SELECT *
FROM CUSTOMERS
WHERE CREDIT_LIMIT = 40000 

--1.9.	Âûáðàòü ïîêóïàòåëåé, ñäåëàâøèõ çàêàçû â îäèí äåíü.
SELECT 
	FIRST.CUST AS FIRST_CUST,
	SECOND.CUST AS SECOND_CUST,
	FIRST.ORDER_DATE
FROM ORDERS FIRST,
	ORDERS SECOND
WHERE FIRST.ORDER_DATE = SECOND.ORDER_DATE AND FIRST.CUST > SECOND.CUST

SELECT *
FROM ORDERS
WHERE ORDER_DATE = '2008-02-10'

--1.10.	Ïîäñ÷èòàòü, íà êàêóþ ñóììó êàæäûé îôèñ âûïîëíèë çàêàçû, è îòñîðòèðîâàòü èõ â ïîðÿäêå óáûâàíèÿ.
SELECT 
	OFFI.OFFICE,
	OFFI.REGION,
	OFFI.CITY,
	SUM(ORD.AMOUNT) AS SUM_AMOUNT
FROM ORDERS ORD LEFT JOIN OFFICES OFFI
ON ORD.REP = OFFI.MGR
GROUP BY OFFI.OFFICE, OFFI.REGION, OFFI.CITY
ORDER BY SUM_AMOUNT DESC

SELECT *
FROM ORDERS
SELECT *
FROM OFFICES

--1.11.	Âûáðàòü ñîòðóäíèêîâ, êîòîðûå ÿâëÿþòñÿ íà÷àëüíèêàìè (ó êîòîðûõ åñòü ïîä÷èíåííûå).
SELECT 
	O.MGR,
	S.MANAGER,
	S.NAME
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.EMPL_NUM = O.MGR
WHERE O.MGR IN (
	SELECT MANAGER 
	FROM SALESREPS
	WHERE EMPL_NUM IS NOT NULL
)

SELECT *
FROM OFFICES

--1.12.	Âûáðàòü ñîòðóäíèêîâ, êîòîðûå íå ÿâëÿþòñÿ íà÷àëüíèêàìè (ó êîòîðûõ íåò ïîä÷èíåííûõ).
SELECT
	S.MANAGER,
	S.NAME,
	O.MGR
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.EMPL_NUM = O.MGR
WHERE MANAGER IS NOT NULL

SELECT 
	MANAGER,
	NAME
FROM SALESREPS
WHERE MANAGER IS NOT NULL

SELECT *
FROM OFFICES

SELECT 
	O.MGR,
	S.MANAGER,
	S.NAME
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.EMPL_NUM = O.MGR
WHERE O.MGR IN (
	SELECT MANAGER 
	FROM SALESREPS
	WHERE EMPL_NUM IS NOT NULL
)

--1.13.	Âûáðàòü âñåõ ïðîäóêòû, ïðîäàâàåìûå ìåíåäæåðàìè èç âîñòî÷íîãî ðåãèîíà.
SELECT 
	ORD.PRODUCT,
	ORD.REP,
	OFFI.REGION
FROM ORDERS ORD LEFT JOIN OFFICES OFFI
ON ORD.REP = OFFI.MGR
WHERE OFFI.REGION IN (
	SELECT REGION
	FROM OFFICES
	WHERE REGION LIKE 'EASTERN'
)

SELECT *
FROM PRODUCTS
SELECT *
FROM SALESREPS
SELECT *
FROM OFFICES
SELECT *
FROM ORDERS

--1.14.	Âûáðàòü ôàìèëèè è äàòû íàéìà âñåõ ñîòðóäíèêîâ è îòñîðòèðîâàòü ïî ñóììå çàêàçîâ, êîòîðûå îíè âûïîëíèëè.
SELECT
	S.NAME,
	O.ORDER_DATE,
	O.AMOUNT,
	SUM_AMOUNT = (
		SELECT SUM(O.AMOUNT) 
		FROM ORDERS O
		WHERE O.REP = S.MANAGER
	)
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
ORDER BY SUM_AMOUNT DESC

SELECT *
FROM ORDERS
SELECT *
FROM SALESREPS

--1.15.	Âûáðàòü çàêàçû, âûïîëíåííûå ìåíåäæåðàìè èç  âîñòî÷íîãî ðåãèîíà è îòñîðòèðîâàòü ïî êîëè÷åñòâó çàêàçàííîãî ïî âîçðàñòàíèþ.
SELECT 
	ORD.ORDER_NUM,
	ORD.REP AS REP_FROM_ORDER,
	OFFI.MGR AS MGR_FROM_OFFICES,
	OFFI.REGION,
	ORD.QTY
FROM ORDERS ORD LEFT JOIN OFFICES OFFI
ON ORD.REP = OFFI.MGR
WHERE OFFI.REGION IN (
	SELECT REGION
	FROM OFFICES
	WHERE REGION = 'EASTERN'
)
ORDER BY ORD.QTY DESC

SELECT *
FROM ORDERS
SELECT *
FROM OFFICES

--1.16.	Âûáðàòü òîâàðû, êîòîðûå äîðîæå òîâàðîâ, çàêàçàííûõ êîìïàíèåé First Corp.
SELECT
	P.MFR_ID,
	C.COMPANY,
	O.CUST,
	P.PRICE AS PRICE_PRODUCT,
	O.AMOUNT,
	P.DESCRIPTION
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT
JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE P.PRICE > (
	SELECT O.AMOUNT
	FROM ORDERS O LEFT JOIN CUSTOMERS C
	ON O.CUST=C.CUST_NUM
	WHERE C.COMPANY LIKE 'FIRST CORP.'
)

SELECT 
	C.COMPANY,
	O.AMOUNT,
	P.PRICE
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON O.CUST = C.CUST_NUM
JOIN PRODUCTS P
ON O.PRODUCT = P.PRODUCT_ID
WHERE C.COMPANY = 'FIRST CORP.'

SELECT *
FROM PRODUCTS
SELECT *
FROM CUSTOMERS
SELECT *
FROM ORDERS

--1.17.	Выбрать товары, которые не входят в товары, заказанные компанией First Corp.
SELECT
	P.MFR_ID,
	C.COMPANY,
	O.CUST,
	P.PRICE AS PRICE_PRODUCT,
	O.AMOUNT,
	P.DESCRIPTION
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT
JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE COMPANY != (
	SELECT C.COMPANY
	FROM ORDERS O LEFT JOIN CUSTOMERS C
	ON O.CUST=C.CUST_NUM
	WHERE C.COMPANY LIKE 'FIRST CORP.'
)

--1.18.	Âûáðàòü òîâàðû, êîòîðûå ïî ñòîèìîñòè íèæå ñðåäíåãî çíà÷åíèÿ ñòîèìîñòè çàêàçà ïî ïîêóïàòåëþ.
SELECT	
	CUST,
	AMOUNT AS AMOUN_LESS_AVG_AMOUNT,
	ORDER_NUM,
	PRODUCT
FROM ORDERS ONE 
WHERE AMOUNT < (
	SELECT 
		AVG(AMOUNT) AS AVG_AMOUNT
		FROM ORDERS TWO
		WHERE TWO.CUST = ONE.CUST
)
GROUP BY CUST, AMOUNT, ORDER_NUM, PRODUCT
ORDER BY CUST DESC

SELECT AVG(AMOUNT) AS AVG_AMOUNT
FROM ORDERS


SELECT *
FROM ORDERS

--1.19.	Íàéòè ñîòðóäíèêîâ, êòî âûïîëíÿë çàêàçû â 2008, íî íå âûïîëíÿë â 2007 (êàê ìèíèìóì 2-ìÿ ðàçíûìè ñïîñîáàìè).
------------------1 METHOD--------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		YEAR(O.ORDER_DATE) AS NEEDED_YEAR
FROM ORDERS O JOIN SALESREPS S
ON O.REP = S.EMPL_NUM
WHERE YEAR(O.ORDER_DATE) = 2008 AND YEAR(O.ORDER_DATE) != 2007

---------------2 METHOD-------------------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		O.ORDER_DATE
FROM SALESREPS S JOIN ORDERS O
ON O.REP = S.EMPL_NUM
WHERE EXISTS (
	SELECT ORDER_DATE 
	FROM ORDERS
	WHERE YEAR(ORDER_DATE) = 2008 AND YEAR(ORDER_DATE) != 2007
	)
ORDER BY S.EMPL_NUM;

SELECT *
FROM SALESREPS
SELECT * 
FROM ORDERS

--1.20.	Íàéòè îðãàíèçàöèè, êîòîðûå íå äåëàëè çàêàçû â 2008, íî äåëàëè â 2007 (êàê ìèíèìóì 2-ìÿ ðàçíûìè ñïîñîáàìè).
------------1 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE YEAR(O.ORDER_DATE) != 2008 AND YEAR(O.ORDER_DATE) = 2007
ORDER BY C.CUST_NUM;
------------2 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
NOT EXISTS (
	SELECT O.CUST 
	FROM ORDERS O 
	WHERE YEAR(O.ORDER_DATE) != 2008 AND YEAR(ORDER_DATE) = 2007
	)
ORDER BY C.CUST_NUM;

--1.21.	Íàéòè îðãàíèçàöèè, êîòîðûå äåëàëè çàêàçû â 2008 è â 2007 (êàê ìèíèìóì 2-ìÿ ðàçíûìè ñïîñîáàìè).
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE NOT EXISTS (
	SELECT O.CUST 
	FROM ORDERS O 
	WHERE YEAR(O.ORDER_DATE) = 2008 AND YEAR(ORDER_DATE) = 2007
	)
ORDER BY C.CUST_NUM;

--2.	Âûïîëíèòå DML îïåðàöèè:
--2.1.	Ñîçäàéòå òàáëèöó Àóäèò (äàòà, îïåðàöèÿ, ïðîèçâîäèòåëü, êîä)  îíà áóäåò èñïîëüçîâàòüñÿ äëÿ êîíòðîëÿ çàïèñè â òàáëèöó PRODUCTS.
CREATE TABLE AUDIT 
(
DATE_ID DATE, 
OPERATION VARCHAR(15), 
MANUFACTURER VARCHAR(15), 
CODE INT
)

--2.2.	Äîáàâüòå âî âðåìåííóþ òàáëèöó âñå òîâàðû.
SELECT *
INTO #T
FROM PRODUCTS

EXEC SP_help PRODUCTS -- ÎÒÎÁÐÀÆÀÅÒ ÈÍÔÎÐÌÀÖÈÞ Î ÒÀÁËÈÖÅ, ÅÃÎ ÑÒÐÓÊÒÓÐÓ
EXEC SP_HELP AUDIT

--2.3.	Äîáàâüòå â ýòó æå âðåìåííóþ òàáëèöó çàïèñü î òîâàðå, èñïîëüçóÿ îãðàíè÷åíèÿ NULL è DEFAULT.
INSERT INTO AUDIT VALUES ('2021-05-23', 'OPERATION_ONE', 'SAMSUNG', 3000)

SELECT *
FROM AUDIT

--2.4.	Äîáàâüòå â ýòó æå âðåìåííóþ òàáëèöó çàïèñü î òîâàðå, è îäíîâðåìåííî äîáàâüòå ýòè æå äàííûå â òàáëèöó àóäèòà 
INSERT INTO #T VALUES ('ZZZ', 'ZXZZ', 'ENGINE', 3000, 5)

SELECT *
FROM #T

INSERT INTO #T
	OUTPUT INSERTED.DESCRIPTION, INSERTED.MFR_ID INTO AUDIT(OPERATION, MANUFACTURER )
	VALUES ('WOW', 'TRX', 'POWER SUPPLY', 1500, 28);

SELECT *
FROM PRODUCTS

--2.5.	Îáíîâèòå äàííûå î òîâàðàõ âî âðåìåííîé òàáëèöå  äîáàâüòå 20% ê öåíå.
UPDATE #T 
SET PRICE = ((PRICE/100)*20)+PRICE --(AMOUNT/100)*20

SELECT * 
FROM #T

SELECT * 
FROM AUDIT

--2.6.	Îáíîâèòå äàííûå î òîâàðàõ, êîòîðûå çàêàçûâàëà First Corp. âî âðåìåííîé òàáëèöå  äîáàâüòå 10% ê öåíå.
UPDATE #T
SET PRICE = ((PRICE/100)*10)+PRICE
WHERE EXISTS (
SELECT 
	P.PRODUCT_ID,
	C.COMPANY,
	O.PRODUCT,
	P.PRICE
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT
JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE C.COMPANY IN (SELECT COMPANY
		FROM CUSTOMERS
		WHERE COMPANY LIKE 'FIRST CORP.')
) 

SELECT 
	C.COMPANY,
	P.PRICE
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT
JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE COMPANY = 'FIRST CORP.'

SELECT *
FROM #T
WHERE PRODUCT_ID = '41004'

--SELECT 
	--P.PRICE
--FROM #T T LEFT JOIN ORDERS O
--ON T.PRODUCT_ID = O.PRODUCT
--JOIN CUSTOMERS C
--ON C.CUST_NUM = O.CUST
--WHERE C.COMAPNY = 'FIRST CORP.'

SELECT *
FROM ORDERS
SELECT *
FROM CUSTOMERS
SELECT *
FROM PRODUCTS

SELECT 
	P.PRODUCT_ID,
	C.COMPANY,
	O.PRODUCT,
	P.PRICE
FROM PRODUCTS P LEFT JOIN ORDERS O
ON P.PRODUCT_ID = O.PRODUCT
JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE C.COMPANY IN (SELECT COMPANY
		FROM CUSTOMERS
		WHERE COMPANY LIKE 'FIRST CORP.')

2.7.	Обновите данные о товаре во временной таблице, 
и одновременно добавьте эти же данные в таблицу аудита (в столбце операция укажите UPDATE, в столбце даты – текущую дату).
SELECT *
FROM #T

SELECT *
FROM AUDIT

UPDATE #T
	SET MFR_ID = 'ZXZ', UPDATE.MFR_ID INTO AUDIT(OPERATION)
	WHERE MFR_ID = 'BIC'

--2.8.	Удалите товары, которые заказывала First Corp. во временной таблице.
DELETE FROM #T
WHERE PRODUCT_ID = (
	SELECT 
		P.PRODUCT_ID
	FROM PRODUCTS P LEFT JOIN ORDERS O
	ON P.PRODUCT_ID = O.PRODUCT
	JOIN CUSTOMERS C
	ON C.CUST_NUM = O.CUST
	WHERE C.COMPANY = 'FIRST CORP.') 

SELECT * 
FROM #T 
WHERE PRODUCT_ID = '41004'

SELECT *
FROM #T

DROP TABLE #T

SELECT *
INTO #T
FROM PRODUCTS

--2.9.	Удалите данные о каком-либо товаре во временной таблице, 
--и одновременно добавьте эти данные в таблицу аудита (в столбце операция укажите DELETE, в столбце даты – текущую дату).
DELETE FROM #T
	OUTPUT GETDATE(), DELETED.MFR_ID INTO AUDIT(DATE_ID, OPERATION)
	WHERE MFR_ID = 'ACI'

SELECT *
FROM AUDIT

SELECT *
FROM #T
WHERE MFR_ID = 'BIC'

3.	Создайте представления:
3.1.	Покупателей, у которых есть заказы выше определенной суммы.
3.2.	Сотрудников, у которых офисы находятся в восточном регионе.
3.3.	Заказы, оформленные в 2008 году.
3.4.	Сотрудники, которые не оформили ни одного заказа.
3.5.	Самый популярный товар.
4.	Продемонстрируйте применение DML операций над представлениями.
5.	Продемонстрируйте и объясните применение опций CHECK OPTION и SCHEMABINDING.
6.	Продемонстрируйте пример применения операций над множествами.
7.	Продемонстрируйте применение команды TRUNCATE.
8.	Напишите скрипт из аналогичных запросов к базе данных по варианту. В качестве комментария укажите условие запроса.
9.	Продемонстрируйте оба скрипта преподавателю
