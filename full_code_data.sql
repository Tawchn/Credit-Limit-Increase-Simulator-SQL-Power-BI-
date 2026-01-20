-- FIRST PART 

-- CREATE A DATABASE
CREATE  DATABASE BNK_SIM

-- USE DATABASE BNK_SIM
USE BNK_SIM

-- CREATE A SCHEMA 
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name ='gold')
EXEC('CREATE SCHEMA gold');

-- check table existance 
DROP TABLE IF EXISTS dbo.monthly_summary,dbo.accounts,dbo.customers;

-- CREATE CUSTOMER TABLE 
CREATE TABLE dbo.customers (
	customer_id INT PRIMARY KEY,
	age TINYINT NOT NULL ,
	income_band VARCHAR(10) NOT NULL
	);

-- CREATE CUSTOMER account TABLE 
CREATE TABLE dbo.accounts (
	customer_id INT PRIMARY KEY,
	current_limit INT NOT NULL,
	current_balance INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id)
	);
	
-- CREATE CUSTOMER monthly summary TABLE

 CREATE TABLE dbo.monthly_summary (
	customer_id INT PRIMARY KEY,
	spend_avg INT NOT NULL,
	late_payments_6m TINYINT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
	);

-- CREATE A CTE 
WITH n AS (SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS customer_id FROM sys.all_objects)
INSERT dbo.customers(customer_id,age,income_band)
SELECT customer_id,
	CAST(21 + (customer_id % 35) AS TINYINT) AS age ,
	CASE customer_id % 3 WHEN 0 THEN 'low' WHEN 1 THEN 'mid' Else 'high' END AS income_band 
FROM n;


INSERT dbo.accounts(customer_id,current_limit,current_balance)
SELECT c.customer_id,
		1000 + (c.customer_id % 10) * 1000 AS current_limit,
		(1000 + (c.customer_id % 10) * 1000) *((customer_id % 9) *10 + 10)/100 AS current_balance
FROM dbo.customers c;


INSERT dbo.monthly_summary(customer_id,spend_avg,late_payments_6m)
SELECT c.customer_id,
	400 + (c.customer_id % 12) * 120 AS spend_avg,
	CAST(CASE WHEN c.customer_id % 10 IN (0,1) THEN 4
			  WHEN c.customer_id % 10 IN (2,3,4) THEN 2
			  WHEN c.customer_id % 10 IN (5,6,7) THEN 1
			  ELSE 0 END AS TINYINT) AS late_payments_6m
FROM dbo.customers c;

GO
CREATE OR ALTER VIEW gold.vw_credit_offer_simulation AS
SELECT
	  c.customer_id,
	  c.age,
	  c.income_band,
	  a.current_limit,
	  a.current_balance,
	  CAST(1.0 * a.current_balance / NULLIF(a.current_limit,0) AS DECIMAL(5,2)) AS utilisation_rate,
	  m.spend_avg,
	  m.late_payments_6m,

  CASE
		WHEN m.late_payments_6m >= 3 OR (1.0*a.current_balance/NULLIF(a.current_limit,0)) >= 0.85 THEN 'High'
		WHEN m.late_payments_6m >= 1 OR (1.0*a.current_balance/NULLIF(a.current_limit,0)) >= 0.65 THEN 'Medium'
		ELSE 'Low'
  END AS risk_band,

  CASE
		WHEN m.late_payments_6m = 0 AND (1.0*a.current_balance/NULLIF(a.current_limit,0)) BETWEEN 0.10 AND 0.70
		  THEN 1 ELSE 0 END AS eligible_for_increase,

  -- Base simulation: Power BI will apply the what-if % on top of this
  a.current_limit AS simulated_limit_base
		FROM dbo.customers c
		JOIN dbo.accounts a ON a.customer_id = c.customer_id
		JOIN dbo.monthly_summary m ON m.customer_id = c.customer_id;
