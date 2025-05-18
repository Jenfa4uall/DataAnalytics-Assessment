#  **Data Analytics Assessment**
This repository contains solutions to a data analytics assessment for a Data Analyst role. The data provided consists of customer transaction records in SQL format.

The assessment includes a database dump and four scenario-based tasks, each focusing on practical SQL data analysis challenges.

## **Project Setup**
1. The database dump file was imported into MySQL.
2. Data tables were explored to understand relationships and data points.
3. Assessment requirements were carefully reviewed before implementation.

## **Assessment Tasks**
1. **High-Value Customers with Multiple Products**
Scenario: Identify customers who have both a funded savings and funded investment plan. This helps in discovering cross-selling opportunities.

Task: Find customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

### **Approach:**

* Joined 3 tables using appropriate foreign and primary keys.

* Used CASE and HAVING clauses to apply conditional logic and filter records.

* Grouped and ordered the result set by relevant fields.

* Validated the result using two sample records.

2. **Transaction Frequency Analysis**
Scenario: Segment customers by transaction frequency (e.g., frequent vs. occasional users).

Task: Calculate the average number of transactions per customer per month and categorize them as:

High Frequency: ≥ 10 transactions/month

Medium Frequency: 3–9 transactions/month

Low Frequency: ≤ 2 transactions/month

### **Approach:**

* Joined 2 related tables.

* Utilized Common Table Expressions (CTEs) for modular, readable query design.

* Used DATE_FORMAT to get unique identifier for calendar month to group transactions by month and AVG() for monthly frequency. Using month number will cause an analysis integrity issue because month number 1 might be January 2024, another row for month number 1 might be January 2023.

* Final categorization used CASE logic, and results were grouped accordingly.

## **Challenges & Resolution:**

*Challenge: Needed to format transaction dates into YYYY-MM for monthly grouping.*

*Solution: Used DATE_FORMAT() to normalize dates, enabling correct aggregation.*

*Rewrote nested queries into CTEs for better performance and clarity.*

3. **Account Inactivity Alert**
Scenario: Identify savings or investment accounts with no inflow transactions in the past 365 days.

Task: Find active accounts that have had no transaction activity for over one year.

### **Approach:**

* Joined 2 tables using appropriate keys.

* Applied a CASE statement to label account types (savings or investment).

* Used DATEDIFF() to calculate days since the last transaction.

* Applied filters using HAVING on the result of a CTE to isolate inactive accounts.

4. **Customer Lifetime Value (CLV) Estimation**
Scenario: Estimate Customer Lifetime Value based on account tenure and transaction volume. Assume a profit rate of 0.1% per transaction.

Task: For each customer, calculate:

Account tenure (in months)

Estimated CLV

### **Approach:**

* Joined savings_savingsaccount and users_customuser tables.

* Used TIMESTAMPDIFF() to compute tenure from the created_on date.

* Defined a SQL variable to hold the current date for reuse.

* Calculated estimated CLV using transaction volume, tenure, and profit rate.

* Grouped the result by customer ID and full name.

### **Challenges & Resolution:**

*Challenge: MySQL error 1055 occurred when using TIMESTAMPDIFF on a non-aggregated column.*

*Cause: This is due to ONLY_FULL_GROUP_BY mode, which enforces that all selected columns must be in GROUP BY or aggregated.*

*Resolution: Wrapped the created_on column in MIN() to comply with MySQL's strict mode and resolve the error.*

# **Thanks for following!**