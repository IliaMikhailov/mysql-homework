-- 2 Задание: Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP TABLE IF EXISTS users; 
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
 	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


DROP PROCEDURE IF EXISTS add_users ;
delimiter //
CREATE PROCEDURE add_users ()
BEGIN
	DECLARE i INT DEFAULT 50;
	WHILE i > 0 DO
		INSERT INTO users(name) VALUES (i);
		SET i = i - 1;
	END WHILE;
END //
delimiter ;


-- проверяем результат
SELECT * FROM users;

CALL add_users();

SELECT * FROM users LIMIT 10;