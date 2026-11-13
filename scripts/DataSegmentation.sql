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
