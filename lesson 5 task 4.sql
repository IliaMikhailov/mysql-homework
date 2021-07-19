DROP DATABASE IF EXISTS vk4;
CREATE DATABASE vk4;
USE vk4;

CREATE TABLE users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- NOW()
	birthday_month VARCHAR(20) NOT NULL
);

insert into users (id, first_name, last_name, created_at, birthday_month) 
values (1, 'Tessie', 'Murdy', DEFAULT, 'may');
insert into users (id, first_name, last_name, created_at, birthday_month) 
values (2, 'Aluino', 'Springham', DEFAULT, 'may');
insert into users (id, first_name, last_name, created_at, birthday_month)  
values (3, 'Jan', 'Goney', DEFAULT, 'june');
insert into users (id, first_name, last_name, created_at, birthday_month)  
values (4, 'Emily', 'Spellard', DEFAULT, 'august');
insert into users (id, first_name, last_name, created_at, birthday_month)  
values (5, 'Regan', 'Hanton', DEFAULT, 'february');
insert into users (id, first_name, last_name, created_at, birthday_month)  
values (6, 'Jonah', 'Spinige', DEFAULT, 'august');
insert into users (id, first_name, last_name, created_at, birthday_month)  
values (7, 'Celle', 'Morgon', DEFAULT, 'september');

SELECT * FROM users WHERE birthday_month = 'may' OR birthday_month = 'august';






























