use Academy 

-- 1. ������� ������� ������, �� ����������� �� ���� � �������� �������.

SELECT * FROM Departments ORDER BY id DESC

-- 2. ������� �������� ����� � �� ��������, ��������� � �������� �������� ��������� ����� �Group Name� � �Group Rating� ��������������.

SELECT Name AS 'Group Name', Rating AS 'Group Rating' FROM Groups

-- 3. ������� ��� �������������� �� �������, ������� ������ �� ��������� � �������� � ������� ������ �� ��������� � �������� (����� ������ � ��������).

SELECT Surname, (Salary / Premium) * 100 AS T, (Salary / (Salary + Premium)) * 100 AS S FROM Teachers

-- 4. ������� ������� ����������� � ���� ������ ���� � ��������� �������: �The dean of faculty [faculty] is [dean].�.

Select 'The dean of faculty '+Name+' is '+convert(varchar(5), Dean)  from Faculties

-- 5. ������� ������� ��������������, ������� �������� ������������ � ������ ������� ��������� 1050.

SELECT Name FROM Teachers
WHERE IsProfessor = 1 AND Salary > 1050;

-- 6. ������� �������� ������, ���� �������������� ������� ������ 11000 ��� ������ 25000.

SELECT Name FROM Departments
WHERE  Financing < 11000  OR  Financing > 25000;

-- 7. ������� �������� ����������� ����� ���������� �Computer Science�

SELECT Name FROM Departments
WHERE NOT LOWER(Name) = 'Computer Science';

-- 8. ������� ������� � ��������� ��������������, ������� �� �������� ������������.

SELECT Surname, Position FROM Teachers
WHERE IsProfessor = 0;

-- 9. ������� �������, ���������, ������ � �������� �����������, � ������� �������� � ��������� �� 160 �� 550.

SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE IsAssistant = 1 AND (Premium > 160 AND Premium < 550);

-- 10. ������� ������� � ������ �����������.

SELECT Surname, Salary FROM Teachers
WHERE IsAssistant = 1;

-- 11. ������� ������� � ��������� ��������������, ������� ���� ������� �� ������ �� 01.01.2000.

SELECT Surname, Position FROM Teachers
WHERE IsProfessor = 1 AND EmploymentDate < '01.01.2000';

-- 12. ������� �������� ������, ������� � ���������� ������� ������������� �� ������� �Software Development�. ��������� ���� ������ ����� �������� �Name of Department�.

SELECT Name  AS 'Name of Department' FROM Departments ORDER BY Name

-- 13. ������� ������� �����������, ������� �������� (����� ������ � ��������) �� ����� 1200.

SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Premium + Salary) < 1200;

-- 14. ������� �������� ����� 5-�� �����, ������� ������� � ��������� �� 2 �� 4.

SELECT Name FROM Groups
WHERE Year = 5 AND (Rating > 2 AND Rating < 4);

-- 15. ������� ������� ����������� �� ������� ������ 550 ��� ��������� ������ 200.

SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Salary < 550 OR Premium < 200);