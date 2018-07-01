-- SELECT THE FIRST 100 rows from the table
SELECT *
 FROM subscriptions
 LIMIT 100;
 -- THERE appears to only be two segments (87 or 30)
 
 -- SELECT THE NUMBER OF DISTICT SEGMENTS, count the number of users in each segment
 SELECT DISTINCT segment, COUNT(*) as 'Number of customers'
 FROM subscriptions
 GROUP BY segment;
 
 
 -- THIS SHOWS THE RANGES AVAILABLE
 SELECT MIN(subscription_start),MAX(subscription_start)
 FROM subscriptions;


-- Now we compute the overall churn rate of the company
 -- CREATE A temporary table for MONTHS
WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
status AS
(SELECT id, first_day as month,
 
  -- The is total active segment
 CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    )
 THEN 1
  ELSE 0
END as is_active,
 
  -- The is cancelled segment
CASE
WHEN (subscription_end BETWEEN first_day AND last_day)
THEN 1
ELSE 0
END as is_canceled

FROM cross_join),
-- Now we generate the Aggregate numbers for both segments
status_aggregate AS
(SELECT
  month,
 SUM(is_active) as sum_active,
 SUM(is_canceled) as sum_canceled
FROM status
GROUP BY month)

-- Compute the Churn Rates
SELECT month, 
1.0*sum_canceled/sum_active as 'overall churn_rate'
FROM status_aggregate;





 -- CREATE A temporary table for MONTHS
WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
-- Now we cross Join the Months table with the subscriptions table
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
-- Now we Create the temporary status table for the two customer Segments
status AS
(SELECT id, first_day as month,
 
  -- The is total active segment
 CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    )
 THEN 1
  ELSE 0
END as is_active,
 
  -- The is cancelled segment
CASE
WHEN (subscription_end BETWEEN first_day AND last_day)
THEN 1
ELSE 0
END as is_canceled,
 
 -- The is active 87 segment
 CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    )
 AND segment = 87
 THEN 1
  ELSE 0
END as is_active_87,

 -- The is cancelled 87 segment
CASE
WHEN (subscription_end BETWEEN first_day AND last_day) AND ( segment= 87) 
THEN 1
ELSE 0
END as is_canceled_87,
 
-- The is active 30 segment
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) 
   AND segment = 30
 THEN 1
  ELSE 0
END as is_active_30,
 
 -- The is cancelled 30 segment
CASE
WHEN (subscription_end BETWEEN first_day AND last_day) AND ( segment= 30) 
THEN 1
ELSE 0
END as is_canceled_30

FROM cross_join),

-- Now we generate the Aggregate numbers for both segments
status_aggregate AS
(SELECT
  month,
 SUM(is_active) as sum_active,
  SUM(is_active_30) as sum_active_30,
  SUM(is_active_87) as sum_active_87, 
 SUM(is_canceled) as sum_canceled,
  SUM(is_canceled_30) as sum_canceled_30,
  SUM(is_canceled_87) as sum_canceled_87
FROM status
GROUP BY month)

-- Compute the Churn Rates
SELECT month, 
1.0*sum_canceled/sum_active as total_churn_rate,
1.0*sum_canceled_30/sum_active_30 as churn_rate_30,
1.0*sum_canceled_87/sum_active_87 as churn_rate_87
FROM status_aggregate;




