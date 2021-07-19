-- Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
DROP DATABASE IF EXISTS vk3;
CREATE DATABASE vk3;
USE vk3;

CREATE TABLE users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	email VARCHAR(145) NOT NULL UNIQUE,
	phone CHAR(11) NOT NULL,
	password_hash CHAR(65) DEFAULT NULL,
	created_at VARCHAR(50), -- NOW()
	updated_at VARCHAR(50),
	INDEX (phone),
	INDEX (email)
);

insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (1, 'Tessie', 'Murdy', 'tmurdy0@phoca.cz', 89109965318, 'QzjnQaBU', NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (2, 'Aluino', 'Springham', 'asp@virg.edu', 89267820204, 'hNwDcK9Xd', NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (3, 'Jan', 'Goney', 'jgoney2@open.org', 89339342595, 'fg5aZq', NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (4, 'Emily', 'Spellard', 'espellard3@miibeian.gov.cn', 89280488655, '2lklLutCwZWr', NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (5, 'Regan', 'Hanton', 'rhanton4@wsj.com', 89436307647, NULL, NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (6, 'Jonah', 'Spinige', 'jspinige5@patch.com', 89436298203, 'WVSnIF8F', NULL, NULL);
insert into users (id, first_name, last_name, email, phone, password_hash, created_at, updated_at) 
values (7, 'Celle', 'Morgon', 'cmorgon6@sakura.ne.jp', 89613108583, 'Kh4AznunGc', NULL, NULL);

update users 
set created_at = CURRENT_TIMESTAMP;

update users 
set updated_at = CURRENT_TIMESTAMP;

ALTER TABLE users MODIFY created_at DATETIME default now();
ALTER TABLE users MODIFY updated_at DATETIME default now();

show FIELDS from users;

select * from users;
