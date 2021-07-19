DROP DATABASE IF EXISTS task_5_5;
CREATE DATABASE task_5_5;
USE task_5_5;

CREATE TABLE catalogs(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	catalog_name VARCHAR(145) NOT NULL
);

insert INTO catalogs(id, catalog_name)
VALUES (1, 'first'),
		(2, 'second'),
		(3, 'third'),
		(4, 'fourth'),
		(5, 'fifth'),
		(6, 'sixth'),
		(7, 'seventh');

SELECT * FROM catalogs WHERE id IN(5, 1, 2) order by catalog_name;































