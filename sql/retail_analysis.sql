-- Retail Sales & Profitability Analysis (SQL Server)
-- Load data/retail_orders.csv into dbo.retail_orders before running these queries.

-- 1. Data quality checks
SELECT COUNT(*) AS row_count FROM dbo.retail_orders;
SELECT COUNT(*) AS missing_customer_ids FROM dbo.retail_orders WHERE customer_id IS NULL;
SELECT * FROM dbo.retail_orders WHERE quantity <= 0 OR sales < 0 OR profit IS NULL;
SELECT order_id, COUNT(*) AS duplicate_count FROM dbo.retail_orders GROUP BY order_id HAVING COUNT(*) > 1;

-- 2. Monthly revenue, profit and margin
SELECT DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
       SUM(sales) AS revenue, SUM(profit) AS profit,
       CAST(100.0 * SUM(profit) / NULLIF(SUM(sales), 0) AS decimal(10,2)) AS profit_margin_pct
FROM dbo.retail_orders GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
ORDER BY month_start;

-- 3. Regional performance
SELECT region, SUM(sales) AS revenue, SUM(profit) AS profit,
       CAST(100.0 * SUM(profit) / NULLIF(SUM(sales), 0) AS decimal(10,2)) AS profit_margin_pct,
       COUNT(DISTINCT order_id) AS orders
FROM dbo.retail_orders GROUP BY region ORDER BY revenue DESC;

-- 4. Category and product profitability
SELECT category, product, SUM(sales) AS revenue, SUM(profit) AS profit,
       SUM(quantity) AS units_sold
FROM dbo.retail_orders GROUP BY category, product ORDER BY profit DESC;

-- 5. Discount impact bands
SELECT CASE WHEN discount_pct = 0 THEN '0%'
            WHEN discount_pct <= 0.10 THEN '1-10%'
            WHEN discount_pct <= 0.20 THEN '11-20%'
            ELSE '21-30%' END AS discount_band,
       COUNT(*) AS order_lines, SUM(sales) AS revenue, SUM(profit) AS profit,
       CAST(100.0 * SUM(profit) / NULLIF(SUM(sales),0) AS decimal(10,2)) AS profit_margin_pct
FROM dbo.retail_orders GROUP BY CASE WHEN discount_pct = 0 THEN '0%'
            WHEN discount_pct <= 0.10 THEN '1-10%'
            WHEN discount_pct <= 0.20 THEN '11-20%' ELSE '21-30%' END
ORDER BY MIN(discount_pct);

-- 6. Loss-making product/order lines
SELECT order_id, order_date, region, category, product, quantity, discount_pct, sales, cost, profit
FROM dbo.retail_orders WHERE profit < 0 ORDER BY profit ASC;

-- 7. Top 10 products by revenue (include ties)
SELECT TOP (10) WITH TIES product, SUM(sales) AS revenue, SUM(profit) AS profit
FROM dbo.retail_orders GROUP BY product ORDER BY SUM(sales) DESC;

-- 8. Running monthly revenue
WITH monthly AS (
 SELECT DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start, SUM(sales) AS revenue
 FROM dbo.retail_orders GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
)
SELECT month_start, revenue, SUM(revenue) OVER (ORDER BY month_start ROWS UNBOUNDED PRECEDING) AS cumulative_revenue
FROM monthly ORDER BY month_start;
