/*
Script Purpose: Truncating tables then bulk inserting tables. 6 tables in total.

*/
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_cust_2ndinfo;
BULK INSERT bronze.erp_cust_2ndinfo
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_cust_loc;
BULK INSERT bronze.erp_cust_loc
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_prd_cat;
BULK INSERT bronze.erp_prd_cat
FROM 'C:\Users\Zaldy\Desktop\SQL Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
