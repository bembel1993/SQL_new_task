--3.1.	Выбрать фамилии и даты найма всех сотрудников.
select name, hire_date 
from salesreps;

--3.2.	Выбрать все заказы, выполненные после опреденной даты.
select * from orders
where order_date > '2008-01-12';

SELECT * FROM ORDERS
WHERE DAY(ORDER_DATE) = '12'

--3.3.	Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
select *	
from SALESREPS 
WHERE MANAGER IS NULL

--3.4.	Выбрать заказы, сумма которых больше определенного значения.
select DESCRIPTION, price
from products
where price > '1875.00';

--3.5.	Выбрать заказы определенного покупателя.
select cust,
		mfr
from orders
where cust = 2111;

--3.6.	Выбрать заказы, сделанные в определенный период.
select order_date = '2008-03-02',
		product
from orders;

--3.7.	Выбрать офисы из 12, 13 и 21 региона.
select *
from offices
where office = 12;
select *
from offices
where office = 13;
select *
from offices
where office = 21;

--3.8.	Выбрать сотрудника, у которого нет менеджера (самого главного).
select name
from salesreps
where manager is null;

--3.9.	Выбрать офисы из региона, который начинается на East.
select office, region
from offices
where region like 'East%';

--3.10.	Выбрать всех продукты с ценой больше определенного значения и отсортировать в порядке убывания цены.
select description, price
from products
where price > 2500
order by price desc;

--3.11.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по возрасту.
select name, age, hire_date
from salesreps
order by age asc;

--3.12.	Выбрать все заказы и отсортировать вначале по стоиомсти по убыванию, а затем по количеству заказанного по возрастанию.
SELECT order_num, AMOUNT, qty 
FROM orders 
ORDER BY amount desc, qty asc;

--3.13.	Выбрать 5 самых дорогих товаров.
select top 5 description, price
from products
order by price desc;

--3.14.	Выбрать 3 самых молодых сотрудников.
select top 3 name, age
from salesreps
order by age asc;

--3.15.	Выбрать 20% самых дорогих заказов.
select top 20 percent amount, product
from orders;

--3.16.	Выбрать 11 покупателей с самым высоким кредитным лимитом.
select top 11 cust_num, credit_limit
from customers
order by credit_limit desc;

--3.17.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
SELECT name, hire_date
FROM   salesreps
order by hire_date desc
OFFSET 3 ROWS 
FETCH NEXT 7 ROWS ONLY;

--3.18.	Выбрать сотрудников с 4 по 7, отсортированных по возрасту и тех, кто с ними одного возраста.
SELECT *
FROM   salesreps
order by EMPL_NUM asc
OFFSET 3 ROWS --OFFSET Целое число ROWS – инструкция задает количество строк, которые необходимо пропустить.
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
except --используется для объединения двух операторов SELECT и возвращает строки из первого оператора SELECT
select * from offices where region = 'Western';

select * from offices where region = 'Western'
intersect --возвращает только строки общие для двух инструкций SELECT
select * from offices where region = 'Western';
*/
--3.19.	Выбрать уникальные товары в заказах.
select distinct product 
from orders;

--3.20.	Подсчитать количество заказов для каждого покупателя.
select cust, sum(QTY) as sum_QTY
from orders 
group by cust;

SELECT CUST, QTY FROM ORDERS
--having count(*) > 1;

--3.21.	Подсчитать итоговую сумму заказа для каждого покупателя.
select cust, sum(amount) as sum_amount
from orders 
group by cust;

SELECT CUST, AMOUNT FROM ORDERS

--3.22.	Подсчитать среднюю цену заказа для каждого сотрудника.
select cust, avg(amount) as sum_amount
from orders 
group by cust;

--3.23.	Найти сотрудников, у которых есть заказ стоимости выше определенного значения.
select cust, amount
from orders
where amount > 22500;

--3.24.	Найти количество продуктов для каждого производителя.
select mfr, sum(qty) as sum_qty
from orders
group by mfr;

--3.25.	Найти самый дорогой товар каждого производителя.
select max(price) as high_price
from products

--3.26.	Найти покупателей и их заказы 
--(в результирующем наборе должны быть: 
--наименование покупателя, наименование товара, производитель, количество и итоговая сумма).
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

--3.27.	Найти всех покупателей и их заказы.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num;

--3.28.	Найти покупателей, у которых нет заказов.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num
where o.order_num is null;

--3.29.	Найти покупателей, у которых есть заказы в определенный период.
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

--3.30.	Найти покупателей, у которых есть заказы выше определенной суммы.
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

--3.31.	Найти заказы, которые оформляли менеджеры из региона EAST.
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
--3.32.	Найти товары, которые купили покупатели с кредитным лимитом больше 40000.
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
--3.33.	Найти всех сотрудников из региона EAST и все их заказы.
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

--3.34.	Найти сотрудников, которые не оформили ни одного заказа.
select *
from salesreps
where quota is null;

--3.35.	Найти сотрудников одного возраста.
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
order by QTY_ON_HAND asc  -- группировка по алфавиту

-------------
--WHERE - ВЫБОРКА ИЗ СТРОК
--COUNT - количество строк
--HAVING - позволяет фильтровать результат группировки, сделанной с помощью команды GROUP BY

--РАСШИРЕННАЯ ГРУППИРОВКА
--ROLLUP - ПОИТОГ ПО СТОЛБЦАМ

--СОЗДАНИЕ ВРЕМЕННОЙ локальной ТАБЛИЦЫ ХРАНИМАЯ В DATABASE -> TEMPDB -- ДОБАВЛЯЕТСЯ #
--SELECT
--INTO #T11
--FROM

--СОЗДАНИЕ ВРЕМЕННОЙ глобальной ТАБЛИЦЫ ХРАНИМАЯ В DATABASE -> TEMPDB -- ДОБАВЛЯЕТСЯ ##
--SELECT
--INTO ##T11
--FROM

--3.1.	Выбрать фамилии и даты найма всех сотрудников.
SELECT NAME, HIRE_DATE
FROM SALESREPS

SELECT *
FROM SALESREPS

--3.2.	Выбрать все заказы, выполненные после опреденной даты.
SELECT ORDER_NUM, ORDER_DATE
FROM ORDERS
WHERE ORDER_DATE > '2008-01-04'

SELECT *
FROM ORDERS

--3.3.	Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
SELECT *
FROM OFFICES
WHERE REGION LIKE 'EASTERN' AND MGR = 108

SELECT *
FROM OFFICES

--3.4.	Выбрать заказы, сумма которых больше определенного значения.
SELECT *
FROM ORDERS
WHERE AMOUNT > 31500

SELECT *
FROM ORDERS

--3.5.	Выбрать заказы определенного покупателя.
SELECT 
	C.COMPANY,
	O.CUST,
	O.ORDER_NUM,
	O.PRODUCT,
	O.AMOUNT
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE COMPANY = 'FIRST CORP.' 

--3.6.	Выбрать заказы, сделанные в определенный период.
SELECT ORDER_NUM, ORDER_DATE
FROM ORDERS
WHERE ORDER_DATE = '2008-02-24'

--3.7.	Выбрать офисы из 12, 13 и 21 региона.----------------------IN-------------------------------
SELECT
	OFFICE,
	REGION
FROM OFFICES
WHERE OFFICE IN (12, 13, 21)

--3.8.	Выбрать сотрудника, у которого нет менеджера (самого главного).
SELECT *
FROM SALESREPS
WHERE MANAGER IS NULL

--3.9.	Выбрать офисы из региона, который начинается на East.
SELECT *
FROM OFFICES
WHERE REGION LIKE 'EAST%'

--3.10.	Выбрать всех продукты с ценой больше определенного значения и отсортировать в порядке убывания цены.
SELECT *
FROM PRODUCTS
WHERE PRICE > 900
ORDER BY PRICE DESC

--3.11.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по возрасту.
SELECT NAME, HIRE_DATE, AGE
FROM SALESREPS
ORDER BY AGE ASC

--3.12.	Выбрать все заказы и отсортировать вначале по стоиомсти по убыванию, а затем по количеству заказанного по возрастанию.
SELECT ORDER_NUM, AMOUNT, QTY
FROM ORDERS
ORDER BY AMOUNT DESC, QTY ASC

SELECT *
FROM PRODUCTS
--3.13.	Выбрать 5 самых дорогих товаров.
SELECT TOP 5 DESCRIPTION, PRICE
FROM PRODUCTS
ORDER BY PRICE DESC

SELECT *
FROM PRODUCTS

--3.14.	Выбрать 3 самых молодых сотрудников.
SELECT TOP 3 NAME, AGE
FROM SALESREPS
ORDER BY AGE ASC

--3.15.	Выбрать 20% самых дорогих заказов.
SELECT TOP 20 PERCENT AMOUNT, PRODUCT
FROM ORDERS

--3.16.	Выбрать 11 покупателей с самым высоким кредитным лимитом.
SELECT TOP 11 COMPANY, CREDIT_LIMIT 
FROM CUSTOMERS
ORDER BY CREDIT_LIMIT DESC 

SELECT *
FROM CUSTOMERS

--3.17.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
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

--3.18.	Выбрать сотрудников с 4 по 7, отсортированных по возрасту и тех, кто с ними одного возраста.
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

--3.19.	Выбрать уникальные товары в заказах.
SELECT DISTINCT PRODUCT
FROM ORDERS

SELECT PRODUCT
FROM ORDERS

--3.20.	Подсчитать количество заказов для каждого покупателя.
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

--3.21.	Подсчитать итоговую сумму заказа для каждого покупателя.
SELECT SUM(AMOUNT) AS AMOUNT_FOR_EACH, CUST
FROM ORDERS
GROUP BY CUST

--3.22.	Подсчитать среднюю цену заказа для каждого сотрудника.
SELECT AVG(SALES) AS AVG_SALES_FOR_EACH, NAME
FROM SALESREPS
GROUP BY EMPL_NUM, NAME

SELECT *
FROM SALESREPS
SELECT * 
FROM CUSTOMERS
--3.23.	Найти сотрудников, у которых есть заказ стоимости выше определенного значения.
SELECT *
FROM ORDERS 
WHERE AMOUNT > 30000

--3.24.	Найти количество продуктов для каждого производителя.
SELECT SUM(QTY_ON_HAND) AS S_Q_O_H, PRICE, MFR_ID, PRODUCT_ID
FROM PRODUCTS
GROUP BY PRICE, MFR_ID, PRODUCT_ID

SELECT *
FROM PRODUCTS

--3.25.	Найти самый дорогой товар каждого производителя.
SELECT MAX(PRICE) AS MAX_PRICE, MFR_ID
FROM PRODUCTS
GROUP BY MFR_ID
ORDER BY MAX_PRICE DESC

--3.26.	Найти покупателей и их заказы (в результирующем наборе должны быть: 
--наименование покупателя, наименование товара, производитель, количество и итоговая сумма).
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

--3.27.	Найти всех покупателей и их заказы.
SELECT 
	O.CUST,
	O.PRODUCT,
	O.ORDER_DATE,
	C.COMPANY
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST

--3.28.	Найти покупателей, у которых нет заказов.
SELECT 
	O.CUST,
	O.PRODUCT,
	O.ORDER_DATE,
	C.COMPANY
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE ORDER_NUM = NULL
GROUP BY O.CUST, O.PRODUCT,	O.ORDER_DATE, C.COMPANY

--3.29.	Найти покупателей, у которых есть заказы в определенный период.
SELECT 
	O.ORDER_DATE,
	C.COMPANY
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE ORDER_DATE = '2007-10-12'

--3.30.	Найти покупателей, у которых есть заказы выше определенной суммы.
SELECT 
	O.ORDER_DATE,
	C.COMPANY,
	O.AMOUNT
FROM ORDERS O LEFT JOIN CUSTOMERS C
ON C.CUST_NUM = O.CUST
WHERE AMOUNT > 30000

--3.31.	Найти заказы, которые оформляли менеджеры из региона EAST.
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

--3.32.	Найти товары, которые купили покупатели с кредитным лимитом больше 40000.
SELECT 
	O.PRODUCT,
	C.CUST_REP,
	C.COMPANY,
	C.CREDIT_LIMIT
FROM ORDERS O LEFT JOIN CUSTOMERS C 
ON C.CUST_NUM = O.CUST
WHERE CREDIT_LIMIT > 40000

--3.33.	Найти всех сотрудников из региона EAST и все их заказы.
SELECT 
	S.MANAGER,
	OS.REGION,
	OS.OFFICE
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
JOIN OFFICES OS
ON S.MANAGER = OS.MGR
WHERE REGION LIKE 'EAST%'

--3.34.	Найти сотрудников, которые не оформили ни одного заказа.
SELECT 
	DISTINCT S.MANAGER,
	OS.REGION,
	OS.OFFICE
FROM ORDERS O LEFT JOIN SALESREPS S
ON O.REP = S.MANAGER
JOIN OFFICES OS
ON S.MANAGER = OS.MGR
WHERE ORDER_NUM = NULL

--3.35.	Найти сотрудников одного возраста.
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