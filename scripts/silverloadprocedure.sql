/*
Script purpose: This is a stored procedure that performs data cleansing from the bronze layer.
Silver load procedure name: silver.load_silver
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';
				--crm 1st table
 		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Inserting Data Into: silver.crm_cust_info';
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
				WHERE flag_last = 1;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
	
				--crm 2nd table	
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>> Inserting Data Into: silver.crm_prd_info';
				INSERT INTO silver.crm_prd_info (
				prd_id,
				cat_id,
				prd_key,
				prd_name,
				prd_cost,
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
				FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';	
		
				--CRM 3rd table
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>> Inserting Data Into: silver.crm_sales_details';	
				INSERT INTO silver.crm_sales_details (
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
				)	
				SELECT
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
				END as sls_order_dt,
				CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				END as sls_ship_dt,
				CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
				END as sls_due_dt,
				CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
				    ELSE sls_sales
				END as sls_sales,
				sls_quantity,
				CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
				    ELSE sls_price
				END AS sls_price
				FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		

		PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

				--ERP 1st table
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_cust_2ndinfo';
        TRUNCATE TABLE silver.erp_cust_2ndinfo;
        PRINT '>> Inserting Data Into: silver.erp_cust_2ndinfo';
				INSERT INTO silver.erp_cust_2ndinfo (	
				customer_id,
				birth_date,
				gender
				)		
				SELECT
				REPLACE(customer_id,'NAS','') customer_id,
				CASE WHEN birth_date > GETDATE() THEN NULL
					ELSE birth_date
				END as birth_date,
				CASE WHEN TRIM(gender) IN ('F','Female') THEN 'Female'
					WHEN TRIM(gender) IN ('M', 'Male') THEN 'Male'
					ELSE 'n/a'
				END as gender
				FROM bronze.erp_cust_2ndinfo;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
			
				--ERP 2nd table
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_cust_loc';
        TRUNCATE TABLE silver.erp_cust_loc;
        PRINT '>> Inserting Data Into: silver.erp_cust_loc';

				INSERT INTO silver.erp_cust_loc (
				customer_id,
				country
				)
				SELECT
				REPLACE(customer_id,'-','') customer_id,
				CASE WHEN TRIM(country) IN ('DE','Germany') THEN 'Germany'
					WHEN TRIM(country) IN ('US','USA') THEN 'United States'
					WHEN country IS NULL OR country = ' ' THEN 'n/a'
					ELSE TRIM(country)
				END country
				FROM bronze.erp_cust_loc
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
				--ERP 3rd table
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_prd_cat';
        TRUNCATE TABLE silver.erp_prd_cat;
        PRINT '>> Inserting Data Into: silver.erp_prd_cat';
				INSERT INTO silver.erp_prd_cat (
				product_id,
				category,
				sub_category,
				maintenance
				)	
				SELECT
				product_id,
				category,
				sub_category,
				maintenance
				FROM bronze.erp_prd_cat;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================================='

    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END



