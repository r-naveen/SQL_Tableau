-- Data Analysis and Exploration

-- 1. Finding out the top 5 years with the most hirings

SELECT YEAR(DateofHire) AS hire_year, COUNT(EmpID) AS total_hirings
FROM emp
GROUP BY hire_year
ORDER BY total_hirings DESC
LIMIT 5;

-- 2. Identifying the top 5 years with most Terminations

SELECT YEAR(DateofTermination) AS termination_date, COUNT(EmpID) AS total_terminations
FROM emp
WHERE DateofTermination IS NOT null
GROUP BY termination_date
ORDER BY total_terminations DESC
LIMIT 5;
    
-- 3. Finding out the top earning employees in each department (Using Window Function)

SELECT * from
	(SELECT EmpID, emp_Name, Department, Salary,
	DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) ranking
	FROM emp) x
where x.ranking <= 2;

-- 4. Identifying the maximum salary of a position and comparing it with others in the same position (Using Window Function)

SELECT EmpID, emp_Name, Position, Salary, 
max(Salary) OVER(PARTITION BY Position ORDER BY Salary DESC) AS max_salary
FROM emp;

-- 5. Analyzing the satisfaction level of employees (Using Case)

SELECT
	CASE
		WHEN EmpSatisfaction IN (0,1) THEN 'Unsatisfied'
        WHEN EmpSatisfaction IN (2,3) THEN 'Moderately Satisfied'
        WHEN EmpSatisfaction IN (4,5) THEN 'Highly Satisfied'
        ELSE 'NA'
	END AS Satisfaction_level,
	count(EmpID) AS Employee_count
FROM emp
GROUP BY Satisfaction_level
ORDER BY Employee_count DESC;

-- 6. Gender and Race breakdown of active employees in the company

SELECT Sex, RaceDesc, count(*) AS Employee_count 
FROM emp
WHERE EmploymentStatus = 'Active'
GROUP BY Sex, RaceDesc
ORDER BY Employee_count DESC;
 
-- 7. Creating a View to display employee work information

CREATE VIEW employee_info AS
SELECT CONCAT(EmpID, '. ', emp_Name) AS employee, 
CONCAT(Position, ' in ', Department) AS office,
CONCAT('Earns $', Salary, ' and reports to ', ManagerName) AS Performance
FROM emp
WHERE EmploymentStatus = 'Active'
ORDER BY EmpID;

SELECT * FROM employee_info

-- 8. List of Employees who earn more than the average salary (Using SubQuery)

SELECT EmpID, emp_Name, Salary
FROM emp
WHERE Salary >= (SELECT AVG(Salary) FROM emp WHERE EmpID IS NOT NULL);

-- 9. Analyzing the Age distribution of employees in the company (Using Case)

SELECT
	CASE
		WHEN age BETWEEN 20 AND 35 THEN 'Young'
        WHEN age BETWEEN 36 AND 50 THEN 'Young Adult'
        WHEN age BETWEEN 50 AND 60 THEN 'Adult'
        ELSE 'Old'
	END AS age_dist,
	count(EmpID) AS Employee_count
FROM emp
GROUP BY age_dist;

-- 10. Average employment period of employees who have been terminated (In Years)

SELECT
round(AVG(datediff(DateofTermination, DateofHire))/365,0) AS avg_employment 
FROM emp
WHERE DateofTermination IS NOT NULL

-- 11. Distribution of employees across different States

SELECT State, count(EmpID) AS employee_count
FROM emp
GROUP BY STATE

-- 12. Salary Analysis by departments (Aggregation)

SELECT Department,
MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary,
ROUND(AVG(Salary),2) AS Avg_Salary, SUM(Salary) AS Total_Salary
FROM emp
GROUP BY Department

-- 13. Fetch Personal Information of Employee using Employee ID (Store Procedure)

DELIMITER $$
CREATE PROCEDURE personal_info(IN id INT)
BEGIN
	SELECT emp_Name, Sex, MaritalDesc, DOB, age, RaceDesc
	FROM emp
	WHERE EmpID = id;
END $$
DELIMITER ;

CALL personal_info(10026);

-- 14. Analysing the Average satisfaction level, employee engagement level, age and absences across departments

SELECT Department, 
ROUND(AVG(EngagementSurvey),0) AS Avg_Engagement_Lvl_OutOf5, ROUND(AVG(age),0) AS Avg_Age_in_Yrs,
ROUND(AVG(Absences),0) AS Avg_Absences_In_Days, ROUND(AVG(EmpSatisfaction),0) AS Avg_Satisfaction_Lvl_OutOf5
FROM emp
GROUP BY Department

-- 15. Salary and age of active non-citizen employees (Using SubQuery)

SELECT emp_Name, Salary, Age
FROM emp
WHERE emp_Name IN 
(SELECT emp_Name FROM emp WHERE CitizenDesc IN ('Eligible NonCitizen', 'Non-Citizen') AND EmploymentStatus = 'Active' );

-- 16. Analysis of Marital Status by Gender

SELECT Sex, MaritalDesc, COUNT(EmpID) as Counts 
FROM emp
GROUP BY Sex, MaritalDesc
ORDER BY Counts DESC;