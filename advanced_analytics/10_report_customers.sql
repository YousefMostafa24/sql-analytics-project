/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- Create Report: gold.report_customers

IF OBJECT_ID('gold.report_customers' , 'V') IS NOT NULL
	DROP VIEW gold.report_customers;
GO

 --Base Query: Retrieves core columns from tables
CREATE VIEW gold.report_customers AS
WITH base_query AS (
SELECT	S.order_number,
		S.product_key,
		S.order_date,
		S.sales_amount,
		S.quanity,
		C.customer_key,
		C.customer_number,
		CONCAT(C.first_name,' ' ,C.last_name) as Full_Name,
		DATEDIFF(YEAR ,C.birthdate ,GETDATE()) as Age
FROM gold.fact_sales S LEFT JOIN gold.dim_customers C
ON S.customer_key = C.customer_key
WHERE order_date IS NOT NULL
)
--Customer Aggregations: Summarizes key metrics at the customer level
, customer_aggregation as (
SELECT 	customer_key,
		customer_number,
		 Full_Name,
		 Age,
		 COUNT(DISTINCT order_number) as total_orders,
		 SUM(sales_amount) as total_sales,
		 SUM(quanity) as toatal_quantity,
		 COUNT(DISTINCT product_key) as total_products,
		 MAX(order_date) as last_order_date,
		 DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key, customer_number, Full_Name, Age
)

SELECT customer_key, customer_number, Full_Name, Age,
	   CASE 
			WHEN Age < 20 THEN 'Under 20'
			WHEN Age BETWEEN 20 AND 29 THEN '20-29'
			WHEN Age BETWEEN 30 AND 39 THEN '30-39'
			WHEN Age BETWEEN 40 AND 49 THEN '40-49'
	   ELSE '50 AND ABOVE'
	   END AS AGE_GROUP,
	   CASE 
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
	    END AS customer_segment,
		DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	   total_orders,
	   total_sales,
	   toatal_quantity,
	   total_products,
	   last_order_date,
	   lifespan,
	CASE WHEN total_sales = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_value,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM customer_aggregation
