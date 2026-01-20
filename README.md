# Credit-Limit-Increase-Simulator-SQL-Power-BI-
This project simulates how a bank can safely increase customer credit limits while controlling portfolio risk.

Using SQL for data modelling and Power BI for scenario analysis, the dashboard allows decision-makers to test different credit increase percentages and instantly see the impact on customer limits and total credit exposure without changing the underlying data.

*Business Problem*

Banks regularly face this question:

“If we increase customer credit limits, how much additional risk and exposure are we taking on?”


Blindly increasing limits can:
  Increase default risk
  Inflate portfolio exposure
  Breach internal risk thresholds

This project provides a controlled, explainable simulation before policy changes are applied.

Solution Approach
1. SQL (Data Modelling & Business Rules)

SQL is used to:

Prepare an analytics-ready dataset
Classify customers into risk bands
Determine eligibility for credit increases
Calculate base metrics such as utilisation and behavioural indicators

Key outputs include:
Risk band (Low / Medium / High)
Eligibility flag (0 or 1)
Current credit limit
Behavioural history (late payments, utilisation)

The final output is exposed as a Gold view for analytics consumption.

2. Power BI (Scenario Simulation & Reporting)

Power BI is used to:

Create a What-If parameter (0–30% credit increase)
Dynamically simulate new credit limits
Show real-time portfolio impact


Key measures:

Eligible Customers
Simulated Credit Limit
Total Simulated Exposure

The dashboard updates instantly as the slider moves, allowing stakeholders to test scenarios safely.

Dashboard Features

What-If Slider: Adjust credit increase percentage (0–30%)
KPI Cards:
  Eligible Customers
  Increase Percentage
  Total Simulated Exposure

Detail Table:
  Customer ID
  Current Limit
  Simulated Limit
  Risk indicators
  
The design prevents accidental filtering and keeps metrics stable during interaction.

*Tools Used*
SQL Server – Data modelling, business logic, risk rules
Power BI Desktop – Measures, What If parameter, dashboarding

  [credit limit simulator overview ](images/dashboard_overview.png)

                  *Key Insights*
Eligibility remains stable while exposure changes dynamically
Higher increase percentages significantly impact total portfolio exposure
Risk-based eligibility prevents unsafe credit expansion
Scenario testing improves decision confidence before rollout

*Why This Matters*
This mirrors how banks:
Test credit policies
Assess portfolio-level risk
Communicate decisions clearly to stakeholders

The approach is explainable, auditable, and suitable for regulated environments.

*Possible Enhancements*
Introduce probability of default (PD) scoring
Track realised outcomes over time
Segment by income band or age group
Add stress-testing scenarios

Author

Tawanda Mucheriwa
Data & Analytics | SQL | Power BI
