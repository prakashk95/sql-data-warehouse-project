/*
========================================================================================================================
Stored procedure script:  Load Silver layer (Bronze Layer ->Silver)
==================================================================-=====================================================
Script Purpose:
              This stored procedure load the data from Bronze layer into the 'silver' schema from Database bronze tables.
              It performs folowwing funcions:
             -Truncates the silver tables before loading into tables.
Perameter: None.
          This stored procedure does not accept any perameter or return any value.
Usage example: 
              EXEC Silver.load_silver;    
========================================================================================================================
*/


CREATE or ALTER PROCEDURE SILVER.load_silver as
BEGIN
    -----------------------------------------------
    PRINT 'Truncating Table:Silver.crm_cust_info.'
    TRUNCATE TABLE Silver.crm_cust_info;
    PRINT 'Inserting Data :Silver.crm_cust_info.';
    insert into Silver.crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
     )

    select
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname ,
    trim(cst_lastname) as cst_lastname,
    case when UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
         when UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
         else 'n/a'
    END cst_marital_status,

    case when UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
         when UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
         else 'n/a'
    END cst_gndr,
    cst_create_date
    from(
       SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
        FROM Bronze.crm_cust_info
        ) t where flag_last = 1;

    ----------------------------------------------------------------------
    PRINT 'Truncating Table:Silver.crm_prd_info.'
    TRUNCATE TABLE Silver.crm_prd_info;
    PRINT 'Inserting Data :Silver.crm_prd_info';

    INSERT INTO Silver.crm_prd_info
    (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,--extract category id
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --extract product kry
        prd_nm,
        ISNULL(prd_cost, 0) AS prd_cost,
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'N/A'
        END   AS prd_line,
        CAST(prd_start_dt AS DATE) AS prd_start_dt,
        DATEADD(
            DAY,
            -1,
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            )
        )  AS prd_end_dt
    FROM Bronze.crm_prd_info;

    ----------------------------------------------------------------------
    PRINT 'Truncating Table:Silver.crm_sales_details.'
    TRUNCATE TABLE Silver.crm_sales_details;
    PRINT 'Inserting Data :Silver.crm_sales_details';
    insert into Silver.crm_sales_details(
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
    select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case when sls_order_dt = 0 or len(sls_order_dt) != 8 THEN NULL
              else cast(cast(sls_order_dt as nvarchar) as date)
              end sls_order_dt,

    case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 THEN NULL
              else cast(cast(sls_ship_dt as nvarchar) as date)
              end sls_ship_dt,

    case when sls_due_dt = 0 or len(sls_due_dt) != 8 THEN NULL
              else cast(cast(sls_due_dt as nvarchar) as date)
              end sls_due_dt,

    case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity* abs(sls_price)
         then sls_quantity * abs(sls_price)
         else sls_sales
         end sls_sales,

    sls_quantity,

    case when sls_price is null or sls_price = 0 
         then sls_sales/nullif(sls_quantity,0)
         else sls_price
         end
    sls_price
    from 
    Bronze.crm_sales_details;

    ----------------------------------------------------------------------
    PRINT 'Truncating Table:silver.erp_CUST_AZ12.'
    TRUNCATE TABLE silver.erp_CUST_AZ12;
    PRINT 'Inserting Data :silver.erp_CUST_AZ12';
    insert into silver.erp_CUST_AZ12(
    CID,
    BDATE,
    GEN)

    select 
    case when cid like 'NAS%' THEN SUBSTRING(cid,4,LEN(CID))
    else CID
    end CID,
    case when BDATE > GETDATE() THEN NULL
    ELSE BDATE
    end BDATE,

    case when UPPER(TRIM(GEN)) in ('F','FEMALE') THEN 'Female'
         when UPPER(Trim(GEN)) in ('M','MALE') THEN 'Male'
         ELSE 'n/a'
    END GEN
    from Bronze.erp_CUST_AZ12;

    ----------------------------------------------------------------------
    PRINT 'Truncating Table:Silver.erp_LOC_A101.'
    TRUNCATE TABLE Silver.erp_LOC_A101;
    PRINT 'Inserting Data :Silver.erp_LOC_A101';
    insert into Silver.erp_LOC_A101(CID,CNTRY)

    select Replace(CID,'-','') CID, 
    case when TRIM(CNTRY) = 'DE' THEN 'Germany'
         WHEN TRIM(CNTRY) in ('US','USA', 'United States') THEN 'United States'
         WHEN TRIM(CNTRY) = '' or CNTRY is NULL THEN 'N/a'
         ELSE CNTRY
    END CNTRY 
    from Bronze.erp_LOC_A101
    ----------------------------------------------------------------------
    PRINT 'Truncating Table:SILVER.erp_PX_CAT_G1V2.'
    TRUNCATE TABLE SILVER.erp_PX_CAT_G1V2;
    PRINT 'Inserting Data :SILVER.erp_PX_CAT_G1V2.';
    INSERT INTO SILVER.erp_PX_CAT_G1V2(ID, CAT, SUBCAT, MAINTENANCE)
    select
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
    from bronze.erp_PX_CAT_G1V2
END

execute silver.load_silver
