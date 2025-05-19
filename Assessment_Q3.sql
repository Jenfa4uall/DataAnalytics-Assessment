-- using the imported adashi staging db
use adashi_staging;
-- Please use the version of the query based on the environment this is being validated.

-- Account Inactivity Alert
-- Using common table expression.
WITH inactive_table AS (
    SELECT
        s.plan_id,
        s.owner_id,
        -- Categorizing to determine if it is a saving or investment plan 
        CASE 
            WHEN p.is_regular_savings = '1' THEN 'savings'
            WHEN p.is_a_fund = '1' THEN 'investments'
            ELSE 'undefined'
        END AS type,

        -- Use the appropriate line below based on SQL engine: This truncates the time from the transaction_date field.  
        MAX(DATE_FORMAT(s.transaction_date, '%Y-%m-%d')) AS last_transaction_date, -- MySQL
        -- FORMAT_DATE('%Y-%m-%d', DATE(MAX(s.transaction_date))) AS last_transaction_date, -- BigQuery

        -- Use the appropriate line below for inactivity_days: This calculate the difference in the current time stamp and last transaction date in days.
        DATEDIFF(CURRENT_TIMESTAMP(), MAX(s.transaction_date)) AS inactivity_days -- MySQL
        -- DATE_DIFF(CURRENT_DATE(), DATE(MAX(s.transaction_date)), DAY) AS inactivity_days, -- BigQuery
        
    FROM savings_savingsaccount s
    JOIN plans_plan p ON p.id = s.plan_id
    GROUP BY s.plan_id, s.owner_id, p.is_regular_savings, p.is_a_fund

    -- Switch HAVING clause to match the correct engine:
    HAVING inactivity_days > 365
    -- HAVING DATE_DIFF(CURRENT_DATE(), DATE(MAX(s.transaction_date)), DAY) > 365
)
-- Getting the final result by filtering using the category. 
SELECT *
FROM inactive_table
WHERE type IN ('savings', 'investments')
ORDER BY inactivity_days DESC;

