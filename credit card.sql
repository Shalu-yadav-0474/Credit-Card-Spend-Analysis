DROP TABLE IF EXISTS customer;
CREATE TABLE customer
(
Client_Num	INT PRIMARY KEY,
Customer_Age INT,
Gender VARCHAR(10),
Dependent_Count	INT,
Education_Level	VARCHAR(15),
Marital_Status VARCHAR(10),
state_cd VARCHAR(10),	
Zipcode INT,
Car_Owner VARCHAR(5),	
House_Owner	VARCHAR(5),
Personal_loan VARCHAR(5),	
contact	VARCHAR(10),
Customer_Job VARCHAR(20),	
Income INT,	
Cust_Satisfaction_Score INT
);

DROP TABLE IF EXISTS card_detail;
CREATE TABLE card_detail
(
Client_Num INT,
Card_Category VARCHAR(10),
Annual_Fees	INT,
Activation_30_Days INT,
Customer_Acq_Cost INT,	
Week_Start_Date	DATE,
Week_Num VARCHAR(10),	
Qtr	VARCHAR(5),
current_year INT, 	
Credit_Limit FLOAT,	
Total_Revolving_Bal INT,	
Total_Trans_Amt INT,
Total_Trans_Vol	INT,
Avg_Utilization_Ratio FLOAT,	
Use_Chip VARCHAR(10),
Exp_Type VARCHAR(20),
Interest_Earned	FLOAT,
Delinquent_Acc INT
);

SELECT * FROM customer 
SELECT * FROM card_detail

-- write sql query to find how many unique customers are their in dataset
SELECT 
   DISTINCT COUNT(Client_Num)
FROM customer;  

-- write sql query to find how many male and female customers out of total customers
SELECT
gender,
count(Client_Num)
FROM customer
group by Gender;

-- write sql query to find customers job role in dataset
SELECT
  Customer_Job,
  count(Client_Num)
FROM customer
group by Customer_Job
order by count desc;

-- write sql query to find how many customers are having car
SELECT
  Car_Owner,
  count(Client_Num)
FROM customer
group by Car_Owner
order by count desc;

-- write sql query to find how many customers are owning any house
SELECT
  House_Owner,
  count(Client_Num)
FROM customer
group by House_Owner
order by count desc;

-- write sql query to find how many customers are having any personal loan
SELECT
  Personal_loan,
  count(Client_Num)
FROM customer
group by Personal_loan
order by count desc;

-- write sql query to find average satisfaction score of customers
SELECT 
   ROUNd(AVG(Cust_Satisfaction_Score),2)
FROM customer;


-- write sql query to analyse how many customers rate what score
SELECT
  Cust_Satisfaction_Score,
  count(Client_Num)
FROM customer
group by Cust_Satisfaction_Score
order by Cust_Satisfaction_Score desc;

-- write sql query to find how many customers fall in specific income range. 
SELECT
  CASE
    WHEN Income>=1000 AND INCOME<50000 THEN '1K-50K'
    WHEN Income>=50000 AND INCOME<100000 THEN '50K-100K'
	WHEN Income>=100000 AND INCOME<150000 THEN '100K-150K'
	WHEN Income>=150000 AND INCOME<200000 THEN '150K-200K'
	WHEN Income>=200000 AND INCOME<250000 THEN '200K-250K'
	END income_range,
	COUNT(Client_Num)
  from customer	
  group by income_range
  ORDER BY COUNT DESC;

 -- write sql query to find revenue earned on quaterly basis.
 SELECT
 Qtr AS quater,
 round(sum(card_detail.annual_fees +
            card_detail.interest_earned+
            card_detail.total_trans_amt)::numeric,2) AS REVENUE
  FROM card_detail
  GROUP BY quater
  ORDER BY Qtr ASC;

-- write sql query to find revenue earned on monthly basis.
 SELECT 
    TO_CHAR(Week_Start_Date, 'Month') AS Month,
    ROUND(SUM(Annual_Fees + Interest_Earned + Total_Trans_Amt)::NUMERIC, 2) AS Total_Revenue
FROM 
    card_detail
GROUP BY 
    TO_CHAR(Week_Start_Date, 'Month')
ORDER BY 
    MIN(Week_Start_Date);

-- write sql query to find revenue earned overall.
SELECT 
    ROUND(SUM(Annual_Fees + Interest_Earned + Total_Trans_Amt)::NUMERIC, 2) AS Total_Revenue
FROM 
    card_detail


--write sql query to determine how many customers have each type of card
SELECT
  card_category,
  count(Client_Num)
FROM card_detail
group by card_category
order by count desc;

--write sql query to find how card is used to made payment
SELECT
  Use_Chip,
  count(Client_Num)
FROM card_detail
group by Use_Chip
order by count desc;

-- write sql query to analysis customer cost of acquisition
SELECT
  card_category,
  round(AVG(Customer_Acq_Cost),2) AS avg_cost,
  MIN(Customer_Acq_Cost) AS MIN_cost,
  MAX(Customer_Acq_Cost) AS MAX_cost
FROM card_detail
group by card_category
order by card_category desc;

-- write sql query to analysis annual fees paid by customer for card
SELECT
  card_category,
  round(AVG(Annual_Fees),2) AS avg_fees,
  MIN(Annual_Fees) AS MIN_fees,
  MAX(Annual_Fees) AS MAX_fees
FROM card_detail
group by card_category
order by card_category desc;

-- write sql query to find on what customers are spending and how much
SELECT
  Exp_Type,
  count(Client_Num)
FROM card_detail
group by Exp_Type
order by count desc;

--write sql query to find age group and their spending analysis
SELECT
  CASE
    WHEN Customer_Age>=18 AND Customer_Age < 25 THEN '18-24'
    WHEN Customer_Age>=25 AND Customer_Age < 35 THEN '25-34'
    WHEN Customer_Age>=35 AND Customer_Age < 45 THEN '35-44'
    WHEN Customer_Age>=45 AND Customer_Age < 55 THEN '45-54'
    WHEN Customer_Age>=55 AND Customer_Age < 65 THEN '55-64'
    ELSE '65+'  
  END AS age_range,
  SUM(cd.Total_Trans_Amt) AS total_spending
FROM 
  customer c
JOIN 
  card_detail cd
ON 
  c.Client_Num = cd.Client_Num
GROUP BY 
  age_range
ORDER BY 
  age_range asc;

-- write sql to find marital status ,gender wise spending analysis 
SELECT
  gender,
  Marital_Status,
  SUM(Total_Trans_Amt) AS total_spending
FROM 
  card_detail
JOIN 
  customer 
ON 
  card_detail.Client_Num = customer.Client_Num
WHERE 
  Marital_Status = 'Single'
GROUP BY 
  gender, Marital_Status

UNION ALL

SELECT
  gender,
  Marital_Status,
  SUM(Total_Trans_Amt) AS total_spending
FROM 
  card_detail
JOIN 
  customer 
ON 
  card_detail.Client_Num = customer.Client_Num
WHERE 
  Marital_Status = 'Married'
GROUP BY 
  gender, Marital_Status
ORDER BY 
  Marital_Status, gender;
