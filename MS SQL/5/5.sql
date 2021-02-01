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
-- create table [Departments]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Financing] money not null check ([Financing] >= 0.0) default 0.0,
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N''),
-- 	[FacultyId] int not null
-- );
-- go
--
-- create table [Faculties]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N'')
-- );
-- go
--
-- create table [Groups]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(100) not null unique check ([Name] <> N''),
-- 	[Year] int not null check ([Year] between 1 and 5),
-- 	[DepartmentId] int not null
-- );
-- go
--
-- create table [GroupsLectures]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[DayOfWeek] int not null check ([DayOfWeek] between 1 and 7),
-- 	[GroupId] int not null,
-- 	[LectureId] int not null
-- );
-- go
--
-- create table [Lectures]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[LectureRoom] nvarchar(max) not null check ([LectureRoom] <> N''),
-- 	[SubjectId] int not null,
-- 	[TeacherId] int not null
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
-- 	[Salary] money not null check ([Salary] > 0.0),
-- 	[Surname] nvarchar(max) not null check ([Surname] <> N'')
-- );
-- go
--
-- alter table [Departments]
-- add foreign key ([FacultyId]) references [Faculties]([Id]);
-- go
--
-- alter table [Groups]
-- add foreign key ([DepartmentId]) references [Departments]([Id]);
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
-- alter table [Lectures]
-- add foreign key ([SubjectId]) references [Subjects]([Id]);
-- go
--
-- alter table [Lectures]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go

USE [Academy]
GO;

-- 1. Вывести количество преподавателей кафедры “Software
-- Development”.

SELECT COUNT(*) FROM Teachers
    INNER JOIN Lectures L on Teachers.Id = L.TeacherId
    INNER JOIN Subjects S on S.Id = L.SubjectId
    WHERE S.Name = 'Software Development';

-- 2. Вывести количество лекций, которые читает преподаватель
-- “Dave McQueen”.

SELECT COUNT(*) FROM Lectures
    INNER JOIN Teachers T on Lectures.TeacherId = T.Id
        WHERE T.Name = 'Dave McQueen';

-- 3. Вывести количество занятий, проводимых в аудитории
-- “D201”.

SELECT COUNT(*) FROM Lectures L
    WHERE LectureRoom = 'D201';

-- 4. Вывести названия аудиторий и количество лекций, про-
-- водимых в них.

SELECT DISTINCT L.LectureRoom, COUNT(GL.Id) FROM Lectures L, GroupsLectures GL
    WHERE L.Id = GL.LectureId;


-- 5. Вывести количество студентов, посещающих лекции пре-
-- подавателя “Jack Underhill”.

SELECT COUNT(*) FROM Groups G
    INNER JOIN GroupsLectures GL on G.Id = GL.GroupId
    INNER JOIN Lectures L on L.Id = GL.LectureId
    INNER JOIN Teachers T on T.Id = L.TeacherId
    WHERE T.Name = 'Jack Underhill';

-- 6. Вывести среднюю ставку преподавателей факультета
-- “Computer Science”.

SELECT AVG(Salary) FROM Teachers
    INNER JOIN Lectures L on Teachers.Id = L.TeacherId
    INNER JOIN GroupsLectures GL on L.Id = GL.LectureId
    INNER JOIN Groups G on G.Id = GL.GroupId
    INNER JOIN Departments D on D.Id = G.DepartmentId
    WHERE D.Name = 'Computer Science';

-- 7. Вывести минимальное и максимальное количество сту-
-- дентов среди всех групп.

alter table Groups
	add NumberOfStudents int
go
-- так как в задании опечатки, я добавлю свое поле с количеством студентов

SELECT MIN(NumberOfStudents), MAX(NumberOfStudents) FROM Groups;

-- 8. Вывести средний фонд финансирования кафедр.

SELECT AVG(Financing) FROM Departments;

-- 9. Вывести полные имена преподавателей и количество чи-
-- таемых ими дисциплин.

SELECT T.Name, T.Surname, COUNT(Academy.dbo.Lectures.Id) FROM Teachers T
    WHERE T.Id = Academy.dbo.Lectures.TeacherId;


-- 10. Вывести количество лекций в каждый день недели.

SELECT DISTINCT COUNT(*) FROM Lectures
    INNER JOIN GroupsLectures GL on Lectures.Id = GL.LectureId
    WHERE DayOfWeek <= 7;

-- 11. Вывести номера аудиторий и количество кафедр, чьи лек-
-- ции в них читаются.

SELECT L.LectureRoom, COUNT(*) AS "QuantityOfDepartments" FROM Departments D
    INNER JOIN Groups G on D.Id = G.DepartmentId
    INNER JOIN GroupsLectures GL on G.Id = GL.GroupId
    INNER JOIN Lectures L on L.Id = GL.LectureId
    GROUP BY L.LectureRoom

-- 12. Вывести названия факультетов и количество дисциплин,
-- которые на них читаются.

SELECT Departments.Name, COUNT(LectureId) FROM Departments, GroupsLectures GL
    INNER JOIN Groups G on G.Id = GL.GroupId
    INNER JOIN Departments on Departments.Id = G.DepartmentId

-- 13. Вывести количество лекций для каждой пары преподава-
-- тель-аудитория.

SELECT COUNT(*) FROM Teachers T
JOIN Lectures L on T.Id = L.TeacherId
GROUP BY TeacherId ; 
