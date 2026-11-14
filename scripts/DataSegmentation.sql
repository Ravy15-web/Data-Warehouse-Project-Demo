/* SEGMENT products into cost ranges and count how many products
fall into each segment */

WITH cost_CTE AS (
SELECT
product_id,
product_name,
cost,
CASE WHEN cost <= 200 AND cost > 0 THEN 'Low cost'
	WHEN cost > 200 AND cost <= 1000 THEN 'average cost'
	WHEN cost > 1000 THEN 'High cost'
	ELSE 'no price'
END cost_rating
FROM gold.dim_products)

SELECT
cost_rating,
COUNT(*) as no_of_products
FROM cost_CTE
GROUP BY cost_rating
ORDER BY COUNT(*) DESC

/* Group customers into three segments based on their spending behavior:
- VIP: Customers with at least 12 months of history and spending more than $5,000.
- Regular: Customers with at least 12 months of history but spending 5,000 or less.
- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group */

-- My messy work compared to Baraa, I tried my best. The results are the same
WITH customer_sales_CTE AS (
SELECT
c.customer_key,
DATEDIFF(month, MIN(f.order_date) OVER (PARTITION BY c.customer_key), MAX(f.order_date)OVER (PARTITION BY c.customer_key)) as order_history,
SUM(f.sales_amount) OVER (PARTITION BY c.customer_key) total_sales,
CASE WHEN SUM(f.sales_amount) OVER (PARTITION BY c.customer_key) > 5000 AND DATEDIFF(month, MIN(f.order_date) OVER (PARTITION BY c.customer_key), MAX(f.order_date)OVER (PARTITION BY c.customer_key)) >= 12 THEN 'VIP'
	WHEN SUM(f.sales_amount) OVER (PARTITION BY c.customer_key) <= 5000 AND DATEDIFF(month, MIN(f.order_date) OVER (PARTITION BY c.customer_key), MAX(f.order_date)OVER (PARTITION BY c.customer_key)) >= 12 THEN 'Regular'
	ELSE 'New'
END customer_rating
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
)

SELECT
customer_rating,
COUNT(customer_key) as total_customers
FROM (
SELECT
customer_key,
customer_rating
FROM customer_sales_CTE
GROUP BY customer_rating, customer_key)t
GROUP BY customer_rating;

--Baraa's Work
WITH customer_spending_CTE AS (
SELECT
c.customer_key,
SUM(f.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) as lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) as total_customers
FROM (
SELECT
customer_key,
total_spending,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
END customer_segment
FROM customer_spending_CTE)t
GROUP BY customer_segment;


