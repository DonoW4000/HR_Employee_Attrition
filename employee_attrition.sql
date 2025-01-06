-- Checking the count of total employees is correct to dataset
SELECT COUNT(*) AS Total_Employees FROM hr_employee_attrition;

-- What is the employment distribution by each department?
SELECT Department, COUNT(*) AS Number_of_Employees
FROM hr_employee_attrition
GROUP BY Department; -- most emolyees are part of the R&D department (961) and the least are Human Resources (63)

-- Average monthly income per gender
SELECT Gender, AVG(MonthlyIncome) AS Average_Income
FROM hr_employee_attrition
GROUP BY Gender; -- Female Employees earn more on avg than Males

-- Attrition for each job role
SELECT JobRole, Attrition, COUNT(*) AS Number_of_Employees
FROM hr_employee_attrition
GROUP BY JobRole, Attrition;

-- Relationship between employee attrition and income analysis
SELECT Attrition, AVG(MonthlyIncome) AS Avg_Income, MIN(MonthlyIncome) AS Min_Income, MAX(MonthlyIncome) AS Max_Income
FROM hr_employee_attrition
GROUP BY Attrition; -- Employees lost due to attrition have a lower avg monthly income with an over $2000 difference

-- Work-life balance relationship to attrition
SELECT WorkLifeBalance, Attrition, COUNT(*) AS Number_of_Employees
FROM hr_employee_attrition
GROUP BY WorkLifeBalance, Attrition; -- higher work-life balance ratings are associated with lower attrition. 
-- This suggests that improving work-life balance could potentially reduce employee turnover

-- //
SELECT 
  EmployeeNumber, 
  YearsAtCompany, 
  YearsInCurrentRole, 
  YearsSinceLastPromotion, 
  Attrition,
  CASE 
    WHEN YearsSinceLastPromotion < 3 THEN 'Promoted Recently'
    WHEN YearsSinceLastPromotion BETWEEN 3 AND 7 THEN 'Average Promotion Rate'
    ELSE 'Needs Review for Promotion'
  END AS Promotion_Status
FROM hr_employee_attrition
ORDER BY YearsSinceLastPromotion;

-- Performance vs Income for each job role
SELECT 
  JobRole, 
  PerformanceRating, 
  AVG(MonthlyIncome) AS Avg_Income, 
  COUNT(*) AS Num_Employees 
FROM hr_employee_attrition 
GROUP BY JobRole, PerformanceRating 
ORDER BY Avg_Income DESC; -- On average, roles with less than employees have a performance rating of 4, while more than 50 is 3.

-- What is the average job satisfaction of each department and how do they rank
SELECT 
  Department, 
  AVG(JobSatisfaction) AS Avg_Job_Satisfaction,
  RANK() OVER (ORDER BY AVG(JobSatisfaction) DESC) AS Satisfaction_Ranking
FROM hr_employee_attrition
GROUP BY Department; -- All departments on avg were the same at 2.6-2.7, with Human Resources being the worst and Sales being the best



-- Finding the department with the highest attrition and the roles within that department
WITH DepartmentAttrition AS (
    -- Calculate the total attrition count per department
    SELECT 
        Department, 
        COUNT(*) AS Attrition_Count
    FROM 
        hr_employee_attrition
    WHERE 
        Attrition = 'Yes'  
    GROUP BY 
        Department
    ORDER BY 
        Attrition_Count DESC 
    LIMIT 1 -- limiting to only one department
)
SELECT 
    da.Department,  
    hea.JobRole,  
    COUNT(*) AS Role_Attrition_Count  -- Count of attritions per role
FROM 
    hr_employee_attrition hea
JOIN 
    DepartmentAttrition da ON hea.Department = da.Department 
WHERE 
    hea.Attrition = 'Yes' 
GROUP BY 
    da.Department, hea.JobRole 
ORDER BY 
    Role_Attrition_Count DESC; -- Descending form the role with the highest attrition to the least
-- The Research and Development Dep[artment had the most attrition out of all three departments,
-- Laboratory Technician (62) was the highest in the department, followed by Research Scientist (47) and Manufacturing Directors (10)

