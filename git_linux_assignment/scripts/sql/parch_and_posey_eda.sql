-- From the accounts table, which sales rep has the most customers under them
select s.name as sales_rep_name, count(*) as total_customers
from accounts a
join sales_reps s 
on s.id = a.sales_rep_id
group by 1
order by total_customers desc;

