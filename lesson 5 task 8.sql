-- Подсчитайте произведение чисел в столбце таблицы.
DROP DATABASE IF EXISTS Task_8;
CREATE DATABASE Task_8;
USE Task_8;

CREATE TABLE numbers(
	number INT NOT NULL
);

insert into numbers
values (1),
	   (2),
	   (3),
	   (4),
	   (5);

select * from numbers;
-- ln(1)+ .. +ln(n) = ln(1*..*n)
select exp(sum(log(number))) from numbers;
