Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==================================================================================
*/
-- Retrieve the important column first and do some data formatting
CREATE VIEW gold.report_customers AS

WITH base_customer_details_CTE AS (
SELECT
f.order_number,
c.customer_number,
f.product_key,
f.customer_key,
CONCAT(c.first_name,' ', c.last_name) as customer_name,
DATEDIFF(year,c.birthdate,GETDATE()) as age,
f.order_date,
f.sales_amount,
f.quantity,
f.price
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL),


/* Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months) */
customer_aggregation_CTE AS (
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) as total_orders,
SUM(sales_amount) as total_sales,
COUNT(quantity) as total_quantity_purchased,
COUNT(DISTINCT product_key) as total_products,
MAX(order_date) as last_order_date,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
FROM base_customer_details_CTE
GROUP BY customer_key, customer_number, customer_name, age)

/* Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend */

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 30 THEN 'Under 30'
	WHEN age between 30 and 39 THEN '30-39'
	WHEN age between 40 and 49 THEN '40-49'
	ELSE '50 and above'
END age_segment,
total_orders,
total_sales,
CASE WHEN total_orders = 0 THEN 0
	ELSE total_sales / total_orders
END as average_order_value,
total_quantity_purchased,
total_products,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) as recency,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	ELSE 'New'
END customer_segment,
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END as average_monthly_spend,
lifespan
FROM customer_aggregation_CTE
