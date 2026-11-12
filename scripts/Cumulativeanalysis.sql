/* Cumulative analysis:
Note: Aggregate(Total from subquery) OVER (ORDER BY date)
*/

-- Running total of sales
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) as cumulative_sales
FROM (
SELECT
DATETRUNC(month, order_date) as order_date,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t

--Moving average of sales
SELECT
order_date,
AVG(average_sales) OVER (ORDER BY order_date) as moving_average_sales
FROM (
SELECT
DATETRUNC(month, order_date) as order_date,
AVG(sales_amount) as average_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t
