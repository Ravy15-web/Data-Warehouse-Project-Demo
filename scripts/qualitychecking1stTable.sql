-- Check for Nulls or Duplicates in Primary Key (Count group by flagging strategy)
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Data Standardization & consistency (CASE WHEN strat.) with UPPER secure
SELECT Distinct cst_gndr
FROM silver.crm_cust_info

SELECT Distinct cst_marital_status
FROM silver.crm_cust_info

--Check for unwanted spaces (TRIM strat.)
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM (cst_firstname)

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM (cst_lastname)

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM (cst_gndr)

SELECT *
FROM silver.crm_cust_info
