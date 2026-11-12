/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */
WITH yearly_sales_cte AS (
SELECT
DATETRUNC(year, order_date) as order_year,
product_name,
SUM(f.sales_amount) as yearly_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY product_name, DATETRUNC(year, order_date)
)
SELECT
order_year,
product_name,
yearly_sales,
AVG(yearly_sales) OVER (PARTITION BY product_name) as target_sales,
yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name) as avg_diff,
CASE WHEN yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name) <= 0 THEN 'Below Average'
	WHEN yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
	ELSE 'Average'
END performance_rating,
yearly_sales - LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY order_year)  as change_in_sales,
CASE WHEN yearly_sales - LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease in sales'
	WHEN yearly_sales - LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase in sales'
	ELSE 'no changes'
END trend
FROM yearly_sales_cte
