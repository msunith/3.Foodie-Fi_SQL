-- A. Customer Journey for customer_id 1, 2, 11, 13, 15, 16, 18, 19

SELECT 
	s.customer_id, p.plan_name, 
    monthname(s.start_date) AS month, s.start_date
FROM foodie_fi.subscriptions s
INNER JOIN plans p 
ON s.plan_id = p.plan_id
WHERE customer_id in (1, 2, 11, 13, 15, 16, 18, 19)
ORDER BY customer_id;

-- B. Data Analysis Questions

-- 1. How many customers has Foodie-Fi ever had?
SELECT count(distinct customer_id) AS total_customers
 FROM foodie_fi.subscriptions;

-- 2. What is the monthly distribution of trial plan start_date values 
-- for our dataset - use the start of the month as the group by value

select monthname(start_date) as month_name, 
		count(*) as trial_customers
 from foodie_fi.subscriptions 
 where plan_id = (select plan_id from plans where plan_name = 'trial')
 group by month(start_date)
 order by month(start_date);

SELECT DISTINCT 
    YEAR(start_date) AS year, 
    MONTHNAME(start_date) AS month,
    COUNT(customer_id) AS new_trial_customer
FROM 
    subscriptions
WHERE 
    plan_id = (
        SELECT 
            plan_id 
        FROM 
            plans 
        WHERE 
            plan_name = 'trial'
    )
GROUP BY 
    YEAR(start_date), MONTH(start_date)
ORDER BY 
    YEAR(start_date), MONTH(start_date);

-- 3. What plan start_date values occur after the year 2020 for our dataset?
-- Show the breakdown by count of events for each plan_name
SELECT plan_name,
		count(*) AS customer_count
FROM foodie_fi.subscriptions s
INNER JOIN plans p ON s.plan_id = p.plan_id
WHERE start_date > '2020-12-31'
GROUP BY s.plan_id
ORDER BY p.plan_id;

-- no new customers in 2021

-- 4. What is the customer count and percentage of customers 
-- who have churned rounded to 1 decimal place?
WITH cte AS 
	(SELECT count(DISTINCT customer_id) as total_Customers,
		SUM(
		CASE 
			WHEN plan_id = 4 THEN 1
            ELSE 0
		END) AS churn_customers
	FROM subscriptions 
    )
SELECT total_customers,churn_customers,
		CONCAT(ROUND(churn_customers/total_customers*100,1),' %') AS '%_churn_customers'
FROM cte;


-- 5. How many customers have churned straight after their initial 
-- free trial - what percentage is this rounded to the nearest whole number?
with rank_cte as
	(SELECT *, RANK() OVER(PARTITION BY customer_id ORDER BY start_date) as rank_val
  FROM subscriptions)
select round(count(
		case when plan_id =4 and rank_val= 2 then 1 end)/
			(select count(distinct customer_id) as total_customers from subscriptions)*100,1) as percent
from rank_cte;
   
-- 6. What is the number and percentage of customer plans after their 
-- initial free trial?
WITH rank_cte AS (
    SELECT 
        customer_id, 
        plan_id,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank_val
    FROM 
        subscriptions
),
plan_value_cte AS (
    SELECT 
        plan_id,
        COUNT(customer_id) AS total_customers
    FROM 
        rank_cte
    WHERE 
        rank_val = 2
    GROUP BY 
        plan_id
),
total_customers_cte AS (
    SELECT 
        COUNT(DISTINCT customer_id) AS total_customers
    FROM 
        subscriptions
)
SELECT 
    p.plan_name,
    ROUND(v.total_customers / t.total_customers * 100, 2) AS '%value'
FROM 
    plan_value_cte v
JOIN 
    plans p 
ON 
    v.plan_id = p.plan_id
CROSS JOIN 
    total_customers_cte t;




-- 7. What is the customer count and percentage breakdown of all 5 plan_name
-- values at 2020-12-31?

WITH rank_cte AS (
    SELECT 
        customer_id, 
        plan_id,
        start_date,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank_val
    FROM 
        subscriptions
),
customer_cte as
(select plan_id,
		customer_id,
        start_date,
        rank_val as rank_n
from rank_cte
where start_date < '2020-12-31' and 
rank_val = (select max(rank_val) from rank_cte as rn 
		where rn.customer_id = rank_cte.customer_id
        and rn.start_date < '2020-12-31'))
select plan_name,
		count(customer_id) as customer_count
from customer_cte
inner join plans using (plan_id)
group by plan_id
order by plan_id;

-- 8. How many customers have upgraded to an annual plan in 2020?
select count(customer_id) as annual_customers_2020
from subscriptions 
where plan_id = 
		(select plan_id from plans where plan_name = 'pro annual')
and year(start_date) = 2020;

-- 9. How many days on average does it take for a customer to an annual 
-- plan from the day they join Foodie-Fi?
SELECT
	concat(
		round(avg(datediff(p.start_date,s.start_date)))
        , ' days') as avg_days
FROM foodie_fi.subscriptions s 
inner join foodie_fi.subscriptions p
on s.customer_id = p.customer_id 
and s.plan_id = 0 and p.plan_id =3;

-- 10. Can you further breakdown this average value into 30 day periods 
-- (i.e. 0-30 days, 31-60 days etc)
SELECT 
    CASE 
        WHEN diff_days BETWEEN 0 AND 30 THEN '0-30 days'
        WHEN diff_days BETWEEN 31 AND 60 THEN '31-60 days'
        WHEN diff_days BETWEEN 61 AND 90 THEN '61-90 days'
        WHEN diff_days BETWEEN 91 AND 120 THEN '91-120 days'
        WHEN diff_days BETWEEN 121 AND 150 THEN '121-150 days'
        WHEN diff_days BETWEEN 151 AND 180 THEN '151-180 days'
		WHEN diff_days BETWEEN 181 AND 210 THEN '181-210 days'
		WHEN diff_days BETWEEN 211 AND 240 THEN '211-240 days'
        WHEN diff_days BETWEEN 241 AND 270 THEN '241-270 days'
		WHEN diff_days BETWEEN 271 AND 300 THEN '271-300 days'
        WHEN diff_days BETWEEN 301 AND 330 THEN '301-330 days'
		WHEN diff_days BETWEEN 331 AND 360 THEN '331-360 days'
        ELSE '>360 days'
    END AS bucket,
    COUNT(*) AS customer_count,
    ROUND(AVG(diff_days)) AS average_day
FROM (
    SELECT 
        s.customer_id,
        DATEDIFF(p.start_date, s.start_date) AS diff_days
    FROM foodie_fi.subscriptions s 
    INNER JOIN foodie_fi.subscriptions p
        ON s.customer_id = p.customer_id 
        AND s.plan_id = 0 
        AND p.plan_id = 3
) AS date_diffs
GROUP BY bucket
ORDER BY MIN(diff_days);

-- 11. How many customers downgraded from a pro monthly 
-- to a basic monthly plan in 2020?
SELECT 
	count(s.customer_id) as downgraded_customers
FROM foodie_fi.subscriptions s
inner join foodie_fi.subscriptions p
on s.customer_id = p.customer_id
where s.start_date <= '2020-12-31' and 
s.plan_id = 2 and p.plan_id = 1
and s.start_date < p.start_date;
