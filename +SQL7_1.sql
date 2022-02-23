--1.Разработать скрипт, демонстрирующий работу в режиме неявной транзакции.
--Неявная транзакция - задает любую отдельную инструкцию INSERT, UPDATE или DELETE как единицу транзакции.
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
    IF (@@ERROR <> 0) --@@error-глобальная переменная
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

--2.Разработать скрипт, демонстрирующий свойства ACID явной транзакции. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--ACID (Atomicity - атомарность, consistency - консистентность, isolation - изолированность, durability - стойкость) 
--это стандартный набор свойств, которые гарантируют, надежность транзакции.
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
        ERROR_NUMBER() AS ErrorNumber,		--Возвращает номер ошибки
        ERROR_SEVERITY() AS ErrorSeverity,  --Возвращает значение серьезности ошибки
        ERROR_STATE() AS ErrorState,		--Возвращает номер состояния для ошибки
        ERROR_PROCEDURE() AS ErrorProcedure,--Возвращает имя хранимой процедуры или триггера  
        ERROR_LINE() AS ErrorLine,			--Возвращает номер строки, в которой произошла ошибка,
        ERROR_MESSAGE() AS ErrorMessage		--Возвращает текст сообщения об ошибке
    IF @@TRANCOUNT > 0						--Возвращает количество операторов BEGIN TRANSACTION, которые произошли в текущем соединении.
        ROLLBACK TRANSACTION;  
END CATCH  
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
SELECT * FROM OFFICES
SELECT * FROM SALESREPS

--3.Разработать скрипт, демонстрирующий применение оператора SAVETRAN. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
SELECT * FROM CUSTOMERS

BEGIN TRY
BEGIN TRAN FIRST_ONE
	INSERT INTO CUSTOMERS
		VALUES (3333, 'NOKIA', 107, 100000.00)
		SAVE TRAN FIRSTCUST --Устанавливает точку сохранения внутри транзакции.
	UPDATE CUSTOMERS
		SET COMPANY = 'APPLE'
		WHERE CUST_NUM = 3333
		ROLLBACK TRAN FIRSTCUST
COMMIT TRAN FIRST_ONE
END TRY
BEGIN CATCH
	SELECT 'ERROR'
END CATCH

--4.Разработать два скрипта A и B. Продемонстрировать неподтвержденное, неповторяющееся и 
--фантомное чтение. Показать усиление уровней изолированности. -УРОВЕНЬ ИЗОЛЯЦИИ ЗАДАЕТ ЗАЩИЩЕННОСТЬ ДАННЫХ В ТРАНЗАКЦИИ
-- НЕПОВТОРЯЮЩЕЕСЯ ЧТЕНИЕ - ЭТО КОГДА Один процесс считывает данные несколько раз, а другой процесс 
							--изменяет эти данные между двумя операциями чтения первого процесса. Значение двух чтений будет разное.
--ФАНТОМНОЕ ЧТЕНИЕ - Последовательные операции чтения могут возвратить разные значения
					--Считывание разного числа строк при каждом чтении
					--Возникают дополнительные фантомные строки, которые вставляются другими транзакциями
					--Значения двух чтений будут разными
--НЕПОДТВЕРЖДЕННОЕ ЧТЕНИЕ - ГРЯЗНОЕ ЧТЕНИЕ -ЧТЕНИЕ НЕПОДТВЕРЖДЕННЫХ ДАННЫХ
--READ UNCOMMITED Не изолирует операции чтения других транзакций
--Транзакция не задает и не признает блокировок
--Допускает проблемы:
--------------------------------------------------------------------
--Грязное чтение - чтение данных, добавленных или измененных транзакцией, которая впоследствии не подтвердится (откатится).
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
--Неповторяемое чтение - при повторном чтении в рамках одной транзакции ранее прочитанные данные оказываются измененными.
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
--Фантомное чтение - при повторном чтении в рамках одной транзакции одна и та же выборка дает разные множества строк.
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
--Чтение незафиксированным READ-UNCOMMITTED | 0: Есть проблемы с грязным чтением, неповторяющимся чтением и фантомным чтением
--INSERT INTO CUSTOMERS VALUES (1111, 'CORPORATION', 110, 72000.00);

--Чтение отправлено READ-COMMITTED | 1: Решить проблему грязных чтений, есть неповторяющиеся чтения, фантомные чтения

--Повторяемое чтение REPEATABLE-READ | 2: Решить проблему грязного чтения, неповторяемого чтения, фантомного чтения, 
--уровня изоляции по умолчанию, использовать механизм MMVC для достижения повторного чтения

--Сериализация SERIALIZABLE | 3: Решить грязные чтения, неповторяющиеся чтения, фантомные чтения, могут обеспечить 
--безопасность транзакций, но завершить последовательное выполнение, самая низкая производительность
--1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- QTY ROWS

--SELECT * FROM CUSTOMERS
--2
BEGIN TRAN  -- открываем параллельную транзакцию - ВСЕ ПАРАЛЛЕЛЬНЫЕ ТРАНЗАКЦИИ ОТДЕЛЕНЫ ДРУГ ОТ ДРУГА
DELETE FROM CUSTOMERS WHERE CUST_NUM = 3333 -- удаляем строку из таблицы
--3
SELECT COUNT(*) FROM CUSTOMERS -- Результат: , неподтвержденное чтение
SELECT * FROM CUSTOMERS
--4
ROLLBACK TRAN -- откатываем транзакцию
--5
SELECT COUNT(*) FROM CUSTOMERS -- Результат: , после отката транзакции В
COMMIT TRAN
----- Покажем, что уровень изолированности READ COMMITTED не допускает неподтвержденное чтение
--RED COMMITED 
--Транзакция выполняет проверку только на наличие монопольной блокировки для данной строки
--Является уровнем изоляции по умолчанию
--Проблемы:
--Неповторяемое чтение
--Фантомное чтение 
-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- запускаем транзакцию, Результат: 
 
--  8
SELECT COUNT(*) FROM CUSTOMERS -- Результат: ожидание, неподтвержденного чтения нет
 
-- 10
SELECT COUNT(*) FROM CUSTOMERS -- сразу после отката транзакции 
--COMMIT TRAN
--- 7
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM CUSTOMERS WHERE CUST_NUM=1111 -- удаляем строку из таблицы

--- 9
ROLLBACK TRAN -- откатываем транзакцию
-------------------------------------------------------
--НЕПОВТОРЯЮЩЕЕСЯ ЧТЕНИЕ
--ЭТО КОГДА Один процесс считывает данные несколько раз, а другой процесс 
--изменяет эти данные между двумя операциями чтения первого процесса. Значение двух чтений будет разное.
--11
SELECT * FROM OFFICES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES
-- 12
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE CITY = 'MOSCOW' -- удаляем строку из таблицы
COMMIT TRAN

-- 13
SELECT COUNT(*) FROM OFFICES -- Результат: 
-- пока вторая транзакция удаляла запись, данные дважды прочитались по-разному.
COMMIT TRAN
----- Покажем, что уровень изолированности REPEATABLE READ не допускает неповторяющееся чтение
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- вернем запись
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат: 17
--- 15
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE = 26 -- удаляем строку из таблицы, результат - ожидание
-- 16
COMMIT TRAN -- сразу после фиксации транзакции А в окне В 
--- Строк обработано:1 - прошло выполнение оператора удаления
--- 17
COMMIT TRAN -- завершаем транзакцию
-----------------------------
SELECT * FROM CUSTOMERS


/*SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM OFFICES -- A: 
 
SELECT * FROM OFFICES -- B: 
COMMIT TRAN*/

--5.	Разработать скрипт, демонстрирующий свойства вложенных транзакций. 
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