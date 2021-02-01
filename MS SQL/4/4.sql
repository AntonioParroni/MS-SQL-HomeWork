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
-- create table [Curators]
-- (
-- 	[Id] int not null identity(1, 1) primary key,
-- 	[Name] nvarchar(max) not null check ([Name] <> N''),
-- 	[Surname] nvarchar(max) not null check ([Surname] <> N'')
-- );
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
-- 	[Financing] money not null check ([Financing] >= 0.0) default 0.0,
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
-- alter table [Lectures]
-- add foreign key ([SubjectId]) references [Subjects]([Id]);
-- go
--
-- alter table [Lectures]
-- add foreign key ([TeacherId]) references [Teachers]([Id]);
-- go



use [Academy];
go;


-- 1. Вывести все возможные пары строк преподавателей и групп.

SELECT t.Name, t.Surname, g.Name
FROM Teachers t
    INNER JOIN Lectures l
        ON t.Id = l.TeacherId
    INNER JOIN GroupsLectures g2l
        ON l.Id = g2l.LectureId
    INNER JOIN Groups g
        ON g2l.GroupId = g.Id

-- 2. Вывести названия факультетов, фонд финансирования
-- кафедр которых превышает фонд финансирования фа-
-- культета.

SELECT Faculties.Name FROM Faculties, Departments
WHERE Faculties.Financing > Departments.Financing;

-- 3. Вывести фамилии кураторов групп и названия групп, ко-
-- торые они курируют.

SELECT c.Surname, g.Name FROM Curators c
    INNER JOIN GroupsCurators g2c
        ON g2c.CuratorId = c.Id
    INNER JOIN Groups g
        ON g.Id = g2c.GroupId;

-- 4. Вывести имена и фамилии преподавателей, которые читают
-- лекции у группы “P107”.

SELECT t.Name, t.Surname FROM Teachers t
    INNER JOIN Lectures l
        ON t.Id = l.TeacherId
    INNER JOIN GroupsLectures g2l
        ON l.Id = g2l.LectureId
    INNER JOIN Groups g
        ON g2l.GroupId = g.Id
        WHERE g.Name = 'P107'
-- 5. Вывести фамилии преподавателей и названия факультетов
-- на которых они читают лекции.

SELECT t.Name, f.Name
FROM Teachers t
    INNER JOIN Lectures l
        ON t.Id = l.TeacherId
    INNER JOIN GroupsLectures g2l
        ON l.Id = g2l.LectureId
    INNER JOIN Groups g
        ON g2l.GroupId = g.Id
    INNER JOIN Departments d
        ON g.DepartmentId = d.Id
    INNER JOIN Faculties f
        ON d.FacultyId = f.Id

-- 6. Вывести названия кафедр и названия групп, которые к
-- ним относятся.

SELECT d.Name, g.Name FROM Groups g
    INNER JOIN Departments d
        ON g.DepartmentId = D.Id

-- 7. Вывести названия дисциплин, которые читает препода-
-- ватель “Samantha Adams”.

SELECT s.Name FROM Subjects s
    INNER JOIN Lectures l
        ON s.Id = l.SubjectId
    INNER JOIN Teachers t
        ON l.TeacherId = t.Id
    WHERE t.Name = 'Samantha Adams';

-- 8. Вывести названия кафедр, на которых читается дисциплина
-- “Database Theory”.

SELECT d.Name FROM Departments d
    INNER JOIN Groups G on d.Id = G.DepartmentId
    INNER JOIN GroupsLectures GL on G.Id = GL.GroupId
    INNER JOIN Lectures L on L.Id = GL.LectureId
    INNER JOIN Subjects S on S.Id = L.SubjectId
    WHERE S.Name = 'Database Theory';

-- 9. Вывести названия групп, которые относятся к факультету
-- “Computer Science”.

SELECT G.Name FROM Groups G
    INNER JOIN Departments D on G.DepartmentId = D.Id
    WHERE D.Name = 'Computer Science';

-- 10. Вывести названия групп 5-го курса, а также название фа-
-- культетов, к которым они относятся.

SELECT G.Name, D.Name FROM Groups G
    INNER JOIN Departments D ON G.DepartmentId = D.Id
    WHERE G.Year = 5;


-- 11. Вывести полные имена преподавателей и лекции, которые
-- они читают (названия дисциплин и групп), причем отобрать
-- только те лекции, которые читаются в аудитории “B103”.

SELECT T.Name, T.Surname, S.Name, G.Name FROM Teachers T
    INNER JOIN Lectures L
        ON t.Id = l.TeacherId
    INNER JOIN Subjects S
        ON l.SubjectId = s.Id
    INNER JOIN GroupsLectures GL
        ON l.Id = GL.LectureId
    INNER JOIN Groups G
        ON G.Id = GL.GroupId
    WHERE L.LectureRoom = 'B103';
 
