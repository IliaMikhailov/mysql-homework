DROP DATABASE IF EXISTS storehouses_products;
CREATE DATABASE storehouses_products;
USE storehouses_products;

CREATE TABLE products(
	value BIGINT NOT NULL
);

INSERT into products(value) 
VALUES  (0),
   		(2500),
   		(0),
		(30),
		(500),
		(1);

select value from products order by if (value > 0, 0, 1), value;



























