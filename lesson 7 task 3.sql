DROP DATABASE IF EXISTS Task_7_3;
CREATE DATABASE Task_7_3;
USE Task_7_3;

CREATE TABLE flights (
	`id` bigint(20) unsigned NOT NULL,
	`fro` varchar(145) NOT NULL,
	`too` varchar(145) NOT NULL
);

CREATE TABLE cities (
	`label` varchar(145) NOT NULL,
	`name` varchar(145) NOT NULL
);

INSERT INTO `flights` (`id`, `fro`, `too`) VALUES ('1', 'moscow', 'omsk');
INSERT INTO `flights` (`id`, `fro`, `too`) VALUES ('2', 'novgorod','kazan');
INSERT INTO `flights` (`id`, `fro`, `too`) VALUES ('3', 'irkutsk', 'moscow');
INSERT INTO `flights` (`id`, `fro`, `too`) VALUES ('4', 'omsk', 'irkutsk');
INSERT INTO `flights` (`id`, `fro`, `too`) VALUES ('5', 'moscow', 'kazan');

INSERT INTO `cities` (`label`, `name`) VALUES ('moscow', 'Москва');
INSERT INTO `cities` (`label`, `name`) VALUES ('irkutsk', 'Иркутск');
INSERT INTO `cities` (`label`, `name`) VALUES ('novgorod', 'Новгород');
INSERT INTO `cities` (`label`, `name`) VALUES ('kazan', 'Казань');
INSERT INTO `cities` (`label`, `name`) VALUES ('omsk', 'Омск');

-- 3 Задание:Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, 
-- name). Поля from, to и label содержат английские названия городов, 
-- поле name — русское. Выведите список рейсов flights с русскими названиями городов.

-- Заменим только столбец откуда 
select f.id, fr.name
from flights as f 
	join cities as fr on f.fro = fr.label;

-- объединим 2 join-а, чтобы получить результат
select f.id, fr.name, fi.name
from flights as f 
	join cities as fr on f.fro = fr.label
	join cities as fi on f.too = fi.label
order by id;

select * from flights;



