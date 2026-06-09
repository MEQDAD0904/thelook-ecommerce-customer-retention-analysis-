-- 02_master_table.sql
-- Goal: create one row per customer with demographic, first-order, and repeat-behavior features.

WITH complete_orders AS (
    SELECT
        o.order_id,
        o.user_id,
        o.created_at,
        o.delivered_at,
        o.returned_at,
        ROW_NUMBER() OVER (
            PARTITION BY o.user_id
            ORDER BY o.created_at
        ) AS order_rank,
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
    WHERE order_rank = 1
),
first_order_value AS (
    SELECT
        oi.order_id,
        ROUND(SUM(oi.sale_price)::numeric, 2) AS first_order_value
    FROM order_items oi
    JOIN first_order fo
        ON oi.order_id = fo.order_id
    GROUP BY 1
),
first_product_category AS (
    SELECT
        x.order_id,
        x.category AS first_product_category
    FROM (
        SELECT
            oi.order_id,
            p.category,
            SUM(oi.sale_price) AS category_revenue,
            ROW_NUMBER() OVER (
                PARTITION BY oi.order_id
                ORDER BY SUM(oi.sale_price) DESC, p.category
            ) AS rn
        FROM order_items oi
        JOIN first_order fo
            ON oi.order_id = fo.order_id
        JOIN products p
            ON oi.product_id = p.product_id
        GROUP BY 1, 2
    ) x
    WHERE x.rn = 1
),
customer_base AS (
    SELECT
        u.user_id,
        u.age,
        u.gender,
        u.country,
        u.state,
        u.city,
        u.traffic_source,
        u.created_at AS user_created_at
    FROM users u
)
SELECT
    cb.user_id,
    cb.age,
    cb.gender,
    cb.country,
    cb.state,
    cb.city,
    cb.traffic_source,
    fo.order_id AS first_order_id,
    fo.created_at AS first_order_created_at,
    fo.delivered_at AS first_order_delivered_at,
    fo.returned_at AS first_order_returned_at,
    fov.first_order_value,
    foc.first_product_category,
    CASE
        WHEN fo.next_order_created_at IS NULL THEN NULL
        ELSE (fo.next_order_created_at::date - fo.created_at::date)
    END AS days_to_repeat,
    CASE
        WHEN fo.next_order_created_at IS NULL THEN FALSE
        ELSE TRUE
    END AS returned,
    CASE
        WHEN fo.next_order_created_at IS NULL THEN 'Never Returner'
        WHEN (fo.next_order_created_at::date - fo.created_at::date) <= 60 THEN 'Early Returner'
        WHEN (fo.next_order_created_at::date - fo.created_at::date) <= 204 THEN 'Mid Returner'
        ELSE 'Late Returner'
    END AS retention_segment,
    CASE
        WHEN fo.created_at IS NOT NULL THEN EXTRACT(MONTH FROM fo.created_at)
    END AS first_order_month,
    CASE
        WHEN fo.created_at IS NOT NULL THEN TO_CHAR(fo.created_at, 'Day')
    END AS first_order_dow
FROM customer_base cb
JOIN first_order fo
    ON cb.user_id = fo.user_id
LEFT JOIN first_order_value fov
    ON fo.order_id = fov.order_id
LEFT JOIN first_product_category foc
    ON fo.order_id = foc.order_id
ORDER BY cb.user_id;

-- Optional export pattern in psql:
-- \copy (
--   <paste the query above without the trailing semicolon>
-- ) TO 'master_table.csv' CSV HEADER;
