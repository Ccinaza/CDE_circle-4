-- From the accounts table, which sales rep has the most customers under them
select s.name as sales_rep_name, count(*) as total_customers
from accounts a
join sales_reps s 
on s.id = a.sales_rep_id
group by 1
order by total_customers desc;

-- 6. Best performing product

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