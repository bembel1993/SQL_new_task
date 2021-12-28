CREATE TABLE Препод
     (Ном_Преп integer NOT NULL,
		ФИО CHAR(20) NOT NULL,
		Стаж INTEGER NOT NULL,
 PRIMARY KEY (Ном_Преп));

INSERT INTO Препод VALUES(11, 'Иванов И.И.', 20);
INSERT INTO Препод VALUES(12, 'Астахов А.А.', 30);
INSERT INTO Препод VALUES(13, 'Евстафьева Е.И.',10);
INSERT INTO Препод VALUES(14, 'Зверева Л.Г.', 5);
INSERT INTO Препод VALUES(15, 'Мирский В.В.', 10);
----------------
CREATE TABLE Предмет
   (ID_Предмет INT NOT NULL,
             CHECK (ID_Предмет BETWEEN 101 AND 199),
        Название VARCHAR(20) NOT NULL,
         Кл_лаб INTEGER,
		Кл_лк INTEGER,
 PRIMARY KEY (ID_Предмет));

INSERT INTO Предмет VALUES(101, 'Математика',58, 60);
INSERT INTO Предмет VALUES(102, 'Английский',48, 50);
INSERT INTO Предмет VALUES(103, 'Русский',60, 60);
INSERT INTO Предмет VALUES(104, 'Химия',38, 30);
INSERT INTO Предмет VALUES(105, 'Информатика',28, 20);
--------------------------
CREATE TABLE Тип_з
   (Тип INTEGER    NOT NULL,
    Тип_занятий VARCHAR(20) NOT NULL,
    Сумма_к_оплате INTEGER,
 PRIMARY KEY (Тип));

INSERT INTO Тип_з VALUES(1, 'Заочно',2000);
INSERT INTO Тип_з VALUES(2, 'Очно',2500);
-----------------------------
CREATE TABLE Пов_кв
  (ID_зан INTEGER NOT NULL,
       Наз_предмета varchar(20),      
  Нач_зан DATE NOT NULL,
  Ок_зан DATE NOT NULL,
        ID_Тип INTEGER NOT NULL,
         Ном_Предмета INTEGER,
		 Имя_преп VARCHAR(40),
         ID_Преп INTEGER NOT NULL,
 PRIMARY KEY (ID_зан),
 FOREIGN KEY (ID_Тип)
  REFERENCES Тип_з(Тип),
 FOREIGN KEY (Ном_Предмета)
  REFERENCES Предмет(ID_Предмет),
 FOREIGN KEY (ID_Преп)
  REFERENCES Препод(Ном_Преп));

INSERT INTO Пов_кв VALUES(101, 'Математика', '2007-08-17', '2007-12-17', 1, 101, 'Иванов И.И.',11);
INSERT INTO Пов_кв VALUES(102, 'Английский', '2007-08-17', '2007-12-17', 2, 102, 'Астахов А.А.',12);
INSERT INTO Пов_кв VALUES(103, 'Русский', '2007-08-17', '2007-12-17', 1, 103, 'Евстафьева Е.И.',13);
INSERT INTO Пов_кв VALUES(104, 'Химия', '2007-08-17', '2007-12-17', 1, 104, 'Зверева Л.Г.',14);
INSERT INTO Пов_кв VALUES(105, 'Информатика', '2007-08-17', '2007-12-17', 2, 105, 'Мирский В.В.',15);

UPDATE Пов_кв SET ID_зан=108 WHERE ID_зан = 104;
UPDATE Предмет SET Название = 'PROGRAMMING' WHERE Название = 'ХИМИЯ';
delete Пов_кв WHERE ID_зан = 108;

select ID_зан, Наз_предмета 
from Пов_кв
where Наз_предмета like 'Анг%';

select * from Предмет
SELECT * FROM Пов_кв
SELECT * FROM Препод
SELECT * FROM Тип_з