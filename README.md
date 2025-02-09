# Case Study #3 - Foodie-Fi_SQL
- Case study solutions for Foodie-Fi #8weeksqlchallenge

## Problem Statement
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## Available Data

Danny has shared the data design for Foodie-Fi and also short descriptions on each of the database tables - our case study focuses on only 2 tables but there will be a challenge to create a new table for the Foodie-Fi team.

Table 1: plans

Customers can choose which plans to join Foodie-Fi when they first sign up.

Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

<table>
    <tr>
        <th>plan_id</th><th>plan_name</th><th>price</th>
    </tr>
    <tr>
    <td>0</td><td>trial</td><td>0</td></tr>
<tr><td>1 </td><td>	basic monthly</td><td> 	9.90</td></tr>
<tr><td>2</td><td> 	pro monthly </td><td>	19.90</td></tr>
<tr><td>3 </td><td>	pro annual </td><td>	199</td></tr>
<tr><td>4</td><td> 	churn</td><td> 	null</td></tr>
</table>
 
 Table 2: subscriptions

Customer subscriptions show the exact date where their specific plan_id starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.
<table>
<tr><th>customer_id </th><th>	plan_id </th><th>	start_date</th>
<tr><td>
<tr><td>1 </td><td>	0 </td><td>	2020-08-01</td></tr>
<tr><td>1 </td><td>	1 </td><td>	2020-08-08</td></tr>
<tr><td>2 </td><td>	0 </td><td>	2020-09-20</td></tr>
<tr><td>2 </td><td>	3 </td><td>	2020-09-27</td></tr>
<tr><td>11 </td><td>	0 </td><td>	2020-11-19</td></tr>
<tr><td>11 </td><td>	4 </td><td>	2020-11-26</td></tr>
<tr><td>13 </td><td>	0 </td><td> 2020-12-15</td></tr>
<tr><td>13 </td><td>	1 </td><td>	2020-12-22</td></tr>
<tr><td>13 </td><td>	2 </td><td>	2021-03-29</td></tr>
<tr><td>15 </td><td>	0 </td><td>	2020-03-17</td></tr>
<tr><td>15 </td><td>	2 </td><td>	2020-03-24</td></tr>
<tr><td>15 	</td><td>4 </td><td>	2020-04-29</td></tr>
</table>

## Entity Relationship Diagram

<img src="https://github.com/msunith/3.Foodie-Fi_SQL/blob/main/Foodie_fy/ERD.png" width ="500" height="50%"/>

## A. Customer Journey for customer_id 1, 2, 11, 13, 15, 16, 18, 19

```sql

SELECT 
	s.customer_id, p.plan_name, 
    monthname(s.start_date) AS month, s.start_date
FROM foodie_fi.subscriptions s
INNER JOIN plans p 
ON s.plan_id = p.plan_id
WHERE customer_id in (1, 2, 11, 13, 15, 16, 18, 19)
ORDER BY customer_id;
```
<table>
<tr><th>
customer_id</th><th> plan_name</th><th> month</th><th> start_date</th></tr>
<tr><td>1</td><td>trial	</td><td>August</td><td>2020-08-01</td><tr>
<tr><td>1</td><td>	basic monthly</td><td>	August</td><td>	2020-08-08</td><tr>
<tr><td>2</td><td>	trial</td><td>	September</td><td>	2020-09-20</td><tr>
<tr><td>2</td><td>	pro annual</td><td>	September</td><td>	2020-09-27</td><tr>
<tr><td>11</td><td>	trial</td><td>	November</td><td>	2020-11-19</td><tr>
<tr><td>11</td><td>	churn</td><td>	November</td><td>	2020-11-26</td><tr>
<tr><td>13	</td><td>trial</td><td>	December</td><td>	2020-12-15</td><tr>
<tr><td>13</td><td>	basic monthly</td><td>	December</td><td>	2020-12-22</td><tr>
<tr><td>13</td><td>	pro monthly</td><td>	March</td><td>	2021-03-29</td><tr>
<tr><td>15</td><td>	trial</td><td>	March</td><td>	2020-03-17</td><tr>
<tr><td>15</td><td>	pro monthly</td><td>	March</td><td>	2020-03-24</td><tr>
<tr><td>15</td><td>	churn</td><td>	April</td><td>	2020-04-29</td><tr>
<tr><td>16</td><td>	trial</td><td>	May</td><td>	2020-05-31</td><tr>
<tr><td>16</td><td>	basic monthly</td><td>	June</td><td>	2020-06-07</td><tr>
<tr><td>16</td><td>	pro annual</td><td>	October</td><td>	2020-10-21</td><tr>
<tr><td>18</td><td>	trial</td><td>	July</td><td>	2020-07-06</td><tr>
<tr><td>18</td><td>	pro monthly</td><td>July</td><td>2020-07-13</td><tr>
<tr><td>19</td><td>	trial</td><td>	June</td><td>	2020-06-22</td><tr>
<tr><td>19</td><td>	pro monthly</td><td>	June</td><td>	2020-06-29</td><tr>
<tr><td>19</td><td>	pro annual</td><td>	August	</td><td>2020-08-29</td><tr>
</table>

## B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?
``` sql
SELECT count(distinct customer_id) AS Total_Customers
 FROM foodie_fi.subscriptions;
 ```
 <table><tr><th>Total_Customers</th></tr>
 <tr><td>1000</td></tr>
 </table>

 ### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

 ```sql
 SELECT 
    MONTHNAME(start_date) AS month_name, 
    COUNT(*) AS Trial_Customers
FROM 
    foodie_fi.subscriptions 
WHERE 
    plan_id = (SELECT plan_id FROM foodie_fi.plans WHERE plan_name = 'trial')
GROUP BY 
    MONTH(start_date), MONTHNAME(start_date)
ORDER BY 
    MONTH(start_date);
```

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
```sql
SELECT plan_name,
		count(*) AS customer_count
FROM foodie_fi.subscriptions s
INNER JOIN plans p ON s.plan_id = p.plan_id
WHERE start_date > '2020-12-31'
GROUP BY s.plan_id
ORDER BY p.plan_id;
```

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
```
WITH cte AS 
	(SELECT count(DISTINCT customer_id) as Total_Customers,
		SUM(
		CASE 
			WHEN plan_id = 4 THEN 1
            ELSE 0
		END) AS churn_customers
	FROM subscriptions 
    )
SELECT Total_Customers,Churn_Customers,
		CONCAT(ROUND(churn_customers/total_customers*100,1),' %') AS '%_Churn_Customers'
FROM cte;
```
<TABLE>
<tr><th>Total_Customers</th><th>Churn_Customers</th><th>%_Churn_Customers</th></tr>
<tr><td>1000</td><td>307</td><td>30.7 %</td></tr>
</table>

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
```sql
with rank_cte as
	(SELECT *, RANK() OVER(PARTITION BY customer_id ORDER BY start_date) as rank_val
  FROM subscriptions)
select round(count(
		case when plan_id =4 and rank_val= 2 then 1 end)/
			(select count(distinct customer_id) as total_customers from subscriptions)*100,1) as percent
from rank_cte;
```
<table><tr><th>Percent</th></tr>
 <tr><td>9.2</td></tr>
 </table>

 ### 6. What is the number and percentage of customer plans after their initial free trial?
 ```sql
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
```
basic monthly	54.60
pro monthly	32.50
pro annual	3.70
churn	9.20

<TABLE>
<tr><th>Plan_Monthly</th><th>%value</th></tr>
<tr><td>basic monthly<td>54.60</td></tr>
<tr><td>pro monthly</td><td>32.50</td></tr>
<tr><td>pro annual</td><td>3.70</td></tr>
<tr><td>churn</td><td>9.20</td></tr>
</table>

### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
``` sql
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
select Plan_Name,
		count(customer_id) as Customer_count
from customer_cte
inner join plans using (plan_id)
group by plan_id
order by plan_id;
```
<TABLE>
<tr><th>Plan_Name</th><th>Customer_count</th></tr>
<tr><td>trial<td>19</td></tr>
<tr><td>basic monthly</td><td>224</td></tr>
<tr><td>pro monthly</td><td>327</td></tr>
<tr><td>pro annual</td><td>195</td></tr>
<tr><td>churn</td><td>235</td></tr>
</table>

### 8. How many customers have upgraded to an annual plan in 2020?
```sql
select count(customer_id) as annual_customers_2020
from subscriptions 
where plan_id = 
		(select plan_id from plans where plan_name = 'pro annual')
and year(start_date) = 2020;
```
<TABLE>
<tr><th>annual_customers_2020</th></tr>
<tr><td>195</td></tr>
</table>

### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
SELECT
	concat(
		round(avg(datediff(p.start_date,s.start_date)))
        , ' days') as avg_days
FROM foodie_fi.subscriptions s 
inner join foodie_fi.subscriptions p
on s.customer_id = p.customer_id 
and s.plan_id = 0 and p.plan_id =3;
```
<TABLE>
<tr><th>avg_days</th></tr>
<tr><td>105 days</td></tr>
</table>

### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
```sql
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
```
### 11. How many customers downgraded from a pro monthly 
-- to a basic monthly plan in 2020?
SELECT 
	count(s.customer_id) as downgraded_customers
FROM foodie_fi.subscriptions s
inner join foodie_fi.subscriptions p
on s.customer_id = p.customer_id
where s.start_date <= '2020-12-31' and 
s.plan_id = 2 and p.plan_id = 1
and s.start_date < p.start_date;

<TABLE>
<tr><th>downgraded_customers</th></tr>
<tr><td>0</td></tr>
</table>


## C. Challenge Payment Question

## The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer  in the subscriptions table with the following requirements:

- 1. monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- 2. upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- 3. upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- 4. once a customer churns they will no longer make payments

```sql
create Table Payment as 
WITH RECURSIVE subscriptions_filtered AS (
    -- Filter relevant subscriptions and determine plan changes
    SELECT 
        customer_id,
        plan_id,
        start_date,
        LEAD(start_date, 1) OVER (PARTITION BY customer_id ORDER BY start_date, plan_id) AS change_date
    FROM subscriptions
    WHERE start_date BETWEEN '2020-01-01' AND '2020-12-31' 
    AND plan_id != 0
),
billing_data AS (
    -- Assign billing end date and amount
    SELECT 
        sf.customer_id, 
        sf.plan_id, 
        p.plan_name, 
        sf.start_date AS billing_date,
        COALESCE(sf.change_date, '2020-12-31') AS end_date,  -- Billing stops at change_date or end of year
        p.price AS amount
    FROM subscriptions_filtered sf
    JOIN plans p ON sf.plan_id = p.plan_id
    WHERE p.plan_name != 'churn'
),
monthly_billing AS (
    -- Base Case: First Billing Record
    SELECT 
        customer_id, 
        plan_id, 
        plan_name, 
        billing_date, 
        end_date, 
        amount, 
        1 AS months_paid
    FROM billing_data

    UNION ALL

    -- Recursive Case: Generate monthly billing records
    SELECT 
        rb.customer_id, 
        rb.plan_id, 
        rb.plan_name, 
        DATE_ADD(rb.billing_date, INTERVAL 1 MONTH) AS billing_date,
        rb.end_date,
        rb.amount,
        rb.months_paid + 1
    FROM monthly_billing rb
    WHERE 
        (rb.billing_date < rb.end_date -- Ensure termination
        and date_add(rb.billing_date,interval 30 day) < rb.end_date)
        AND rb.plan_name <> 'pro annual'
),
upgrade_adjustments AS (
    -- Identify customers who upgraded to the annual plan
    SELECT 
        mb.customer_id,
        SUM(CASE WHEN mb.plan_id != 3 THEN mb.amount ELSE 0 END) AS total_paid, 
        MIN(CASE WHEN mb.plan_id = 3 THEN mb.billing_date END) AS upgrade_date
    FROM monthly_billing mb
    GROUP BY mb.customer_id
),
final_billing AS (
    -- Adjust the payment for customers who upgraded to the annual plan
    SELECT 
        mb.customer_id, 
        mb.plan_id, 
        mb.plan_name, 
        mb.billing_date, 
        mb.end_date, 
        CASE 
            -- If it's an annual upgrade, adjust the amount
            WHEN mb.plan_id = 3 AND ua.upgrade_date = mb.billing_date THEN 
                199 - ua.total_paid
            ELSE mb.amount 
        END AS amount
    FROM monthly_billing mb
    LEFT JOIN upgrade_adjustments ua 
    ON mb.customer_id = ua.customer_id
)
SELECT * FROM final_billing
ORDER BY customer_id, billing_date;
```


