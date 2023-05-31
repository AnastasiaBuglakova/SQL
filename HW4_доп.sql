-- Доп задание
USE lesson_4;

-- 1 Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT COUNT(*)
FROM likes
JOIN media
ON likes.media_id = media.id
JOIN users
ON users.id = media.user_id
JOIN `profiles`
ON `profiles`.user_id = users.id 
WHERE YEAR(`profiles`.birthday) + 12 > YEAR(CURRENT_DATE);

-- 2 Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT COUNT(*), `profiles`.gender
-- `profiles`.birthday,
-- CONCAT(users.firstname, " ", users.lastname) as person
FROM likes
JOIN users
ON users.id = likes.user_id
JOIN `profiles` 
ON `profiles`.user_id = users.id
 GROUP BY gender;
-- 3 Вывести всех пользователей, которые не отправляли сообщения.
SELECT 
	CONCAT(users.firstname, ' ', users.lastname) AS Person,
    users.id,
	messages.from_user_id
FROM users
LEFT JOIN messages
ON users.id = messages.from_user_id
WHERE messages.from_user_id IS NULL;

-- 4 (по желанию)* Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех написал ему
-- сообщений.

SELECT COUNT(*), to_user_id, from_user_id, CONCAT(users.firstname, ' ', users.lastname) AS From_Person
FROM messages

JOIN users
ON users.id = messages.from_user_id
WHERE to_user_id = 1

GROUP BY from_user_id
ORDER BY COUNT(*);

SELECT from_user_id, to_user_id, COUNT(*) AS rating,
	CONCAT(users.firstname, ' ', users.lastname) AS From_Person
FROM messages
JOIN users
ON messages.from_user_id = users.id
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY rating DESC
LIMIT 1;