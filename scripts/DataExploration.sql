/* This is the table for measurement exploration' */

SELECT 'Total Sales' as measure_name, 
SUM(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity Sold' as measure_name,
SUM(quantity) AS total_quantity FROM gold.fact_sales
UNION ALL
SELECT 'Total average price' as measure_name,
AVG(price) as avg_price FROM gold.fact_sales
UNION ALL
SELECT 'Total number of orders' as measure_name,
COUNT(DISTINCT order_number) as total_orders FROM gold.fact_sales
UNION ALL
SELECT 'Total number of products' as measure_name,
COUNT(DISTINCT product_name) as total_products FROM gold.dim_products
UNION ALL
SELECT 'Total customers' as measure_name,
COUNT(customer_key) as total_customers FROM gold.dim_customers
UNION ALL
SELECT 'Customers who ordered' as measure_name,
COUNT(DISTINCT customer_key) as total_customers FROM gold.fact_sales;
