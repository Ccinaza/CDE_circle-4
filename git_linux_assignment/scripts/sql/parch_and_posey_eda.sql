-- 1. From the accounts table, which sales rep has the most customers under them
select s.name as sales_rep_name, count(*) as total_customers
from accounts a
join sales_reps s 
on s.id = a.sales_rep_id
group by 1
order by total_customers desc;

-- 2. Best performing product
SELECT 
    product,
    SUM(total_units) AS total_units_sold,
    SUM(total_sales) AS total_revenue
FROM (
    SELECT 'standard' AS product, 
           SUM(standard_qty) AS total_units,
           SUM(standard_qty * standard_amt_usd / NULLIF(standard_qty,0)) AS total_sales
    FROM orders
    UNION ALL
    SELECT 'gloss' AS product, 
           SUM(gloss_qty) AS total_units,
           SUM(gloss_qty * gloss_amt_usd / NULLIF(gloss_qty,0)) AS total_sales
    FROM orders
    UNION ALL
    SELECT 'poster' AS product, 
           SUM(poster_qty) AS total_units,
           SUM(poster_qty * poster_amt_usd / NULLIF(poster_qty,0)) AS total_sales
    FROM orders
) AS products
GROUP BY product
ORDER BY total_units_sold DESC, total_revenue DESC
LIMIT 1;

-- 3. Show the yearly performance of each region in terms of both order volume and total order value
SELECT r.name AS region,
       DATE_PART('year', o.occurred_at) AS order_year,
       COUNT(o.id) AS total_orders,
       SUM(o.total_amt_usd) AS total_order_value
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY r.name, order_year
ORDER BY order_year, total_orders DESC, total_order_value DESC;

-- 4. top 10 accounts by total order amount in USD
SELECT a.name, sum(o.total) total_qty, sum(o.total_amt_usd) total_amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- 5. What are the top 3 channels that generated the highest revenue, and how much? 
select 
    w.channel, 
    sum(cast(o.total_amt_usd as numeric)) as revenue
from web_events as w
left join orders as o
    on w.account_id = o.account_id
group by w.channel
order by revenue desc
limit 3;

-- 6. Find the total orders alongside the total revenue generated
select 
    count(*) as total_orders,
    sum(cast(total_amt_usd as numeric)) as total_revenue
from orders;


-- 7.Monthly revenue trend
SELECT DATE_TRUNC('month', occurred_at) AS month, 
       SUM(total_amt_usd) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

--8. Rep Activity vs Web Events
SELECT s.name AS sales_rep,
       COUNT(DISTINCT o.id) AS num_orders,
       COUNT(DISTINCT w.id) AS num_web_events
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
LEFT JOIN orders o ON a.id = o.account_id
LEFT JOIN web_events w ON a.id = w.account_id
GROUP BY s.name
ORDER BY num_orders DESC;
