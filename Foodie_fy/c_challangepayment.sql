-- C. Challenge Payment Question

-- The Foodie-Fi team wants you to create a new payments table for 
-- the year 2020 that includes amounts paid by each customer 
-- in the subscriptions table with the following requirements:

-- 1. monthly payments always occur on the same day of month 
-- as the original start_date of any monthly paid plan
-- 2. upgrades from basic to monthly or pro plans are reduced
-- by the current paid amount in that month and start immediately
-- 3. upgrades from pro monthly to pro annual are paid at the 
-- end of the current billing period and also starts
-- at the end of the month period
-- 4. once a customer churns they will no longer make payments

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

