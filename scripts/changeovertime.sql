--Change over time analysis - Revenue
SELECT
order_month,
total_customers,
total_sales,
amount_change,
CONCAT(COALESCE(CAST((CAST(amount_change as FLOAT) / CAST(total_sales as FLOAT) * 100) as DECIMAL(10,2)),0),'%') as percentage_change
FROM (
SELECT
DATETRUNC(month, order_date) as order_month,
COUNT(DISTINCT customer_key) as total_customers,
SUM(sales_amount) as total_sales,
SUM(sales_amount)- LAG(SUM(sales_amount)) OVER (ORDER BY DATETRUNC(month, order_date)) as amount_change
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t
