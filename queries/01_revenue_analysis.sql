-- 01_revenue_analysis.sql
-- Goal: build revenue sanity checks before retention work.

-- 1) Total revenue and order count
SELECT
    COUNT(DISTINCT oi.order_id) AS completed_orders,
    COUNT(*) AS line_items,
    ROUND(SUM(oi.sale_price)::numeric, 2) AS total_revenue,
    ROUND(AVG(oi.sale_price)::numeric, 2) AS avg_item_revenue
FROM order_items oi
WHERE oi.status = 'Complete';

-- 2) Monthly revenue trend
SELECT
    DATE_TRUNC('month', oi.created_at)::date AS month,
    ROUND(SUM(oi.sale_price)::numeric, 2) AS revenue
FROM order_items oi
WHERE oi.status = 'Complete'
GROUP BY 1
ORDER BY 1;

-- 3) Top categories by revenue
SELECT
    p.category AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.sale_price)::numeric, 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.status = 'Complete'
GROUP BY 1
ORDER BY revenue DESC
LIMIT 15;

-- 4) Revenue concentration by customer
SELECT
    user_id,
    ROUND(SUM(sale_price)::numeric, 2) AS revenue
FROM order_items
WHERE status = 'Complete'
GROUP BY 1
ORDER BY revenue DESC
LIMIT 20;
