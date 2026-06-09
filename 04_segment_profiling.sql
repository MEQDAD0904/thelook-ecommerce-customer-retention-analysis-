-- 04_segment_profiling.sql
-- Goal: compare customer profiles by retention segment.

WITH master AS (
    SELECT *
    FROM retention_master_table
)
SELECT
    retention_segment,
    COUNT(*) AS customers,
    ROUND(AVG(age)::numeric, 2) AS avg_age,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age)::numeric, 2) AS median_age,
    ROUND(AVG(first_order_value)::numeric, 2) AS avg_first_order_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY first_order_value)::numeric, 2) AS median_first_order_value,
    ROUND(AVG(days_to_repeat)::numeric, 2) AS avg_days_to_repeat,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_repeat)::numeric, 2) AS median_days_to_repeat
FROM master
GROUP BY 1
ORDER BY 2 DESC;

-- Gender split by retention segment
SELECT
    retention_segment,
    gender,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY retention_segment), 2) AS pct_within_segment
FROM retention_master_table
GROUP BY 1, 2
ORDER BY 1, 4 DESC;

-- Top categories by retention segment
SELECT
    retention_segment,
    first_order_top_category,
    COUNT(*) AS customers
FROM retention_master_table
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
