--use [master];
--go

--if db_id('Hospital') is not null
--begin
--	drop database [Hospital];
--end
--go

--create database [Hospital];
--go

--use [Hospital];
--go

--create table [Departments]
--(
--	[Id] int not null identity(1, 1) primary key,
--	[Building] int not null check ([Building] between 1 and 5),
--	[Financing] money not null check ([Financing] >= 0.0) default 0.0,
--	[Floor] int not null check ([Floor] >= 1),
--	[Name] nvarchar(100) not null unique check ([Name] <> N'')
--);
--go

--create table [Diseases]
--(
--	[Id] int not null identity(1, 1) primary key,
--	[Name] nvarchar(100) not null unique check ([Name] <> N''),
--	[Severity] int not null check ([Severity] >= 1) default 1
--);
--go

--create table [Doctors]
--(
--	[Id] int not null identity(1, 1) primary key,
--	[Name] nvarchar(max) not null check ([Name] <> N''),
--	[Phone] char(10) null,
--	[Premium] money not null check ([Premium] >= 0.0) default 0.0,
--	[Salary] money not null check ([Salary] > 0.0),
--	[Surname] nvarchar(max) not null check ([Surname] <> N'')
--);
--go

--create table [Examinations]
--(
--	[Id] int not null identity(1, 1) primary key,
--	[DayOfWeek] int not null check ([DayOfWeek] between 1 and 7),
--	[EndTime] time not null,
--	[Name] nvarchar(100) not null unique check([Name] <> N''),
--	[StartTime] time not null check ([StartTime] between '08:00' and '18:00'),
--	check ([StartTime] < [EndTime])
--);
--go

--create table [Wards]
--(
--	[Id] int not null identity(1, 1) primary key,
--	[Building] int not null check ([Building] between 1 and 5),
--	[Floor] int not null check ([Floor] >= 1),
--	[Name] nvarchar(20) not null unique check([Name] <> N'')
--);
--go

use [Hospital];
go

--1. ������� ���������� ������� �����.

SELECT * FROM Wards;

--2. ������� ������� � �������� ���� ������.

SELECT Name, Phone FROM Doctors;

--3. ������� ��� ����� ��� ����������, �� ������� �������-
--������ ������.

SELECT DISTINCT Floor FROM Wards; 

--4. ������� �������� ����������� ��� ������ �Name of Disease�
--� ������� �� ������� ��� ������ �Severity of Disease�.

SELECT Name AS 'Name of Disease', Severity AS 'Severity of Disease' FROM Diseases;

--5. ������������ ��������� FROM ��� ����� ���� ������
--���� ������, ��������� ��� ��� ����������.

SELECT Name AS 'Name Of The Ward', Building AS 'Building Of The Ward', Floor AS 'Floor Of The Ward' FROM Wards;

--6. ������� �������� ���������, ������������� � �������
--5 � ������� ���� �������������� ����� 30000.

SELECT Name FROM Departments
WHERE Building = 5 AND Financing < 30000;

--7. ������� �������� ���������, ������������� � 3-� �������
--� ������ �������������� � ��������� �� 12000 �� 15000.

SELECT Name FROM Departments
WHERE Building = 3 AND (Financing > 12000 AND Financing < 15000);

--8. ������� �������� �����, ������������� � �������� 4 � 5
--�� 1-� �����.

SELECT Name FROM Wards
WHERE (Building = 4 OR Building = 5) AND Floor = 1;


--9. ������� ��������, ������� � ����� �������������� ��-
--�������, ������������� � �������� 3 ��� 6 � �������
--���� �������������� ������ 11000 ��� ������ 25000.

SELECT Name, Financing FROM Departments
WHERE (Building = 3 OR Building = 6) AND (Financing < 11000 OR Financing > 25000);

--10. ������� ������� ������, ��� �������� (����� ������
--� ��������) ��������� 1500.

SELECT Surname FROM Doctors 
WHERE Salary + Premium > 1500;


--11. ������� ������� ������, � ������� �������� ��������
--��������� ����������� ��������.

SELECT Surname FROM Doctors 
WHERE ((Salary + Premium) / 2) > Premium * 3;

--12. ������� �������� ������������ ��� ����������, �����-
--����� � ������ ��� ��� ������ � 12:00 �� 15:00.

SELECT Name FROM Examinations
WHERE DayOfWeek = 1 OR DayOfWeek = 2 OR DayOfWeek = 3
AND (StartTime > '12:00:00' AND StartTime < '15:00:00') 

--13. ������� �������� � ������ �������� ���������, �����-
--�������� � �������� 1, 3, 8 ��� 10.

SELECT Name, Building FROM Departments
WHERE Building = 1 OR Building = 3 OR Building = 8 OR Building = 10;

--14. ������� �������� ����������� ���� �������� �������,
--����� 1-� � 2-�.

SELECT Name FROM Diseases
WHERE Severity != 1 OR Severity !=2;

--15. ������� �������� ���������, ������� �� �������������
--� 1-� ��� 3-� �������.

SELECT Name FROM Departments
WHERE Building != 1 OR Building != 3;

--16. ������� �������� ���������, ������� ������������� � 1-�
--��� 3-� �������.

SELECT Name FROM Departments
WHERE Building = 1 OR Building = 3;

--17. ������� ������� ������, ������������ �� ����� �N�.

SELECT Surname FROM Doctors
WHERE Surname LIKE 'N';