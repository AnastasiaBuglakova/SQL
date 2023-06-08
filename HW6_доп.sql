USE lesson_4;
-- Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют 
-- хотя бы одному критерию:
-- а) из одного города
-- б) состоят в одной группе
-- в) друзья друзей

SET @uid = 2;
SELECT user_id, hometown FROM `profiles`
WHERE hometown IN (SELECT hometown FROM `profiles` WHERE user_id = @uid) 
	OR user_id IN (SELECT DISTINCT user_id FROM users_communities WHERE community_id IN (SELECT DISTINCT community_id from users_communities WHERE user_id = @uid))
    OR user_id IN (SELECT initiator_user_id  FROM friend_requests WHERE target_user_id IN 
		(SELECT target_user_id FROM friend_requests WHERE status = 'approved' AND initiator_user_id = @uid) 
		AND status = 'approved' AND initiator_user_id != @uid)
    OR user_id IN (SELECT target_user_id FROM friend_requests WHERE initiator_user_id IN 
		(SELECT initiator_user_id FROM friend_requests WHERE status = 'approved' AND target_user_id = @uid) 
		AND status = 'approved' AND target_user_id != @uid)
ORDER BY rand()
LIMIT 5;

-- Создать функцию, вычисляющей коэффициент популярности пользователя (по количеству друзей)

DROP FUNCTION IF EXISTS get_pop;
DELIMITER //

CREATE FUNCTION get_pop (id INT)
RETURNS DECIMAL
DETERMINISTIC
BEGIN
	DECLARE a INT;
    DECLARE res DECIMAL;
	SET a = id;
	SELECT COUNT(*) INTO res FROM friend_requests WHERE target_user_id = a AND (status = "approved" OR status = "reauested");
    RETURN res;
END//

SELECT get_pop(6);

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего
--  времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция 
-- должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи"
-- Рабочий вариант
DROP FUNCTION IF EXISTS hello;
DELIMITER //

CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE msg VARCHAR(40);
    IF CURRENT_TIME() BETWEEN '00:00:00' AND '05:59:59' 
		THEN SET msg = "Доброй ночи";
	ELSEIF CURRENT_TIME() BETWEEN '06:00:00' AND '11:59:59' 
		THEN SET msg = "Доброе утро";
	ELSEIF CURRENT_TIME() BETWEEN '12:00:00' AND '17:59:59' 
		THEN SET msg = "Добрый день";
	ELSEIF CURRENT_TIME() BETWEEN '18:00:00' AND '23:59:59' 
		THEN SET msg = "Добрый вечер";
	END IF;
	RETURN msg;
END//

SELECT hello();
//
-- Необходимо перебрать всех пользователей и тех пользователей, у которых дата рождения меньше 
-- определенной даты обновить дату рождения на сегодняшнюю дату. (реализация с помощью цикла)
SELECT @rows := COUNT(*) FROM `profiles`;

DELIMITER //
CREATE PROCEDURE while_cycle ()
BEGIN
	DECLARE i INT;
    SET i = @rows;
	WHILE i > 0 DO
		UPDATE `profiles` SET birthday = CURRENT_DATE() WHERE  birthday  < '1980-01-01'; 
		SET i = i - 1;
	END WHILE;
END//
CALL while_cycle (); 
SELECT * FROM `profiles`;

