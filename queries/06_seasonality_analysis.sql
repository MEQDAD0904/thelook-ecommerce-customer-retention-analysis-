-- 06_seasonality_analysis.sql
-- Goal: test whether first-order timing is related to retention.

WITH complete_orders AS (
    SELECT
        o.user_id,
        o.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY o.user_id
            ORDER BY o.created_at
        ) AS rn,
        LEAD(o.created_at) OVER (
            PARTITION BY o.user_id
            ORDER BY o.created_at
        ) AS next_order_created_at
    FROM orders o
    WHERE o.status = 'Complete'
),
first_order AS (
    SELECT *
    FROM complete_orders
    WHERE rn = 1
)
SELECT
    CASE
        WHEN next_order_created_at IS NULL THEN 'Never Returner'
        WHEN (next_order_created_at::date - created_at::date) <= 60 THEN 'Early Returner'
        WHEN (next_order_created_at::date - created_at::date) <= 204 THEN 'Mid Returner'
        ELSE 'Late Returner'
    END AS retention_segment,
    EXTRACT(MONTH FROM created_at) AS order_month,
    TO_CHAR(created_at, 'Day') AS order_dow,
    COUNT(*) AS customers
FROM first_order
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;
