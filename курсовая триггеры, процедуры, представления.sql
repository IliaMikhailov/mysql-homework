use smk;

DROP PROCEDURE IF EXISTS add_production;
DELIMITER //
CREATE PROCEDURE add_production(tech_name VARCHAR(145), cost Decimal, inc_control_need boolean)
BEGIN 
	DECLARE tran_rollback BOOL DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
	BEGIN
		SET tran_rollback = 1;
	GET stacked DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		SET @tran_result := CONCAT(code, ': ', error_string);
	END ;

	START TRANSACTION;
	INSERT INTO production (tech_name, cost, inc_control_need) VALUES (tech_name, cost, inc_control_need);
	IF tran_rollback THEN
		ROLLBACK;
	ELSE
		SET @tran_result := 'ok';
		COMMIT;
	END IF;	
END //
DELIMITER ;
-- пробное добавление продукции
CALL add_production('711112.001', 350, 1);

-- для проверки результата добавления
-- SELECT  @tran_result;
-- select * from production p where tech_name = '711112.001';

CREATE or replace VIEW view_summ_of_utilisation
AS
select dp.tech_name, dp.number_in_shipment * p.cost from defect_production dp
	join production p on p.tech_name = dp.tech_name 
where solution = 'Выставить рекламацию. Списать и утилизировать' or 'Списать и утилизировать';
 
SELECT * FROM view_last_date_solutions;


DROP TRIGGER IF EXISTS check_date_of_custom;

DELIMITER //

CREATE TRIGGER check_date_of_custom BEFORE insert ON warehouse
FOR EACH ROW
BEGIN 
	IF NEW.date_of_custom is not null THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. date of custom must be NULL';
    END IF;
END //

DELIMITER ;


DROP TRIGGER IF exists check_control_complete;
delimiter //
CREATE TRIGGER check_control_complete after update ON incoming_control
FOR EACH ROW
	begin
		IF NEW.control or NEW.control_result IS NULL THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Update Canceled. after update control, control_result must be not NULL';
		END IF;
	END //
delimiter ;

DROP TRIGGER IF exists check_solution;
delimiter //
CREATE TRIGGER check_solution after update ON defect_production
FOR EACH ROW
	begin
		IF NEW.solution or NEW.type_of_defect or text_of_defect IS NULL THEN 
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Update Canceled. after update solution, type_of_defect, text_of_defect must be not NULL';
		END IF;
	END //
delimiter ;


