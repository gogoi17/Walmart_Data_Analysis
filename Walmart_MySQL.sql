use walmart_db;


-- Data Overview
select * from walmart;

-- count total records 
select count(*) from walmart;

-- Count payment methods and numbers of transaction by payment method 
select payment_method, count(*)
from walmart 
group by payment_method;

-- Count distinct branches 
select count(distinct Branch)
from walmart;

-- Find the max and min quantity sold
select 
	min(quantity) as min_quantity, 
    max(quantity) as max_quantity
from walmart;



-- Business Problems 

-- Q1 Find different payment methods, number of transactions,and quantity sold by payment method.
select 
	payment_method, 
	count(*) as num_payments,
    sum(quantity) as num_qty_sold
from walmart 
group by payment_method;


-- Q2 Calculate the average revenue per transaction by branch
select 
	Branch, 
	avg(total) as avg_revenue_per_transction
from walmart
group by Branch;


-- Q3 Identify the top 3 product categories that contribute the most to total revenue
select 
	category,
    sum(total) as total_revenue
from walmart
group by category
order by total_revenue desc
limit 3;


-- Q4 Calculate the total profit for each category
select 
	category,
    sum(total*profit_margin) as total_profit
from walmart 
group by category 
order by total_profit desc;


-- Q5 Determine the most common payment method for each branch
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

-- Q6 Analyse monthly sales trends across all branches
select 
	Branch,
    date_format(date,'%Y-%m') as month,
    sum(total) as monthly_sales
from walmart 
group by branch, date_format(date,'%Y-%m')
order by branch, month;


-- Q7 Indentify the month with the highest average transaction value
select 
	date_format(date,'%Y-%m') as month,
    avg(total) as avg_transaction_value
from walmart 
group by month
order by avg_transaction_value desc
limit 1;    


-- Q8 Compare weekday vs weekend sales 
 select 
	case 
		when dayname(date) in ('Saturday','Sunday') then 'Weekend'
        else 'Weeday'
	end as day_type,
    count(distinct invoice_id) as total_transactions,
    sum(total) as total_sales, 
    sum(quantity) as total_quantity_sold
from walmart
group by day_type;
    
 
-- Q9 Identify the buiest day of the week for each branch based on the number of transactions
select Branch, buiest_day, no_transactions
from(
	select 
		Branch,
		dayname(date) as buiest_day,
		count(*) as no_transactions,
		rank() over(partition by Branch order by count(*) desc) as rank_
	from walmart
	group by Branch, buiest_day
) as ranked 
where rank_ = 1;


-- Q10 How many transcations occur in each shift(Morning, Afternoon, Evening) across branches?

select 
	Branch,
    case
		when hour(time(time)) < 12 then 'Morning'
        when hour(time(time)) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift,
    COUNT(*) as num_invoices
from walmart
group by Branch,shift
order by Branch, num_invoices desc;

-- Q11 Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

with revenue_2022 as (
	select 	
		Branch,
		sum(total) as revenue
	from walmart 
	where year(date) = 2022
	group by Branch 
),
revenue_2023 as (
	select 
		Branch,
        sum(total) as revenue
	from walmart 
    where year(date) = 2023
    group by Branch
)
select 
	r2022.Branch,
    r2022.revenue as last_year_revenue,
    r2023.revenue as current_year_revenue,
    round(((r2022.revenue - r2023.revenue)/r2022.revenue)*100,2) as revenue_decrease_ratio
from revenue_2022 as r2022
join revenue_2023 as r2023 on r2022.Branch = r2023.Branch
where r2022.revenue > r2023.revenue
order by revenue_decrease_ratio desc 
limit 5;

-- Q12 Indentify the highest-rated category in each branch , display the branch category and avg-rating

with ranked_categories as (
    select 
        Branch,
        category,
        avg(rating) as avg_rating,
        rank() over (partition by Branch order by avg(rating) desc) as rn
    from walmart
    group by Branch, category
)
select Branch, category, avg_rating
from ranked_categories
where rn = 1;

-- Q13 What is the average rating for each product category?
select 
	category,
	avg(rating) as avg_rating
from walmart
group by category 
order by avg_rating desc;

-- Q14 Determine the avegrage,minimum,and maximum rating of categories for each city

select 
	City,
    category,
    avg(rating) as avg_rating,
    min(rating) as min_rating,
    max(rating) as max_rating
from walmart
group by City,category;

