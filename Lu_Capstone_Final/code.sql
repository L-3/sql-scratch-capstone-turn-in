-- Question 1 -----------------------------------
-- COUNT DISTINCT number of campaigns.
SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Campaigns'
FROM page_visits;

-- COUNT DISTINCT number of sources.
SELECT COUNT(DISTINCT utm_source) AS 'Number of Sources'
FROM page_visits;

-- List sources used per campaign to show how they are related.
SELECT DISTINCT utm_campaign AS 'Campaign',
	utm_source AS 'Source'
FROM page_visits;



-- Question 2 -----------------------------------
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;



-- Question 3 -----------------------------------
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS ' Campaign',
       COUNT(*) AS 'First Touch Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;



-- Question 4 -----------------------------------
WITH last_touch AS (
   SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Last Touch Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;



-- Question 5 -----------------------------------
SELECT COUNT(DISTINCT user_id) AS 'Customers with Purchases', page_name as 'Page Name'
FROM page_visits
WHERE page_name = '4 - purchase';

-- Extra query to determine the total number of customers who didn't make a purchase
SELECT COUNT(DISTINCT user_id) AS 'Customers with Purchases', page_name AS 'Page Name'
FROM page_visits
WHERE page_name IS NOT '4 - purchase';



-- Question 6 -----------------------------------
WITH last_touch AS (
   SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Last Touch Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;