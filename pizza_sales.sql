create database pizza;

use pizza;

select *from order_details;
select *from orders;
select *from pizza_types;
select *from pizzas;


# Q1 - Retrieve total no. of order placed.

select count(order_id) as total_order from orders;

# Q2 - calculate total revenue generated from pizzas sales.

select
round(sum(a.quantity*b.price),2) as total_revenue
from 
order_details as a
join 
pizzas as b
on 
a.pizza_id=b.pizza_id; 

# Q3- identify highest price of pizza.

select max(price) as highest_price$ from pizzas;

# Q4 - Identify most common pizza size.
select size,count(size) as pizzas_size from pizzas group by size order by pizzas_size desc limit 1;


# Q5 - list top 5 most pizzas type ordered with their quantity;
select 
count(a.quantity) as order_quantity,
b.pizza_type_id
from 
order_details as a
join 
pizzas as b 
on 
a.pizza_id = b.pizza_id group by pizza_type_id order by order_quantity desc limit 5;

# Q6 - find total quantity of each pizzas ordered.
select
count(a.quantity) as total_quantity,
c.name
from 
order_details as a
join
pizzas as b 
on a.pizza_id=b.pizza_id 
join 
pizza_types as c
on 
b.pizza_type_id=c.pizza_type_id
group by name order by total_quantity desc;

# Q6 - determine distributin of ordered by hour of the day

# let consider for a particular date#

select 
count(a.quantity) as pizza_order,
hour(b.time) as hours
from
order_details as a 
join 
orders as b
on 
a.order_id=b.order_id
 where date = '2015-01-01' group by hours


# Q7- find category wise pizzas sales dsitribution.

select
round(sum(a.quantity*b.price),2) as total_sales,
c.category
from 
order_details as a
join
pizzas as b 
on 
a.pizza_id=b.pizza_id
join 
pizza_types as c 
on 
b.pizza_type_id=c.pizza_type_id 
group by category order by total_sales desc;

# Q8 - calculate avg no. of pizzas order by per days.

with average as (select
sum(a.quantity) as pizza_orders,
b.date
from 
order_details as a
join 
orders as b
on 
a.order_id=b.order_id
group by date)
select avg(pizza_orders) as avg_order_perday from average;

# Q9 - determine top3most ordered pizzas based on revenue.

select 
round(sum(a.quantity*b.price),2) as total_revenue,
b.pizza_id
from 
order_details as a 
join 
pizzas as b 
on 
a.pizza_id=b.pizza_id 
group by pizza_id order by total_revenue desc limit 3;


# Q10 - % contribution of each pizza type in revenue
with sales as (
select 
round(sum(a.quantity*b.price),2) as total_revenue,
b.pizza_id
from 
order_details as a 
join 
pizzas as b 
on 
a.pizza_id=b.pizza_id 
group by pizza_id order by total_revenue desc)
select total_revenue/(select 
round(sum(a.quantity*b.price),2) as total_revenue
from 
order_details as a 
join 
pizzas as b 
on 
a.pizza_id=b.pizza_id )*100
as per_of_share, pizza_id from sales group by pizza_id;

# Q10 - cummulative revenue generate over a time.
select date,
 sum(total_revenue) over (order by date) as cum_rev
 from
 (
select
round(sum(a.quantity*b.price),2) as total_revenue,
c.date
from 
order_details as a
join 
pizzas as b 
on 
a.pizza_id = b.pizza_id 
join 
orders as c
on 
a.order_id=c.order_id
group by date) as sales ORDER BY 
    date;



# Q12- determine top 3 most ordered pizzas based on revenue for each pizzas category;

select total_revenue, pizza_type_id,category,
 rank() over (partition by category order by total_revenue ) as rn from
(
select 
round(sum(a.quantity*b.price),2) as total_revenue,
b.pizza_type_id,
c.category
from 
order_details as a 
join 
pizzas as b 
on 
a.pizza_id=b.pizza_id 
join
pizza_types as c
on 
b.pizza_type_id =c.pizza_type_id
group by pizza_type_id,category
 order by total_revenue) as rev
  ORDER BY category,
    rn;



