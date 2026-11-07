/*
Script purpose: creating tables, 6 tables in total

Use the following syntax to check the existing tables:

IF OBJECT_ID ('schema.table_name', 'U') IS NOT NULL
	DROP TABLE schema.table_name
*/

CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for CRM product information
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
CREATE TABLE silver.erp_cust_2ndinfo (
customer_id NVARCHAR(50),
birth_date DATE,
gender NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for ERP customer location
CREATE TABLE silver.erp_cust_loc (
customer_id NVARCHAR(50),
country NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--DDL for ERP product categories and subcategories
CREATE TABLE silver.erp_prd_cat (
product_id NVARCHAR(50),
category NVARCHAR(50),
sub_category NVARCHAR(50),
maintenance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
