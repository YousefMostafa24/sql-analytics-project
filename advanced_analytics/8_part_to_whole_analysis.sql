/*
===============================================================================
📊 Part-to-Whole Analysis: Category Contribution to Total Sales
===============================================================================
Purpose:
    - Identify how much each product category contributes to the overall sales.
    - Useful for understanding which categories drive most of the revenue.
Metrics:
    - Total sales per category
    - Overall total sales
    - Percentage contribution of each category
Tables Used:
    - gold.fact_sales
    - gold.dim_products
Functions Used:
    - SUM(), ROUND(), CAST(), CONCAT()
    - Window function: SUM(...) OVER ()
===============================================================================
*/

SELECT 
    p.category,
    SUM(f.sales_amount) AS total_sales,
    SUM(SUM(f.sales_amount)) OVER () AS overall_sales,
    CONCAT(ROUND(
            (CAST(SUM(f.sales_amount) AS FLOAT) / SUM(SUM(f.sales_amount)) OVER ()) * 100, 2 ), '%') AS percentage_of_total
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_sales DESC;
