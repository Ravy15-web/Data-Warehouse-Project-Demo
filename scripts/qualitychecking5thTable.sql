--Check for customer_id
SELECT
customer_id as old_customer_id,
REPLACE(customer_id,'-','') customer_id
FROM bronze.erp_cust_loc

--Check for country
SELECT DISTINCT
country as old_country,
CASE WHEN country IN ('DE','Germany') THEN 'Germany'
	WHEN country IN ('US','USA','United States') THEN 'United States'
	WHEN country IN ('Australia','United Kingdom','France','Canada') THEN country
	ELSE 'n/a'
END country
FROM bronze.erp_cust_loc
ORDER BY country
