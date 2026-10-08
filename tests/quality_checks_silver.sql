/*
======================================================================================
Quality Checks

======================================================================================
Script Purpose
    This Script performs variuos quality checks for data consistency,
    accuracy and standardization across the 'silver' schemas. It includes checks for:
    -Null or duplicaes primary key.
    -Unwanted spaces in string fields.
    -Data standardization and consistency.
    -Invalid date ranges and orders.
    -Data consistency between related fields.

Usage Note:
    -Run these checks aftr data loading silver layer
    -Investigate and resolve any discrepancies found during the checks.

======================================================================================
*/


-- ===============================================================================
--Checking 'silver.crm_cust_info'
-- ===============================================================================
-- Checking for NULLs or Duplicates in the primary key
-- Expectation: No results
SELECT
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING  COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in the string columns
-- Expectation: No results

SELECT
  cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data standardization and Consistency i.e., No Abbrevations and NO Null replace with Unknown or n/a
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info
-- ===============================================================================
--Checking 'silver.crm_sales_details'
-- ===============================================================================
-- Invalid Dates Checking
SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <=0 OR LEN(sls_order_dt)!=8 or sls_order_dt> 20500101 OR sls_order_dt < 19000101
--- Invalid Intergers Checking for Sales, qty and price
SELECT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price as old_sls_price,
CASE WHEN sls_sales IS  NULL OR sls_sales<=0 OR sls_sales!= sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price is NULL or sls_price<=0
	 THEN sls_sales/NULLIF(sls_quantity,0)
	 ELSE sls_price
END AS sls_price
FROM silver.crm_sales_details
where sls_sales!= sls_quantity * sls_price OR 
	  sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR 
	  sls_sales<=0 or sls_quantity<=0 OR  sls_price<=0
ORDER BY sls_sales,sls_quantity,sls_price


-- ===============================================================================
--Checking 'silver.erp_cust_az12'
-- ===============================================================================
SELECT DISTINCT
BDATE
FROM silver.erp_cust_az12
WHERE BDATE < '1924-01-01' OR BDATE> GETDATE()
  
-- To get the Distinct Values in a column


SELECT DISTINCT
GEN
FROM silver.erp_cust_az12

-- ===============================================================================
--Checking 'silver.erp_loc_a101'
-- ===============================================================================
-- Primary key Correction for Joining tables
SELECT DISTINCT 
	CID,
	REPLACE(CID,'-','') CID
FROM silver.erp_loc_a101

-- Data inconsistency correction
  
SELECT DISTINCT 
	CNTRY,
	CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		 WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
		 ELSE TRIM(CNTRY)
	END CNTRY

FROM silver.erp_loc_a101

-- ===============================================================================
--Checking 'silver.erp_px_cat_g1v2'
-- ===============================================================================
-- Check for unwanted Spaces
SELECT 
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
FROM silver.erp_px_cat_g1v2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR MAINTENANCE != TRIM(MAINTENANCE)


