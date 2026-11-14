/*
===============================================================================
Product Report
===============================================================================
Purpose: This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3, Aggregates product-level metrics:
		-total orders
		-total sales
		-total quantity sold
		-total customers (unique)
		-lifespan (in months)
	4. Calculates valuable KPIs:
		-recency (months since last sale)
		-average order revenue (AOR)
		-average monthly revenue
===============================================================================
*/
CREATE VIEW gold.report_products AS

WITH base_productinfo_CTE AS (
SELECT
f.product_key,
product_name,
category,
subcategory,
cost,
COUNT(order_number) as total_orders,
COUNT(DISTINCT customer_key) as total_customers,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan,
MAX(order_date) as last_order_date,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY
f.product_key,
product_name,
category,
subcategory,
cost)

SELECT
product_key,
product_name,
category,
subcategory,
cost,
total_orders,
CASE WHEN total_orders = 0 THEN 0
	ELSE total_sales / total_orders
END average_order_revenue,
total_customers,
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END average_monthly_revenue,
lifespan,
DATEDIFF(month, MAX(last_order_date), GETDATE()) as recency,
total_sales,
CASE WHEN total_sales > 100000 THEN 'High_Performers'
	WHEN total_sales between 30000 and 100000 THEN 'Mid-Range'
	ELSE 'Low-Performers'
END productsales_segment,
total_quantity
FROM base_productinfo_CTE
GROUP BY product_key,
product_name,
category,
subcategory,
cost,
total_orders,
total_sales,
lifespan,
total_quantity,
total_customers
