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