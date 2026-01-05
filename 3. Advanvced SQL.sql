-- STORED PROCEDURES
SELECT *
FROM employee_salary
WHERE salary >=50000
;

large_salaries2
DELIMITER $$
CREATE PROCEDURE large_salaries1()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >=50000
	;
	SELECT *
	FROM employee_salary
	WHERE salary >=10000
;
END $$
DELIMITER ;
CALL large_salaries1();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary =50000 AND salary <=60000
	;
	SELECT *
	FROM employee_salary
	WHERE salary <=10000 
;
END $$
DELIMITER ;
CALL large_salaries2();
-- hjmlk,l.l,


DELIMITER $$
CREATE PROCEDURE large_salaries5(huggymuffin_param INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = huggymuffin_param
    ;
END $$
DELIMITER ;
CALL large_salaries5(1);



-- TRIGGERS AND EVENTS
-- This is a block of code which is executed automatically when a event takes place on a specific table

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics(employee_id,first_name,last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END$$
DELIMITER ;

INSERT INTO employee_salary(employee_id,first_name,last_name,occupation,salary,dept_id)
VALUES (13 ,'Jean-Ralphio' ,'Saperstein' ,'Entertainment 720 CEO' ,111000, 4);
	
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


-- EVENTS 
-- a scheduled automator

SELECT *
FROM employee_demographics;
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE 
	FROM employee_demographics
	WHERE age >= 60;
END $$
DELIMITER ;
SHOW VARIABLES LIKE 'event%';


