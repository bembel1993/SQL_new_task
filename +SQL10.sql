--1.	Разработать курсор, который выводит все данные о клиенте.
SELECT * 
FROM CUSTOMERS

DECLARE  
	@CUST_NUM VARCHAR(50),
	@COMPANY VARCHAR(50),
	@CUST_REP VARCHAR(50),
    @CREDIT_LIMIT INT,
    @MESSAGE VARCHAR(200)
PRINT ' LIST CUSTOMERS:'
--СОЗДАЕМ КУРСОР
DECLARE KLIENT_CURSOR CURSOR FOR  
    SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT
    FROM CUSTOMERS
    --WHERE COMPANY='First Corp.'
    --ORDER BY COMPANY, CREDIT_LIMIT

--ОТКРЫВАЕМ КУРСОР
OPEN KLIENT_CURSOR
FETCH NEXT FROM KLIENT_CURSOR INTO @CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT --FETCH - ЧТЕНИЕ КУРСОРА
WHILE @@FETCH_STATUS=0
BEGIN
    SELECT @MESSAGE= 'CUST_NUM: '+ @CUST_NUM +'|||'+'COMPANY: '+@COMPANY +'||| '+'CUST_REP: ' + @CUST_REP +'|||'+
					'CREDIT_LIMIT: ' +CAST(@CREDIT_LIMIT AS VARCHAR(80))
    PRINT @MESSAGE
    FETCH NEXT FROM KLIENT_CURSOR INTO @CUST_NUM, @COMPANY, @CREDIT_LIMIT, @CUST_REP -- переход к следующему клиент
END

CLOSE KLIENT_CURSOR
DEALLOCATE KLIENT_CURSOR
-------------------------------------------------------------------

--2.	Разработать курсор, который выводит все данные о сотрудниках офисов и их количество.
SELECT * 
FROM OFFICES
------OFFICES---------------
DECLARE @OFFICE INT,
		@CITY VARCHAR(20),
		@REGION VARCHAR(20),
		@MGR INT,
		@TARGET INT,
		@SALES INT,
		@SEND_TO_DISPLAY VARCHAR(1000);

DECLARE OFFICES_CURSOR CURSOR
FOR SELECT OFFICE, CITY, REGION, COUNT(MGR), TARGET, SALES 
FROM OFFICES 
GROUP BY OFFICE, CITY, REGION, MGR, TARGET, SALES;

OPEN OFFICES_CURSOR;

FETCH FROM OFFICES_CURSOR INTO @OFFICE, @CITY, @REGION, @MGR, @TARGET, @SALES
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SELECT @SEND_TO_DISPLAY = CAST(@OFFICE AS VARCHAR(20))+'---'+ @CITY+'---'+ @REGION +'---'+ 
		CAST(@MGR AS VARCHAR(20))+'---'+ CAST(@TARGET AS VARCHAR(200))+'---'+CAST(@SALES AS VARCHAR(200));
	PRINT @SEND_TO_DISPLAY
	FETCH FROM OFFICES_CURSOR INTO @OFFICE, @CITY, @REGION, @MGR, @TARGET, @SALES
END

CLOSE OFFICES_CURSOR
DEALLOCATE OFFICES_CURSOR

-----------SALESREPS--------------------
SELECT *
FROM SALESREPS

DECLARE @EMPL_NUM VARCHAR(45), 
		@NAME VARCHAR(45),
    --@age int, 
	--@rep_office int, 
		@TITLE VARCHAR(40),
	--@hire_date INT,
	--@manager int, 
	--@quota decimal(9, 2), 
		@SALES DECIMAL(9, 2),
		@SUM INT, 
	--@message1 varchar(80),
		@MESSAGE VARCHAR(1000),
		@QTY VARCHAR(100)
DECLARE SALESREPS_CURSOR CURSOR 
	FOR SELECT EMPL_NUM, NAME, TITLE, SALES, COUNT(*) FROM SALESREPS GROUP BY EMPL_NUM, NAME, TITLE, SALES;
 
OPEN SALESREPS_CURSOR;
 
FETCH FROM SALESREPS_CURSOR INTO @EMPL_NUM, @NAME, @TITLE, @SALES, @SUM
WHILE @@FETCH_STATUS = 0 
BEGIN 
	--FETCH FROM salesreps_cursor INTO @empl_num, @name, @age, @rep_office, @title, @hire_date, @manager, @quota, @sales;
   SELECT @MESSAGE = @EMPL_NUM + '||| ' + @NAME + ' ' +  @TITLE+ '||| '+ CAST(@SALES AS VARCHAR(1000))+'||| '+ 
   '--QTY CUST-- '+ CAST(@SUM AS VARCHAR(30))
   PRINT @MESSAGE
   SELECT @QTY = '--QTY CUST-- '+ CAST((SELECT COUNT(*) FROM SALESREPS) AS VARCHAR(100))
   FETCH FROM SALESREPS_CURSOR INTO @EMPL_NUM, @NAME, @TITLE, @SALES, @SUM
END
PRINT @QTY

CLOSE SALESREPS_CURSOR 
DEALLOCATE SALESREPS_CURSOR 

-----------------------------------------------------------------------------------------------
--3.	Разработать локальный курсор, который выводит все сведения о товарах и их среднюю цену.
SELECT * --AVG(PRICE) 
FROM PRODUCTS 
WHERE MFR_ID = 'ACI'

SELECT * 
FROM PRODUCTS

DECLARE @MFR_ID VARCHAR(20),
		@PRODUCT_ID VARCHAR(20),
		@PRICE INT,
		@SEND_TO_DISPLAY VARCHAR(1000),
		@DEFINITE_PRODUCT VARCHAR(100),
		@ACI VARCHAR(100)
DECLARE PRODUCTS_CURSOR CURSOR LOCAL			--LOCAL - Указывает, что курсор является локальным по отношению к пакету, хранимой процедуре или триггеру
	FOR SELECT DISTINCT MFR_ID, PRODUCT_ID, PRICE  
	FROM PRODUCTS 
	GROUP BY MFR_ID, PRODUCT_ID, PRICE;

OPEN PRODUCTS_CURSOR;

FETCH FROM PRODUCTS_CURSOR INTO @MFR_ID, @PRODUCT_ID, @PRICE
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		--SELECT @SEND_TO_DISPLAY = @MFR_ID+'|||'+ @PRODUCT_ID +'|||'+ CAST(AVG(@PRICE) AS VARCHAR(20));
	--PRINT @SEND_TO_DISPLAY
	SET @SEND_TO_DISPLAY = @MFR_ID+ '|||'+@PRODUCT_ID+'|||'+(SELECT CAST(AVG(PRICE) AS VARCHAR(20)) FROM PRODUCTS);
	PRINT @SEND_TO_DISPLAY
	FETCH FROM PRODUCTS_CURSOR INTO @MFR_ID, @PRODUCT_ID, @PRICE
END
SELECT @ACI = 'ACI: ' + CAST((SELECT AVG(PRICE) FROM PRODUCTS WHERE MFR_ID = 'ACI') AS VARCHAR(20))
	PRINT @ACI

CLOSE PRODUCTS_CURSOR
DEALLOCATE PRODUCTS_CURSOR

---------------------------------------------------------------------------------------------------
--4.	Разработать глобальный курсор, который выводит сведения о заказах, выполненныъ в 2008 году.
SELECT * 
FROM ORDERS 
WHERE ORDER_DATE = '2008'

DECLARE 
	@ORDER_NUM INT, 
	@ORDER_DATE DATE,
	@MFR VARCHAR(10),
	@PRODUCT VARCHAR(20),
	@SHOW_TO_DISPLAY VARCHAR(400)

DECLARE ORDERS_CURSOR CURSOR GLOBAL   --GLOBAL - Указывает, что курсор является глобальным по отношению к соединению.
	FOR	SELECT ORDER_NUM, ORDER_DATE, MFR, PRODUCT FROM ORDERS
	WHERE YEAR(ORDER_DATE)=2008 
	GROUP BY ORDER_NUM, ORDER_DATE, MFR, PRODUCT
	
OPEN ORDERS_CURSOR;

FETCH FROM ORDERS_CURSOR INTO @ORDER_NUM, @ORDER_DATE, @MFR, @PRODUCT;
	--WHILE @@FETCH_STATUS = 0		--КОНТРОЛЬ ДОСТИЖЕНИЯ КОНЦА КУРСОРА - ЕСЛИ 0, ТО ВЫБОРКА ПРОШЛА УСПЕШНО
WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT ORDER_DATE=@ORDER_DATE FROM ORDERS
		--WHERE ORDER_DATE='2008'
	SELECT @SHOW_TO_DISPLAY = CAST(@ORDER_NUM AS VARCHAR(20))+'|||'+ CAST(@ORDER_DATE AS VARCHAR(20))+'|||'+@MFR+'|||'+@PRODUCT
	PRINT @SHOW_TO_DISPLAY
	FETCH FROM ORDERS_CURSOR INTO @ORDER_NUM, @ORDER_DATE, @MFR, @PRODUCT;
END

CLOSE ORDERS_CURSOR
DEALLOCATE ORDERS_CURSOR

--5.	Разработать статический курсор, который выводит сведения о покупателях и их заказах.
--STATIC Указывает, что курсор всегда отображает результирующий набор в том виде, который он имел на момент первого открытия курсора,
--и создает временную копию данных, предназначенную для использования курсором. 
--Все запросы к курсору обращаются к этой временной таблице в базе данных tempdb.
SELECT * FROM CUSTOMERS
SELECT * FROM ORDERS

DECLARE 
	@message2 VARCHAR(80),
	@cust_num2 INT, 
	@company2 VARCHAR(15), 
	@cust_rep2 INT,
    @credit_limit2 DECIMAL(8, 2),
	@ORDER_PRODUCT VARCHAR(30)

DECLARE CUST_CURSOR CURSOR STATIC
FOR SELECT C.CUST_NUM, C.COMPANY, C.CUST_REP, C.CREDIT_LIMIT,
			O.PRODUCT
FROM CUSTOMERS C LEFT JOIN ORDERS O
ON C.CUST_NUM = O.CUST

OPEN CUST_CURSOR

FETCH FROM CUST_CURSOR INTO @cust_num2, @company2, @cust_rep2, @credit_limit2, @ORDER_PRODUCT
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message2 = cast(@cust_num2 as varchar(20)) + '|||' + @company2 + '|||' + cast(@cust_rep2 as varchar(20)) + '|||' +
      cast(@credit_limit2 as varchar(10)) +'|||'+ @ORDER_PRODUCT
   PRINT @message2 
   FETCH FROM CUST_CURSOR INTO @cust_num2, @company2, @cust_rep2, @credit_limit2, @ORDER_PRODUCT
   --PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END

CLOSE CUST_CURSOR 
DEALLOCATE CUST_CURSOR

6.	Разработать динамический курсор, который обновляет данные о сотруднике в зависимости от суммы выполненных заказов (поле SALES).
select *
from salesreps

DECLARE @NAME VARCHAR(50),  @TITLE VARCHAR(80), @SALES INT
 
DECLARE UPDATE_CURSOR CURSOR DYNAMIC FOR  ----DYNAMIC Определяет курсор, который отображает все изменения данных, сделанные в строках результирующего набора
    SELECT  NAME, TITLE, SALES 
	FROM SALESREPS 

OPEN UPDATE_CURSOR 
  
  FETCH FROM UPDATE_CURSOR INTO  @NAME, @TITLE, @SALES
  WHILE @@FETCH_STATUS = 0 
     BEGIN 
		IF @SALES > 30000 UPDATE SALESREPS SET TITLE = 'NOTFORSALE' 
			WHERE CURRENT OF UPDATE_CURSOR
		FETCH FROM UPDATE_CURSOR INTO @NAME, @TITLE, @SALES
		PRINT @SALES
		PRINT @NAME
     END 

CLOSE UPDATE_CURSOR
DEALLOCATE UPDATE_CURSOR

--------------------------------------------------------
--------------------------------------------------------
SELECT * FROM ORDERS
SELECT * FROM SALESREPS

DECLARE 
	@REP INT, 
	@SALES DECIMAL(9, 2),
	@SHOW_TO_DISPLAY VARCHAR(400),
	@MOHRE INT

DECLARE UPDATE_CURSOR CURSOR LOCAL DYNAMIC   --DYNAMIC Определяет курсор, который отображает все изменения данных, сделанные в строках результирующего набора
	FOR	SELECT REP, SUM(AMOUNT) AS SUM_AOUNT, AMOUNT 
	FROM ORDERS
	GROUP BY REP, AMOUNT
	
OPEN UPDATE_CURSOR;

FETCH FROM UPDATE_CURSOR INTO @REP, @SALES, @MOHRE
	--WHILE @@FETCH_STATUS = 0		--КОНТРОЛЬ ДОСТИЖЕНИЯ КОНЦА КУРСОРА - ЕСЛИ 0, ТО ВЫБОРКА ПРОШЛА УСПЕШНО
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @MOHRE > 30000 
	UPDATE ORDERS SET ORDER_NUM = NULL
	WHERE CURRENT OF UPDATE_CURSOR;
	--UPDATE SALESREPS SET SALES = @SALES
	--WHERE EMPL_NUM=@REP
	--SELECT @SHOW_TO_DISPLAY = CAST(@REP AS VARCHAR(20))+'-----'+ CAST(@SALES AS VARCHAR(20))
	--PRINT @SHOW_TO_DISPLAY
	FETCH FROM UPDATE_CURSOR INTO @REP, @SALES, @MOHRE
END

CLOSE UPDATE_CURSOR
DEALLOCATE UPDATE_CURSOR

SELECT * FROM ORDERS WHERE REP=101

--7.	Продемонстрировать свойства SCROLL.
DECLARE SCROLL_CURSOR CURSOR SCROLL --CERSOR SCROLL - ЭТО КУРСОР ПРОКРУТКИ ОН ПОЗВОЛЯЕТ ПЕРЕМЕЩАТЬСЯ ПО СТРОКАМ РЕЗУЛЬТАТА
	FOR SELECT * FROM OFFICES;

OPEN SCROLL_CURSOR
	
	FETCH LAST FROM SCROLL_CURSOR			--выбирает последнюю строку из набора результатов курсора
	FETCH PRIOR FROM SCROLL_CURSOR			--выборка предыдущей строки с текущей позиции курсора
	FETCH ABSOLUTE 8 FROM SCROLL_CURSOR		--извлекает n- ю строку из первой позиции курсора
	FETCH FIRST FROM SCROLL_CURSOR			--выбирает первую строку / запись из набора результатов курсора
	FETCH RELATIVE 4 FROM SCROLL_CURSOR		--выбирает n- ю строку из текущей позиции курсора
CLOSE SCROLL_CURSOR
DEALLOCATE SCROLL_CURSOR
