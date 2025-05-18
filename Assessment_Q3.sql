-- using the imported adashi staging db
use adashi_staging;
-- Please use the version of the query based on the environment this is being validated.

-- Account Inactivity Alert
-- Please use the below query if this is being validated on MySQL workbench.

-- Using common table expression.
WITH inactive_table AS (
    SELECT
        s.plan_id,
        s.owner_id,
        CASE 
            WHEN p.is_regular_savings = '1' THEN 'savings'
            WHEN p.is_a_fund = '1' THEN 'investments'
            ELSE 'undefined'
        END AS type,
        MAX(DATE_FORMAT(s.transaction_date,'%Y-%m-%d')) AS last_transaction_date,
        DATEDIFF(CURRENT_TIMESTAMP(), MAX(s.transaction_date)) AS inactivity_days
    FROM savings_savingsaccount s
    JOIN plans_plan p ON p.id = s.plan_id
    GROUP BY s.plan_id, s.owner_id, p.is_regular_savings, p.is_a_fund
    HAVING inactivity_days > 365
    )

SELECT *
FROM inactive_table
WHERE type IN ('savings', 'investments')
ORDER BY inactivity_days DESC;


-- BIG QUERY VERSION
-- Please use this if this is being executed on Google Big Query
/* WITH inactive_table AS (
    SELECT
        s.plan_id,
        s.owner_id,
        CASE 
            WHEN p.is_regular_savings = '1' THEN 'savings'
            WHEN p.is_a_fund = '1' THEN 'investments'
            ELSE 'undefined'
        END AS type,
        MAX(FORMAT_DATE('%Y-%m-%d',DATE(s.transaction_date)) AS last_transaction_date
    FROM savings_savingsaccount s
    JOIN plans_plan p ON p.id = s.plan_id
    GROUP BY s.plan_id, s.owner_id, p.is_regular_savings, p.is_a_fund
),
filtered_inactive AS (
    SELECT *,
        DATE_DIFF(CURRENT_DATE(), last_transaction_date, DAY) AS inactivity_days
    FROM inactive_table
    WHERE inactivity_days > 365
)

SELECT *
FROM filtered_inactive
WHERE type IN ('savings', 'investments')
ORDER BY inactivity_days DESC;
*/