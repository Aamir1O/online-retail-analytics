-- ============================================================
-- Online Retail II — Database Setup & Validation
-- Author: Aamir
-- ============================================================

-- Step 1: Create table
CREATE TABLE online_retail_sales (
    invoice         VARCHAR(20),
    stockcode       VARCHAR(20),
    description     TEXT,
    quantity        INTEGER,
    invoicedate     TIMESTAMP,
    price           NUMERIC(10, 2),
    customer_id     NUMERIC(10, 0),
    country         VARCHAR(100),
    revenue         NUMERIC(12, 2),
    year            INTEGER,
    month           INTEGER,
    month_year      VARCHAR(10)
);

-- Step 2: Fix date column type
ALTER TABLE online_retail_sales
ALTER COLUMN invoicedate TYPE TIMESTAMP
USING invoicedate::TIMESTAMP;

-- Step 3: Validate row count
SELECT COUNT(*) FROM online_retail_sales;

-- Step 4: Preview data
SELECT * FROM online_retail_sales LIMIT 5;

-- Step 5: Validate key metrics match notebook output
SELECT 
    ROUND(SUM(revenue)::NUMERIC, 2) AS total_revenue,
    COUNT(DISTINCT invoice)          AS total_orders,
    COUNT(DISTINCT customer_id)      AS total_customers,
    COUNT(DISTINCT country)          AS total_countries
FROM online_retail_sales;

-- Step 6: Validate date range
SELECT 
    MIN(invoicedate) AS start_date,
    MAX(invoicedate) AS end_date
FROM online_retail_sales;