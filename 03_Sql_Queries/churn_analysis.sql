/*=========================================================
TELCO CUSTOMER CHURN ANALYSIS


Objective:
Analyze customer churn patterns, identify key churn drivers,
quantify revenue at risk, and uncover high-risk customer
segments using SQL.

=========================================================*/

-- =====================================================
-- DATABASE SELECTION

USE customer_churn_project;

-- =====================================================
-- DATA VALIDATION

SHOW TABLES;

SELECT *
FROM clean_telco_churn
LIMIT 5;

-- =====================================================
-- KPI ANALYSIS

-- Total Customers

SELECT
    COUNT(*) AS total_customers
FROM clean_telco_churn;

-- Churned Customers

SELECT
    COUNT(*) AS churned_customers
FROM clean_telco_churn
WHERE Churn = 'Yes';

-- Overall Churn Rate

SELECT
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn;

-- =====================================================
-- CHURN DRIVER ANALYSIS


-- Churn by Contract Type

SELECT
    Contract,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY Contract
ORDER BY churn_rate DESC;

-- Churn by Internet Service

SELECT
    InternetService,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- Churn by Online Security

SELECT
    OnlineSecurity,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY OnlineSecurity
ORDER BY churn_rate DESC;

-- Churn by Tech Support

SELECT
    TechSupport,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY TechSupport
ORDER BY churn_rate DESC;

-- Churn by Payment Method

SELECT
    PaymentMethod,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- Churn by Online Backup

SELECT
    OnlineBackup,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY OnlineBackup
ORDER BY churn_rate DESC;

-- Churn by Device Protection

SELECT
    DeviceProtection,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY DeviceProtection
ORDER BY churn_rate DESC;

-- Churn by Paperless Billing

SELECT
    PaperlessBilling,
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
GROUP BY PaperlessBilling
ORDER BY churn_rate DESC;

-- =====================================================
-- REVENUE IMPACT ANALYSIS


-- Monthly Revenue at Risk

SELECT
    ROUND(SUM(MonthlyCharges), 2) AS revenue_at_risk
FROM clean_telco_churn
WHERE Churn = 'Yes';

-- Revenue at Risk by Contract Type

SELECT
    Contract,
    COUNT(*) AS churned_customers,
    ROUND(SUM(MonthlyCharges), 2) AS revenue_at_risk
FROM clean_telco_churn
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY revenue_at_risk DESC;

-- Revenue at Risk by Tenure Group

SELECT
    tenure_group,
    COUNT(*) AS churned_customers,
    ROUND(SUM(MonthlyCharges), 2) AS revenue_at_risk
FROM clean_telco_churn
WHERE Churn = 'Yes'
GROUP BY tenure_group
ORDER BY revenue_at_risk DESC;

-- Revenue at Risk by Internet Service

SELECT
    InternetService,
    COUNT(*) AS churned_customers,
    ROUND(SUM(MonthlyCharges), 2) AS revenue_at_risk
FROM clean_telco_churn
WHERE Churn = 'Yes'
GROUP BY InternetService
ORDER BY revenue_at_risk DESC;

-- =====================================================
-- CUSTOMER VALUE ANALYSIS


-- Average Monthly Charge by Churn Status

SELECT
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM clean_telco_churn
GROUP BY Churn;

-- Average Lifetime Revenue by Churn Status

SELECT
    Churn,
    ROUND(AVG(TotalCharges), 2) AS avg_total_revenue
FROM clean_telco_churn
GROUP BY Churn;

-- Highest Spending Churned Customers

SELECT
    customerID,
    MonthlyCharges,
    TotalCharges
FROM clean_telco_churn
WHERE Churn = 'Yes'
ORDER BY MonthlyCharges DESC
LIMIT 5;

-- =====================================================
-- CUSTOMER SEGMENTATION ANALYSIS


-- High-Risk Customer Segment

SELECT
    COUNT(*) AS customers,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate
FROM clean_telco_churn
WHERE Contract = 'Month-to-month'
AND InternetService = 'Fiber optic'
AND OnlineSecurity = 'No'
AND TechSupport = 'No';

-- Top High-Risk Customer Segments

SELECT
    Contract,
    InternetService,
    ROUND(AVG(Churn_Flag) * 100, 2) AS churn_rate,
    COUNT(*) AS customers
FROM clean_telco_churn
GROUP BY Contract, InternetService
HAVING COUNT(*) > 50
ORDER BY churn_rate DESC
LIMIT 3;

