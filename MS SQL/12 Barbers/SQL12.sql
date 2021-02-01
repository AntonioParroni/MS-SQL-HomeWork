-- Задание 1. Используя триггеры, пользовательские функции, хранимые процедуры реализуйте следующую функциональность:

/*Create database BarberShop_SPU911
go
use BarberShop_SPU911

create table Barbers
(
    id int primary key identity,
    f_name nvarchar(50),
    l_name nvarchar (50),
    gender nvarchar (10),
    phone nvarchar (20),
    email nvarchar (50),
    birth_date date,
    hire_date date,
    position_id int
)
go

create table Positions
(
    id int primary key identity,
    name nvarchar (100),
)
go
create table Services
(
     id int primary key identity,
    name nvarchar (100),
    duration time,
    price money
)
go
create table Barber_Services
(
    barber_id int,
    service_id int
)

go
create table Feedbacks
(
    id int primary key identity,
    barber_id int,
    client_id int,
    mark_id int,
    description nvarchar(max),
    feed_back int
)

go
create table Marks
(
    id int primary key identity,
    name nvarchar (50)
)

go
create table Barbers
(
    id int primary key identity,
    f_name nvarchar(50),
    l_name nvarchar (50),
    phone nvarchar (20),
    email nvarchar (50),
)
go

create table Visits
(
    id int primary key identity,
    barber_id int,
    client_id int,
    visit_date date,
    cost money,
    feedback_id int
)
go

create table Visit_Service
(
    visit_id int,
    service_id int,
)

go

create table week_days(
    id int primary key identity,
    name nvarchar (20)
)

create table Schedules
(
    day_id int,
    barber_id int,
    from_time time,
    till_time time
)
go

create table Bookings
(
    id int primary key identity,
    client_id int,
    barber_id int,
    day_id int,
    time_start time,

)
go

create table BookingServices
(
    booking_id int,
    service_id int
)
go
create table Client
(
    client_id int identity primary key,
    name nvarchar(50),

)
go
USE BarberShop_SPU911

alter table Barbers
add foreign key (position_id) references Positions(id)

alter table Barber_Services
add foreign key (barber_id) references Barbers(id),
    foreign key (service_id) references Services(id)

alter table Visits
add foreign key (barber_id) references Barbers(id),
    foreign key (client_id) references Client(client_id),
    foreign key (feedback_id) references Feedbacks (id)

alter table Feedbacks
add foreign key (barber_id) references Barbers(id),
    foreign key (client_id) references Client(client_id),
    foreign key (mark_id) references Marks(id);

alter table Schedules
    add foreign key (day_id) references week_days(id),
     foreign key (barber_id) references Barbers(id)

alter table Bookings
    add foreign key (client_id) references Client(client_id),
        foreign key (barber_id) references Barbers(id),
        foreign key (day_id) references week_days(id)

alter table BookingServices
    add foreign key (booking_id) references Bookings(id),
        foreign key (service_id) references Services(id)

alter table Visit_Service
    add foreign key (visit_id) references Visits(id),
        foreign key (service_id) references Services(id)



*/
use BarberShop_SPU911
go
-- 1. Вернуть информацию о барбере, который работает в барбершопе дольше всех

CREATE FUNCTION Show_Barber_With_Longest_Working_Time_In_Shop ()
    RETURNS TABLE AS RETURN (
        SELECT * FROM Barbers
        HAVING hire_date = MIN(hire_date)
    )

-- 2. Вернуть информацию о барбере, который обслужил максимальное количество клиентов в указанном диапазоне
-- дат. Даты передаются в качестве параметра

CREATE FUNCTION Show_Barber_With_Maximum_Clients_In_Dates (@FromDate date, @TillDate date)
    RETURNS TABLE AS RETURN (
        SELECT TOP 1 * FROM Barbers
        INNER JOIN Visits V on Barbers.id = V.barber_id
        WHERE visit_date > @FromDate AND visit_date < @TillDate
        GROUP BY f_name, Barbers.id, f_name, l_name, gender, phone, email, birth_date, hire_date, position_id, V.id, barber_id, client_id, visit_date, cost, feedback_id
        ORDER BY COUNT(DISTINCT client_id) DESC
    )

-- 3. Вернуть информацию о клиенте, который посетил барбершоп максимальное количество раз

CREATE FUNCTION Show_Client_With_Most_Visits ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 1 Client.name, COUNT(DISTINCT V.client_id) AS 'Visits' FROM Client
        INNER JOIN Visits V on Client.client_id = V.client_id
        GROUP BY Client.name
        ORDER BY COUNT(DISTINCT V.client_id) DESC
    )

SELECT * FROM Show_Client_With_Most_Visits();
-- 4. Вернуть информацию о клиенте, который потратил в барбершопе максимальное количество денег

CREATE FUNCTION Show_Client_With_Most_Spent_Money ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 1 Client.name, SUM(cost) AS 'Total Cost' FROM Client
        INNER JOIN Visits V on Client.client_id = V.client_id
        GROUP BY Client.name
        ORDER BY SUM(cost) DESC
    )

-- 5. Вернуть информацию о самой длинной по времени услуге
-- в барбершопе

CREATE FUNCTION Show_Info_About_The_Longest_Service ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 1 Services.name, MAX(duration) AS 'Maximum Time' FROM Services
        GROUP BY Services.name
        ORDER BY MAX(duration) DESC
    )

-- Задание 2. Используя триггеры, пользовательские функции, хранимые процедуры реализуйте следующую функциональность:

-- 1. Вернуть информацию о самом популярном барбере (по
-- количеству клиентов)

CREATE FUNCTION Show_Most_Popular_Barber ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 1 Barbers.f_name, Barbers.l_name , COUNT(DISTINCT client_id) AS 'Visits With Client' FROM Barbers
        INNER JOIN Visits V on Barbers.id = V.barber_id
        GROUP BY Barbers.f_name, Barbers.l_name
        ORDER BY COUNT(DISTINCT client_id) DESC
    )

-- 2. Вернуть топ-3 барберов за месяц (по сумме денег, потраченной клиентами)

CREATE FUNCTION Show_Top_Three_Barbers_In_A_Month ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 3 Barbers.f_name, Barbers.l_name, SUM(cost) AS 'Total Spent' FROM Barbers
        INNER JOIN Visits V on Barbers.id = V.barber_id
        WHERE visit_date > '2019-12-31' AND visit_date < '2020-01-31'
        GROUP BY Barbers.f_name, Barbers.l_name
        ORDER BY SUM(cost) DESC
    )

-- 3. Вернуть топ-3 барберов за всё время (по средней оценке).
-- Количество посещений клиентов не меньше 30

CREATE FUNCTION Show_Top_Three_All_Time_Barbers ()
    RETURNS TABLE AS RETURN (
        SELECT TOP 3 Barbers.f_name, Barbers.l_name, AVG(description) AS 'Average Vote' FROM Barbers
        INNER JOIN Visits V on Barbers.id = V.barber_id
        INNER JOIN Feedbacks F on F.id = V.feedback_id
        GROUP BY Barbers.f_name, Barbers.l_name
        HAVING COUNT(DISTINCT feedback_id) > 30
        ORDER BY AVG(description) DESC
    )

-- 4. Показать расписание на день конкретного барбера. Информация о барбере и дне передаётся в качестве параметра

CREATE FUNCTION Show_Barber_Schedule (@BarberFirstName nvarchar(30), @BarberLastName nvarchar(30), @day nvarchar(20))
    RETURNS TABLE AS RETURN (
        SELECT f_name, l_name, time_start FROM Barbers
        INNER JOIN Bookings B on Barbers.id = B.barber_id
        INNER JOIN week_days wd on wd.id = B.day_id
        WHERE f_name = @BarberFirstName AND l_name = @BarberLastName AND dbo.week_days.name = @day
        GROUP BY Barbers.f_name, Barbers.l_name, time_start
    )

-- 5. Показать свободные временные слоты на неделю конкретного барбера. Информация о барбере и дне передаётся
-- в качестве параметра

CREATE FUNCTION Show_Barber_Free_Schedule (@BarberFirstName nvarchar(30), @BarberLastName nvarchar(30), @day nvarchar(20))
    RETURNS TABLE AS RETURN (
        SELECT f_name, l_name, time_start, wd.name FROM Barbers
        INNER JOIN Bookings B on Barbers.id = B.barber_id
        INNER JOIN week_days wd on wd.id = B.day_id
        WHERE f_name = @BarberFirstName AND l_name = @BarberLastName AND wd.name != @day
        GROUP BY Barbers.f_name, Barbers.l_name, time_start, wd.name
    )

-- 6. Перенести в архив информацию о всех уже завершенных
-- услугах (это те услуги, которые произошли в прошлом)

CREATE PROCEDURE Archive_All_Past_Visits AS
BEGIN
    INSERT INTO Archive (id,barber_id,client_id,visit_date,cost,feedback_id)
    SELECT id, barber_id, client_id, visit_date, cost, feedback_id
    FROM Visits
    WHERE visit_date < GETDATE()
END;

-- 7. Запретить записывать клиента к барберу на уже занятое
-- время и дату

CREATE TRIGGER Forbid_Make_An_Appointment_On_Already_Busy_Date ON Visits AFTER INSERT AS
    SELECT V.visit_date FROM Visits V
    INNER JOIN Bookings B on V.client_id = B.client_id and V.barber_id = B.barber_id
    IF (visit_date = inserted.visit_date)
    ROLLBACK TRANSACTION
    RETURN;
-- 8. Запретить добавление нового джуниор-барбера, если в салоне уже работают 5 джуниор-барберов

CREATE TRIGGER Forbid_Hiring_More_Than_5_Junior_Barbers ON Barbers AFTER INSERT AS
    SELECT B.position_id FROM Barbers B
    INNER JOIN Positions P on P.id = B.position_id
    WHERE P.name = 'Junior'
    IF (COUNT(DISTINCT Barbers.barber_id) > 5)
    ROLLBACK TRANSACTION
    RETURN;

-- 9. Вернуть информацию о клиентах, которые не поставили
-- ни одного фидбека и ни одной оценки

CREATE FUNCTION Show_No_Feedback_Clients ()
    RETURNS TABLE AS RETURN (
        SELECT C.name FROM Client C
        INNER JOIN Feedbacks F on C.client_id = F.client_id
        WHERE description IS NULL AND feed_back IS NULL
    )

-- 10.Вернуть информацию о клиентах, которые не посещали
-- барбершоп свыше одного года

CREATE FUNCTION Show_No_Feedback_Clients ()
    RETURNS TABLE AS RETURN (
        SELECT C.name, V.visit_date, MAX(V.visit_date) FROM Client C
        INNER JOIN Visits V on C.client_id = V.client_id
        WHERE DATEDIFF(year,(SELECT V.visit_date, MAX(V.visit_date) FROM Visits), GETDATE()) > 1
    )
