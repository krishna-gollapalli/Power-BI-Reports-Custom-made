
select * from pizza_sales

-- total revenue of all the pizza orders
select sum(total_price) as total_revenue
from pizza_sales

--Average amount spent per order.

select avg(total_price) over (partition by order_id ) as avg_ord_val
from pizza_sales
group by order_id

-- or 
select sum(total_price)/count(distinct order_id) as avg_ord_val
from pizza_sales


-- sum of quantities of all pizzas sold. 

select sum(quantity) as total_quantity
from pizza_sales


--total number of orders placed. 

select count(distinct order_id ) as total_orders_placed
from pizza_sales

--average number of pizzas sold per order

select CAST(CAST(sum(quantity) as decimal(10,2)) /CAST(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as avg_order_quantity
from pizza_sales


-- Data vizz -Queries
select * from pizza_sales

-- showcase trend of total orders on a daily basis. 
select order_date,count(distinct order_id) as total_orders, sum(quantity) as total_ordered_quantity 
from pizza_sales
group by order_date
order by 1 

select datename(dw, order_date) as day_of_week,count(distinct order_id) as total_orders, sum(quantity) as total_ordered_quantity 
from pizza_sales
group by datename(dw, order_date)

select datename(MONTH, order_date) as day_of_week,count(distinct order_id) as total_orders, sum(quantity) as total_ordered_quantity 
from pizza_sales
group by datename(MONTH, order_date)
order by 2 desc


---% of Sales by Pizza Category 
select distinct pizza_category, 
cast( sum(total_price) over (partition by pizza_category) as decimal(10,2)) as total_revenue,
cast((sum(total_price) over (partition by pizza_category)/(select sum(total_price) from pizza_sales))*100 as decimal(10,2)) as PCT
from pizza_sales
order by 3 desc


select pizza_category, 
sum(total_price) AS total_revenue, 
(sum(total_price)*100/(select sum(total_price) from pizza_sales)) as PCT
from pizza_sales
group by pizza_category


---% of Sales by Pizza Size 
select distinct pizza_size, 
cast( sum(total_price) over (partition by pizza_size) as decimal(10,2)) as total_revenue,
cast((sum(total_price) over (partition by pizza_size)/(select sum(total_price) from pizza_sales where DATEPART(QUARTER, order_date) = 1))*100 as decimal(10,2)) as PCT
from pizza_sales
where DATEPART(QUARTER, order_date) = 1
order by 3 desc


select pizza_size, 
sum(total_price) AS total_revenue, 
(sum(total_price)*100/(select sum(total_price) from pizza_sales where DATEPART(QUARTER, order_date) = 1)) as PCT
from pizza_sales
where DATEPART(QUARTER, order_date) = 1
group by pizza_size


--- Top 5 best sellers by revenue, total quantity and total orders

select top 5 pizza_name, sum(total_price) as total_revenue, count(distinct order_id) as total_orders
from pizza_sales
group by pizza_name
order by total_revenue desc, total_orders desc