/*
===============================================================================
📊 Change Over Time Analysis
===============================================================================
Purpose:
    - Analyze monthly sales trends using different date functions:
        • YEAR(), MONTH()
        • DATETRUNC()
        • FORMAT()
    - Compare total sales, customer count, and quantity sold over time.
    - Track how many new customers were acquired each year.

Queries Included:
    1. Sales performance by year and month using YEAR(), MONTH()
    2. Monthly aggregation using DATETRUNC() for accurate time grouping
    3. Readable date formatting with FORMAT() for reporting
    4. Annual new customer acquisition from customer dimension table

Tables Used:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Analyse sales performance over time
SELECT YEAR(order_date) AS order_year ,
	   MONTH(order_date) AS order_month,
	   SUM(sales_amount) AS total_Sales, 
	   COUNT(DISTINCT customer_key) AS total_customers,
	   SUM(quanity) AS total_quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date) ,MONTH(order_date)
ORDER BY total_Sales desc ,MONTH(order_date)



-- DATETRUNC()
SELECT DATETRUNC(MONTH ,order_date) AS order_date,
	   SUM(sales_amount) AS total_Sales, 
	   COUNT(DISTINCT customer_key) AS total_customers,
	   SUM(quanity) AS total_quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH ,order_date)
ORDER BY DATETRUNC(MONTH ,order_date)


-- FORMAT()
SELECT FORMAT(order_date, 'yyyy MMMM') AS order_date,
	   SUM(sales_amount) AS total_sales,
	   COUNT(DISTINCT customer_key) AS total_customers,
	   SUM(quanity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy MMMM')
ORDER BY FORMAT(order_date, 'yyyy MMMM');


--Number of new customers were added each year
SELECT YEAR(CREATE_DATE) AS create_year ,COUNT(customer_key) as total_Cusomer
FROM gold.dim_customers
GROUP BY  YEAR(CREATE_DATE)
