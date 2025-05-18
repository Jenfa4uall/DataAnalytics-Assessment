-- using the imported adashi staging db
use adashi_staging;

-- Transaction Frequency Analysis 
-- Step 1: Get monthly transaction count per customer
WITH monthly_transaction_counts AS (
    SELECT
        owner_id,
	-- To get a unique identifier for each calendar month, we use year-month date format. Using month number alone will cause 
        DATE_FORMAT(transaction_date, '%Y-%m') AS trans_year_month, -- MySQL date transformation to year_month.
        -- FORMAT_DATE('%Y-%m', DATE(transaction_date)) AS trans_year_month, --- This part is should be uncommented if this is being tested on Big Query.
        COUNT(*) AS monthly_trans_count
    FROM savings_savingsaccount
    GROUP BY owner_id, trans_year_month
    -- The query above is a named subquery(monthly_transaction_counts) that counts the monthly transaction per customer using savings_savingsaccount table. 
),
-- Step 2: Calculate average monthly transaction per customer
customer_monthly_avg AS (
    SELECT
        owner_id,
        ROUND(AVG(monthly_trans_count), 2) AS avg_monthly_trans
    FROM monthly_transaction_counts
    GROUP BY owner_id
    -- The query above is a named subquery(customer_monthly_avg) that average the monthly transaction per customer using monthly_transaction_counts. 
),
-- Step 3: Categorize each customer
categorized_customers AS (
    SELECT
        owner_id,
        avg_monthly_trans,
        CASE
            WHEN avg_monthly_trans >= 10 THEN 'High Frequency'
            WHEN avg_monthly_trans BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_monthly_avg
    -- The query above is a named subquery(categorized_customers) that categorize customer based on avg_monthly_trans. 
)
-- Step 4: Summarized results
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_trans), 1) AS avg_transactions_per_month -- The field is rounded to one decimal place. 
FROM categorized_customers
GROUP BY frequency_category;

