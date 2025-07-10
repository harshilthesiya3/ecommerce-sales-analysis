select * from ecommerce_sales;

--monthly sales trend(revenue month to month)
CREATE OR REPLACE VIEW monthly_sales_trend as
select extract(month from invoicedate) as monthh,
extract(year from invoicedate) as yearr,
sum(quantity *unitprice)as total_revenue
from ecommerce_sales
where quantity>0 and unitprice>0
group by monthh,yearr
order by monthh,yearr;

--top countries by total revenue

CREATE OR REPLACE VIEW top_5_country_based_on_revenue as
select country,
sum(quantity *unitprice)as total_revenue
from ecommerce_sales
where quantity>0 and unitprice>0
group by country
order by total_revenue desc;

--best time of day for max sales

CREATE OR REPLACE VIEW busiest_hour_for_most_revenue as
select extract(hour from invoicedate) popular_hour_of_day,
sum(quantity*unitprice)as total_revenue from
ecommerce_sales 
where quantity>0 and unitprice>0
group by popular_hour_of_day
order by total_revenue desc;

--weekday vs weekend sales

CREATE OR REPLACE VIEW weekend_vs_weekday_sales as
select 
	case when extract(dow from invoicedate) in (0,6)
	then 'weekend'
	else
		'weekday'
	end as day_type,sum(quantity*unitprice) as total_revenue
from ecommerce_sales
where quantity>0 and unitprice>0
group by day_type 
order by total_revenue desc;

--country + month combo(monthly revenue and top countries)

CREATE OR REPLACE VIEW top_country_based_on_monthly_revenue as
select to_char(date_trunc('month', invoicedate),'Mon YYYY') as monthh,
sum(quantity* unitprice) as total_revenue ,country
from ecommerce_sales 
where quantity>0 and unitprice>0
group by country,monthh 
order by total_revenue desc;

--for holiday months

CREATE OR REPLACE VIEW holiday_month_revenue as
select to_char(date_trunc('month', invoicedate),'Mon YYYY') as monthh,
sum(quantity* unitprice) as holiday_revenue 
from ecommerce_sales 
where quantity>0 and unitprice>0
and extract(month from invoicedate) in (11,12)
group by monthh 
order by holiday_revenue desc;

-- cancellation patterns(invoices starting with 'C')

CREATE OR REPLACE VIEW cancellation_patterns as
SELECT 
  SUM(CASE WHEN InvoiceNo NOT LIKE 'C%' THEN quantity * unitprice ELSE 0 END) AS successfull_revenue,
  SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN quantity * unitprice ELSE 0 END) AS cancelled_revenue,
  sum(quantity*unitprice) as total_revenue,
  round(100.0 * SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN quantity * unitprice ELSE 0 END) /
    NULLIF(SUM(quantity * unitprice), 0),2) as cancellation_percent
FROM ecommerce_sales
where quantity is not null and unitprice is not null;

--cancellation patterns based on country

CREATE OR REPLACE VIEW country_based_cancellation_patterns as
SELECT 
	country,
	round(100.0 * SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN quantity * unitprice ELSE 0 END) /
    NULLIF(SUM(quantity * unitprice), 0),2) as cancellation_percent,

  SUM(CASE WHEN InvoiceNo NOT LIKE 'C%' THEN quantity * unitprice ELSE 0 END) AS successfull_revenue,
  SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN quantity * unitprice ELSE 0 END) AS cancelled_revenue,
  sum(quantity*unitprice) as total_revenue
  FROM ecommerce_sales
where quantity is not null and unitprice is not null
group by country
order by cancellation_percent;

