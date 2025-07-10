select * from ecommerce_sales;

--unique customers
create or replace view unique_customer as  
select distinct(customerid) as total_unique_customer 
from ecommerce_sales where customerid is not null;

--top5 customer by total spending
CREATE OR REPLACE VIEW top5_customer_based_on_spending as
select sum(quantity*unitprice) as total_spent,customerid as top_5_guest
from ecommerce_sales where customerid is not null
group by customerid 
order by total_spent desc
limit 5;

--customer with more than 1 transaction
CREATE OR REPLACE VIEW customer_with_more_transaction as
select customerid,count(invoiceno) as num_transactions
from  ecommerce_sales where customerid is not null 
group by customerid
having count(distinct invoiceno)>1 order by num_transactions desc; 

--average order value per customer
CREATE OR REPLACE VIEW avg_order_value_per_customer as
select customerid,avg(quantity*unitprice) as avgspent_per_item,
count(*) as total_items
from ecommerce_sales where customerid is not null
group by customerid
order by avgspent_per_item desc limit 10;

--average pricespent per order by customer
CREATE OR REPLACE VIEW avg_spent_per_order as
select customerid,(sum(quantity *unitprice)/count(distinct invoiceno)) as avg_per_order
from ecommerce_sales where customerid is not null
group by customerid
order by avg_per_order desc limit 10;


--which customer ordered the most item
CREATE OR REPLACE VIEW topitem_ordered as
select customerid,sum(quantity) as item_total
from ecommerce_sales where customerid is not null 
group by customerid
order by item_total desc;