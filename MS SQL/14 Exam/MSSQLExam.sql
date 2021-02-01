use master
go

create database Sport_Records
go

use Sport_Records
go


-- 1. Создать таблицы competition, result, sportsman.

/*В таблице competition хранится информация о проводимых
соревнованиях:
● competition_id (ID соревнования);
● competition_name (наименование соревнования);
● world_record (мировой рекорд);
● set_date (дата установки мирового рекорда);*/

 create table competition
 (
     competition_id int primary key identity,
     competition_name nvarchar(30),
     world_record time,
     set_date date,
 )
 go

/*В таблице sportsman хранится информация о спортсменах:
● sportsman_id (ID спортсмена);
● sportsman_name (имя спортсмена);
● rank (разряд спортсмена);
● year_of_birth (год рождения);
● personal_record (персональный рекорд);
● country (страна спортсмена);*/

 create table sportsman
(
    sportsman_id int primary key identity,
    sportsman_name nvarchar(20),
    rank nvarchar(10),
    year_of_birth date,
    personal_record time,
    country nvarchar(30)
 )

 /*
 В таблице result хранится информация о результатах соревнований:
● competition_id (ID соревнования);
● sportsman_id (ID спортсмена);
● result (результат спортсмена);
 ● city (место проведения);
 ● hold_date (дата проведения);*/

  create table result
 (
     competition_id int foreign key references competition(competition_id),
     sportsman_id int foreign key references sportsman(sportsman_id),
     result_time int,
     city nvarchar(30),
     hold_date date,
 )
 go


-- 2. Заполните таблицы тестовыми данными с помощью
-- команды INSERT

INSERT INTO sportsman (sportsman_name, rank, year_of_birth, personal_record, country)
VALUES (N'Anton', N'1', N'1995-05-04', N'00:00:22', N'Italy'),
       (N'Anna', N'1', N'1995-08-01', N'00:05:34', N'Russia'),
       (N'Paolo', N'2', N'1954-02-23', N'00:00:30', N'Italy'),
       (N'Oksana', N'1', N'1966-06-05', N'00:00:21', N'Ukraine'),
       (N'Vlad', N'4', N'2000-09-10', N'00:00:25', N'Ukraine')

INSERT INTO competition (competition_name, world_record, set_date)
VALUES (N'Karate',N'01:12:12',N'2001-02-04'),
       (N'Running',N'00:12:12',N'2002-10-07'),
       (N'Running with obstacles',N'00:30:01',N'1997-03-04'),
       (N'Ski',N'01:00:03',N'2005-01-02')

INSERT INTO result (competition_id, sportsman_id, result_time, city, hold_date)
    VALUES (1,1,N'01:12:11',N'Rome',N'2010-03-01'),
           (2,2,N'00:04:11',N'Moscow',N'2009-08-22'),
           (3,3,N'01:12:11',N'Odessa',N'2010-03-01'),
           (4,4,N'00:33:32',N'Kiev',N'2007-10-05')

-- SELECT s.sportsman_name, c.competition_name FROM sportsman s
-- INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
-- INNER JOIN competition c on c.competition_id = r2.competition_id

-- 3. Создать таблицу как результат выполнения команды
-- SELECT.

/*SELECT * INTO new_table FROM sportsman*/

-- 4. Выдайте всю информацию о спортсменах из таблицы
-- sportsman.

SELECT * FROM sportsman

-- 5. Выдайте наименование и мировые результаты по всем
-- соревнованиям.

SELECT C.competition_name, C.world_record FROM competition C

-- 6. Выберите имена всех спортсменов, которые родились в 1990 году.

SELECT S.sportsman_name FROM sportsman S
WHERE year_of_birth = 1990

-- 7. Выберите наименование и мировые результаты по всем
-- соревнованиям, установленные 12-05-2010 или 15-05-2010.

SELECT c.competition_name, c.world_record FROM competition c
WHERE c.set_date = '2010-05-12' OR c.set_date = '2010-05-15';

-- 8. Выберите дату проведения всех соревнований,
-- проводившихся в Москве и полученные на них
-- результаты равны 10 секунд.

SELECT r.hold_date FROM result r
WHERE r.city = 'Moscow' AND r.result_time = 10;

-- 9. Выберите имена всех спортсменов, у которых
-- персональный рекорд не равен 25 с.

SELECT S.sportsman_name FROM sportsman S
WHERE personal_record != '00:00:25'

-- 10. Выберите названия всех соревнований, у которых
-- мировой рекорд равен 15 с и дата установки рекорда не
-- равна 12-02-2015.

SELECT C.competition_name FROM competition C
WHERE world_record = '00:00:15' AND set_date != '2015-02-12'

-- 11. Выберите города проведения соревнований, где
-- результаты принадлежат множеству {13, 25, 17, 9}.

SELECT r.city FROM result r
WHERE r.result_time IN (13, 25, 17, 9);


-- 12. Выберите имена всех спортсменов, у которых год
-- рождения 2000 и разряд не принадлежит множеству {3, 7, 9}.

SELECT s.sportsman_name FROM sportsman s
WHERE year_of_birth = '2000' AND NOT s.rank IN (3, 7, 9);

-- 13. Выберите дату проведения всех соревнований, у
-- которых город проведения начинается с буквы "М".

SELECT r.hold_date FROM result r
WHERE r.city LIKE 'M%'

-- 14. Выберите имена всех спортсменов, у которых имена
-- начинаются с буквы "М" и год рождения не
-- заканчивается на "6".

SELECT s.sportsman_name FROM sportsman s
WHERE s.sportsman_name LIKE 'M%' AND NOT s.year_of_birth LIKE '%6';

-- 15. Выберите наименования всех соревнований, у
-- которых в названии есть слово "международные".

SELECT c.competition_name FROM competition c
WHERE competition_name LIKE N'%международные%'

-- 16. Выберите годы рождения всех спортсменов без
-- повторений.

SELECT DISTINCT S.year_of_birth FROM sportsman S

-- 17. Найдите количество результатов, полученных 12-05-2014.

SELECT COUNT(R.result_time) FROM result R
WHERE R.hold_date = '12-05-2014'


-- 18. Вычислите максимальный результат, полученный в Москве.

SELECT MAX(r.result_time) FROM result r
WHERE r.city = 'Moscow';

-- 19. Вычислите минимальный год рождения спортсменов,
-- которые имеют 1 разряд.

SELECT MIN(s.year_of_birth) FROM sportsman s
WHERE s.rank = 1;

-- 20. Определите имена спортсменов, у которых личные
-- рекорды совпадают с результатами, установленными 12-04-2014.

SELECT s.sportsman_name FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
WHERE s.personal_record = r2.result_time AND r2.hold_date = '2014-04-12';

-- 21. Выведите наименования соревнований, у которых
-- дата установления мирового рекорда совпадает с датой
-- проведения соревнований в Москве 20-04-2015.

SELECT c.competition_name FROM competition c
INNER JOIN result r2 on c.competition_id = r2.competition_id
WHERE r2.hold_date = '2015-04-20' = c.set_date AND city = 'Moscow'

-- 22. Вычислите средний результат каждого из спортсменов.

SELECT s.sportsman_name, AVG(r.result_time) FROM sportsman s
INNER JOIN result r on s.sportsman_id = r.sportsman_id

-- 23. Выведите годы рождения спортсменов, у которых
-- результат, показанный в Москве выше среднего по всем спортсменам.

SELECT s.year_of_birth FROM sportsman s
LEFT JOIN result r ON r.sportsman_id = s.sportsman_id
WHERE r.city = 'Moscow' AND r.result_time > (select AVG(r.result_time) FROM result);

-- 24. Выведите имена всех спортсменов, у которых год
-- рождения больше, чем год установления мирового
-- рекорда, равного 12 с.

SELECT s.sportsman_name FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
WHERE s.year_of_birth > r2.hold_date AND r2.result_time = 12;

-- 25. Выведите список спортсменов в виде 'Спортсмен '
-- ['имя спортсмена'] 'показал результат' ['результат'] 'в
-- городе' ['город']

SELECT N'Спортсмен ' + s.sportsman_name + N' показал результат ' + r.result_time +  N' в городе ' + r.city FROM sportsman s
INNER JOIN result r on s.sportsman_id = r.sportsman_id

-- 26. Выведите имена всех спортсменов, у которых разряд
-- ниже среднего разряда всех спортсменов, родившихся в
-- 2000 году.

SELECT s.sportsman_name FROM sportsman s
WHERE s.rank < (SELECT AVG(s.rank) WHERE s.year_of_birth = '2000%')

-- 27. Выведите данные о спортсменах, у которых
-- персональный рекорд совпадает с мировым.

SELECT * FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
INNER JOIN competition c on c.competition_id = r2.competition_id
WHERE c.world_record = s.personal_record

-- 28. Определите количество участников с фамилией
-- Иванов, которые участвовали в соревнованиях с
-- названием, содержащим слово 'Региональные'

SELECT COUNT(s.sportsman_name) FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
INNER JOIN competition c on c.competition_id = r2.competition_id
WHERE sportsman_name LIKE N'%Иванов' AND c.competition_name LIKE N'%Региональные%'

-- 29. Выведите города, в которых были установлены мировые рекорды.

SELECT DISTINCT r.city FROM result r
INNER JOIN competition c on c.competition_id = r.competition_id

-- 30. Найдите минимальный разряд спортсменов, которые установили мировой рекорд.

SELECT MIN(s.rank) FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id

-- 31. Выведите названия соревнований, на которых было
-- установлено максимальное количество мировых рекордов.

SELECT c.competition_name FROM competition c

-- 32. Определите, спортсмены какой страны участвовали в
-- соревнованиях больше всего.

SELECT s.country, COUNT(*) as 'Quantity' FROM sportsman s
INNER JOIN result r2 on s.sportsman_id = r2.sportsman_id
GROUP BY s.country
ORDER BY 2 DESC;

-- 33. Измените разряд на 1 тех спортсменов, у которых
-- личный рекорд совпадает с мировым.

UPDATE sportsman
SET sportsman.rank = 1
FROM sportsman
INNER JOIN result r2 on sportsman.sportsman_id = r2.sportsman_id
INNER JOIN competition c on c.competition_id = r2.competition_id
WHERE personal_record = world_record ;

-- 34. Вычислите возраст спортсменов, которые участвовали в соревнованиях в Москве.

SELECT sportsman_name, DATEDIFF(year, year_of_birth, GETDATE()) as 'Current Age' FROM sportsman
INNER JOIN result r2 on sportsman.sportsman_id = r2.sportsman_id
WHERE city = 'Moscow';

-- 35. Измените дату проведения всех соревнований,
-- проходящих в Москве на 4 дня вперед.

UPDATE result
SET hold_date = DATEADD(day,4,hold_date)
FROM result
WHERE city = 'Moscow';

-- 36. Измените страну у спортсменов, у которых разряд
-- равен 1 или 2, с Италии на Россию.

UPDATE sportsman
SET country = 'Russia'
FROM sportsman
WHERE rank = 1 OR rank = 2 AND country = 'Italy';

-- 37. Измените название соревнований с 'Бег' на 'Бег с
-- препятствиями'

UPDATE competition
SET competition_name = 'Running with obstacles'
FROM competition
WHERE competition_name = 'Running';

-- 38. Увеличьте мировой результат на 2 с для соревнований
-- ранее 20-03-2005.

UPDATE competition
SET world_record = DATEADD(second,2,world_record)
FROM competition
WHERE set_date < '2005-03-20';

-- 39. Уменьшите результаты на 2 с соревнований, которые
-- проводились 20-05-2012 и показанный результат не
-- менее 45 с.

UPDATE competition
SET world_record = DATEADD(second, -2,world_record)
FROM competition
WHERE set_date = '2012-05-20' AND world_record > '00:00:45';

-- 40. Удалите все результаты соревнований в Москве,
-- участники которых родились не позже 1980 г.

DELETE result FROM result
INNER JOIN sportsman s on s.sportsman_id = result.sportsman_id
WHERE year_of_birth < '1980-01-01' AND city = 'Moscow';

-- 41. Удалите все соревнования, у которых результат равен 20 с.

DELETE FROM result
WHERE result_time = 20;

-- 42. Удалите все результаты спортсменов, которые
-- родились в 2001 году.

DELETE result FROM result
INNER JOIN sportsman s on s.sportsman_id = result.sportsman_id
WHERE year_of_birth > '2000-12-31' AND year_of_birth < '2002-01-01';

