--STEP 1-IMPORT EXCEL CSV FILE TO POSTGRESQL

CREATE TABLE DiabetesData (
    Pregnancies INT,
    Glucose INT,
    BloodPressure INT,
    SkinThickness INT,
    Insulin INT,
    BMI FLOAT,
    DiabetesPedigree FLOAT,
    Age INT,
    Outcome INT
);
--STEP-2
COPY DiabetesData( Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigree,Age,Outcome)
FROM 'D:\My Projects\diabetes.csv'
DELIMITER ','
CSV HEADER;

--View the first few rows to check the data
SELECT * FROM DiabetesData


--1.Count of Diabetic and Non-Diabetic Patients:
SELECT Outcome, COUNT(*) AS Count
FROM DiabetesData
GROUP BY Outcome;

--2.Average Glucose Level for Diabetic Patients:
SELECT AVG(Glucose) AS Average_Glucose_Diabetic
FROM DiabetesData
WHERE Outcome = 1;

--3.Maximum and Minimum BMI among Non-Diabetic Patients and diabetic patients
SELECT
  MAX(CASE WHEN Outcome = 0 AND BMI > 0 THEN BMI ELSE NULL END) AS Max_BMI_Non_Diabetic,
  MIN(CASE WHEN Outcome = 0 AND BMI > 0 THEN BMI ELSE NULL END) AS Min_BMI_Non_Diabetic,
  MAX(CASE WHEN Outcome = 1 AND BMI > 0 THEN BMI ELSE NULL END) AS Max_BMI_Diabetic,
  MIN(CASE WHEN Outcome = 1 AND BMI > 0 THEN BMI ELSE NULL END) AS Min_BMI_Diabetic
FROM DiabetesData;

--4.Average Age for Patients with More Than 4 Pregnancies:
SELECT ROUND(AVG(age),2) AS Average_Age_More_Pregnancies FROM DiabetesData
WHERE pregnancies > 4;

--5.BMI less than 18.5; status underweight; BMI is 18.5 to <25; status healthy; BMI is 25.0 to <30;
--status overweight and BMI more than 30; then status obesity
SELECT *,
       CASE
           WHEN BMI < 18.5 THEN 'underweight'
           WHEN BMI >= 18.5 AND BMI < 25 THEN 'healthy'
           WHEN BMI >= 25 AND BMI < 30 THEN 'overweight'
           WHEN BMI >= 30 THEN 'obesity'
           ELSE 'unknown'
       END AS BMI_Status
FROM DiabetesData
where outcome=1
order by age DESC ;
--6-Determine the distribution of diabetic patients in various BMI categories 
--(underweight, healthy, overweight, and obesity) to assess the correlation
--between BMI and diabetes in the dataset
SELECT
    BMI_Status,
    COUNT(*) AS Count
FROM (
    SELECT *,
        CASE
            WHEN BMI < 18.5 THEN 'underweight'
            WHEN BMI >= 18.5 AND BMI < 25 THEN 'healthy'
            WHEN BMI >= 25 AND BMI < 30 THEN 'overweight'
            WHEN BMI >= 30 THEN 'obesity'
            ELSE 'unknown'
        END AS BMI_Status
    FROM DiabetesData
    WHERE Outcome = 1
) AS DiabeticPatients
GROUP BY BMI_Status;



--7.Diabetic Patients with a Diabetes Pedigree Score Above 0.5:
SELECT COUNT(diabetespedigree) AS diabetespedigreecount FROM DiabetesData
WHERE Outcome = 1 AND DiabetesPedigree > 0.5;

--8.Average SkinThickness for Patients with Low Glucose (under 90 mg/dL):
SELECT ROUND(AVG(SkinThickness),2) AS Average_SkinThickness_Low_Glucose
FROM DiabetesData
WHERE Glucose < 90;

--9.Oldest Patient with Diabetes
SELECT MAX(Age) AS Oldest_Age_Diabetic
FROM DiabetesData
WHERE Outcome = 1;

--10.Age range Distribution of Patients with Diabetes:
SELECT
    '20-30' AS Age_Range,
    COUNT(*) AS Count
FROM DiabetesData
WHERE Outcome = 1
    AND Age >= 20
    AND Age <= 30
UNION ALL
SELECT
    '30-60' AS Age_Range,
    COUNT(*) AS Count
FROM DiabetesData
WHERE Outcome = 1
    AND Age > 30
    AND Age <= 60;


--10.Patients with the Highest Glucose Level by Age Group:
SELECT Age_Group, MAX(Glucose) AS Max_Glucose
FROM (
  SELECT
    CASE
      WHEN Age < 30 THEN 'Under 30'
      WHEN Age >= 30 AND Age < 50 THEN '30-49'
      ELSE '50 and Over'
    END AS Age_Group,Glucose
  FROM DiabetesData
 ) AS DiabetesData
GROUP BY Age_Group;

--11.Average BMI for Patients with Diabetes by Number of Pregnancies:
SELECT Pregnancies, AVG(BMI) AS Avg_BMI_Diabetic
FROM DiabetesData
WHERE Outcome = 1
GROUP BY Pregnancies
ORDER BY Pregnancies;

--12.Patients with the Highest Glucose Levels and Blood Pressure above the Average:
SELECT *
FROM DiabetesData
WHERE Glucose = (SELECT MAX(Glucose) FROM DiabetesData) AND
      BloodPressure > (SELECT AVG(BloodPressure) FROM DiabetesData);
























