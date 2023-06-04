-- Задание 1
CREATE DATABASE cars;
DROP TABLE IF EXISTS cars;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

-- 1.	Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов

CREATE OR REPLACE VIEW view1 AS
	SELECT *
    FROM cars
    WHERE cost < 25000;
SELECT * FROM view1;

-- 2.	Изменить в существующем представлении порог для стоимости: 
-- пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW view1 AS 
SELECT *
FROM cars
WHERE cost < 30000;
SELECT * FROM view1;
-- Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE OR REPLACE VIEW view2 AS
	SELECT *
    FROM cars
    WHERE name in ('Audi','Skoda');
SELECT * FROM view2;

-- Задание 2
-- Добавьте новый столбец под названием «время до следующей станции». 
-- Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
-- Мы можем вычислить это значение без использования оконной функции SQL, но это может быть 
-- очень сложно. Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает 
-- значения из одной строки со следующей строкой, чтобы получить результат. В этом случае 
-- функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
DROP TABLE IF EXISTS trains;
CREATE TABLE trains
(
	train_id INT ,
    station VARCHAR(20),
    station_time TIME
);

INSERT trains
VALUES
	(110, "San Francisco", '10:00:00'),
    (110, "Redwood City", '10:54:00'),
    (110, "Palo Alto", '11:02:00'),
    (110, "San Jose", '12:35:00'),
	(120, "San Francisco", '11:00:00'),
    (120, "Palo Alto", '12:49:00' ), 
    (120, "San Jose", '13:30:00');
    
SELECT *
FROM trains;

SELECT train_id,
    station,
    station_time,
	TIMEDIFF( LEAD(station_time) OVER(PARTITION BY train_id ORDER BY station_time) , station_time)
    AS time_to_next_station
FROM trains;

-- ДОП
-- Для скрипта, поставленного в прошлом уроке.
-- 1 Получите друзей пользователя с id=1 (решение задачи с помощью представления “друзья”)
USE lesson_4;
CREATE OR REPLACE VIEW friends AS 
	SELECT * 
    FROM friend_requests JOIN  users on users.id = target_user_id
    WHERE target_user_id = 1 AND status = "approved";
SELECT * FROM  friends;
-- 2 Создайте представление, в котором будут выводится все сообщения, в которых принимал
-- участие пользователь с id = 1.
CREATE OR REPLACE VIEW messages_1 AS 
	SELECT * 
    FROM messages 
    WHERE from_user_id = 1 OR to_user_id = 1;
SELECT * FROM  messages_1;

-- 2 Получите список медиафайлов пользователя с количеством лайков(media m, likes l ,users u)

CREATE OR REPLACE VIEW media_and_likes AS 
	SELECT COUNT(*) AS quantity_of_lkies, media.id, body, filename
    FROM likes JOIN  media on media.id = media_id
    GROUP BY media.id;
SELECT * FROM  media_and_likes;


-- 3 Получите количество групп у пользователей
SELECT COUNT(*), user_id FROM users_communities GROUP BY user_id;
-- 4.1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), 
-- которые не старше 20 лет.

CREATE OR REPLACE VIEW info_about_users AS 
	SELECT user_id, gender,hometown, users.firstname, users.lastname
    FROM `profiles` JOIN users on user_id = users.id
WHERE YEAR(CURDATE() ) - YEAR(`profiles`.birthday) > 20;
SELECT * FROM  info_about_users;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT from_user_id, users.firstname, users.lastname, COUNT(messages.id) AS 'message_count',
	DENSE_RANK() OVER(ORDER BY COUNT(messages.id) DESC) AS 'Dense_Rank'
FROM users
JOIN messages ON messages.from_user_id = users.id
GROUP BY from_user_id
ORDER BY 'message_count' DESC;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите 
-- разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
SELECT * ,
	LAG(created_at ) OVER(PARTITION BY from_user_id ORDER BY created_at) AS `x`,
	DATEDIFF(created_at, LAG(created_at ) OVER(PARTITION BY from_user_id ORDER BY created_at)) AS days_diff
FROM messages;
	
SELECT train_id,
    station,
    station_time,
	TIMEDIFF( LEAD(station_time) OVER(PARTITION BY from_user_id ORDER BY station_time) , station_time)
    AS time_to_next_station
FROM trains;
