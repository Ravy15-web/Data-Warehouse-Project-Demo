/*

*/

--crm 1st table
INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) cst_firstname,
TRIM(cst_lastname) cst_lastname,
CASE WHEN TRIM(cst_marital_status) = 'M' THEN 'Married'
	WHEN TRIM(cst_marital_status) = 'S' THEN 'Single'
	ELSE 'n/a'
END cst_marital_status,
CASE WHEN TRIM(cst_gndr) = 'F' THEN 'Female'
	WHEN TRIM(cst_gndr) = 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM ( SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1


--crm 2nd table	
INSERT INTO silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_name,
prd_cst,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7, LEN(prd_key)) as prd_key,
prd_name,
ISNULL(prd_cost,0) as prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a'
END prd_line,
prd_start_dt,
DATEADD(day, -1, LEAD(prd_end_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as prd_end_dt
FROM bronze.crm_prd_info










