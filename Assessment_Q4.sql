-- using the imported adashi staging db
use adashi_staging;

SELECT 
    s.owner_id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Use the correct line below based on SQL engine:
    TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURRENT_TIMESTAMP()) AS tenure_months, -- MySQL
    -- DATE_DIFF(CURRENT_DATE(), DATE(MIN(s.created_on)), MONTH) AS tenure_months, -- BigQuery

    COUNT(*) AS total_transactions,
    
    -- Use the correct formula below based on SQL engine:
    -- The timestampdiff() allows us to calculate the number of months between the creation date and current time stamp. 
    ROUND((
        COUNT(*) / TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURRENT_TIMESTAMP())
    ) * 12 * (0.1 / 100), 2) AS estimated_clv -- MySQL

    -- ROUND((
    --     COUNT(*) / DATE_DIFF(CURRENT_DATE(), DATE(MIN(s.created_on)), MONTH)
    -- ) * 12 * (0.1 / 100), 2) AS estimated_clv -- BigQuery

FROM savings_savingsaccount s
JOIN users_customuser u ON u.id = s.owner_id
GROUP BY customer_id, name
ORDER BY estimated_clv DESC;



