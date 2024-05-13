-- query 1
-- this query shows the customers with their total sales and a rank
select o_custkey customer
, sum(o_totalprice) total_sales
, row_number() over (order by total_sales desc) rank_c
from snowflake_sample_data.tpch_sf1.orders o
join snowflake_sample_data.tpch_sf1.customer c
on o.o_custkey = c.c_custkey
group by all
order by rank_c;

-- query 2
-- using query 1 and a cte collecting the orders with a rank
with larg_cust as (
select o_custkey customer
, sum(o_totalprice) total_sales_c
, row_number() over (order by sum(o_totalprice) desc) rank_c
from snowflake_sample_data.tpch_sf1.orders o
join snowflake_sample_data.tpch_sf1.customer c
on o.o_custkey = c.c_custkey
group by all
)
, larg_orders as (
select o_custkey customer
, o_orderkey orderk
, o_totalprice total_sales_o
, row_number() over (partition by customer order by sum(total_sales_o) desc) rank_o
from snowflake_sample_data.tpch_sf1.orders o
join snowflake_sample_data.tpch_sf1.customer c
on o.o_custkey = c.c_custkey
group by all
)
select rank_c, larg_cust.customer, orderk, total_sales_c, total_sales_o from larg_cust
join larg_orders
on larg_cust.customer = larg_orders.customer
where rank_c <= 5
and rank_o <= 5
order by 1,5 desc
;

-- query 3
-- putting the results in a row with listagg
with larg_cust as (
select o_custkey customer
, sum(o_totalprice) total_sales_c
, row_number() over (order by sum(o_totalprice) desc) rank_c
from snowflake_sample_data.tpch_sf1.orders o
join snowflake_sample_data.tpch_sf1.customer c
on o.o_custkey = c.c_custkey
group by all
)
, larg_orders as (
select o_custkey customer
, o_orderkey orderk
, o_totalprice total_sales_o
, row_number() over (partition by customer order by sum(total_sales_o) desc) rank_o
from snowflake_sample_data.tpch_sf1.orders o
join snowflake_sample_data.tpch_sf1.customer c
on o.o_custkey = c.c_custkey
group by all
)
select rank_c, larg_cust.customer, round(total_sales_c,0) total_sales_c, listagg(round(total_sales_o,0),', ') largest_ordersizes from larg_cust
join larg_orders
on larg_cust.customer = larg_orders.customer
where rank_c <= 5
and rank_o <= 5
group by all
order by rank_c;
