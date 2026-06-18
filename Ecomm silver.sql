-- ======================================================================================================
-- SILVER LAYER(data cleaning and validation)
-- ======================================================================================================

drop table if exists orders_cleansed;
create table orders_cleansed(
                 order_id varchar(50),
                 customer_id varchar(50),
                 order_status varchar(30),
                 purchase_date datetime,
                 delivery_date datetime
                 );
                 
insert into orders_cleansed(
              order_id,
              customer_id,
              order_status,
              purchase_date,
              delivery_date)
	select
	order_id,
    customer_id,
    order_status,
    case
    when order_purchase_timestamp is null or order_purchase_timestamp = ' '
    then null
    else
    str_to_date(order_purchase_timestamp,'%Y-%m-%d %H:%i:%s')
    end as purchase_date,
    case when order_delivered_customer_date is null or order_delivered_customer_date = ' '
    then null
    else
    str_to_date(order_delivered_customer_date,'%Y-%m-%d %H:%i:%s') 
    end as delivery_date
from olist_orders_dataset
where order_id is not null;

select count(*) from orders_cleansed where order_id is null;
desc orders_cleansed;

drop table if exists order_items_cleansed;
create table order_items_cleansed(
      order_id varchar (50),
      order_item_id int,
      product_id varchar(50),
      seller_id varchar(50),
      shipping_limit_date datetime,
      price decimal(10,2),
      freight_value decimal (10,2)
      );
      
      
insert into order_items_cleansed
select
     order_id,
     cast(order_item_id as unsigned),
     product_id,
     seller_id,
     str_to_date(shipping_limit_date,'%Y-%m-%d %H:%i:%s'),
     cast(trim(price) as decimal(10,2)),
     cast(trim(freight_value) as decimal(10,2))
from olist_order_items_dataset;

desc order_items_cleansed;
select count(*) from order_items_cleansed where order_id is null;

drop table if exists products_cleansed;
create table products_cleansed(
     product_id varchar(50),
     product_catrgory_name varchar(100),
     product_name_length int,
     product_description_length int,
     product_photos_qty int,
     product_weight_g int,
     product_length_cm int,
     product_height_cm int,
     product_width_cm int);
     
insert into products_cleansed
select
    product_id,
    product_category_name,
    cast(product_name_lenght as unsigned),
    cast(product_description_lenght as unsigned),
    cast(product_photos_qty as unsigned),
    cast(product_weight_g as unsigned),
    cast(product_length_cm as unsigned),
    cast(product_height_cm as unsigned),
    cast(product_width_cm as unsigned)
from olist_products_dataset;

desc products_cleansed;
select count(*) from products_cleansed where product_id is null;

select * from order_items_cleansed where price <=0;
-- no such prices

-- duplicate order_id in orders table.
select order_id, count(*)
from orders_cleansed
group by order_id
having count(*)>1;
-- no duplicate oreder id exist.

-- product ids in orderitems that dont exist in products
select oi.*
from order_items_cleansed oi
left join products_cleansed p
on oi.product_id = p.product_id
where p.product_id is null;
-- there are few such product ids.

select *
from orders_cleansed
where delivery_date < purchase_date;
-- there are such purchase date which is more than delivery date.


delete from order_items_cleansed   -- deleting productIds in order_items_cleansed which do not exixt in product table.
where product_id in (
select product_id from(
select oi.*
from order_items_cleansed oi
left join products_cleansed p
on oi.product_id = p.product_id
where p.product_id is null
limit 100) as temp);


check table order_items_cleansed;
check table products_cleansed;
alter table order_items_cleansed add index(product_id);

select count(*) from order_items_cleansed;

update orders_cleansed      -- handling delivery dates which are less than purchse date
set delivery_date = null
where delivery_date < purchase_date;

-- checking order_items_cleansed

-- null order_id or product_id
select * from order_items_cleansed where order_id is null or product_id is null;
-- no such row is present.

-- negative or zero price
select * from order_items_cleansed where price <= 0;
-- no such value found.

-- negative freight
select * from order_items_cleansed where freight_value < 0;
-- no such values found.

-- checking orders_cleansed

-- null primary values
select count(*) from orders_cleansed where order_id is null;
-- no such value found.

-- duplicate order ids
select order_id, count(*) from orders_cleansed
group by order_id having count(*)>1;
-- no duplicate ids.

-- null purchase dates
select count(*) from orders_cleansed where purchase_date is null;
-- no null value.

-- checking products_cleansed

-- null product id
select * from products_cleansed where product_id is null;
-- no such ids. 

-- duplicate product_id
select product_id, count(*)
from products_cleansed
group by product_id
having count(*)>1;
-- no duplicate product id

 -- missing category name
 select * from products_cleansed where product_catrgory_name is null;
 -- no such products!
 
 select * from products_cleansed  
 where product_weight_g <= 0
  or product_length_cm <= 0
  or product_height_cm <= 0
  or product_width_cm <=0;
  
  delete from products_cleansed  -- deleting the products having weight 0 or negative.
  where product_weight_g <= 0;
