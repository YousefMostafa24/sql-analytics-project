/*
===============================================================================
🗂 Database & Data Exploration
===============================================================================
Purpose:
    - Explore database structure (tables, columns, schemas)
    - Analyze dimension tables
    - Identify key date ranges in the data

Key Tables:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS

SQL Functions:
    - DISTINCT, ORDER BY
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/


-- Retrieve a list of all tables in the database
SELECT TABLE_CATALOG, TABLE_SCHEMA, 
       TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;


-- Retrieve all columns for a specific table (dim_customers)
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, 
       CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


--Explore ALL Countries our Customers Come From.
SELECT DISTINCT country
FROM gold.dim_customers


--Explore All Categoreis The Major Division
SELECT DISTINCT category ,subcategory ,product_name
FROM gold.dim_products
ORDER BY 1,2,3



--The date of first and last order
SELECT Min(order_date) as first_order_date ,MAX(order_date) as last_order_date ,
	     DATEDIFF(MONTH ,MIN(order_date) ,MAX(order_date)) AS range_months
FROM gold.fact_sales


--The Youngest and The Oldest Customer
SELECT MIN(birthdate) as  oldest_customer, 
	     DATEDIFF(YEAR ,MIN(birthdate),GETDATE()) AS oldest_age,
	     MAX(birthdate) as youngest_customer,
	     DATEDIFF(YEAR ,MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers


