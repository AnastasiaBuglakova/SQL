
USE lesson3;
DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45),
	lastname VARCHAR(45),
    post VARCHAR(45),
    seniority INT,
    salary DECIMAL(8,2),
    age INT
);

INSERT staff (firstname, lastname, post, seniority, salary, age)
VALUES
  ('Вася', 'Петров', 'Начальник', 40, 100000, 60),
  ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
  ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
  ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
  ('Иван', 'Иванов', 'Рабочий', 40, 30000, 59),
  ('Петр', 'Петров', 'Рабочий', 20, 25000, 60),
  ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
  ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
  ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
  ('Максим', 'Максимов', 'Рабочий', 2, 11000, 22),
  ('Юрий', 'Галкин', 'Рабочий', 3, 12000, 24),
  ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
  
-- 1 Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания 
SELECT * FROM staff 
ORDER BY salary;
SELECT * FROM staff 
ORDER BY salary DESC;

-- 2 Выведите 5 максимальных заработных плат (saraly)
SELECT * FROM staff 
ORDER BY salary DESC
LIMIT 5;

-- 3 Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT 
	post, 
    SUM(salary) 
FROM staff 
GROUP BY post;

-- 4 Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте 
-- от 24 до 49 лет включительно.
SELECT 
	COUNT(*), 
    post 
FROM staff 
WHERE age >=24 AND age <=49 AND POST = 'Рабочий'
GROUP BY post;

-- 5 Найдите количество специальностей
SELECT COUNT(DISTINCT post)
FROM staff;

-- 6 Выведите специальности, у которых средний возраст сотрудников меньше 30 лет 
SELECT 
    post,
    AVG(age)
FROM staff 
GROUP BY post
HAVING AVG(age) < 30;

-- ДОП Вывести ТОП-2 самых высокооплачиваемых сотрудников в каждой должности
SELECT post, lastname, salary 
FROM (
    SELECT post, lastname, salary, 
        DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank1
    FROM staff
) AS ranked
WHERE rank1 <= 2;
