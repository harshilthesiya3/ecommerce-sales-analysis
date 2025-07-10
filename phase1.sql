select * from ecommerce_sales limit 10;

--total transactions
CREATE OR REPLACE VIEW total_transaction as
select count(distinct invoiceno) as total_transactions from ecommerce_sales;

--total products sold
CREATE OR REPLACE VIEW total_products_sold as
select sum(quantity) as total_products_sold 
from ecommerce_sales;

--total revenue
CREATE OR REPLACE VIEW total_revenue as
select sum(quantity * unitprice) as total_revenue_per_prod
from ecommerce_sales;

---top 10 most sold products
CREATE OR REPLACE VIEW top10_popular_items as
select description,sum(quantity) as total_sold 
from ecommerce_sales 
group by description order by sum(quantity) desc limit 10;

--unique products sold
CREATE OR REPLACE VIEW unique_product_sold as
select count(distinct stockcode) as unique_products_sold from ecommerce_sales;