--
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


/* Все задания необходимо выполнить по отно-
шению к базе данных «Музыкальная коллекция», описанной
в практическом задании для этого модуля. Создайте следую-
щие представления:*/
/*Используйте опции CHECK OPTION, SCHEMABINDING,
ENCRYPTION там, где это необходимо или полезно.
*/

-- 1. Представление отображает названия всех исполнителей

CREATE VIEW All_Singer AS
    SELECT S.Name FROM Singer S

SELECT * FROM All_Singer

-- 2. Представление отображает полную информацию о всех пес-
-- нях: название песни, название диска, длительность песни,
-- музыкальный стиль песни, исполнитель

CREATE VIEW Full_Info_About_Songs AS
    SELECT S.Name AS 'Song Name', MD.Name AS 'Disk Name', S.Duration AS 'Song Duration', G.Name AS 'Genre Name', S2.Name AS 'Song Singer' FROM Song S
        INNER JOIN Music_Disk MD on MD.music_disk_id = S.disk_id
        INNER JOIN Genre G on G.genre_id = S.genre_id
        INNER JOIN Singer S2 on S2.singer_id = S.singer_id

SELECT * FROM Full_Info_About_Songs
-- 3. Представление отображает информацию о музыкальных
-- дисках конкретной группы. Например, The Beatles

CREATE VIEW The_Beatles_Disks AS
    SELECT D.Name, D.release_date, G.Name AS 'Genre Name', S.name AS 'Song Name', P.name AS 'Publisher Name' FROM Music_Disk D
        INNER JOIN Genre G on G.genre_id = D.genre_id
        INNER JOIN Singer S on S.singer_id = D.singer_id AND S.name = 'The Beatles'
        INNER JOIN Publisher P on P.publisher_id = D.publisher_id
        INNER JOIN Song S2 on D.music_disk_id = S2.disk_id
        WHERE S2.disk_id = D.music_disk_id
        WITH CHECK OPTION

--SELECT * FROM The_Beatles_Disks

-- 4. Представление отображает название самого популярного
-- в коллекции исполнителя. Популярность определяется по
-- количеству дисков в коллекции

    CREATE VIEW Most_Popular_Singer AS WITH SUBQ AS(
    SELECT S.Name, COUNT(*) AMT
    FROM Singer S
    LEFT JOIN Music_Disk MD on S.singer_id = MD.singer_id
    GROUP BY S.Name)

    SELECT S.Name, COUNT (*) AMT
    FROM Singer S
    LEFT OUTER JOIN Music_Disk MD on S.singer_id = MD.singer_id
    GROUP BY S.Name
    HAVING COUNT (*) = (SELECT MAX(AMT) FROM SUBQ)

SELECT * FROM Most_Popular_Singer


-- 5. Представление отображает топ-3 самых популярных в кол-
-- лекции исполнителей. Популярность определяется по ко-
-- личеству дисков в коллекции

CREATE VIEW Top_Three_Most_Popular_Singers AS WITH SUBQ AS(
    SELECT S.Name, COUNT(*) AMT
    FROM Singer S
    LEFT JOIN Music_Disk MD on S.singer_id = MD.singer_id
    GROUP BY S.Name)

    SELECT TOP 3 S.Name, COUNT (*) AMT
    FROM Singer S
    LEFT OUTER JOIN Music_Disk MD on S.singer_id = MD.singer_id
    GROUP BY S.Name
    HAVING COUNT (*) = (SELECT MAX(AMT) FROM SUBQ)

-- 6. Представление отображает самый долгий по длительности
-- музыкальный альбом.

CREATE VIEW The_Biggest_Album AS WITH SUBQ AS(
    SELECT S.duration, COUNT(*) AMT
    FROM Song S
    LEFT JOIN Music_Disk MD on S.disk_id = MD.music_disk_id
    GROUP BY S.duration)

    SELECT MD.Name, COUNT (*) AMT
    FROM Music_Disk MD
    LEFT OUTER JOIN Song S2 on MD.music_disk_id = S2.disk_id
    GROUP BY MD.Name
    HAVING COUNT (*) = (SELECT MAX(AMT) FROM SUBQ)

-- Задание 2. Все задания необходимо выполнить по отно-
-- шению к базе данных «Музыкальная коллекция», описанной
-- в практическом задании для этого модуля:

-- 1. Создайте обновляемое представление, которое позволит
-- вставлять новые стили

CREATE VIEW Add_New_Genre AS
    SELECT G.Name, G.genre_id FROM Genre G
    INSERT INTO Add_New_Genre (Name)
    VALUES ('Rock')

      INSERT INTO Add_New_Genre (Name)
    VALUES ('Metal')

    SELECT * FROM Add_New_Genre

-- 2. Создайте обновляемое представление, которое позволит
-- вставлять новые песни

CREATE VIEW Add_New_Song AS
    SELECT S.name, S.duration FROM Song S
    INSERT INTO Add_New_Song (name, duration)
    VALUES ('Final Cooldown', '3:44')

    SELECT * FROM Add_New_Song

-- 3. Создайте обновляемое представление, которое позволит
-- обновлять информацию об издателе


CREATE VIEW Update_Publisher AS
    SELECT P.name, P.country FROM Publisher P
    WHERE P.publisher_id = 1
    UPDATE Update_Publisher
    SET name = 'UKF', country = 'UK'

SELECT * FROM Update_Publisher

-- 4. Создайте обновляемое представление, которое позволит
-- удалять исполнителей

CREATE VIEW Delete_Singers AS
    SELECT S.Name FROM Singer S
    WHERE singer_id = 1

    DELETE FROM Delete_Singers


-- 5. Создайте обновляемое представление, которое позволит
-- обновлять информацию о конкретном исполнителе. На-
-- пример, Muse.

CREATE VIEW Update_Muse AS
    SELECT S.name, S.singer_id FROM Singer S
    WHERE S.name = 'Muse'

    UPDATE Update_Muse
    SET name = 'Muse', singer_id = 2

-- Задание №3 дублирует уже мною сделанное задание №2  
