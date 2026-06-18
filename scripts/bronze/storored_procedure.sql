/*
========================================================================================================================
Stored procedure script:  Load Bronze layer (Source ->Bronze)
==================================================================-=====================================================
Script Purpose:
              This stored procedure load the data from sources into the 'bronze' schema from external sources CSV files.
              It performs folowwing funcions:
             -Truncates the bronze tables before loading into tables.
             -Uses 'BULK INSERT' command to load data from CSV Files to Bronze tables.
Perameter: None.
          This stored procedure does not accept any perameter or return any value.
Usage example: 
              EXEC Bronze.load_bronze;    
========================================================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze as  
BEGIN
DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @BATCH_START DATETIME, @BATCH_END TIME;

BEGIN TRY
SET @BATCH_START = GETDATE();

	PRINT'======================================================================='
	PRINT'LOADING BRONZE LAYER'
	PRINT'-----------------------------------------------------------------------'
	PRINT'LOADING CRM TABLES'
	PRINT'-----------------------------------------------------------------------'

	
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.crm_cust_info '
	TRUNCATE TABLE Bronze.crm_cust_info; --qUICKLY DELETE ALL DATA AND RESET THE TABLE.
	PRINT'>>LOADING DATA IN TABLE: Bronze.crm_cust_info '
	BULK INSERT Bronze.crm_cust_info 
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_crm\cust_info.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR) + 'SECONDS.';

	PRINT'------------------------'
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.crm_prd_info'
	TRUNCATE TABLE Bronze.crm_prd_info; --QUICKLY DELETE ALL DATA AND RESET THE TABLE.

	PRINT'>>LOADING DATA IN TABLE: Bronze.crm_prd_info'
	BULK INSERT Bronze.crm_prd_info 
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_crm\prd_info.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR)  + 'SECONDS.';

	
	PRINT'------------------------'
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.crm_sales_details'
	TRUNCATE TABLE Bronze.crm_sales_details; --QUICKLY DELETE ALL DATA AND RESET THE TABLE.

	PRINT'>>LOADING DATA IN TABLE: Bronze.crm_sales_details'
	BULK INSERT Bronze.crm_sales_details 
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_crm\sales_details.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	PRINT'-----------------------------------------------------------------------'
	PRINT'LOADING ERP TABLES'
	PRINT'-----------------------------------------------------------------------'

		SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR)  + 'SECONDS.';

	
	PRINT'------------------------'
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.erp_CUST_AZ12'
	TRUNCATE TABLE Bronze.erp_CUST_AZ12; --QUICKLY DELETE ALL DATA AND RESET THE TABLE.

	PRINT'>>LOADING DATA IN TABLE: Bronze.erp_CUST_AZ12'
	BULK INSERT Bronze.erp_CUST_AZ12
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_erp\CUST_AZ12.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
		SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR) + 'SECONDS.';

	
	PRINT'------------------------'
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.erp_LOC_A101'
	TRUNCATE TABLE Bronze.erp_LOC_A101; --QUICKLY DELETE ALL DATA AND RESET THE TABLE.

	PRINT'>>LOADING DATA IN TABLE: Bronze.erp_LOC_A101'
	BULK INSERT Bronze.erp_LOC_A101
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_erp\LOC_A101.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

	SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR)  + 'SECONDS.';

	
	PRINT'------------------------'
	SET @START_TIME = GETDATE();
	PRINT'>>TRUNCATING TABLE: Bronze.erp_PX_CAT_G1V2'
	TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2; --QUICKLY DELETE ALL DATA AND RESET THE TABLE.

	PRINT'>>LOADING DATA IN TABLE: Bronze.erp_PX_CAT_G1V2'
	BULK INSERT Bronze.erp_PX_CAT_G1V2
	FROM 'C:\Users\pc\Desktop\sql projects\WareHouse\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH(
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
		SET @END_TIME = GETDATE();
	PRINT'>>lOAD DURATION:' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR)  + 'SECONDS.';

	PRINT'-------------------------------------------------'
	
SET @BATCH_END = GETDATE();
PRINT'LOADIND BRONZE LAYER COMPLETE'
PRINT'TOTAL LOAD TIME OF BRONZE LAYER:' + CAST(DATEDIFF(SECOND,@BATCH_START,@BATCH_END) AS NVARCHAR) + 'SECONDS.'

END TRY
BEGIN CATCH
END CATCH

END

--EXECUTE TO CREATE IT
EXEC Bronze.load_bronze

