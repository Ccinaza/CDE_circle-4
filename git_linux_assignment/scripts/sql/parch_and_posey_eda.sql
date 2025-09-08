-- From the accounts table, which sales rep has the most customers under them
select s.name as sales_rep_name, count(*) as total_customers
from accounts a
join sales_reps s 
on s.id = a.sales_rep_id
group by 1
order by total_customers desc;

-- Show the yearly performance of each region in terms of both order volume and total order value

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

