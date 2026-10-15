SELECT SUM(revenue) AS total_revenue,
	AVG(revenue) AS average_revenue

FROM monthly_sales;

WITH sales_stats AS( SELECT sale_month, revenue, MAX(revenue) OVER() AS highest_revenue, MIN(revenue) OVER() AS lowest_revenue
FROM monthly_sales)

SELECT sale_month,
	revenue,
    CASE
		WHEN revenue = highest_revenue THEN 'Highest Revenue'
        WHEN revenue = lowest_revenue THEN 'Lowest Revenue'
        END AS revenue_category
	
FROM sales_stats
WHERE revenue = highest_revenue
OR revenue = lowest_revenue
ORDER BY revenue DESC;

WITH sales_stats AS ( SELECT sale_month, revenue, LAG(revenue) OVER(ORDER BY sale_month) AS previous_month_revenue
FROM monthly_sales), sales_comparison AS( 
	SELECT sale_month, 
			revenue, 
        previous_month_revenue, 
        revenue - previous_month_revenue AS revenue_change,
        (revenue - previous_month_revenue)/NULLIF(previous_month_revenue, 0) * 100 AS percentage_change
        
FROM sales_stats)

SELECT sale_month, revenue, previous_month_revenue, revenue_change, percentage_change
FROM sales_comparison
WHERE revenue_change < 0
ORDER BY revenue_change;


WITH sales_stats AS (SELECT sale_month, revenue, AVG(revenue) OVER() AS average_revenue
	FROM monthly_sales), sales_difference AS( SELECT sale_month, revenue, average_revenue,
		average_revenue - revenue AS difference_below_average
        
FROM sales_stats)

SELECT sale_month, revenue, average_revenue, difference_below_average
FROM sales_difference
WHERE revenue < average_revenue
ORDER BY difference_below_average DESC;

SELECT sale_month, 
	revenue,
    RANK() OVER(ORDER BY revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER(ORDER BY revenue DESC) AS dense_revenue_rank

FROM monthly_sales;