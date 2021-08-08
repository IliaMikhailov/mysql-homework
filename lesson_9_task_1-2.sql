-- 1 Задание: В базе данных shop и sample присутствуют одни и те же таблицы, 
-- учебной базы данных. Переместите запись id = 1 из таблицы shop.users
-- таблицу sample.users. Используйте транзакции.
START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;
-- смотрим результат переноса 
SELECT * FROM shop.users;
SELECT * FROM sample.users;


-- 2 Задание: Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.
CREATE or replace VIEW name_product
as
SELECT name FROM catalogs WHERE name like 'Процессор%'
union 
SELECT name FROM products WHERE desription like 'Процессор%';

-- смотрим результат представления
select * from name_product;

