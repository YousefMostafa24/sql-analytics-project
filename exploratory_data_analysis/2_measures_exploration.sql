/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


--The Total Sales
SELECT SUM(sales_amount) as total_sales
FROM gold.fact_sales


--How many items are sold
SELECT SUM(quanity) as total_quantity
FROM gold.fact_sales


--The average selling price
SELECT AVG(price) as avg_price
FROM gold.fact_sales

--The total number of orders
SELECT count(DISTINCT order_number) as total_orders
FROM gold.fact_sales

--The total number of products
SELECT count(product_key) as total_products
FROM gold.dim_products


--The total number of customers
SELECT count(customer_key) as total_customers
FROM gold.dim_customers


--The total number of customers that has placed an order
SELECT count(DISTINCT customer_key) as total_customers 
FROM gold.fact_sales


--A Reoprt that shows all key mertics of the business
SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quanity) 
FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) 
FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) 
FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) 
FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) 
FROM gold.dim_customers
