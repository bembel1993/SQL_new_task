--3.1.	������� ������� � ���� ����� ���� �����������.
select name, hire_date 
from salesreps;

--3.2.	������� ��� ������, ����������� ����� ���������� ����.
select * from orders
where order_date > '2008-01-12';

SELECT * FROM ORDERS
WHERE DAY(ORDER_DATE) = '12'

--3.3.	������� ��� ����� �� ������������� ������� � ����������� ������������ �����������.
select *	
from SALESREPS 
WHERE MANAGER IS NULL

--3.4.	������� ������, ����� ������� ������ ������������� ��������.
select DESCRIPTION, price
from products
where price > '1875.00';

--3.5.	������� ������ ������������� ����������.
select cust,
		mfr
from orders
where cust = 2111;

--3.6.	������� ������, ��������� � ������������ ������.
select order_date = '2008-03-02',
		product
from orders;

--3.7.	������� ����� �� 12, 13 � 21 �������.
select *
from offices
where office = 12;
select *
from offices
where office = 13;
select *
from offices
where office = 21;

--3.8.	������� ����������, � �������� ��� ��������� (������ ��������).
select name
from salesreps
where manager is null;

--3.9.	������� ����� �� �������, ������� ���������� �� East.
select office, region
from offices
where region like 'East%';

--3.10.	������� ���� �������� � ����� ������ ������������� �������� � ������������� � ������� �������� ����.
select description, price
from products
where price > 2500
order by price desc;

--3.11.	������� ������� � ���� ����� ���� ����������� � ������������� �� ��������.
select name, age, hire_date
from salesreps
order by age asc;

--3.12.	������� ��� ������ � ������������� ������� �� ��������� �� ��������, � ����� �� ���������� ����������� �� �����������.
SELECT order_num, AMOUNT, qty 
FROM orders 
ORDER BY amount desc, qty asc;

--3.13.	������� 5 ����� ������� �������.
select top 5 description, price
from products
order by price desc;

--3.14.	������� 3 ����� ������� �����������.
select top 3 name, age
from salesreps
order by age asc;

--3.15.	������� 20% ����� ������� �������.
select top 20 percent amount, product
from orders;

--3.16.	������� 11 ����������� � ����� ������� ��������� �������.
select top 11 cust_num, credit_limit
from customers
order by credit_limit desc;

--3.17.	������� ����������� � 4 �� 7, ��������������� �� ���� �����.
SELECT name, hire_date
FROM   salesreps
order by hire_date desc
OFFSET 3 ROWS 
FETCH NEXT 7 ROWS ONLY;

--3.18.	������� ����������� � 4 �� 7, ��������������� �� �������� � ���, ��� � ���� ������ ��������.
SELECT *
FROM   salesreps
order by EMPL_NUM asc
OFFSET 3 ROWS --OFFSET ����� ����� ROWS � ���������� ������ ���������� �����, ������� ���������� ����������.
FETCH NEXT 4 ROWS ONLY;
/*
select name, rep_office from (
	select top 5 with ties *
	from salesreps
	order by rep_office) x
except
select name, rep_office from(
	select top 2 * 
	from salesreps
	order by rep_office) y;

select * from offices where region = 'Eastern'
union
select * from offices where region = 'Western';

select * from offices where region = 'Eastern'
except --������������ ��� ����������� ���� ���������� SELECT � ���������� ������ �� ������� ��������� SELECT
select * from offices where region = 'Western';

select * from offices where region = 'Western'
intersect --���������� ������ ������ ����� ��� ���� ���������� SELECT
select * from offices where region = 'Western';
*/
--3.19.	������� ���������� ������ � �������.
select distinct product 
from orders;

--3.20.	���������� ���������� ������� ��� ������� ����������.
select cust, sum(QTY) as sum_QTY
from orders 
group by cust;

SELECT CUST, QTY FROM ORDERS
--having count(*) > 1;

--3.21.	���������� �������� ����� ������ ��� ������� ����������.
select cust, sum(amount) as sum_amount
from orders 
group by cust;

SELECT CUST, AMOUNT FROM ORDERS

--3.22.	���������� ������� ���� ������ ��� ������� ����������.
select cust, avg(amount) as sum_amount
from orders 
group by cust;

--3.23.	����� �����������, � ������� ���� ����� ��������� ���� ������������� ��������.
select cust, amount
from orders
where amount > 22500;

--3.24.	����� ���������� ��������� ��� ������� �������������.
select mfr, sum(qty) as sum_qty
from orders
group by mfr;

--3.25.	����� ����� ������� ����� ������� �������������.
select max(price) as high_price
from products

--3.26.	����� ����������� � �� ������ 
--(� �������������� ������ ������ ����: 
--������������ ����������, ������������ ������, �������������, ���������� � �������� �����).
select * from orders;
select * from customers;

select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from orders o join customers c
on o.cust = c.cust_num;

--3.27.	����� ���� ����������� � �� ������.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num;

--3.28.	����� �����������, � ������� ��� �������.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num
where o.order_num is null;

--3.29.	����� �����������, � ������� ���� ������ � ������������ ������.
 select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount,
	o.order_date
from customers c left join orders o
on o.cust = c.cust_num
where o.order_date = '2007-10-12';

--3.30.	����� �����������, � ������� ���� ������ ���� ������������ �����.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount,
	o.order_date
from customers c left join orders o
on o.cust = c.cust_num
where o.amount > 22500;

--3.31.	����� ������, ������� ��������� ��������� �� ������� EAST.
select
	o.mfr,
	o.product,
	s.manager,
	s.name,
	offi.region
from orders o join salesreps s
on o.rep = s.manager
join offices offi
on s.manager = offi.mgr
where offi.region like 'east%'

SELECT *
FROM SALESREPS
SELECT *
FROM OFFICES
SELECT *
FROM ORDERS
--3.32.	����� ������, ������� ������ ���������� � ��������� ������� ������ 40000.
select
	c.company,
	c.CREDIT_LIMIT,
	o.product,
	o.mfr,
	o.qty
from customers c left join orders o
on o.cust = c.cust_num
where CREDIT_LIMIT > 40000; 

-----------------------------------------------------------------------
--3.33.	����� ���� ����������� �� ������� EAST � ��� �� ������.
select 
	s.name,
	s.empl_num, 
	ord.product,
	ord.amount,
	ord.qty
from salesreps s left join orders ord
on s.empl_num = ord.cust
where region like 'East%';

select 
	s.name,
	s.empl_num,
	o.region,
	od.order_num,
	od.order_date,
	od.amount
from salesreps s join offices o
on s.rep_office = o.office
left join orders od 
on s.empl_num = od.rep
where o.region like 'east%'
order by od.amount;
-----------------------------------------------------------------------

--3.34.	����� �����������, ������� �� �������� �� ������ ������.
select *
from salesreps
where quota is null;

--3.35.	����� ����������� ������ ��������.
SELECT age, name 
FROM  salesreps 
WHERE  age = 45;
-------------------------------------------------------------------------
select 
	top 3
	sum(od.qty) as sum_qty,
	
	p.description,
	p.PRODUCT_ID
from products p join orders od
on p.QTY_ON_HAND = od.qty
group by p.DESCRIPTION, p.PRODUCT_ID
order by sum(od.qty) desc;

select *
from products
order by QTY_ON_HAND asc  -- ����������� �� ��������

-------------
--WHERE - ������� �� �����
--COUNT - ���������� �����
--HAVING - ��������� ����������� ��������� �����������, ��������� � ������� ������� GROUP BY

--����������� �����������
--ROLLUP - ������ �� ��������

--�������� ��������� ��������� ������� �������� � DATABASE -> TEMPDB -- ����������� #
--SELECT
--INTO #T11
--FROM

--�������� ��������� ���������� ������� �������� � DATABASE -> TEMPDB -- ����������� ##
--SELECT
--INTO ##T11
--FROM

--3.1.	������� ������� � ���� ����� ���� �����������.
SELECT NAME, HIRE_DATE
FROM SALESREPS

SELECT *
FROM SALESREPS

--3.2.	������� ��� ������, ����������� ����� ���������� ����.
SELECT ORDER_NUM, ORDER_DATE
FROM ORDERS
WHERE ORDER_DATE > '2008-01-04'

SELECT *
FROM ORDERS

--3.3.	������� ��� ����� �� ������������� ������� � ����������� ������������ �����������.
SELECT *
FROM OFFICES
WHERE REGION LIKE 'EASTERN' AND MGR = 108

SELECT *
FROM OFFICES

--3.4.	������� ������, ����� ������� ������ ������������� ��������.
SELECT *
FROM ORDERS
WHERE AMOUNT > 31500

SELECT *
FROM ORDERS

--3.5.	������� ������ ������������� ����������.
SELECT 
	C.COMPANY,
	O.CUST,
	O.ORDER_NUM,
	O.PRODUCT,
	O.AMOUNT
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE COMPANY = 'FIRST CORP.' 

--3.6.	������� ������, ��������� � ������������ ������.
SELECT ORDER_NUM, ORDER_DATE
FROM ORDERS
WHERE ORDER_DATE = '2008-02-24'

--3.7.	������� ����� �� 12, 13 � 21 �������.----------------------IN-------------------------------
SELECT
	OFFICE,
	REGION
FROM OFFICES
WHERE OFFICE IN (12, 13, 21)

--3.8.	������� ����������, � �������� ��� ��������� (������ ��������).
SELECT *
FROM SALESREPS
WHERE MANAGER IS NULL

--3.9.	������� ����� �� �������, ������� ���������� �� East.
SELECT *
FROM OFFICES
WHERE REGION LIKE 'EAST%'

--3.10.	������� ���� �������� � ����� ������ ������������� �������� � ������������� � ������� �������� ����.
SELECT *
FROM PRODUCTS
WHERE PRICE > 900
ORDER BY PRICE DESC

--3.11.	������� ������� � ���� ����� ���� ����������� � ������������� �� ��������.
SELECT NAME, HIRE_DATE, AGE
FROM SALESREPS
ORDER BY AGE ASC

--3.12.	������� ��� ������ � ������������� ������� �� ��������� �� ��������, � ����� �� ���������� ����������� �� �����������.
SELECT ORDER_NUM, AMOUNT, QTY
FROM ORDERS
ORDER BY AMOUNT DESC, QTY ASC

SELECT *
FROM PRODUCTS
--3.13.	������� 5 ����� ������� �������.
SELECT TOP 5 DESCRIPTION, PRICE
FROM PRODUCTS
ORDER BY PRICE DESC

SELECT *
FROM PRODUCTS

--3.14.	������� 3 ����� ������� �����������.
SELECT TOP 3 NAME, AGE
FROM SALESREPS
ORDER BY AGE ASC

--3.15.	������� 20% ����� ������� �������.
SELECT TOP 20 PERCENT AMOUNT, PRODUCT
FROM ORDERS

--3.16.	������� 11 ����������� � ����� ������� ��������� �������.
SELECT TOP 11 COMPANY, CREDIT_LIMIT 
FROM CUSTOMERS
ORDER BY CREDIT_LIMIT DESC 

SELECT *
FROM CUSTOMERS

--3.17.	������� ����������� � 4 �� 7, ��������������� �� ���� �����.
----1 VERSION----
SELECT EMPL_NUM, NAME, HIRE_DATE
FROM SALESREPS
ORDER BY HIRE_DATE ASC
OFFSET 3 ROWS 
FETCH NEXT 4 ROWS ONLY;
----2 VERSION-----
SELECT EMPL_NUM, NAME, HIRE_DATE
FROM SALESREPS
WHERE EMPL_NUM BETWEEN 104 AND 107
----
SELECT EMPL_NUM, NAME, HIRE_DATE
FROM SALESREPS

--3.18.	������� ����������� � 4 �� 7, ��������������� �� �������� � ���, ��� � ���� ������ ��������.
SELECT EMPL_NUM, NAME, AGE
FROM SALESREPS
ORDER BY AGE ASC
OFFSET 3 ROWS
FETCH NEXT 4 ROWS ONLY
--
SELECT EMPL_NUM, NAME, AGE
FROM SALESREPS
WHERE EMPL_NUM BETWEEN 104 AND 107
ORDER BY AGE DESC

--3.19.	������� ���������� ������ � �������.
SELECT DISTINCT PRODUCT
FROM ORDERS

SELECT PRODUCT
FROM ORDERS

--3.20.	���������� ���������� ������� ��� ������� ����������.
SELECT 
	O.QTY, 
	O.CUST,
	C.COMPANY,
	SUM(O.QTY) AS SUM_FOR_EACH
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON O.CUST = C.CUST_NUM
-----
SELECT SUM(QTY) AS SUM_FOR_EACH, CUST
FROM ORDERS
GROUP BY CUST
--
SELECT QTY, CUST
FROM ORDERS
ORDER BY CUST ASC
--
SELECT *
FROM ORDERS
SELECT *
FROM CUSTOMERS

--3.21.	���������� �������� ����� ������ ��� ������� ����������.
SELECT SUM(AMOUNT) AS AMOUNT_FOR_EACH, CUST
FROM ORDERS
GROUP BY CUST

--3.22.	���������� ������� ���� ������ ��� ������� ����������.
SELECT AVG(SALES) AS AVG_SALES_FOR_EACH, NAME
FROM SALESREPS
GROUP BY EMPL_NUM, NAME

SELECT *
FROM SALESREPS
SELECT * 
FROM CUSTOMERS
--3.23.	����� �����������, � ������� ���� ����� ��������� ���� ������������� ��������.
SELECT *
FROM ORDERS 
WHERE AMOUNT > 30000

--3.24.	����� ���������� ��������� ��� ������� �������������.
SELECT SUM(QTY_ON_HAND) AS S_Q_O_H, PRICE, MFR_ID, PRODUCT_ID
FROM PRODUCTS
GROUP BY PRICE, MFR_ID, PRODUCT_ID

SELECT *
FROM PRODUCTS

--3.25.	����� ����� ������� ����� ������� �������������.
SELECT MAX(PRICE) AS MAX_PRICE, MFR_ID
FROM PRODUCTS
GROUP BY MFR_ID
ORDER BY MAX_PRICE DESC

--3.26.	����� ����������� � �� ������ (� �������������� ������ ������ ����: 
--������������ ����������, ������������ ������, �������������, ���������� � �������� �����).
SELECT 
	C.COMPANY, 
	O.MFR,
	O.QTY,
	SUM(O.AMOUNT) AS SUM_AMOUNT
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
GROUP BY C.COMPANY, O.MFR, O.QTY

SELECT *
FROM ORDERS
SELECT *
FROM CUSTOMERS
SELECT *
FROM PRODUCTS

--3.27.	����� ���� ����������� � �� ������.
SELECT 
	O.CUST,
	O.PRODUCT,
	O.ORDER_DATE,
	C.COMPANY
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST

--3.28.	����� �����������, � ������� ��� �������.
SELECT 
	O.CUST,
	O.PRODUCT,
	O.ORDER_DATE,
	C.COMPANY
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE ORDER_NUM = NULL
GROUP BY O.CUST, O.PRODUCT,	O.ORDER_DATE, C.COMPANY

--3.29.	����� �����������, � ������� ���� ������ � ������������ ������.
SELECT 
	O.ORDER_DATE,
	C.COMPANY
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE ORDER_DATE = '2007-10-12'

--3.30.	����� �����������, � ������� ���� ������ ���� ������������ �����.
SELECT 
	O.ORDER_DATE,
	C.COMPANY,
	O.AMOUNT
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE AMOUNT > 30000

--3.31.	����� ������, ������� ��������� ��������� �� ������� EAST.
SELECT 
	S.MANAGER,
	OS.REGION,
	OS.OFFICE,
	O.ORDER_NUM
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
JOIN OFFICES OS
ON S.MANAGER = OS.MGR
WHERE REGION LIKE 'EAST%'

SELECT *
FROM SALESREPS
SELECT *
FROM OFFICES

--3.32.	����� ������, ������� ������ ���������� � ��������� ������� ������ 40000.
SELECT 
	O.PRODUCT,
	C.CUST_REP,
	C.COMPANY,
	C.CREDIT_LIMIT
FROM ORDERS O LEFT JOIN CUSTOMERS C 
ON C.CUST_NUM = O.CUST
WHERE CREDIT_LIMIT > 40000

--3.33.	����� ���� ����������� �� ������� EAST � ��� �� ������.
SELECT 
	S.MANAGER,
	OS.REGION,
	OS.OFFICE
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
JOIN OFFICES OS
ON S.MANAGER = OS.MGR
WHERE REGION LIKE 'EAST%'

--3.34.	����� �����������, ������� �� �������� �� ������ ������.
SELECT 
	DISTINCT S.MANAGER,
	OS.REGION,
	OS.OFFICE
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
JOIN OFFICES OS
ON S.MANAGER = OS.MGR
WHERE ORDER_NUM = NULL

--3.35.	����� ����������� ������ ��������.
SELECT AGE, NAME 
FROM  SALESREPS 
WHERE  AGE IN (45)

--SELECT AGE, NAME, COUNT(EMPL_NUM) AS COUTEMPL
--FROM  SALESREPS 
--WHERE  AGE = AGE
--GROUP BY AGE, NAME
--HAVING COUNT(EMPL_NUM)>1

UPDATE SALESREPS
SET AGE=45
WHERE AGE = 48

SELECT DISTINCT AGE, NAME
FROM SALESREPS
GROUP BY NAME

SELECT NAME, AGE
FROM SALESREPS