use rishabh ;

CREATE TABLE health (
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(20),
    Blood_Type VARCHAR(10),
    Medical_Condition VARCHAR(100),
    Date_of_Admission text,
    Doctor VARCHAR(100),
    Hospital VARCHAR(150),
    Insurance_Provider VARCHAR(100),
    Billing_Amount float,
    Room_Number INT,
    Admission_Type VARCHAR(50),
    Discharge_Date text,
    Medication VARCHAR(100),
    Test_Results VARCHAR(100)
);

select * from health;

drop table health;


-- 2. First Step: Data Exploration (EDA)
-- Question 1: How many records are in the dataset?
select count(*) from health;
-- 2: How many unique hospitals are present? 
select count(distinct(Hospital)) from health;
-- 3: What is the total billing amount?
select Round(sum(Billing_Amount),2) from health;
-- 4: What is the minimum and maximum patient age?
SELECT
    MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age
FROM health;
-- 5: What is the date range of the dataset?
SELECT
    MIN(Date_of_Admission) AS First_Admission,
    MAX(Date_of_Admission) AS Last_Admission
FROM health;
-- 6: Check duplicate records.
SELECT *,
       COUNT(*) AS Duplicate_Count
FROM health
GROUP BY
    Name, Age, Gender, Blood_Type,
    Medical_Condition, Date_of_Admission,
    Doctor, Hospital, Insurance_Provider,
    Billing_Amount, Room_Number,
    Admission_Type, Discharge_Date,
    Medication, Test_Results
HAVING COUNT(*) > 1;



-- A. Patient Analysis
-- 	How many total patients are recorded?
select count(Name) from health;
-- What is the gender distribution of patients? 
SELECT
    Gender,
    COUNT(*) AS Total_Patients,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM health),
        2
    ) AS Percentage
FROM health
GROUP BY Gender
ORDER BY Total_Patients DESC;
-- 	What is the average age of patients?
select avg(Age) from health;
-- 	Which age group has the highest number of patients?
select 
case
 when age  between 0 and 18 then "0-18"
 when age  between 19 and 30 then "19-30"
 when age  between 31 and 45 then "31-45"
 when age  between 46 and  60 then "46-60"
 when age  between 61 and 75 then "61-75"
 else "76-100"
 end as As_group,
 count(*)
 from health
 group by As_group
 order by count(*) desc
 limit 1;
 -- Which blood group is most common?
 select Blood_Type,count(*) from health
 group by Blood_Type
 order by count(*) desc
 limit 1;
 -- What are the top 5 most common medical conditions?
 select Medical_Condition ,count(*) from health
 group by Medical_Condition
 order by Count(*)
 limit 5;
 
 
 
 -- B. Hospital Performance Analysis
 -- 	Which hospital has the highest number of admissions?
  select Hospital,count(*) from health
 group by Hospital
 order by count(*) desc
 limit 1; 
 -- 	Which hospital generates the highest total billing amount?
 select Hospital, sum(Billing_Amount)AS total_billing_Amount from health
 group by Hospital
 order by total_billing_Amount desc
 limit 1;
 -- 	What is the average billing amount for each hospital?
 select Hospital, Avg(Billing_Amount)AS Avg_billing_Amount from health
 group by Hospital;
 -- 	Which hospitals have the highest average patient age?
 SELECT
    Hospital,
    ROUND(AVG(Age), 2) AS Average_Patient_Age,
    COUNT(*) AS Total_Patients
FROM health
WHERE Age IS NOT NULL
GROUP BY Hospital
ORDER BY Average_Patient_Age DESC
LIMIT 10;
-- Which doctor attends the highest number of patients?
select Doctor, count(*) from health
group by Doctor
limit 1;
-- 	What are the top 10 hospitals by patient admissions?
SELECT
    Hospital,
    COUNT(*) AS Total_Admissions
FROM health
GROUP BY Hospital
ORDER BY Total_Admissions DESC
LIMIT 10;


-- C. Medical Condition Analysis
-- 	Which medical condition has the highest number of patients?
select Medical_Condition, Count(*) From health
group by Medical_Condition
order by Count(*) desc
limit 1;
-- What is the average billing amount for each medical condition?
select Medical_Condition, Avg(Billing_Amount) From health
group by Medical_Condition;
-- 	Which medical condition has the highest average billing?
select Medical_Condition, Avg(Billing_Amount)as avg_billing_amount From health
group by Medical_Condition
order by avg_billing_amount desc
limit 1 ;
-- What is the gender distribution for each medical condition?
SELECT
    Medical_Condition,
    Gender,
    COUNT(*) AS Total_Patients
FROM health
GROUP BY
    Medical_Condition,
    Gender
ORDER BY
    Medical_Condition,
    Total_Patients DESC;
-- Which medications are prescribed most frequently?
SELECT
    Medication,
    COUNT(*) AS Total_Prescriptions
FROM health
WHERE Medication IS NOT NULL
GROUP BY Medication
ORDER BY Total_Prescriptions DESC
LIMIT 10;
-- 	What are the test result distributions?
SELECT
    Test_Results,
    COUNT(*) AS Total_Patients,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM health
         WHERE Test_Results IS NOT NULL), 2
    ) AS Percentage
FROM health
WHERE Test_Results IS NOT NULL
GROUP BY Test_Results
ORDER BY Total_Patients DESC;



-- D. Revenue & Billing Analysis
-- 	What is the total healthcare billing revenue?
select sum(Billing_Amount) from health;

-- 	What is the average billing amount per patient?
select Name,avg(Billing_Amount) from health
group by Name ;
-- 	Which insurance provider has the highest total billing?
select Insurance_Provider ,max(Billing_Amount) from health
group by Insurance_Provider; 
-- 	Which admission type generates the highest billing?
SELECT
    Admission_Type,
    ROUND(SUM(Billing_Amount), 2) AS Total_Billing
FROM health
GROUP BY Admission_Type
ORDER BY Total_Billing DESC;
-- Which hospitals have billing above the overall average?
SELECT
    Hospital,
    ROUND(AVG(Billing_Amount), 2) AS Average_Billing
FROM health
GROUP BY Hospital
HAVING AVG(Billing_Amount) > (
    SELECT AVG(Billing_Amount)
    FROM health
)
ORDER BY Average_Billing DESC;
-- What are the top 10 highest patient billing amounts?
SELECT
    Name,
    Hospital,
    Medical_Condition,
    Billing_Amount
FROM health
WHERE Billing_Amount IS NOT NULL
ORDER BY Billing_Amount DESC
LIMIT 10;


-- E. Admission & Discharge Analysis
-- 	How many patients were admitted each year?
SELECT
    YEAR(Date_of_Admission) AS Admission_Year,
    COUNT(*) AS Total_Admissions
FROM health
WHERE Date_of_Admission IS NOT NULL
GROUP BY YEAR(Date_of_Admission)
ORDER BY Admission_Year;
-- 	Which month has the highest number of admissions?
SELECT
    MONTHNAME(Date_of_Admission) AS Admission_Month,
    COUNT(*) AS Total_Admissions
FROM health
WHERE Date_of_Admission IS NOT NULL
GROUP BY MONTH(Date_of_Admission), MONTHNAME(Date_of_Admission)
ORDER BY Total_Admissions DESC;
-- 	What is the average length of hospital stay?
SELECT
    ROUND(AVG(DATEDIFF(Discharge_Date, Date_of_Admission)), 2)
    AS Average_Stay_Days
FROM health
WHERE Discharge_Date IS NOT NULL
AND Date_of_Admission IS NOT NULL;
-- Which admission type is most common?
SELECT
    Admission_Type,
    COUNT(*) AS Total_Admissions
FROM health
GROUP BY Admission_Type
ORDER BY Total_Admissions DESC;
-- 	Which patients stayed in the hospital for more than 10 days?
SELECT
    Patient_ID,
    Name,
    Hospital,
    Medical_Condition,
    Date_of_Admission,
    Discharge_Date,
    DATEDIFF(Discharge_Date, Date_of_Admission) AS Stay_Days
FROM health
WHERE DATEDIFF(Discharge_Date, Date_of_Admission) > 10;
	-- Which hospital has the longest average patient stay?
    SELECT
    Hospital,
    ROUND(
        AVG(DATEDIFF(Discharge_Date, Date_of_Admission)), 2
    ) AS Average_Stay_Days,
    COUNT(*) AS Total_Patients
FROM health
WHERE Discharge_Date IS NOT NULL
AND Date_of_Admission IS NOT NULL
GROUP BY Hospital
ORDER BY Average_Stay_Days DESC
LIMIT 10;


-- F. Advanced SQL Analysis
-- 	Find the second-highest billing amount.
SELECT MAX(Billing_Amount) AS Second_Highest_Billing
FROM health
WHERE Billing_Amount < (
    SELECT MAX(Billing_Amount)
    FROM health
);
-- 	Rank hospitals based on total billing.
SELECT
    Hospital,
    SUM(Billing_Amount) AS Total_Billing,
    DENSE_RANK() OVER (
        ORDER BY SUM(Billing_Amount) DESC
    ) AS Hospital_Rank
FROM health
GROUP BY Hospital;
-- 	Find the top 3 medical conditions in each hospital.
WITH Condition_Rank AS (
    SELECT
        Hospital,
        Medical_Condition,
        COUNT(*) AS Total_Patients,
        RANK() OVER (
            PARTITION BY Hospital
            ORDER BY COUNT(*) DESC
        ) AS Condition_Rank
    FROM health
    GROUP BY Hospital, Medical_Condition
)
SELECT
    Hospital,
    Medical_Condition,
    Total_Patients,
    Condition_Rank
FROM Condition_Rank
WHERE Condition_Rank <= 3
ORDER BY Hospital, Condition_Rank;
-- 	Compare hospital billing with overall average billing.
SELECT DISTINCT
    Hospital,
    ROUND(
        AVG(Billing_Amount) OVER (
            PARTITION BY Hospital
        ), 2
    ) AS Hospital_Avg_Billing,
    ROUND(
        AVG(Billing_Amount) OVER (), 2
    ) AS Overall_Avg_Billing
FROM health
WHERE Billing_Amount IS NOT NULL
ORDER BY Hospital_Avg_Billing DESC;
-- Calculate monthly billing trends.
WITH Monthly_Billing AS (
    SELECT
        YEAR(Date_of_Admission) AS Admission_Year,
        MONTH(Date_of_Admission) AS Admission_Month,
        MONTHNAME(Date_of_Admission) AS Month_Name,
        SUM(Billing_Amount) AS Total_Billing
    FROM health
    WHERE Date_of_Admission IS NOT NULL
    GROUP BY
        YEAR(Date_of_Admission),
        MONTH(Date_of_Admission),
        MONTHNAME(Date_of_Admission)
)
SELECT
    Admission_Year,
    Month_Name,
    ROUND(Total_Billing, 2) AS Total_Billing
FROM Monthly_Billing
ORDER BY Admission_Year, Admission_Month;
-- 	Find doctors whose patient count is above average.
WITH Doctor_Patient_Count AS (
    SELECT
        Doctor,
        COUNT(*) AS Total_Patients
    FROM health
    WHERE Doctor IS NOT NULL
    GROUP BY Doctor
)
SELECT
    Doctor,
    Total_Patients
FROM Doctor_Patient_Count
WHERE Total_Patients > (
    SELECT AVG(Total_Patients)
    FROM Doctor_Patient_Count
)
ORDER BY Total_Patients DESC;



















