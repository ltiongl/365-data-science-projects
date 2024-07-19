
USE 365_checkout_database;

SELECT * FROM checkout_actions
WHERE action_date = '2022-07-01' AND action_name LIKE 'checkout%';
SELECT * FROM checkout_carts
ORDER BY action_date;

-- Retrieve Checkout Steps Information

WITH cte_checkout_actions AS (
    SELECT
        a.action_date,
        SUM(CASE WHEN action_name LIKE 'checkout%' THEN 1 ELSE 0 END) AS count_total_checkout_attempts,
        SUM(CASE WHEN action_name LIKE '%success%' THEN 1 ELSE 0 END) AS count_successful_checkout_attempts
    FROM 
        checkout_carts c
            JOIN
        checkout_actions a ON c.user_id = a.user_id
    GROUP BY a.action_date),
cte_checkout_carts AS (
    SELECT
        action_date,
        COUNT(*) AS count_total_carts
	FROM checkout_carts
    GROUP BY action_date)
SELECT
    c.action_date,
    count_total_carts,
    count_total_checkout_attempts,
    count_successful_checkout_attempts
FROM
    cte_checkout_carts c
        LEFT JOIN
    cte_checkout_actions a ON a.action_date = c.action_date
WHERE c.action_date IS NOT NULL 
ORDER BY c.action_date;

-- Retrieve Chcekout Errors Information

SELECT
    user_id,
    action_date,
    action_name,
    error_message,
    device
FROM checkout_actions
WHERE error_message IS NOT NULL AND action_name LIKE 'checkout%' 
ORDER BY action_date;
