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
