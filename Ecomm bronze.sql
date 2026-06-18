-- DATA WAREHOUSING PROJECT.

-- ======================================================================================================
-- BRONZE LAYER( raW data import and validation)
-- ======================================================================================================

create database ecommerce;
use ecommerce;
-- data imported from csv
select * from olist_products_dataset;
select * from olist_orders_dataset;
select * from olist_order_items_dataset;

