-- 05_delivery_time_analysis.sql
-- Goal: test whether first-order delivery time differs for early vs never returners.

WITH complete_orders AS (
    SELECT
        o.user_id,
        o.order_id,
        o.created_at,
        o.delivered_at,
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
),
delivery AS (
    SELECT
        user_id,
        order_id,
        (delivered_at::date - created_at::date) AS delivery_days,
        CASE
            WHEN next_order_created_at IS NULL THEN 'Never Returner'
            WHEN (next_order_created_at::date - created_at::date) <= 60 THEN 'Early Returner'
            WHEN (next_order_created_at::date - created_at::date) <= 204 THEN 'Mid Returner'
            ELSE 'Late Returner'
        END AS retention_segment
    FROM first_order
    WHERE delivered_at IS NOT NULL
)
SELECT
    retention_segment,
    COUNT(*) AS customers,
    ROUND(AVG(delivery_days)::numeric, 2) AS avg_delivery_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY delivery_days)::numeric, 2) AS median_delivery_days
FROM delivery
WHERE retention_segment IN ('Early Returner', 'Never Returner')
GROUP BY 1
ORDER BY 1;
