--First view table
CREATE VIEW gold.dim_customers AS

SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.country as country,
ci.cst_marital_status as marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM is the Master for gender info
	ELSE COALESCE(ca.gender,'n/a')
END AS gender,
ca.birth_date as birthdate,
ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_2ndinfo ca
ON ci.cst_key = ca.customer_id
LEFT JOIN silver.erp_cust_loc la
ON ci.cst_key = la.customer_id

--2nd view table
CREATE VIEW gold.dim_products AS

SELECT
ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_name as product_name,
pn.cat_id as category_id,
pc.category as category,
pc.sub_category as subcategory,
pc.maintenance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_prd_cat pc
ON pn.cat_id = pc.product_id
WHERE prd_end_dt IS NULL
