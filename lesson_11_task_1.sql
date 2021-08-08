-- создаём таблицу logs
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  created_at DATETIME,
  table_name varchar(15),
  id_key int(20),
  name varchar(255)
) ENGINE=ARCHIVE;

-- создаём триггеры на добавление данных в logs при добавлении в таблицы новых данных
DROP TRIGGER IF EXISTS check_insert_in_tables;
DELIMITER //
CREATE TRIGGER check_insert_in_tables AFTER INSERT ON products
FOR EACH ROW
	BEGIN
		insert into logs (created_at, table_name, name) values (CURRENT_TIMESTAMP, 'products', new.name);
	END //

CREATE TRIGGER check_insert_in_table_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
	BEGIN
		insert into logs (created_at, table_name, id_key, name) values (CURRENT_TIMESTAMP,'catalogs', new.id, new.name);
	END //

	CREATE TRIGGER check_insert_in_table_users AFTER INSERT ON users
FOR EACH ROW
	BEGIN
		insert into logs (created_at, table_name, id_key, name) values (CURRENT_TIMESTAMP,'users', new.id, new.name);
	END //	
	
DELIMITER ;

-- для удобства добавил сюда команды добавления, чтобы потом посмотреть результат
INSERT INTO products (name, desription, price, catalog_id) values ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1);
INSERT INTO products (name, desription, price, catalog_id) values ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1);
INSERT INTO products (name, desription, price, catalog_id) values ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1);
INSERT INTO products (name, desription, price, catalog_id) values ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1);
INSERT INTO products (name, desription, price, catalog_id) values ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2);
INSERT INTO products (name, desription, price, catalog_id) values ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2);
INSERT INTO products (name, desription, price, catalog_id) values ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
-- смотрим результат
select * from logs;