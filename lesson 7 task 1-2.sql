USE Task_7_2;
-- 1. Задание: Составьте список пользователей users, 
-- которые осуществили хотя бы один заказ orders в интернет магазине.
select users.id, users.name 
from orders 
join users on users.id = orders.user_id;

-- 2 Задание: Выведите список товаров products и разделов catalogs, 
-- который соответствует товару.
SELECT name FROM catalogs WHERE name like 'Процессор%'
union 
SELECT name FROM products WHERE desription like 'Процессор%';









