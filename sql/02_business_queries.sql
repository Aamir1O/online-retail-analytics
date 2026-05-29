-- Query 1: — Monthly Revenue Trend
select TO_CHAR(invoicedate, 'YYYY-MM') as month_year,
ROUND(SUM(revenue)::NUMERIC, 2) AS  total_revenue,
COUNT(DISTINCT invoice) as total_orders,
COUNT(DISTINCT customer_id) as total_customers
from online_retail_sales
GROUP BY TO_CHAR(invoicedate, 'YYYY-MM')
ORDER BY month_year

-- Peak revenue occurs in November both years, not December.
-- Sep-Nov consistently drives 35-40% of annual revenue.
-- Wholesale buying behaviour explains pre-Christmas peak.


-- Query 2 — Revenue by Country
select country,
ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue,
COUNT(DISTINCT invoice) as total_orders,
COUNT(DISTINCT customer_id) as total_customers,
ROUND(SUM(revenue)::NUMERIC / COUNT(DISTINCT invoice ),2 ) AS avg_order_value
FROM online_retail_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- UK generates ~85% of total revenue.
-- Netherlands has lowest order count but 2nd highest revenue
-- due to extremely high AOV (£2,429 vs UK £476) — wholesale behaviour.


-- Query 3 — Top 10 Products by Revenue
SELECT
    stockcode,
    description,
    ROUND(SUM(revenue)::NUMERIC, 2)  AS total_revenue,
    SUM(quantity)                     AS total_units_sold,
    COUNT(DISTINCT invoice)           AS total_orders
FROM online_retail_sales
WHERE stockcode NOT IN ('M', 'DOT', 'POST', 'BANK CHARGES', 'PADS')
  AND description NOT ILIKE '%postage%'
  AND description NOT ILIKE '%manual%'
GROUP BY stockcode, description
ORDER BY total_revenue DESC
LIMIT 10;

-- REGENCY CAKESTAND 3 TIER is the most consistent top performer.
-- PAPER CRAFT LITTLE BIRDIE (£168K) came from a single order -- outlier.
-- Top 10 products are all gift/home décor items -- clear niche identity.


-- Query 4 — Top 10 Customers by Revenue
SELECT
    customer_id,
    country,
    ROUND(SUM(revenue)::NUMERIC, 2)  AS total_revenue,
    COUNT(DISTINCT invoice)           AS total_orders,
    ROUND(SUM(revenue)::NUMERIC / COUNT(DISTINCT invoice), 2) AS avg_order_value
FROM online_retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id, country
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer 16446: 2 orders, £168K revenue -- single bulk purchase outlier.
-- EIRE's top 2 customers alone account for significant share of country revenue.
-- Top 10 customers span UK, Netherlands, EIRE, Australia -- international VIPs matter.



-- Query 5 — Average Order Value by Month
SELECT
    TO_CHAR(invoicedate, 'YYYY-MM') AS month_year,
    ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue,
    COUNT(DISTINCT invoice)AS total_orders,
    ROUND(SUM(revenue)::NUMERIC / COUNT(DISTINCT invoice), 2) AS avg_order_value
FROM online_retail_sales
GROUP BY TO_CHAR(invoicedate, 'YYYY-MM')
ORDER BY month_year;

-- AOV flat across 24 months (£430-£575 range).
-- Revenue peaks are volume-driven, not value-driven.
-- No evidence of successful upsell/cross-sell strategy over the period.


-- Query 6 — Repeat vs One-Time Customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS order_count
    FROM online_retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE 
        WHEN order_count = 1 THEN 'One-time buyer'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Occasional buyer'
        WHEN order_count > 5 THEN 'Loyal buyer'
    END                        AS customer_segment,
    COUNT(*)                   AS total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer_orders
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- 72.4% of customers purchased more than once -- strong retention signal.
-- Wholesale customer base drives repeat behaviour naturally.
-- One-time buyers (27.6%) are still worth investigating 

-- Query 7 — Revenue by Day of Week

SELECT
    TO_CHAR(invoicedate, 'Day')      AS day_of_week,
    EXTRACT(DOW FROM invoicedate)    AS day_number,
    ROUND(SUM(revenue)::NUMERIC, 2)  AS total_revenue,
    COUNT(DISTINCT invoice)           AS total_orders
FROM online_retail_sales
GROUP BY day_of_week, day_number
ORDER BY day_number;

-- Saturday generates <0.05% of total revenue -- business is B2B wholesale.
-- Thursday and Tuesday are peak ordering days.
-- Weekend silence confirms customers are businesses, not consumers.
-- Marketing campaigns, promotions, and communications should target
-- Tuesday-Thursday window for maximum impact.
-- Sunday activity (£1.79M) likely from automated/scheduled wholesale orders.


-- Query 8: Monthly Revenue Growth Rate
WITH monthly AS (
    SELECT
        TO_CHAR(invoicedate, 'YYYY-MM') AS month_year,
        ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue
    FROM online_retail_sales
    GROUP BY TO_CHAR(invoicedate, 'YYYY-MM')
)
SELECT
    month_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month_year) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month_year))
        / LAG(total_revenue) OVER (ORDER BY month_year) * 100, 2
    ) AS growth_rate_pct
FROM monthly
ORDER BY month_year;

-- Revenue is highly seasonal with consistent Sep-Nov acceleration both years.
-- Month-over-month swings of 40-50% are normal for this business cycle.
-- Dec 2011 drop (-57%) is a data truncation artifact, not real decline.
-- Stable underlying growth visible when comparing same months year over year.


-- Query 9: Customer Revenue Segments
WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue
    FROM online_retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_revenue >= 10000 THEN 'High Value (£10k+)'
        WHEN total_revenue >= 1000  THEN 'Mid Value (£1k-10k)'
        WHEN total_revenue >= 100   THEN 'Low Value (£100-1k)'
        ELSE 'Micro (under £100)'
    END                                       AS revenue_segment,
    COUNT(*)                                  AS total_customers,
    ROUND(AVG(total_revenue)::NUMERIC, 2)     AS avg_revenue,
    ROUND(SUM(total_revenue)::NUMERIC, 2)     AS segment_revenue
FROM customer_revenue
GROUP BY revenue_segment
ORDER BY avg_revenue DESC;


-- Top 4.4% of customers (261 High Value) drive 50% of total revenue.
-- More extreme than Pareto 80/20 -- business is dangerously concentrated.
-- Losing a single High Value customer has outsized revenue impact.
-- Priority action: dedicated account management for all 261 High Value customers.

-- Query 10: Pareto -- Top 20% customers revenue contribution
WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue
    FROM online_retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
deciles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(10) OVER (ORDER BY total_revenue DESC) AS decile
    FROM customer_revenue
)
SELECT
    decile,
    COUNT(*)                                                                          AS total_customers,
    ROUND(SUM(total_revenue)::NUMERIC, 2)                                             AS decile_revenue,
    ROUND(SUM(total_revenue) * 100.0 / SUM(SUM(total_revenue)) OVER (), 2)           AS revenue_pct
FROM deciles
GROUP BY decile
ORDER BY decile;

-- Top 10% of customers generate 63.9% of revenue -- super-Pareto distribution.
-- Top 20% generate 77.3% of revenue.
-- Bottom 50% of customers contribute only 6.96% of revenue combined.
-- Business risk: extreme revenue concentration in small customer group.
-- Recommendation: VIP retention programme + diversification strategy.