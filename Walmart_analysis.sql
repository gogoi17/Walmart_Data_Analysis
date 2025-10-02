USE walmart_db;

-- Data Overview
SELECT * FROM walmart;

-- count total records 
SELECT COUNT(*) AS total_records FROM walmart;

-- Count distinct branches 
SELECT 
	COUNT(DISTINCT Branch)
FROM walmart;

-- Find the max and min quantity sold
SELECT 
	MIN(quantity) AS min_quantity, 
    MAX(quantity) AS max_quantity
FROM walmart;


-- Business Problems 
-- Q1 Find different payment methods, number of transactions, and quantity sold by payment method.
SELECT
	payment_method, 
	COUNT(*) AS num_payments,
    SUM(quantity) AS num_qty_sold
FROM walmart 
GROUP BY payment_method;

-- Q2 Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rank_ = 1;

-- Q3 Calculate the average revenue per transaction by branch
SELECT 
	Branch, 
	AVG(total) AS avg_revenue_per_transction
FROM walmart
GROUP BY Branch;

-- Q4 Identify the top 3 product categories that contribute the most to total revenue
SELECT 
	category,
    SUM(total) AS total_revenue
FROM walmart
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 3;

-- Q5 Analyse monthly sales trends across all branches
SELECT 
	Branch,
    DATE_FORMAT(DATE,'%Y-%m') AS month,
    SUM(total) AS monthly_sales
FROM walmart 
GROUP BY Branch, DATE_FORMAT(DATE,'%Y-%m')
ORDER BY Branch, month;

-- Q6 Identify the month with the highest average transaction value
SELECT 
	DATE_FORMAT(DATE,'%Y-%m') AS month,
    AVG(total) AS avg_transaction_value
FROM walmart 
GROUP BY month
ORDER BY avg_transaction_value DESC
LIMIT 1;    

-- Q7 Compare weekday vs weekend sales 
 SELECT 
	CASE 
		WHEN DAYNAME(DATE) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
	END AS day_type,
    COUNT(distinct invoice_id) AS total_transactions,
    SUM(total) AS total_sales, 
    SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY day_type;
    
-- Q8 Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS (
	SELECT 	
		Branch,
		SUM(total) AS revenue
	FROM walmart 
	WHERE YEAR(DATE) = 2022
	GROUP BY Branch 
),
revenue_2023 AS (
	SELECT 
		Branch,
        SUM(total) AS revenue
	FROM walmart 
    WHERE YEAR(DATE) = 2023
    GROUP BY Branch
)
SELECT 
	r2022.Branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue)/r2022.revenue)*100,2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.Branch = r2023.Branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC 
LIMIT 5;

 
-- Q9 Identify the busiest day of the week for each branch based on the number of transactions
SELECT Branch, busiest_day, no_transactions
FROM(
	SELECT 
		Branch,
		DAYNAME(DATE) AS buiest_day,
		COUNT(*) AS no_transactions,
		RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS rank_
	FROM walmart
	GROUP BY Branch, busiest_day
) AS ranked 
WHERE rank_ = 1;

-- Q10 How many transcations occur in each shift(Morning, Afternoon, Evening) across branches?
SELECT 
	Branch,
    CASE
		WHEN HOUR(TIME(TIME)) < 12 THEN 'Morning'
        WHEN HOUR(time(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY Branch,shift
ORDER BY Branch, num_invoices DESC;

-- Q11 Identify the highest-rated category in each branch, display the branch category and avg-rating
WITH ranked_categories AS (
    SELECT 
        Branch,
        category,
        AVG(rating) AS avg_rating,
        RANK()  OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) AS rn
    FROM walmart
    GROUP BY Branch, category
)
SELECT Branch, category, avg_rating
FROM ranked_categories
WHERE rn = 1;

-- Q12 Determine the average, minimum, and maximum rating of categories for each city
SELECT
	City,
    category,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM walmart
GROUP BY City, category;

-- Q13 What is the average rating for each product category?
SELECT 
	category,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY category 
ORDER BY avg_rating DESC;

-- Q14 Calculate the total profit for each category
SELECT 
	category,
    SUM(total*profit_margin) AS total_profit
FROM walmart 
GROUP BY category 
ORDER BY total_profit DESC;
