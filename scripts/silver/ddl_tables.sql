/*
====================================================================================
DDL Script: Create Silver Tables
====================================================================================
Purpose: 
       This script creates tables in the 'silver' schema, dropping existing tables
       if they already exist.
       Run this script to redefine the DDL structure of silver tables
====================================================================================     
*/

USE DataWarehouse;

IF OBJECT_ID('Silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_cust_info
	CREATE TABLE Silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(10),
	cst_gndr VARCHAR(10),
	cst_create_date DATE,
	wrh_create_date DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('Silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_prd_info
	CREATE TABLE Silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	wrh_create_date DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('Silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE Silver.crm_sales_details
	CREATE TABLE Silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	wrh_create_date DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('Silver.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE Silver.erp_CUST_AZ12
	CREATE TABLE Silver.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(10),
	wrh_create_date DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('Silver.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE Silver.erp_LOC_A101
	CREATE TABLE Silver.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(20),
	wrh_create_date DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('Silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE Silver.erp_PX_CAT_G1V2
	CREATE TABLE Silver.erp_PX_CAT_G1V2(
	ID NVARCHAR(20),
	CAT NVARCHAR(30),
	SUBCAT NVARCHAR(30),
	MAINTENANCE NVARCHAR(10),
	wrh_create_date DATETIME DEFAULT GETDATE()
);



