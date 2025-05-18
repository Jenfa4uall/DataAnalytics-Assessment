-- using the imported adashi staging db
use adashi_staging;
  
-- High-Value Customers with Multiple Products
SELECT 
    p.owner_id, 
    CONCAT (u.first_name,' ',u.last_name) name,
    COUNT(CASE WHEN p.is_regular_savings = '1' THEN 1 END) AS savings_count,
    COUNT(CASE WHEN p.is_a_fund = '1' THEN 1 END) AS investment_count,
    ROUND(SUM(s.confirmed_amount/100), 2) AS total_deposits -- The total deposit field is converted from kobo to Naira by dividing by 100 and standardize the formatting. 
FROM plans_plan p 
JOIN savings_savingsaccount s ON p.id = s.plan_id
JOIN users_customuser u ON u.id = p.owner_id  -- Joining the users table with the previous tables.
GROUP BY p.owner_id, name
HAVING 
	savings_count > 0 AND
    investment_count > 0 AND
    total_deposits >0
ORDER BY total_deposits DESC;

