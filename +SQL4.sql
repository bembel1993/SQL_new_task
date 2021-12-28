--1.1.	������� ��� ������, ����������� ������������ �����������.
select 
	ord.rep,
	ord.mfr,
	ord.product,
	ord.amount,
	ord.order_date,
	cus.cust_num,
	cus.company
from orders ord join customers cus
on ord.cust = cus.cust_num
where company = 'Chen Associates';

SELECT *
FROM ORDERS
WHERE CUST = 
		(SELECT CUST_NUM FROM CUSTOMERS WHERE COMPANY = 'Chen Associates');

--1.2.	������� ���� ����������� � ������� ���������� ����� ��������� �������.
select
	c.cust_num,
	c.company,
	o.amount,
	SumAmount=(select sum(amount) from orders o where o.cust=c.cust_num)
from orders o join customers c
on o.cust = c.cust_num
order by amount desc; 

--1.3.	������� ��� ������, ������� ����������� ����������� �� ���������� �������.
select 
	--o.rep,
	o.order_num
	--o.mfr,
	--o.product,
	--s.manager
	--offi.region
from orders o join salesreps s
on o.rep = s.empl_num
join offices offi
on s.rep_office = offi.office
where offi.region like 'Eastern'
--order by manager;

select order_num
from orders
where rep in (select empl_num from salesreps where rep_office in 
(select office from offices where region = 'Eastern'))

--1.4.	����� �������� �������, ������������� ����������� First Corp.
select
	c.company,
	--s.manager,
	--o.mfr,
	--o.product,
	--o.rep,
	p.description
from customers c join salesreps s
on c.cust_rep = s.manager
join orders o
on s.empl_num = o.rep
join products p
on o.mfr = p.mfr_id
where company = 'First Corp.'

select description 
from products
where product_id in (select product from orders where cust =
		(select cust_num from customers where company = 'First Corp.'))

--1.5.	������� ���� ����������� �� ���������� ������� � ������������� �� ��������� Quota.
select
	s.name,
	s.quota,
	o.region
from salesreps s join offices o
on s.empl_num = o.mgr
where region like 'Eastern'
order by quota

select 
	s.name,
	s.quota,
	o.region
from salesreps s join offices o
on s.empl_num=o.mgr
where rep_office in (select office from offices where region='Eastern')
order by quota

--1.6.	������� ������, ����� ������� ������ �������� ��������.
--select
	--mfr,
	--AMOUNT,
	--product,
	--avg(amount) as avg_amount
--from orders
--group by mfr, product, AMOUNT
--order by mfr
--------------------------------
select *
from orders
where amount > (select avg(amount) as avg_amount from orders);

--select avg(price) as avg_price
--from products
--group by product_id
--------------------------------
--select 
	--product, count(qty) as qty_product,
	--avg(amount) as avg_amount
--from orders
--group by product
--having avg(amount) > 8256;
---------------------------------
--select sum(price) as sum_price
--from products 
--group by product_id

--1.7.	������� ����������, ������� ����������� ����� � ��� �� �����������.
select
	--c.company,
	c.cust_rep,
	o.rep,
	o.cust
	--s.manager,
	--s.name
from customers c join orders o
on c.cust_rep = o.rep
order by cust_rep

select 
	first.rep,
	second.rep,
	first.cust
from orders first, orders second
where first.cust = second.cust and first.rep > second.rep
---------------------------------
--select *
--from orders
--where rep =
--(select rep
--from orders)

--1.8.	������� ����������� � ���������� ��������� �������.
	
select
	first.cust_num as firstCust_num,
	second.cust_num as secondCust_num,
	first.credit_limit,
	first.company
from customers first, customers second
where first.credit_limit = second.credit_limit and first.cust_num = second.cust_num
order by credit_limit desc

--1.9.	������� �����������, ��������� ������ � ���� ����.
select
	o.cust,
	o.order_num,
	o.order_date,
	c.company
from orders o join customers c
on o.cust = c.cust_num
order by order_date asc

select
	first.cust as firstCust,
	second.cust as secondCust,
	first.order_date,
	c.company
from orders first, orders second 
join customers c
on second.cust=c.cust_num 
where first.order_date = second.order_date
and first.cust = second.cust
order by order_date asc

--1.10.	����������, �� ����� ����� ������ ���� �������� ������, � ������������� �� � ������� ��������.
select a.rep_office, sum(b.amount) as sum_amount
from orders b join salesreps a
on a.empl_num=b.rep
--where rep in 
--(select empl_num from salesreps where rep_office = 21 )
group by a.rep_office
--order by rep
------------------------------------
select a.rep_office, sum(b.amount) as sum_amount
from orders b join salesreps a
on a.empl_num=b.rep
group by a.rep_office
order by sum_amount desc

--1.11.	������� �����������, ������� �������� ������������ (� ������� ���� �����������).
select manager, name
from salesreps
where manager is null

select o.mgr, s.manager, s.name  
from offices o join salesreps s
on o.mgr = s.empl_num
where o.mgr in (select s.manager from salesreps s where s.empl_num is not null)

--1.12.	������� �����������, ������� �� �������� ������������ (� ������� ��� �����������).
select manager, name
from salesreps
where manager is not null

--1.13.	������� ��� ��������, ����������� ����������� �� ���������� �������.
select o.product,
		s.manager,
		offi.region
from orders o join salesreps s
on o.rep = s.manager 
join offices offi
on s.manager = offi.mgr
where rep in (
	select mgr from offices where region like 'eastern' 
)
-----------------------------------------------------

--1.14.	������� ������� � ���� ����� ���� ����������� � ������������� �� ����� �������, ������� ��� ���������.
select 
	s.name, 
	s.hire_date,
	amount
from salesreps s join orders o
on s.manager = o.rep
order by amount asc

--where manager in (
	--select sum(amount) as sum_amount
	--from orders
	--order by amount asc
	--)

--1.15.	������� ������, ����������� ����������� ��  ���������� ������� � ������������� �� ���������� ����������� �� �����������.
select o.cust,
		o.product,
		s.manager,
		s.name,
		o.qty,
		offi.region
from orders o join salesreps s
on o.rep = s.manager 
join offices offi
on s.manager = offi.mgr
where rep in (
	select mgr from offices where region like 'eastern' 
)
order by o.qty asc

--1.16.	������� ������, ������� ������ �������, ���������� ��������� First Corp.
select 
	p.product_id,
	o.cust,
	--c.cust_num,
	--o.cust
	c.company,
	p.price
from CUSTOMERS c join ORDERS o
on c.CUST_NUM = o.CUST
join PRODUCTS p
on o.PRODUCT = p.PRODUCT_ID

where cust_num in(
	select price from PRODUCTS where price > 'First Corp' 
)

select 
	product_id,
	price
from products
where product_id in (select product from orders where amount > (select amount from orders
where cust = (select cust_num from customers where company = 'First Corp.')))

1.17.	������� ������, ������� �� ������ � ������, ���������� ��������� First Corp.


--1.18.	������� ������, ������� �� ��������� ���� �������� �������� ��������� ������ �� ����������.
select
	cust,
	amount
from orders first
where amount < (select 
					avg(amount)
				from orders second
				where second.cust = first.cust)
order by cust

--1.19.	����� �����������, ��� �������� ������ � 2008, �� �� �������� � 2007 (��� ������� 2-�� ������� ���������).
------------------1 METHOD--------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		YEAR(O.ORDER_DATE) AS Fin_Year
FROM ORDERS O JOIN SALESREPS S
ON   O.REP = S.EMPL_NUM
WHERE YEAR(O.ORDER_DATE) = 2008 OR YEAR(O.ORDER_DATE) IS NULL

UNION

SELECT	S.EMPL_NUM,
		S.NAME,
		YEAR(O.ORDER_DATE) AS Fin_Year
FROM ORDERS O JOIN SALESREPS S
ON   O.REP = S.EMPL_NUM
WHERE YEAR(O.ORDER_DATE) = 2007 OR YEAR(O.ORDER_DATE) IS NULL
ORDER BY YEAR(O.ORDER_DATE) DESC

---------------2 METHOD-------------------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		O.ORDER_DATE
FROM SALESREPS S join ORDERS O
on O.REP = S.EMPL_NUM
WHERE 
EXISTS (SELECT O.REP FROM ORDERS O WHERE O.REP=S.EMPL_NUM AND 
			YEAR(O.ORDER_DATE) = 2008)
ORDER BY S.EMPL_NUM;
-----------------------------------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		O.ORDER_DATE
FROM SALESREPS S join ORDERS O
on O.REP = S.EMPL_NUM
WHERE 
NOT EXISTS (SELECT O.REP FROM ORDERS O WHERE O.REP=S.EMPL_NUM 
				AND YEAR(O.ORDER_DATE) = 2007)
ORDER BY S.EMPL_NUM;

--1.20.	����� �����������, ������� �� ������ ������ � 2008, �� ������ � 2007 (��� ������� 2-�� ������� ���������).
------------1 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
YEAR(O.ORDER_DATE) != 2008
ORDER BY C.CUST_NUM;
------------2 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
NOT EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) = 2008)
ORDER BY C.CUST_NUM;
---------------------------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) IN (2007))
ORDER BY O.ORDER_DATE ASC;

--1.21.	����� �����������, ������� ������ ������ � 2008 � � 2007 (��� ������� 2-�� ������� ���������).
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) IN (2008, 2007))
ORDER BY O.ORDER_DATE DESC;
------------------------------------------------------------------------------------------------------------------

--2.	��������� DML ��������:
--2.1.	�������� ������� ����� (����, ��������, �������������, ���) � ��� ����� �������������� ��� �������� ������ � ������� PRODUCTS.
SELECT * FROM PRODUCTS
-----------------------------------------------
CREATE TABLE AUDIT (DATE_ID DATE, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE VARCHAR(8)) -- ������� �����

 SELECT * FROM AUDIT
--2.2.	�������� �� ��������� ������� ��� ������.
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
--2.3.	�������� � ��� �� ��������� ������� ������ � ������, ��������� ����������� NULL � DEFAULT.
--ALTER TABLE ������������ ����������� �������� ��������� ������������ �������. 
			--��������, ����� ��������� ��� ������� �������, ��������� ��� ���������� ������� ��� 
			--��������������� ������� ���� ���� �������.
ALTER TABLE #AUDIT6 ADD CONSTRAINT PRICE
DEFAULT 100 FOR PRICE; --DEFAULT - �������� �� ���������

INSERT INTO #AUDIT6 (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE , QTY_ON_HAND)
VALUES ('STR', '33TRX', '_xXx_', default, 3333);

SELECT * FROM #AUDIT6

--2.4.	�������� � ��� �� ��������� ������� ������ � ������, � ������������ �������� ��� �� ������ � ������� ������ 
	--	(� ������� �������� ������� INSERT, � ������� ���� � ������� ����).
INSERT INTO #AUDIT6 (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE , QTY_ON_HAND)
	OUTPUT inserted.PRODUCT_ID, inserted.MFR_ID INTO AUDIT(OPERATION, MANUFACTURER )
	VALUES ('WOW', 'TR', 'YYY', 10000, 1000);

	--DATE_ID DATE, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE VARCHAR(8)

--2.5.	�������� ������ � ������� �� ��������� ������� � �������� 20% � ����.
UPDATE #AUDIT6 SET PRICE = ((PRICE/100)*20)+PRICE --(AMOUNT/100)*20
SELECT * FROM #AUDIT6
SELECT * FROM AUDIT
--2.6.	�������� ������ � �������, ������� ���������� First Corp. �� ��������� ������� � �������� 10% � ����.
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
--2.7.	�������� ������ � ������ �� ��������� �������, � ������������ �������� ��� �� ������ � ������� ������ 
	--	(� ������� �������� ������� UPDATE, � ������� ���� � ������� ����).

--2.8.	������� ������, ������� ���������� First Corp. �� ��������� �������.
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

--2.9.	������� ������ � �����-���� ������ �� ��������� �������, � ������������ �������� ��� ������ � ������� ������ 
		--(� ������� �������� ������� DELETE, � ������� ���� � ������� ����).
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

--3.	�������� �������������:
--3.1.	�����������, � ������� ���� ������ ���� ������������ �����.
--������������� � ����������� �������, �������������� ����� ������������� ������, 
				--������� ����� ���������� ��� ��������� ��� ������������� �������������. 
				--� ������� �� ������� ������ ����������� ��� ������, ������������� �� �������� 
				--��������������� ������ ������ ������, ����������� � ����. 
GO
CREATE VIEW HIGH_SALES AS
SELECT * 
FROM SALESREPS WHERE SALES>200000

SELECT * FROM HIGH_SALES

DROP VIEW HIGH_SALES
GO

--3.2.	�����������, � ������� ����� ��������� � ��������� �������.
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

--3.3.	������, ����������� � 2008 ����.
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

--3.4.	����������, ������� �� �������� �� ������ ������.
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

--3.5.	����� ���������� �����.
CREATE VIEW TOP_PRODUCT
AS
SELECT 
	MAX (QTY) AS MAS_QTY
FROM ORDERS

SELECT * FROM TOP_PRODUCT

SELECT * FROM PRODUCTS
SELECT * FROM ORDERS

--4.	����������������� ���������� DML �������� ��� ���������������.
--������������� - ��� ���������������� ������, ���������� � ���� ������, 
				--������� �������� ������� ������� ������� � �� ������� ��� ������ �������� �������� ������. 
				--��� �������� ������������� ������������ ������ ����������� ������. 
CREATE  VIEW DEMO_VIEW_CUST 
AS
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT 
FROM CUSTOMERS
WHERE COMPANY = 'First Corp.'

SELECT * FROM DEMO_VIEW_CUST

DROP VIEW DEMO_VIEW_CUST

--5.	����������������� � ��������� ���������� ����� CHECK OPTION � SCHEMABINDING.

CREATE  VIEW DEMO_VIEW3
AS
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT 
FROM CUSTOMERS
WHERE COMPANY = 'First Corp.'
WITH CHECK OPTION --WITH CHECK OPTION ��������� ��������� �����, ������� ��� � ����������

INSERT INTO DEMO_VIEW3 VALUES (2102,'xXx', 101, 10000.00)

SELECT * FROM DEMO_VIEW3

DROP VIEW DEMO_VIEW3
------------------------------------------------------------------------
DROP VIEW Best_Sales;
GO

CREATE VIEW Best_Sales AS
SELECT  * FROM SALESREPS 
WHERE [SALES]>200000
WITH CHECK OPTION --WITH CHECK OPTION ��������� ��������� �����, ������� ��� � ����������
GO

INSERT INTO Best_Sales (EMPL_NUM, NAME, HIRE_DATE, SALES)
	VALUES (133, 'John Bon Jovi', '2019-11-14', 10000); -- ������!

SELECT * FROM BEST_SALES

--6.	����������������� ������ ���������� �������� ��� �����������.
--7.	����������������� ���������� ������� TRUNCATE.
TRUNCATE TABLE AUDIT --TRUNCATE � �������� ����������� �������� ���� ����� � �������
SELECT * FROM AUDIT

--8.	�������� ������ �� ����������� �������� � ���� ������ �� ��������. � �������� ����������� ������� ������� �������.
--9.	����������������� ��� ������� �������������.


--------��.1.21------------------
--1.1.	������� ��� ������, ����������� ������������ �����������.
SELECT *
FROM ORDERS
WHERE CUST = (
	SELECT CUST_NUM 
	FROM CUSTOMERS
	WHERE COMPANY = 'Ace International'
)

SELECT *
FROM CUSTOMERS

--1.2.	������� ���� ����������� � ������� ���������� ����� ��������� �������.
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
--1.3.	������� ��� ������, ������� ����������� ����������� �� ���������� �������.
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

--1.4.	����� �������� �������, ������������� ����������� First Corp.
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

--1.5.	������� ���� ����������� �� ���������� ������� � ������������� �� ��������� Quota.
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

--1.6.	������� ������, ����� ������� ������ �������� ��������.
SELECT *
FROM ORDERS 
WHERE AMOUNT > (
	SELECT AVG(AMOUNT) AS AVG_AMOUNT
	FROM ORDERS 
)
ORDER BY AMOUNT DESC

--1.7.	������� ����������, ������� ����������� ����� � ��� �� �����������.
SELECT 
	FIRST.REP,
	SECOND.REP,
	FIRST.CUST
FROM ORDERS FIRST, 
	ORDERS SECOND
WHERE FIRST.CUST = SECOND.CUST AND FIRST.REP > SECOND.REP

--1.8.	������� ����������� � ���������� ��������� �������.
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

--1.9.	������� �����������, ��������� ������ � ���� ����.
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

--1.10.	����������, �� ����� ����� ������ ���� �������� ������, � ������������� �� � ������� ��������.
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

--1.11.	������� �����������, ������� �������� ������������ (� ������� ���� �����������).
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

--1.12.	������� �����������, ������� �� �������� ������������ (� ������� ��� �����������).
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

--1.13.	������� ���� ��������, ����������� ����������� �� ���������� �������.
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

--1.14.	������� ������� � ���� ����� ���� ����������� � ������������� �� ����� �������, ������� ��� ���������.
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

--1.15.	������� ������, ����������� ����������� ��  ���������� ������� � ������������� �� ���������� ����������� �� �����������.
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

--1.16.	������� ������, ������� ������ �������, ���������� ��������� First Corp.
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

1.17.	������� ������, ������� �� ������ � ������, ���������� ��������� First Corp.
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
WHERE NOT EXISTS (
	SELECT C.COMPANY
	FROM ORDERS O LEFT JOIN CUSTOMERS C
	ON O.CUST=C.CUST_NUM
	WHERE C.COMPANY LIKE 'FIRST CORP.'
)

--1.18.	������� ������, ������� �� ��������� ���� �������� �������� ��������� ������ �� ����������.
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

--1.19.	����� �����������, ��� �������� ������ � 2008, �� �� �������� � 2007 (��� ������� 2-�� ������� ���������).
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

--1.20.	����� �����������, ������� �� ������ ������ � 2008, �� ������ � 2007 (��� ������� 2-�� ������� ���������).
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

--1.21.	����� �����������, ������� ������ ������ � 2008 � � 2007 (��� ������� 2-�� ������� ���������).
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

--2.	��������� DML ��������:
--2.1.	�������� ������� ����� (����, ��������, �������������, ���) � ��� ����� �������������� ��� �������� ������ � ������� PRODUCTS.
CREATE TABLE AUDIT 
(
DATE_ID DATE, 
OPERATION VARCHAR(15), 
MANUFACTURER VARCHAR(15), 
CODE INT
)

--2.2.	�������� �� ��������� ������� ��� ������.
SELECT *
INTO #T
FROM PRODUCTS

EXEC SP_help PRODUCTS -- ���������� ���������� � �������, ��� ���������
EXEC SP_HELP AUDIT

--2.3.	�������� � ��� �� ��������� ������� ������ � ������, ��������� ����������� NULL � DEFAULT.
INSERT INTO AUDIT VALUES ('2021-05-23', 'OPERATION_ONE', 'SAMSUNG', 3000)

SELECT *
FROM AUDIT

--2.4.	�������� � ��� �� ��������� ������� ������ � ������, � ������������ �������� ��� �� ������ � ������� ������ 
INSERT INTO #T VALUES ('ZZZ', 'ZXZZ', 'ENGINE', 3000, 5)

SELECT *
FROM #T

INSERT INTO #T
	OUTPUT INSERTED.DESCRIPTION, INSERTED.MFR_ID INTO AUDIT(OPERATION, MANUFACTURER )
	VALUES ('WOW', 'TRX', 'POWER SUPPLY', 1500, 28);

SELECT *
FROM PRODUCTS

--2.5.	�������� ������ � ������� �� ��������� ������� � �������� 20% � ����.
UPDATE #T 
SET PRICE = ((PRICE/100)*20)+PRICE --(AMOUNT/100)*20

SELECT * 
FROM #T

SELECT * 
FROM AUDIT

--2.6.	�������� ������ � �������, ������� ���������� First Corp. �� ��������� ������� � �������� 10% � ����.
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

2.7.	�������� ������ � ������ �� ��������� �������, � ������������ �������� ��� �� ������ � ������� ������ (� ������� �������� ������� UPDATE, � ������� ���� � ������� ����).
2.8.	������� ������, ������� ���������� First Corp. �� ��������� �������.
2.9.	������� ������ � �����-���� ������ �� ��������� �������, � ������������ �������� ��� ������ � ������� ������ (� ������� �������� ������� DELETE, � ������� ���� � ������� ����).
3.	�������� �������������:
3.1.	�����������, � ������� ���� ������ ���� ������������ �����.
3.2.	�����������, � ������� ����� ��������� � ��������� �������.
3.3.	������, ����������� � 2008 ����.
3.4.	����������, ������� �� �������� �� ������ ������.
3.5.	����� ���������� �����.
4.	����������������� ���������� DML �������� ��� ���������������.
5.	����������������� � ��������� ���������� ����� CHECK OPTION � SCHEMABINDING.
6.	����������������� ������ ���������� �������� ��� �����������.
7.	����������������� ���������� ������� TRUNCATE.
8.	�������� ������ �� ����������� �������� � ���� ������ �� ��������. � �������� ����������� ������� ������� �������.
9.	����������������� ��� ������� �������������.
