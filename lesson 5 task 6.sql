DROP DATABASE IF EXISTS vk6;
CREATE DATABASE vk6;
USE vk6;

CREATE TABLE users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	created_at DATETIME DEFAULT now(),
	birthday DATE NOT NULL
);


insert into users (id, first_name, last_name, created_at, birthday) 
values (1, 'Tessie', 'Murdy', DEFAULT, '2001-08-12');
insert into users (id, first_name, last_name, created_at, birthday) 
values (2, 'Aluino', 'Springham', DEFAULT, '2002-05-03');
insert into users (id, first_name, last_name, created_at, birthday)  
values (3, 'Jan', 'Goney', DEFAULT, '1990-02-22');
insert into users (id, first_name, last_name, created_at, birthday)  
values (4, 'Emily', 'Spellard', DEFAULT, '1998-06-17');
insert into users (id, first_name, last_name, created_at, birthday)  
values (5, 'Regan', 'Hanton', DEFAULT, '2004-10-10');
insert into users (id, first_name, last_name, created_at, birthday)  
values (6, 'Jonah', 'Spinige', DEFAULT, '2002-12-12');
insert into users (id, first_name, last_name, created_at, birthday)  
values (7, 'Celle', 'Morgon', DEFAULT, '2000-01-05');

select TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age from users;

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())) AS average_age from users;































