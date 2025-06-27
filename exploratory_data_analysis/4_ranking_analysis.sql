/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


--The 5 Products generate the highiest revenue 
SELECT 
*
FROM (SELECT product_name ,SUM(sales_amount)as total_revenue ,ROW_NUMBER() OVER ( ORDER BY SUM(sales_amount) DESC) as RN
		FROM gold.fact_sales S JOIN gold.dim_products P
		ON S.product_key = P.product_key
		group by product_name)T
WHERE RN<=5

--with top

SELECT top(5) product_name ,SUM(sales_amount) as total_revenue
FROM gold.fact_sales S JOIN gold.dim_products P
ON S.product_key = P.product_key
GROUP BY product_name
ORDER BY total_revenue DESC



--The 5 worst-performing products in terms of sales
SELECT top(5) product_name ,SUM(sales_amount) as total_revenue
FROM gold.fact_sales S JOIN gold.dim_products P
ON S.product_key = P.product_key
GROUP BY product_name
ORDER BY total_revenue 



--The top 10 customers who have generated the highest revernue
SELECT 
*
FROM (SELECT first_name, last_name, SUM(sales_amount)as total_revenue ,ROW_NUMBER() OVER ( ORDER BY SUM(sales_amount) DESC) as RN
		FROM gold.fact_sales S left JOIN gold.dim_customers C
		ON S.customer_key = C.customer_key
		group by first_name,last_name )T
WHERE RN<=10


--The 5 customers with fewest orders placed
SELECT top(5) first_name, last_name ,COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales S left JOIN gold.dim_customers C
ON S.customer_key = C.customer_key
GROUP BY  first_name, last_name 
ORDER BY total_orders 
