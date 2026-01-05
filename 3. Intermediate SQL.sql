-- Joins These allow you to join 2 or more tables if they have a common column
SELECT *
FROM parks_and_recreation.employee_demographics;

-- These two tables have same column employee_id 

SELECT *
FROM parks_and_recreation.employee_salary;

-- Inner Join returns rows that are the same in both columns of both tables
SELECT *
FROM parks_and_recreation.employee_demographics AS dem # aliasing
INNER JOIN employee_salary AS sal # aliases
	ON dem.employee_id= sal.employee_id
;

SELECT dem.employee_id,age,occupation
FROM parks_and_recreation.employee_demographics AS dem # aliasing
INNER JOIN employee_salary AS sal # aliases
	ON dem.employee_id= sal.employee_id;


# OUTER JOINS
# left Outer Join it takes everything from the left table and match it with everything in the right table;

SELECT *
FROM parks_and_recreation.employee_demographics AS dem # aliasing
LEFT JOIN employee_salary AS sal # aliases
	ON dem.employee_id= sal.employee_id
    ;


# Right  Outer Join- it takes everything from the right table and match it with everything in the left table;

SELECT *
FROM parks_and_recreation.employee_demographics AS dem # aliasing
RIGHT JOIN employee_salary  sal # aliases
	ON dem.employee_id= sal.employee_id
    ;
    
#SELF JOIN

SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON Emp1.employee_id+1=emp2.employee_id
    ;
    

SELECT emp1.employee_id AS  emp_santa,
emp1.first_name  first_name_santa,
emp1.last_name  last_name_santa,
emp2.employee_id  emp_name,
emp2.first_name  first_name_emp,
emp2.last_name  last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON Emp1.employee_id+1=emp2.employee_id
    ;

-- Joining Multiple tables

SELECT *
FROM parks_and_recreation.employee_demographics AS dem # aliasing
INNER JOIN employee_salary AS sal # aliases
	ON dem.employee_id= sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id=pd.department_id
;

SELECT *
FROM parks_departments;

-- UNION allows you to combine rows together (you take one select 
SELECT first_name,last_name
FROM employee_demographics
UNION ALL
SELECT first_name,last_name
FROM employee_salary;

SELECT first_name,last_name
FROM employee_demographics
UNION ALL
SELECT first_name,last_name
FROM employee_salary;

SELECT  first_name ,last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age >40
UNION
SELECT  first_name ,last_name, 'Old lady' AS label
FROM employee_demographics
WHERE age >40 AND gender ='Female'
UNION
SELECT  first_name ,last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary>70000;

-- STRING FUNCTIONS
SELECT length('skyfall');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

SELECT UPPER('skyfall');

SELECT LOWER('skyfall');

SELECT L('skyfall');

SELECT first_name ,UPPER(first_name)
FROM employee_demographics;


-- CASE STATEMENTS
SELECT first_name,
last_name,
CASE 
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_bracket
FROM employee_demographics;

-- Pay Increase and Bonus

SELECT first_name,last_name,salary,
CASE
	WHEN salary <=50000 THEN salary+(salary*0.05)
    WHEN salary >50000 THEN salary * 1.07
END AS New_salary,
CASE
	WHEN dept_id=6 THEN salary*1.10
END AS Bonus
FROM employee_salary;


-- SUB QUERIES
# we are selecting everything in demographics table where emp_id matches
SELECT *
FROM 	employee_demographics
WHERE employee_id IN 
				( SELECT employee_id
					FROM employee_salary
					WHERE dept_id=1 )
;


SELECT first_name,salary ,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary
;

SELECT gender,AVG(age),Max(age),Count(age)
FROM employee_demographics
GROUP BY gender;

SELECT  *
FROM 
(SELECT gender,AVG(age) avg_age,
Max(age) max_age,
Count(age) count_age
FROM employee_demographics
GROUP BY gender) AS Agg_table
;

SELECT  AVG(max_age)
FROM 
(SELECT gender,AVG(age) avg_age,
Max(age) max_age,
Count(age) count_age
FROM employee_demographics
GROUP BY gender) AS Agg_table
;

-- WINDOW FUNCTIONS
-- Rolling Total its adding up salry totals based on gender

SELECT dem.first_name,
		dem.last_name,
        gender,
        salary,
SUM(salary) OVER( PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;


SELECT dem.employee_id,
		dem.first_name,
        dem.last_name,
        gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num, #no duplicates
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num, # duplicates positionally
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num # duplicates numerically
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id =sal.employee_id;

