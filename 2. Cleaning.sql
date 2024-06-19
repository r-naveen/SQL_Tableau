-- Cleaning the Dataset

-- 1. Changing column name

ALTER TABLE emp
RENAME COLUMN ï»¿Employee_Name TO emp_Name;

-- 2. Converting columns to date datatype which are in text format

set sql_safe_updates = 0;

update emp
set DOB = CASE
	WHEN DOB like '%-%' THEN date_format(str_to_date(DOB, '%Y-%m-%d'), '%Y-%m-%d')
END;

update emp
set DateofHire = CASE
	WHEN DateofHire like '%-%' THEN date_format(str_to_date(DateofHire, '%Y-%m-%d'), '%Y-%m-%d')
END;

update emp
set DateofTermination = CASE
	WHEN DateofTermination like '%-%' THEN date_format(str_to_date(DateofTermination, '%Y-%m-%d'), '%Y-%m-%d')
END;

update emp
set LastPerformanceReview_Date = CASE
	WHEN LastPerformanceReview_Date like '%-%' THEN date_format(str_to_date(LastPerformanceReview_Date, '%Y-%m-%d'), '%Y-%m-%d')
END;

-- 3. Calculate the age of employees and adding it as a new column

alter table emp
add column age INT

update emp
set age = timestampdiff(YEAR,DOB,CURDATE());