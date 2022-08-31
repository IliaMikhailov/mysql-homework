-- 2 Задание: В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS check_birthday_before_insert;
DELIMITER //
CREATE TRIGGER check_not_null_name_and_description BEFORE INSERT ON products
FOR EACH ROW
	BEGIN
		IF (NEW.name is null) and (NEW.desription is null) THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Insert Canceled. name and descriprion can not be null either';
		END IF;
	END //
DELIMITER ;

-- будет ошибка ввода
INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  (NULL, NULL, 7890.00, 1);
 
-- здесь ошибки не будет
 INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  (NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i3-8100', NULL, 7890.00, 1);
 
 -- смотрим, что сохранилось в таблице
 select * from products;
