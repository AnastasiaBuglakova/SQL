-- Основное ДЗ:
-- Создайте процедуру, которая принимает кол-во сек и формат их в кол-во дней, часов, минут и секунд.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

USE hw6;

DROP PROCEDURE IF EXISTS conv_time; 
DELIMITER $$
CREATE PROCEDURE conv_time
(
	IN num INT,
    IN form VARCHAR(4),
    OUT t VARCHAR(180)
)
BEGIN
	DECLARE days VARCHAR(20); 
	DECLARE hours VARCHAR(20);
	DECLARE minutes VARCHAR(20);
	DECLARE seconds VARCHAR(20);
	DECLARE num_time INT;
    DECLARE format VARCHAR(4);
    SET format= form;
    IF format = 'dhms' THEN
		SET num_time = num;
		SET days = CONCAT((num_time DIV 86400), " days ");
		SET num_time = num_time % 86400;
		SET hours = CONCAT((num_time DIV 3600), " hours ");
		SET num_time = num_time % 3600;
		SET minutes = CONCAT((num_time  DIV  60), " minutes ");
		SET num_time = num_time % 60;
		SET seconds = CONCAT(num_time, " seconds ");
		
		SET t = CONCAT(CONCAT(days , hours), CONCAT(minutes, seconds));
        
	ELSEIF format = 'hms' THEN
		SET num_time = num;
		SET hours = CONCAT((num_time DIV 3600), " hours ");
		SET num_time = num_time % 3600;
		SET minutes = CONCAT((num_time  DIV  60), " minutes ");
		SET num_time = num_time % 60;
		SET seconds = CONCAT(num_time, " seconds ");
		
		SET t = CONCAT(hours, CONCAT(minutes, seconds));
	END IF;
END $$
-- Вызов процедуры 
CALL conv_time(123456,'hms', @outtime); 
SELECT @outtime;



