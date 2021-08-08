-- 1 Задание: Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP PROCEDURE IF EXISTS hello;

DELIMITER //

CREATE PROCEDURE hello()
BEGIN 
	SET @timer := current_time();
	select 
	CASE
		when @timer between '00:00:00' and '05:59:59' THEN 'доброй ночи'
		WHEN @timer between '06:00:00' and '11:59:59' THEN 'доброе утро'
		WHEN @timer between '12:00:00' and '17:59:59' THEN 'добрый день'
		WHEN @timer between '18:00:00' and '23:59:59' THEN 'добрый вечер'
	end as say_hello;
END //
DELIMITER ;

call hello();
