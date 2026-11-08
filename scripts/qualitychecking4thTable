--Check for customer_id
SELECT
COUNT(REPLACE(customer_id,'NAS','')) customer_id
FROM bronze.erp_cust_2ndinfo
WHERE REPLACE(customer_id,'NAS','') NOT IN (
SELECT cst_key
FROM silver.crm_cust_info)


--Check for birthdate
SELECT
birth_date
FROM bronze.erp_cust_2ndinfo
WHERE birth_date < '1924-01-01' OR birth_date > GETDATE()

--Check for gender
SELECT DISTINCT
gender
FROM bronze.erp_cust_2ndinfo
