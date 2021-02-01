-- use master
-- go
--
-- create database Sport_Shop
-- go

use Sport_Shop
go
/*Задание 1. Создайте базу данных «Спортивный магазин».
Эта база данных должна содержать информацию о товарах,
продажах, сотрудниках, клиентах. Необходимо хранить
следующую информацию:
1. О товарах: название товара, вид товара (одежда, обувь,
и т.д.), количество товара в наличии, себестоимость, производитель, цена продажи
2. О продажах: название проданного товара, цена продажи, количество, дата продажи, информация о продавце
(ФИО сотрудника, выполнившего продажу), информация
о покупателе (ФИО покупателя, если купил зарегистрированный покупатель)
3. О сотрудниках: ФИО сотрудника, должность, дата приёма
на работу, пол, зарплата
4. О клиентах: ФИО клиента, email, контактный телефон,
пол, история заказов, процент скидки, подписан ли на
почтовую рассылку.*/

create table Goods
(
    id int primary key identity,
    name nvarchar(50),
    type nvarchar(40),
    quantity int,
    production_price money, 
    selling_price money, 
    manufacturer nvarchar(50)
)
go

create table Sells
(
    id int primary key identity,
    sold_good_id int,
    seller_id int,
    buyer_id int,
    sold_date date,
    quantity int,
    sold_price int
)
go


create table Employers
(
    id int primary key identity,
    name nvarchar(50),
    position nvarchar(50),
    enroll_date date,
    gender nvarchar (10),
    salary money,
)
go

create table Clients
(
    id int primary key identity,
    name nvarchar(50),
    email nvarchar(50),
    phone nvarchar(30),
    gender nvarchar(10),
    reg_date date,
    discount float,
    subscribed bit,
)
go

-- ALTER TABLE Clients
-- ADD reg_date date


alter table Sells
add foreign key (sold_good_id) references Goods(id),
    foreign key (seller_id) references Employers(id),
    foreign key (buyer_id) references Clients(id)
go


-- Задание 1. Для базы данных «Спортивный магазин» из
-- практического задания модуля «Триггеры, хранимые про-
-- цедуры и пользовательские функции» создайте следующие
-- хранимые процедуры:


-- 1. Хранимая процедура отображает полную информацию
-- о всех товарах

CREATE PROCEDURE Full_Goods_Info AS
BEGIN
    SELECT * FROM Goods
END;

EXEC Full_Goods_Info

-- 2. Хранимая процедура показывает полную информацию
-- о товаре конкретного вида. Вид товара передаётся в ка-
-- честве параметра. Например, если в качестве параметра
-- указана обувь, нужно показать всю обувь, которая есть
-- в наличии

CREATE PROCEDURE Specific_Type_Goods_Info
    @type NVARCHAR(40) AS
BEGIN
    SELECT * FROM Goods
    WHERE type LIKE @type;
END;

EXEC Specific_Type_Goods_Info "Shoes"
EXEC Specific_Type_Goods_Info "Hat"

-- 3. Хранимая процедура показывает топ-3 самых старых кли-
-- ентов. Топ-3 определяется по дате регистрации

 /*    О клиентах: ФИО клиента, email, контактный телефон,
пол, история заказов, процент скидки, подписан ли на
почтовую рассылку.*/
    -- В описании такого поля нет. Поэтому я создам его сам.

CREATE PROCEDURE Top_Three_Most_Older_Clients AS
BEGIN
    SELECT Clients.name FROM Clients
    WHERE Clients.reg_date IS NOT NULL
    AND Clients.reg_date = (
    SELECT TOP 3 Clients.reg_date
    FROM Clients
    WHERE Clients.reg_date IS NOT NULL
    ORDER BY Clients.reg_date
)
GROUP BY Clients.name, Clients.reg_date
ORDER BY Clients.reg_date
END;

drop procedure Top_Three_Most_Older_Clients
EXEC Top_Three_Most_Older_Clients

-- 4. Хранимая процедура показывает информацию о самом
-- успешном продавце. Успешность определяется по общей
-- сумме продаж за всё время

CREATE PROCEDURE Most_Efficient_Employee AS
BEGIN
    SELECT TOP 1 E.Name FROM Employers E
    FULL OUTER JOIN Sells S ON E.id = S.seller_id
    ORDER BY SUM(S.sold_price ON S.seller_id = E.id)
END;

-- EXEC Most_Efficient_Employee
-- DROP PROCEDURE Most_Efficient_Employee

-- 5. Хранимая процедура проверяет есть ли хоть один товар
-- указанного производителя в наличии. Название произво-
-- дителя передаётся в качестве параметра. По итогам работы
-- хранимая процедура должна вернуть yes в том случае, если
-- товар есть, и no, если товара нет

CREATE PROCEDURE Boolean_Check_Type
    @type NVARCHAR(40) AS
BEGIN
    SELECT G.type FROM Goods G
   IF Sport_Shop.dbo.Goods.type = @type
       PRINT 'Yes';
ELSE
       PRINT 'No';
END;

EXEC Specific_Type_Goods_Info "Shoes"
EXEC Specific_Type_Goods_Info "Hat"

-- 6. Хранимая процедура отображает информацию о самом по-
-- пулярном производителе среди покупателей. Популярность
-- среди покупателей определяется по общей сумме продаж

CREATE PROCEDURE Most_Popular_Manufacturer AS
SELECT G.manufacturer, SUM(sold_price) AS 'Total Sells Sum' FROM Goods G
    INNER JOIN Sells S2 on G.id = S2.sold_good_id
    INNER JOIN Clients C on S2.buyer_id = C.id
    GROUP BY G.manufacturer
    ORDER BY 2 DESC;
EXEC Most_Popular_Manufacturer
DROP PROCEDURE Most_Popular_Manufacturer

-- 7. Хранимая процедура удаляет всех клиентов, зарегистриро-
-- ванных после указанной даты. Дата передаётся в качестве
-- параметра. Процедура возвращает количество удаленных
-- записей.

CREATE PROCEDURE Delete_Clients_After_A_Date
    @date date AS
BEGIN
    DELETE FROM Clients
    WHERE reg_date = @date
    RETURN @@ROWCOUNT
END
EXEC Delete_Clients_After_A_Date '2020-04-02'
DROP PROCEDURE Delete_Clients_After_A_Date

/*Задание 2. Для базы данных «Музыкальная коллекция» из
практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые
процедуры:*/

-- use master
-- go
-- create database Music_Collection
-- go
-- use Music_Collection
-- go
--  create table Music_Disk
-- (
--     music_disk_id int primary key identity,
--     name nvarchar(30),
--     release_date date,
--     genre_id int,
--     singer_id int,
--     publisher_id int,
-- )
-- go
--
-- create table Genre
-- (
--     genre_id int primary key identity,
--     name nvarchar(20)
-- )
-- go
--
-- create table Publisher
-- (
--     publisher_id int primary key identity,
--     name nvarchar(30),
--     country nvarchar(20)
-- )
-- go
--
-- create table Singer
-- (
--     singer_id int primary key identity,
--     name nvarchar(50)
-- )
-- go
--
-- create table Song
-- (
--     song_id int primary key identity,
--     name nvarchar(30),
--     duration time,
--     disk_id int,
--     genre_id int,
--     singer_id int
-- )
--
-- alter table Music_Disk
-- add foreign key (genre_id) references Genre(genre_id),
--  foreign key (singer_id) references Singer(singer_id),
--  foreign key (publisher_id) references Publisher(publisher_id)
-- go
--
-- alter table Song
-- add foreign key (disk_id) references Music_Disk(music_disk_id),
--     foreign key (genre_id) references Genre(genre_id),
--     foreign key (singer_id) references Singer(singer_id)
-- go



use Music_Collection
go

-- 1. Хранимая процедура показывает полную информацию
-- о музыкальных дисках

CREATE PROCEDURE Show_Full_Info_About_Disk AS
    SELECT MD.name, MD.release_date, G.name, S.name, P.name, P.country FROM Music_Disk MD
    INNER JOIN Genre G on MD.genre_id = G.genre_id
    INNER JOIN Publisher P on P.publisher_id = MD.publisher_id
    INNER JOIN Singer S on S.singer_id = MD.singer_id
EXEC Show_Full_Info_About_Disk
DROP PROCEDURE Show_Full_Info_About_Disk

-- 2. Хранимая процедура показывает полную информацию
-- о всех музыкальных дисках конкретного издателя. Название издателя передаётся в качестве параметра

CREATE PROCEDURE Specific_Publisher_Info
    @name NVARCHAR(30) AS
BEGIN
    SELECT P.name, M.name, M.release_date FROM Publisher P
    INNER JOIN Music_Disk M on P.publisher_id = M.publisher_id
    WHERE P.name = @name;
END;

-- 3. Хранимая процедура показывает название самого популярного стиля

CREATE PROCEDURE Show_Most_Popular_Style AS
    SELECT TOP 1 G.name, COUNT(M.genre_id) FROM Genre G
    INNER JOIN Music_Disk M on G.genre_id = M.genre_id
    GROUP BY G.name
    ORDER BY G.name DESC;

-- 4. Популярность стиля определяется по количеству дисков
-- в коллекции

CREATE PROCEDURE Show_Most_Popular_Style AS
    SELECT TOP 1 G.name, COUNT(M.music_disk_id) FROM Genre G
    INNER JOIN Music_Disk M on G.genre_id = M.genre_id
    GROUP BY G.name
    ORDER BY G.name DESC;

-- 5. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен. Название
-- стиля передаётся в качестве параметра, если передано слово
-- all, анализ идёт по всем стилям

CREATE PROCEDURE Show_Specific_Style
    @genre as nvarchar(20) AS
    BEGIN
      SELECT G.name, M.name, M.release_date, COUNT(S.disk_id) FROM Music_Disk M
        INNER JOIN Song S on M.music_disk_id = S.disk_id
        INNER JOIN Genre G on G.genre_id = M.genre_id
        WHERE G.name = @genre
        GROUP BY G.name, M.name, M.release_date
    END;

-- 6. Хранимая процедура удаляет все диски заданного стиля.
-- Название стиля передаётся в качестве параметра. Процедура
-- возвращает количество удаленных альбомов

CREATE PROCEDURE Delete_Selected_Genre
    @genre as nvarchar(20) AS
    BEGIN
    DELETE Music_Disk FROM Music_Disk
    INNER JOIN Genre G2 on G2.genre_id = Music_Disk.genre_id
    WHERE G2.name = @genre
    PRINT @@ROWCOUNT
    END;

    EXEC Delete_Selected_Genre 'Metal'
    DROP PROCEDURE Delete_Selected_Genre

-- 7. Хранимая процедура отображает информацию о самом
-- «старом» альбом и самом «молодом». Старость и молодость
-- определяются по дате выпуска

CREATE PROCEDURE Show_Most_Recent_And_Most_Old_Disk AS
    SELECT TOP 1 M.name, MIN(M.release_date)  FROM Music_Disk M
    UNION
    SELECT TOP 1M.name, MAX(M.release_date) FROM Music_Disk M;

-- 8. Хранимая процедура удаляет все диски в названии которых есть заданное слово. Слово передаётся в качестве
-- параметра. Процедура возвращает количество удаленных
-- альбомов. 

CREATE PROCEDURE Delete_Music_Disk_By_Name_Keyword
    @name as nvarchar(30),
    @id INT OUTPUT AS
    BEGIN
    DELETE Music_Disk FROM Music_Disk
    WHERE Music_Disk.name LIKE @name
    SET @id = @@rowcount
    --PRINT @@ROWCOUNT
    --RETURN @@ROWCOUNT
    END;

    DECLARE @deleted INT
    EXEC Delete_Music_Disk_By_Name_Keyword 'Hell', @deleted
    PRINT @deleted
    DROP PROCEDURE Delete_Music_Disk_By_Name_Keyword