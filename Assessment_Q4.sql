
-- Customer Lifetime Value (CLV) Estimation
-- Declare reusable variables
SET @today := CURRENT_TIMESTAMP();

SELECT 
    s.owner_id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, MIN(s.created_on), @today) AS tenure_months, -- Due to peculiarity of the timestampdiff() function used here to MySQL, If this is being validated on Google Big query, please comment this and uncomment the next line.  
     -- DATE_DIFF(CURRENT_DATE(), DATE(MIN(s.created_on)), MONTH) AS tenure_months,
    COUNT(*) AS total_transactions,
    FORMAT((
        COUNT(*) / TIMESTAMPDIFF(MONTH, MIN(s.created_on), @today)
    ) * 12 * (0.1 / 100),2) AS estimated_clv    
     /* (
        COUNT(*) / DATE_DIFF(CURRENT_DATE(), DATE(MIN(s.created_on)), MONTH)
    ) * 12 * (0.1 / 100) AS estimated_clv */ -- If the code block is being executed on Google Big query, please use this aggregation and comment the previous expression. 
FROM savings_savingsaccount s
JOIN users_customuser u ON u.id = s.owner_id
GROUP BY customer_id, name
ORDER BY estimated_clv DESC;


