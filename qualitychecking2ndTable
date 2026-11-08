-- Check for Nulls or Duplicates in Primary Key
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check for unwanted spaces
SELECT
prd_name
FROM silver.crm_prd_info
WHERE prd_name != TRIM(prd_name)

--Check for nulls or 0 cost
SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Check for standardization
SELECT DISTINCT
prd_line
FROM silver.crm_prd_info

--Check for date qualities
SELECT
prd_id,
prd_key,
prd_name,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt,
DATEADD(day, -1, (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))) AS prd_end_dt_test
FROM silver.crm_prd_info

SELECT *
FROM bronze.crm_prd_info
