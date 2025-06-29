/*
===============================================================================
📈 Cumulative Analysis
===============================================================================
Purpose:
    - Analyze sales performance over time at different granularities.
    - Track total daily and monthly sales.
    - Calculate running total of sales (cumulative) and moving average price.

Queries Included:
    1. Monthly sales trend using DATETRUNC()
    2. Daily sales totals using order_date
    3. Monthly cumulative sales and moving average price using window functions

Functions Used:
    - DATETRUNC()
    - Window Functions:SUM() OVER (), AVG() OVER ()

Table Used:
    - gold.fact_sales
===============================================================================
*/
--the total sales per month 
--the running total of sales over time
SELECT SUM(sales_amount) AS total_sales ,DATETRUNC(month, order_date)
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)


SELECT SUM(sales_amount) AS total_sales , order_date
FROM gold.fact_sales
GROUP BY  order_date


SELECT order_date ,total_Sales ,
		SUM(total_Sales) OVER ( ORDER BY order_date) as running_total_Sales,
		AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM(
	SELECT DATETRUNC(MONTH ,order_date) AS order_date,
		   SUM(sales_amount) AS total_Sales,
		   AVG(price) as avg_price
	FROM gold.fact_sales
	where order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date))T
