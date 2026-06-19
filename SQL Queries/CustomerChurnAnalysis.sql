
DROP table telecom_customers;
CREATE TABLE telecom_customers (
    customerID VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(8),
    SeniorCitizen INT,
    Partner VARCHAR(3),
    Dependents VARCHAR(3),
    tenure INT,
    PhoneService VARCHAR(3),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(25),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(3),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(3)
);

copy telecom_customers(customerID, gender, SeniorCitizen, Partner, Dependents, tenure, PhoneService, MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies, 
Contract, PaperlessBilling, PaymentMethod, MonthlyCharges, TotalCharges, Churn)
from 'F:\Project _File\CustomerChurnAnalysisCleaned.csv'
DELIMITER ','
CSV header;

select * from telecom_customers;

-- 1. How many customers are there in the dataset?
select count(*) as TotalCustomer from telecom_customers;

-- 2. How many customers have churned?
SELECT COUNT(*) AS churned_customers
FROM telecom_customers
WHERE Churn = 'Yes';

-- 3. What is the overall churn rate?
select  ROUND(
        (COUNT(CASE WHEN Churn='Yes' THEN 1 END)::DECIMAL
        / COUNT(*)) * 100,
        2
    )  
as  churn_Rate from telecom_customers;
-- 4. What is the gender distribution of customers?
select gender,count(*) as CountGender from telecom_customers group by gender;
-- 5. Which gender has the highest churn?
select gender ,count(*) as TotalGender from telecom_customers where churn='Yes'
group by gender order by TotalGender DESC;
-- 6. How many senior citizens are there?
SELECT
    SeniorCitizen,
    COUNT(*) AS total_customers
FROM telecom_customers
GROUP BY SeniorCitizen;

--7. Which contract type has the highest churn?
SELECT
    Contract,
    COUNT(*) AS churned_customers
FROM telecom_customers
WHERE Churn='Yes'
GROUP BY Contract
ORDER BY churned_customers DESC;
-- 8. What is the average monthly charge for churned and non-churned customers?
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges),2) AS average_monthly_charge
FROM telecom_customers
GROUP BY Churn;
-- 9. Which payment method is most commonly used?
select paymentMethod , count(*) as TotalCount from telecom_customers 
group by paymentMethod order by TotalCount DESC;

-- 10. Which payment method has the highest churn?
select paymentMethod , count(*) as TotalCount from telecom_customers where churn='Yes'
group by paymentMethod order by TotalCount DESC;

-- 11. Does paperless billing affect churn?
SELECT
    PaperlessBilling,
    COUNT(*) AS churned_customers
FROM telecom_customers
WHERE Churn='Yes'
GROUP BY PaperlessBilling;

-- 12. Which internet service has the highest churn?
select InternetService ,count(*) as Totalchurn from telecom_customers where churn='Yes' group by
InternetService Order by Totalchurn DESC;

-- 13. How does tenure affect churn?
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END AS tenure_group,

    COUNT(*) AS churned_customers

FROM telecom_customers

WHERE Churn='Yes'

GROUP BY tenure_group

ORDER BY tenure_group;

-- 14. Which customers have the highest monthly charges?
SELECT
    customerID,
    MonthlyCharges
FROM telecom_customers
ORDER BY MonthlyCharges DESC
LIMIT 10;

-- 15. Which customers have stayed the longest?
SELECT
    customerID,
    tenure
FROM telecom_customers
ORDER BY tenure DESC
LIMIT 10;

-- 16. Which combination of contract and internet service has the highest churn?
SELECT
    Contract,
    InternetService,
    COUNT(*) AS churned_customers
FROM telecom_customers
WHERE Churn='Yes'
GROUP BY Contract, InternetService
ORDER BY churned_customers DESC;