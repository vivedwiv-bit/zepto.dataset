create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric (5,2),
availablequantity integer,
discounetdsellingprice NUMERIC (8,2),
weightingms integer,
outOfStock boolean,
quantity integer
);

--data exploration

--count of rows
select count (*) from zepto;

-- sample data
select * from zepto
limit 10;

-- null values
select * from zepto
where name is null 
or
category is null 
or
mrp is null 
or
discountpercent is null 
or
discounetdsellingprice is null 
or
weightingms is null 
or
availablequantity is null 
or
outOfStock is null 
or
quantity is null ;

-- different product categories

select distinct category
from zepto
order by category;

-- products in stock vs out of stock

select outOfStock, count (sku_id)
from zepto
group by outOfStock;

-- product names present multiple times

select name , count ( sku_id) as "numeber of SKUs"
from zepto
group by name
having count (sku_id) > 1
order by count (sku_id) desc;

-- data cleaning

-- product with price = 0

select * zepto
where mrp = 0 or discounetdsellingprice = 0;

delete from zepto
where mrp = 0;

-- convert paise into rupees

update zepto
set mrp = mrp/100.0,
discounetdsellingprice =discounetdsellingprice/100.0;

select mrp , discounetdsellingprice from zepto

-- top 10 best - value products based on discount % , 

select distinct name, mrp , discountpercent
from zepto
order by discountpercent desc
limit 10;

--- products with high mrp but out of stock,
select distinct name, mrp 
from zepto
where outOfStock = TRUE and mrp > 300
order by mrp desc;

-- estimated revenue for each category
select category,
sum (discounetdsellingprice * availablequantity) as total_revenue 
from zepto
group by category
order by total_revenue;

-- products where mrp > 500 AND DISCOUNT IS LESS THAN 100.

SELECT DISTINCT name , mrp,discountpercent
from zepto
where mrp > 500 and discountpercent < 10
order by mrp desc , discountpercent desc;

-- top 5 cat. offering the highest avg discount %.

select category,
round(avg (discountpercent) , 2) as avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;

-- price per gram for products above 100g and sort by best value.
select distinct name , weightingms , discounetdsellingprice,
round (discounetdsellingprice / weightingms , 2) as price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram;

-- group the products into categories like low , medium , bulk...


select distinct name , weightingms, 
case when weightingms < 1000 then 'LOW'
     when weightingms < 5000 then 'MEDIUM'
     else 'BULK'
     end as weigh_category
from zepto;
