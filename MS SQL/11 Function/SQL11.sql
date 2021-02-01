-- Задание 1. Для базы данных «Спортивный магазин» из
-- практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие
-- пользовательские функции:

/*
use master
go

create database Sport_Shop
go
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

alter table Sells
add foreign key (sold_good_id) references Goods(id),
    foreign key (seller_id) references Employers(id),
    foreign key (buyer_id) references Clients(id)
go*/

use Sport_Shop
go

-- 1. Пользовательская функция возвращает количество уникальных покупателей

CREATE FUNCTION Get_Unique_Clients(@count int)
RETURNS int
AS
BEGIN
    DECLARE @count int;
    SET @count = (SELECT COUNT(Clients.id) FROM Clients);
     IF (@count IS NULL)
        SET @count = 0;
    RETURN @count;
END;

-- 2. Пользовательская функция возвращает среднюю цену товара конкретного вида. Вид товара передаётся в качестве
-- параметра. Например, среднюю цену обуви

CREATE FUNCTION Get_Average_Selling_Price(@type nvarchar(40))
RETURNS money
AS
BEGIN
    DECLARE @avg_price money;
    SET @avg_price = (SELECT AVG(selling_price) FROM Goods
        WHERE type = @type);
     IF (@avg_price IS NULL)
        SET @avg_price = 0;
    RETURN @avg_price;
END;

EXEC Get_Average_Selling_Price 'MyHat'
-- 3. Пользовательская функция возвращает среднюю цену
-- продажи по каждой дате, когда осуществлялись продажи

CREATE FUNCTION Get_Average_Selling_Price_On_Date(@date date)
RETURNS money
AS
BEGIN
    DECLARE @avg_price money;
    SET @avg_price = (SELECT AVG(selling_price) FROM Goods
        INNER JOIN Sells S on Goods.id = S.sold_good_id
        WHERE sold_date = @date);
     IF (@avg_price IS NULL)
        SET @avg_price = 0;
    RETURN @avg_price;
END;

-- 4. Пользовательская функция возвращает информацию о последнем проданном товаре. Критерий определения последнего проданного товара: дата продажи

CREATE FUNCTION Last_Selling_Info()
RETURNS TABLE
AS
 RETURN
 (
  SELECT G.name, G.type, G.quantity, G.production_price, G.selling_price, G.manufacturer FROM Goods G
    INNER JOIN Sells S on G.id = S.sold_good_id
    HAVING sold_date = MAX(sold_date)
 )
-- 5. Пользовательская функция возвращает информацию о первом проданном товаре. Критерий определения первого
-- проданного товара: дата продажи

CREATE FUNCTION First_Selling_Info()
RETURNS TABLE
AS
 RETURN
 (
  SELECT G.name, G.type, G.quantity, G.production_price, G.selling_price, G.manufacturer FROM Goods G
    INNER JOIN Sells S on G.id = S.sold_good_id
    HAVING sold_date = MIN(sold_date)
 )

-- 6. Пользовательская функция возвращает информацию о заданном виде товаров конкретного производителя. Вид
-- товара и название производителя передаются в качестве
-- параметров

CREATE FUNCTION Get_Specific_Data_On_Goods(@type nvarchar(40), @manufacturer nvarchar(50))
RETURNS TABLE
AS
RETURN (
    SELECT G.name, G.type, G.quantity, G.production_price, G.selling_price, G.manufacturer FROM Goods G
    WHERE type = @type AND manufacturer = @manufacturer
)

-- 7. Пользовательская функция возвращает информацию о покупателях, которым в этом году исполнится 45 лет

-- alter table Clients
-- 	add born_date date
-- go

CREATE FUNCTION Get_Info_On_Old_Clients()
RETURNS TABLE
AS
RETURN (
    SELECT id, name, email, phone, gender, orders_history, discount, subscribed, reg_date, born_date FROM Clients
    WHERE DATEDIFF(year, born_date, GETDATE()) = 45
)

-- Задание 2. Для базы данных «Музыкальная коллекция» из
-- практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие пользовательские функции:

/*use master
go
create database Music_Collection
go
use Music_Collection
go
 create table Music_Disk
(
    music_disk_id int primary key identity,
    name nvarchar(30),
    release_date date,
    genre_id int,
    singer_id int,
    publisher_id int,
)
go

create table Genre
(
    genre_id int primary key identity,
    name nvarchar(20)
)
go

create table Publisher
(
    publisher_id int primary key identity,
    name nvarchar(30),
    country nvarchar(20)
)
go

create table Singer
(
    singer_id int primary key identity,
    name nvarchar(50)
)
go

create table Song
(
    song_id int primary key identity,
    name nvarchar(30),
    duration time,
    disk_id int,
    genre_id int,
    singer_id int
)

create table Album
    (
        id int primary key identity,
        name nvarchar(40)
)


alter table Music_Disk
add foreign key (genre_id) references Genre(genre_id),
 foreign key (singer_id) references Singer(singer_id),
 foreign key (publisher_id) references Publisher(publisher_id)
go

alter table Song
add foreign key (disk_id) references Music_Disk(music_disk_id),
    foreign key (genre_id) references Genre(genre_id),
    foreign key (singer_id) references Singer(singer_id)
go

alter table Music_Collection.dbo.Music_Disk
add foreign key (album_id) references Album(id)

use Music_Collection
go
*/

use Music_Collection
go
-- 1. Пользовательская функция возвращает все диски заданного
-- года. Год передаётся в качестве параметра

CREATE FUNCTION Get_Specific_Year_Disks(@date date)
RETURNS TABLE
    AS RETURN
    (
        SELECT music_disk_id, name, release_date FROM Music_Disk
        WHERE release_date = @date
        )

-- 2. Пользовательская функция возвращает информацию
-- о дисках с одинаковым названием альбома, но разными
-- исполнителями

CREATE FUNCTION Get_Specific_Album_Disks()
RETURNS TABLE
    AS RETURN
    (
        SELECT music_disk_id, Music_Disk.name, release_date FROM Music_Disk
        INNER JOIN Album A on A.id = Music_Disk.album_id
        FULL OUTER JOIN Singer S on S.singer_id = Music_Disk.singer_id
        )

-- 3. Пользовательская функция возвращает информацию о всех
-- песнях в чьем названии встречается заданное слово. Слово
-- передаётся в качестве параметра

CREATE FUNCTION Get_Songs_By_Name (@name nvarchar(20))
RETURNS TABLE
    AS RETURN
    (
        SELECT S.name, S.duration FROM Song S
        WHERE name LIKE @name
    )

-- 4. Пользовательская функция возвращает количество альбомов в стилях hard rock и heavy metal

CREATE FUNCTION Return_Hard_Rock_Album_Count ()
RETURNS int
AS
BEGIN
    DECLARE @counter int
    SET @counter = (SELECT COUNT(music_disk_id) FROM Music_Disk
        INNER JOIN Genre G on G.genre_id = Music_Disk.genre_id
        WHERE G.name = 'Hard Rock' OR G.name = 'Heavy Metal');
     IF (@counter IS NULL)
        SET @counter = 0;
    RETURN @counter;
END;

-- 5. Пользовательская функция возвращает информацию о средней длительности песни заданного исполнителя. Название
-- исполнителя передаётся в качестве параметра

CREATE FUNCTION Return_Hard_Rock_Album_Count (@singer_name nvarchar(50))
RETURNS time
AS
BEGIN
    DECLARE @avg time
    SET @avg = (SELECT AVG(duration) FROM Song
        INNER JOIN Singer S on S.singer_id = Song.singer_id
        WHERE S.name = @singer_name);
     IF (@avg IS NULL)
         PRINT 'No Such Artist'
        SET @avg = 0;
    RETURN @avg;
END;

-- 6. Пользовательская функция возвращает информацию о самой долгой и самой короткой песне

CREATE FUNCTION Get_Info_About_Most_Short_And_Long_Song ()
RETURNS TABLE
    AS RETURN
(
    SELECT S.name, S.duration FROM Song S
    GROUP BY S.name, S.duration
    HAVING S.duration = MAX(S.duration) AND S.duration = MAX(S.duration)
)

SELECT * FROM Get_Info_About_Most_Short_And_Long_Song()

-- 7. Пользовательская функция возвращает информацию об
-- исполнителях, которые создали альбомы в двух и более
-- стилях.

CREATE FUNCTION Get_Singers_With_Different_Styles()
RETURNS TABLE
    AS RETURN
    (
        SELECT S.name, MD.name, MD.release_date FROM Singer S
        INNER JOIN Music_Disk MD on S.singer_id = MD.singer_id
        INNER JOIN Genre G on G.genre_id = MD.genre_id
        HAVING COUNT(DISTINCT G.genre_id) > 1
    )