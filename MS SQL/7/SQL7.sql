-- use [master];
-- go
--
-- if db_id('Academy') is not null
-- begin
-- 	drop database [Academy];
-- end
-- go
--
-- create database [Academy];
-- go
--
-- use [Academy];
-- go
--
-- create table [Assistants]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[TeacherId] int not null
-- );
-- go
--
-- create table [Curators]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[TeacherId] int not null
-- );
-- go
--
-- create table [Deans]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[TeacherId] int not null
-- );
-- go
--
-- create table [Departments]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Building] int not null check ([Building] between 1 and 5),
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N''),
-- 	[FacultyId] int not null,
-- 	[HeadId] int not null
-- );
-- go
--
-- create table [Faculties]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Building] int not null check ([Building] between 1 and 5),
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N''),
-- 	[DeanId] int not null
-- );
-- go
--
-- create table [Groups]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(10) not null unique check ([Name] <> N''),
-- 	[Year] int not null check ([Year] between 1 and 5),
-- 	[DepartmentId] int not null
-- );
-- go
--
-- create table [GroupsCurators]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[CuratorId] int not null,
-- 	[GroupId] int not null
-- );
-- go
--
-- create table [GroupsLectures]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[GroupId] int not null,
-- 	[LectureId] int not null
-- );
-- go
--
-- create table [Heads]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[TeacherId] int not null
-- );
-- go
--
-- create table [LectureRooms]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Building] int not null check ([Building] between 1 and 5),
-- 	[Name] nvarchar(10) not null unique check ([Name] <> N'')
-- );
-- go
--
-- create table [Lectures]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[SubjectId] int not null,
-- 	[TeacherId] int not null
-- );
-- go
--
-- create table [Schedules]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Class] int not null check ([Class] between 1 and 8),
-- 	[DayOfWeek] int not null check ([DayOfWeek] between 1 and 7),
-- 	[Week] int not null check ([Week] between 1 and 52),
-- 	[LectureId] int not null,
-- 	[LectureRoomId] int not null
-- );
-- go
--
-- create table [Subjects]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N'')
-- );
-- go
--
-- create table [Teachers]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(max) not null check ([Name] <> N''),
-- 	[Surname] nvarchar(max) not null check ([Surname] <> N'')
-- );
-- go
--
-- alter table [Assistants]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go
--
-- alter table [Curators]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go
--
-- alter table [Deans]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go
--
-- alter table [Departments]
-- add foreign key ([FacultyId]) references [Faculties]([Id]);
-- go
--
-- alter table [Departments]
-- add foreign key ([HeadId]) references [Heads]([Id]);
-- go
--
-- alter table [Faculties]
-- add foreign key ([DeanId]) references [Deans]([Id]);
-- go
--
-- alter table [Groups]
-- add foreign key ([DepartmentId]) references [Departments]([Id]);
-- go
--
-- alter table [GroupsCurators]
-- add foreign key ([CuratorId]) references [Curators]([Id]);
-- go
--
-- alter table [GroupsCurators]
-- add foreign key ([GroupId]) references [Groups]([Id]);
-- go
--
-- alter table [GroupsLectures]
-- add foreign key ([GroupId]) references [Groups]([Id]);
-- go
--
-- alter table [GroupsLectures]
-- add foreign key ([LectureId]) references [Lectures]([Id]);
-- go
--
-- alter table [Heads]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go
--
-- alter table [Lectures]
-- add foreign key ([SubjectId]) references [Subjects]([Id]);
-- go
--
-- alter table [Lectures]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go
--
-- alter table [Schedules]
-- add foreign key ([LectureId]) references [Lectures]([Id]);
-- go
--
-- alter table [Schedules]
-- add foreign key ([LectureRoomId]) references [LectureRooms]([Id]);
-- go

use Academy
go;

-- 1.Вывести названия аудиторий, в которых читает лекции
-- преподаватель “Edward Hopper”.

SELECT LR.Name FROM LectureRooms LR
    INNER JOIN Schedules S on LR.Id = S.LectureRoomId
    INNER JOIN Lectures L on L.Id = S.LectureId
    INNER JOIN Teachers T on T.Id = L.TeacherId
    WHERE T.Name = 'Edward' AND T.Surname = 'Hopper';

-- 2.Вывести фамилии ассистентов, читающих лекции в группе
-- “F505”.

SELECT T.Surname FROM Teachers T
    INNER JOIN Assistants A on T.Id = A.TeacherId
    INNER JOIN Lectures L on T.Id = L.TeacherId
    INNER JOIN GroupsLectures GL on L.Id = GL.LectureId
    INNER JOIN Groups G on G.Id = GL.GroupId
    WHERE G.Name = 'F505';

-- 3.Вывести дисциплины, которые читает преподаватель “Alex
-- Carmack” для групп 5-го курса.

SELECT S.Name FROM Subjects S
    INNER JOIN Lectures L on S.Id = L.SubjectId
    INNER JOIN Teachers T on T.Id = L.TeacherId
    INNER JOIN GroupsLectures GL on L.Id = GL.LectureId
    INNER JOIN Groups G on G.Id = GL.GroupId
    WHERE T.Name = 'Alex' AND T.Surname = 'Carmack' AND G.Year = 5;

-- 4.Вывести фамилии преподавателей, которые не читают
-- лекции по понедельникам.

SELECT T.Surname FROM Teachers T
    INNER JOIN Lectures L on T.Id = L.TeacherId
    INNER JOIN Schedules S on L.Id = S.LectureId
    WHERE S.DayOfWeek != 1;

-- 5.Вывести названия аудиторий, с указанием их корпусов,
-- в которых нет лекций в среду второй недели на третьей
-- паре.

SELECT LR.Name, LR.Building FROM LectureRooms LR
    INNER JOIN Schedules S on LR.Id = S.LectureRoomId
    WHERE S.DayOfWeek != 3 AND S.Week != 2 AND S.Class != 3;

-- 6.Вывести полные имена преподавателей факультета “Computer
-- Science”, которые не курируют группы кафедры “Software
-- Development”.

SELECT T.Name, T.Surname FROM Teachers T
    INNER JOIN Lectures L on T.Id = L.TeacherId
    INNER JOIN GroupsLectures GL on L.Id = GL.LectureId
    INNER JOIN Groups G on G.Id = GL.GroupId
    INNER JOIN Departments D on D.Id = G.DepartmentId
    INNER JOIN GroupsCurators GC on G.Id = GC.GroupId
    FUll OUTER JOIN Faculties F on F.Name = 'Software Development' AND D.FacultyId = F.Id
    WHERE D.Name = 'Computer Science'


-- 7.Вывести список номеров всех корпусов, которые имеются
-- в таблицах факультетов, кафедр и аудиторий.

SELECT D.Building FROM Departments D
FULL OUTER JOIN Faculties F on F.Id = D.FacultyId
INNER JOIN Groups G on D.Id = G.DepartmentId
INNER JOIN GroupsLectures GL on G.Id = GL.GroupId
INNER JOIN Lectures L on L.Id = GL.LectureId
INNER JOIN Schedules S on L.Id = S.LectureId
FULL OUTER JOIN LectureRooms LR on S.LectureRoomId = LR.Id


-- 8.Вывести полные имена преподавателей в следующем по-
-- рядке: деканы факультетов, заведующие кафедрами, пре-
-- подаватели, кураторы, ассистенты.

SELECT T.Name, T.Surname FROM Teachers T
LEFT JOIN Deans D on T.Id = D.TeacherId
LEFT JOIN Heads H on T.Id = H.TeacherId
LEFT JOIN Curators C on T.Id = C.TeacherId
LEFT JOIN Assistants A on T.Id = A.TeacherId
ORDER BY D.TeacherId, H.TeacherId, T.Id, C.TeacherId, A.Id, T.Name, T.Surname



-- 9.Вывести дни недели (без повторений), в которые имеются
-- занятия в аудиториях “A311” и “A104” корпуса

SELECT DISTINCT S.DayOfWeek FROM Schedules S
INNER JOIN LectureRooms LR on LR.Id = S.LectureRoomId
WHERE LR.Name= 'A311' OR LR.Name = 'A104' AND LR.Building = 6
