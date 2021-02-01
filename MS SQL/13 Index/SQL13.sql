-- Задание 1. Для базы данных «Спортивный магазин» из
-- практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» выполните действия:

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

-- 1. Создайте набор clustered (кластеризованных) индексов для
-- тех таблиц, где это необходимо

CREATE CLUSTERED INDEX PK__Goods__3213E83FBBD6F00D
    ON Goods (id);
GO

-- 2. Создайте набор nonclustered (некластеризованных) индексов
-- для тех таблиц, где это необходимо

CREATE NONCLUSTERED INDEX PK__Quantity
    ON Goods (quantity);
GO

CREATE NONCLUSTERED INDEX PK__Salary
    ON Employers (salary);
GO

-- 3. Решите нужны ли вам composite (композитные) индексы с
-- учетом структуры базы данных и запросов. Если да, создайте индексы

CREATE INDEX PK__Composite ON Clients(name,phone);

-- 4. Решите нужны ли вам indexes with included columns (индексы с включенными столбцами). Учитывайте структуру
-- базы данных и запросов. Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX WebSite ON Clients
(
	email ASC
)
INCLUDE (subscribed, reg_date, orders_history) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


-- 5. Решите нужны ли вам filtered indexes (отфильтрованные
-- индексы). Учитывайте структуру базы данных и запросов. Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX QuantitySells
    ON Sells (quantity, sold_price)
    WHERE quantity IS NOT NULL ;


-- 6. Проверьте execution plans (планы выполнения) для наиболее
-- важных запросов с точки зрения частоты их использования.

SET SHOWPLAN_XML ON

SELECT *
  FROM Goods
  WHERE type IS NULL

-- Если найдено слабое место по производительности, попробуйте решить возникшую проблему с помощью создания
-- новых индексов.


-- Задание 2. Для базы данных «Музыкальная коллекция» из
-- практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» выполните действия:

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

-- 1. Создайте набор clustered (кластеризованных) индексов для тех таблиц, где это необходимо

-- на каждой таблице есть

-- 2. Создайте набор nonclustered (некластеризованных) индексов
-- для тех таблиц, где это необходимо

CREATE NONCLUSTERED INDEX PK__Singer
    ON Singer (name);
GO

CREATE NONCLUSTERED INDEX PK__Album
    ON Album (name);
GO

-- 3. Решите нужны ли вам composite (композитные) индексы
-- с учетом структуры базы данных и запросов. Если да, создайте индексы

CREATE INDEX PK__Publisher ON Publisher(name,country);

-- 4. Решите нужны ли вам indexes with included columns (индексы с включенными столбцами). Учитывайте структуру
-- базы данных и запросов. Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX MusicInfo ON Music_Disk
(
	name ASC
)
INCLUDE (release_date) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- 5. Решите нужны ли вам filtered indexes (отфильтрованные
-- индексы). Учитывайте структуру базы данных и запросов.
-- Если необходимость есть, создайте индексы

CREATE NONCLUSTERED INDEX UniqueSongs
    ON Song (song_id,name, duration)
    WHERE disk_id IS NULL ;

-- 6. Проверьте execution plans (планы выполнения) для наиболее
-- важных запросов с точки зрения частоты их использования.

SELECT *
  FROM Song

SELECT * FROM Music_Disk

-- Music_Collection> SELECT * FROM Music_Disk
-- [2021-01-22 20:06:56] 1 row retrieved starting from 1 in 71 ms (execution: 4 ms, fetching: 67 ms)

-- Если найдено слабое место по производительности, попробуйте решить возникшую проблему с помощью создания
-- новых индексов.

