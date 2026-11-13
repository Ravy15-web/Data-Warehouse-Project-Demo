-- Which categories contribute the most to overall sales?
SELECT
category,
sales_category,
SUM(sales_category) OVER() as total_sales,
CONCAT(ROUND((sales_category / SUM(sales_category) OVER())*100,2,3),'%') as percentage_of_total_sales
FROM (
SELECT
p.category,
CAST(SUM(f.sales_amount) AS FLOAT) as sales_category
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category)t
ORDER BY sales_category DESC
