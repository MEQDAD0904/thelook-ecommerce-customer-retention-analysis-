-- 03_retention_summary.sql
-- Goal: quantify return behavior at the customer level.

WITH customer_orders AS (
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
    FROM customer_orders
    WHERE rn = 1
)
SELECT
    COUNT(*) AS customers,
    COUNT(next_order_created_at) AS customers_who_returned,
    ROUND(100.0 * COUNT(next_order_created_at) / COUNT(*), 2) AS return_rate_pct,
    ROUND(AVG(next_order_created_at::date - created_at::date)::numeric, 2) AS avg_days_to_repeat,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY (next_order_created_at::date - created_at::date)
    )::numeric, 2) AS median_days_to_repeat
FROM first_order;

-- Return-rate buckets by days-to-repeat
SELECT
    CASE
        WHEN next_order_created_at IS NULL THEN 'Never Returner'
        WHEN (next_order_created_at::date - created_at::date) <= 60 THEN 'Early Returner'
        WHEN (next_order_created_at::date - created_at::date) <= 204 THEN 'Mid Returner'
        ELSE 'Late Returner'
    END AS segment,
    COUNT(*) AS customers
FROM first_order
GROUP BY 1
ORDER BY 2 DESC;
