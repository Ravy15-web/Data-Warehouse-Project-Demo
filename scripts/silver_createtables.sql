/*
Script purpose: creating tables, 6 tables in total

Use the following syntax to check the existing tables:

IF OBJECT_ID ('schema.table_name', 'U') IS NOT NULL
	DROP TABLE schema.table_name
*/

--DDL for CRM customer information
IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info
CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for CRM product information
IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info
CREATE TABLE silver.crm_prd_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_name NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for CRM sales details
IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details
CREATE TABLE silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for ERP customer secondary information
IF OBJECT_ID ('silver.erp_cust_2ndinfo', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_2ndinfo
CREATE TABLE silver.erp_cust_2ndinfo (
customer_id NVARCHAR(50),
birth_date DATE,
gender NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for ERP customer location
IF OBJECT_ID ('silver.erp_cust_loc', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_loc
CREATE TABLE silver.erp_cust_loc (
customer_id NVARCHAR(50),
country NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for ERP product categories and subcategories
IF OBJECT_ID ('silver.erp_prd_cat', 'U') IS NOT NULL
	DROP TABLE silver.erp_prd_cat
CREATE TABLE silver.erp_prd_cat (
product_id NVARCHAR(50),
category NVARCHAR(50),
sub_category NVARCHAR(50),
maintenance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
