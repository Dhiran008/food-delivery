
---- Total Deliveries Per Partner;
SELECT dp.name,
       COUNT(d.delivery_id) AS total_deliveries
FROM deliveries d
JOIN delivery_partners dp 
ON d.partner_id = dp.partner_id
WHERE d.delivery_status = 'Delivered'
GROUP BY dp.name
ORDER BY total_deliveries DESC;

-- show all user from chennai
select*from users 
where address='chennai';

-- restaurants with rating above 4.3
select name,rating 
from restaurants 
where rating >4.3;

-- menu items under ₹200
select item_name,price
from menu_items
where price <200;

-- delivered orders
select order_id,delivery_status  
from deliveries
where delivery_status='delivered';

-- count total users 
select COUNT(user_id) as total_users
FROM users;

--   Total revenue from delivered orders
select sum(total_amount) as total_revenue
from orders 
where order_status ='delivered';

-- number of order per restaurants
select r.name,count(o.order_id) as number_of_orders
from restaurants r
join orders o on r.restaurant_id=o.restaurant_id
group by r.name;

-- customer name and their total orders
select u.name,count(o.order_id)
from users u
left join orders o
on u.user_id=o.user_id
group by u.name;

--  Find the most expensive menu item
select item_name,price
from menu_items
order by price desc limit 1;

-- Total orders handled by each delivery partner 
select dp.name,count(d.delivery_id) as total_deliver
from deliveries d
left join delivery_partners dp
on dp.partner_id=d.partner_id
group by dp.name;

--  Find the second highest priced menu item
select item_name,price
from( select item_name,price,
nth_value(price,3) over(order by price desc ) as second_price
from menu_items )t where price= second_price;

 --  using dense rank second highest 
select item_name,price
from(select item_name,price, 
       dense_rank() over(order by price desc) as rnk 
       from menu_items)t where rnk=2;
       
 select distinct price
 from menu_items
 order by price desc 
 limit 1,1;
       
-- users who placed more than 1 order
select u.name,count(o.user_id) as total_orders
from users u 
join orders o on u.user_id=o.user_id
group by u.name having count(o.user_id)>1;

-- Daily revenue report
select p.payment_date,sum(o.total_amount) as revenue
from payments p 
join orders o on p.order_id=o.order_id
where p.payment_status = 'success'
group by p.payment_date;

-- top 3 restaurants by revenue
select r.name,sum(o.total_amount)as revenue
from restaurants r 
join orders o on r.restaurant_id=o.restaurant_id
where order_status = 'delivered'
group by r.name order by revenue desc limit 3;

-- order details with payment and delivery status
select o.order_id,o.total_amount,o.order_status,d.delivery_status,p.payment_status
from orders o 
join deliveries d on o.order_id=d.order_id
join payments p on d.order_id=p.order_id;

-- average order value
select avg(total_amount)as avg_value
from orders ;

-- orders placed in February 2026
select total_amount,order_date
from orders
where month (order_date) = 2
and year(order_date) = 2026;

-- Categorize orders as High / Medium / Low value
select order_id,total_amount,
case  
when total_amount >=400 then 'high'
when total_amount  between 200 and 300 then 'medium'
else 'low'
end as amount_catgory
 from orders;
 
 -- delivery partners who delivered more than 2 orders
 select dp.name,d.delivery_status,count(d.partner_id) as delivery_count
 from delivery_partners dp 
 join deliveries d
 on dp.partner_id=d.partner_id where d.delivery_status='delivered'
 group by dp.name having delivery_count>2;
 
 -- Rank restaurants based on total revenue
 select r.name,sum(o.total_amount)as total_revenue,
       dense_rank()over (order by sum(o.total_amount) desc) as rank_revenue
       from orders o 
       join restaurants r 
       on r.restaurant_id=o.restaurant_id
       where o.order_status='delivered'
       group by r.name;
-- Assign row number to each user based on total orders
select u.name,count(o.order_id) as total_order,
row_number()over(order by count(o.order_id)desc) as row_numbers
from users u 
join orders o on u.user_id=o.user_id
group by u.name ;

-- Find top 2 highest priced items in each restaurant
select r.restaurant_id,r.name,t.price
from (
  select m.restaurant_id,m.price,
  dense_rank() over (partition by m.restaurant_id order by m.price desc) as rnk 
  from menu_items m
) t
join restaurants r on r.restaurant_id= t.restaurant_id where t.rnk<=2;

-- Show cumulative revenue day by day
select date(p.payment_date) as order_date,
sum(o.total_amount) as revnue ,  
sum(sum(o.total_amount)) over (order by date(p.payment_date)) as comulative_revenue
from payments p join orders o on p.order_id=o.order_id where p.payment_status='success' group by p.payment_date;

-- index
create index idx_order_userid
on orders(user_id);

create index idx_paymentid_paymentstatus
on payments(payment_id,payment_status);

CREATE INDEX idx_restaurant_status
ON orders(restaurant_id, order_status);

show index from payments

-- Auto update order_status when payment success
 
delimiter  //
create trigger after_payment_success
after insert on payments
for each row
begin 
  if   new.payment_status='success' then 
      update orders 
		set order_status='confirmed'
        where order_id=new.order_id;
        end if;
end; 
//
delimiter ;

-- place order procedure

DELIMITER //

CREATE PROCEDURE place_order(
   IN p_user_id INT,
   IN p_restaurant_id INT,
   IN p_amount DECIMAL(10,2)
)
BEGIN
   INSERT INTO orders(user_id, restaurant_id, total_amount, order_status)
   VALUES(p_user_id, p_restaurant_id, p_amount, 'Pending');
END;
//

DELIMITER ;

-- Get Total Revenue By Restaurant

select r.name,sum(o.total_amount)as total_revenue
from restaurants r left join orders o 
on r.restaurant_id=o.restaurant_id where o.order_status='delivered'
group by r.name ;

delimiter //
create procedure total_revenue_restaurants (in p_restaurant_id int)
begin 
  select sum(total_amount)as total_revenue 
  from orders 
  where restaurant_id=p_restaurant_id and order_status='delivered';
 end;
 //
 delimiter ;
 
 call total_revenue_restaurants(1);
 
 
 -- Find top 5 customers by lifetime spending
 select distinct o.user_id,u.name,sum(o.total_amount)as total
 from orders o join users u 
 on u.user_id=o.user_id where o.order_status='delivered' group by u.user_id order by total desc limit 5;
 
 -- Detect revenue drop month over month
 select year(order_date)as yr,
		month(order_date)as mn,
        sum(total_amount)as revenue
from orders 
where order_status='delivered'
group by yr,mn
order by yr,mn;

-- Find churn users (No orders in last 30 days)
select user_id,name
from users where user_id not in(select user_id from orders where order_date>= now()-interval 30 day );

-- Find restaurants with above average revenue
select r.name,sum(o.total_amount) as avg_amount
from restaurants r join orders o on r.restaurant_id=o.restaurant_id where order_status='delivered'
group by r.name having avg_amount>(select avg(total_amount) from orders);



