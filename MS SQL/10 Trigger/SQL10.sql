-- Задание 1. К базе данных «Спортивный магазин» из практического задания к этому модулю создайте следующие триггеры:

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
-- 1. При добавлении нового товара триггер проверяет его наличие на складе, если такой товар есть и новые данные о
-- товаре совпадают с уже существующими данными, вместо
-- добавления происходит обновление информации о количестве товара

CREATE TRIGGER Check_Update_Goods_Quantity
ON Goods AFTER INSERT
AS
UPDATE Goods
SET quantity = + (SELECT quantity FROM inserted)
WHERE name = (SELECT name FROM inserted) AND
      type = (SELECT type FROM inserted) AND
      production_price = (SELECT production_price FROM inserted) AND
      manufacturer = (SELECT manufacturer FROM inserted)

    SET IDENTITY_INSERT Goods ON
    INSERT INTO Goods VALUES (2,'MyHat','Hat',45,12.05,29.99,'U.K')

-- 2. При увольнении сотрудника триггер переносит информацию
-- об уволенном сотруднике в таблицу «Архив сотрудников»

CREATE TRIGGER Archive_Deleted_Employee
ON Employers AFTER DELETE
AS
INSERT INTO EmployersArchive VALUES ((SELECT id FROM deleted),
                                     (SELECT name FROM deleted),
                                     (SELECT position FROM deleted),
                                     (SELECT enroll_date FROM deleted),
                                     (SELECT gender FROM deleted),
                                     (SELECT salary FROM deleted))
-- SET exID = (SELECT id FROM deleted)
-- SET exName = (SELECT name FROM deleted)
-- SET exPosition = (SELECT position FROM deleted)
-- SET exEnroll_Date = (SELECT enroll_date FROM deleted)
-- SET exGender = (SELECT gender FROM deleted)
-- SET exSalary = (SELECT salary FROM deleted)

-- 3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 6.

CREATE TRIGGER Set_Limit_Of_Six_Employee
    ON Employers AFTER INSERT AS
    IF 6 > (SELECT COUNT(Employers.id) FROM Employers)
    PRINT 'There are already more than 6 employers'
    DELETE inserted FROM Employers
    WHERE Employers.id = inserted.id

-- К базе данных «Музыкальная коллекция» из
-- практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие триггеры:

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

use Music_Collection
go
*/

use Music_Collection
go
-- 1. Триггер не позволяющий добавить уже существующий
-- в коллекции альбом

CREATE TRIGGER Forbid_Adding_Album_Duplicates ON Music_Disk AFTER INSERT AS
    IF EXISTS(name = inserted.name)
    ROLLBACK TRANSACTION
    RETURN;

-- 2. Триггер не позволяющий удалять диски группы The Beatles

CREATE TRIGGER Forbid_Deleting_The_Beatles ON Music_Disk AFTER DELETE AS
    IF deleted.name = 'The Beatles'
    ROLLBACK TRANSACTION
    RETURN;

-- 3. При удалении диска триггер переносит информацию об
-- удаленном диске в таблицу «Архив»

CREATE TRIGGER Archive_Deleted_Disks
ON Music_Disk AFTER DELETE AS
INSERT INTO MusicDiskArchive VALUES ((SELECT music_disk_id FROM deleted),
                                     (SELECT name FROM deleted),
                                     (SELECT release_date FROM deleted),
                                     (SELECT genre_id FROM deleted),
                                     (SELECT singer_id FROM deleted),
                                     (SELECT publisher_id FROM deleted))

-- 4. Триггер не позволяющий добавлять в коллекцию диски
-- музыкального стиля «Dark Power Pop».

CREATE TRIGGER Forbid_Add_Dark_Power_Pop ON Music_Disk AFTER INSERT AS
    SELECT G.genre_id FROM Genre G
    WHERE G.name = 'Dark Power Pop'
    IF inserted.genre_id = genre_id
    ROLLBACK TRANSACTION
    RETURN;

-- Задание 3. К базе данных «Продажи» из практического
-- задания модуля «Работа с таблицами и представлениями в
-- MS SQL Server» создайте следующие триггеры:

/*create database Sales
go
use Sales
go

create table Sellers(
	Id int identity primary key,
	Name nvarchar(100) not null CHECK(Name <> N'') UNIQUE,
	Email nvarchar(100) not null CHECK(Email <> N'') UNIQUE,
	Phone_number nvarchar(20) not null CHECK(Phone_number <> N'') UNIQUE
)

go

create table Buyers(
	Id int identity primary key,
	Name nvarchar(100) not null CHECK(Name <> N'') UNIQUE,
	Email nvarchar(100) not null CHECK(Email <> N'') UNIQUE,
	Phone_number nvarchar(20) not null CHECK(Phone_number <> N'') UNIQUE
)

go

create table Sales_inf(
	Id int identity primary key,
	SellerId int not null REFERENCES Sellers(Id),
	BuyerId int not null REFERENCES Buyers(Id),
	ProductName nvarchar(100) not null CHECK(ProductName <> N''),
	SellingPrice money not null CHECK(SellingPrice >= 0) default 0,
	TransactionDate date not null
)
go

use Sales
go*/
use Sales
go
-- 1. При добавлении нового покупателя триггер проверяет
-- наличие покупателей с такой же фамилией. При нахождении совпадения триггер записывает об этом информацию
-- в специальную таблицу

CREATE TRIGGER Check_Buyers_Name ON Buyers INSTEAD OF INSERT AS
    IF inserted.Name = (SELECT Name FROM Buyers)
        INSERT INTO Archive VALUES (inserted.Id,inserted.Name,inserted.Email,inserted.Phone_number)
    ELSE
        INSERT INTO Buyers VALUES (inserted.Id,inserted.Name,inserted.Email,inserted.Phone_number)

-- 2. При удалении информации о покупателе триггер переносит
-- его историю покупок в таблицу «История покупок»

CREATE TRIGGER Archive_Sales_Info
ON Sales_inf AFTER DELETE AS
INSERT INTO SalesArchive VALUES ((SELECT id FROM Sales_inf
                                 WHERE BuyerId = deleted.BuyerId),
                                     (SELECT SellerId FROM Sales_inf
                                         WHERE BuyerId = deleted.BuyerId),
                                     (SELECT BuyerId FROM Sales_inf),
                                     (SELECT ProductName FROM Sales_inf
                                         WHERE BuyerId = deleted.BuyerId),
                                     (SELECT SellingPrice FROM Sales_inf
                                         WHERE BuyerId = deleted.BuyerId),
                                     (SELECT TransactionDate FROM Sales_inf
                                         WHERE BuyerId = deleted.BuyerId))

-- 3. При добавлении продавца триггер проверяет есть ли он в
-- таблице покупателей, если запись существует добавление
-- нового продавца отменяется

CREATE TRIGGER Check_Existing_Buyer_As_Customer ON Sellers INSTEAD OF INSERT AS
    IF inserted.Name = (SELECT Name FROM Buyers)
    RETURN
    ELSE INSERT INTO Sellers VALUES (inserted.Id,inserted.Name,inserted.Phone_number,inserted.Email)
    RETURN;

-- 4. При добавлении покупателя триггер проверяет есть ли он
-- в таблице продавцов, если запись существует добавление
-- нового покупателя отменяется

CREATE TRIGGER Check_Existing_Buyer_As_Customer ON Buyers INSTEAD OF INSERT AS
    IF inserted.Name = (SELECT Name FROM Sellers)
    RETURN
    ELSE INSERT INTO Buyers VALUES (inserted.Id,inserted.Name,inserted.Phone_number,inserted.Email)
    RETURN;

-- 5. Триггер не позволяет вставлять информацию о продаже
-- таких товаров: яблоки, груши, сливы, кинза.

CREATE TRIGGER Forbid_Sales_About_Fruits ON Sales_inf INSTEAD OF INSERT AS
    IF inserted.ProductName = N'Яблоки' OR
       inserted.ProductName = N'Груши' OR
       inserted.ProductName = N'Сливы' OR
       inserted.ProductName = N'Кинза'
    RETURN
    ELSE INSERT INTO Sales_inf VALUES (inserted.Id,inserted.SellerId,inserted.BuyerId,inserted.ProductName,inserted.SellingPrice,inserted.TransactionDate)
    RETURN