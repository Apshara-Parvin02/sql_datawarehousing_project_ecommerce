-- ======================================================================================================
-- GOLD LAYER(business insights)
-- ======================================================================================================

DROP TABLE IF EXISTS gold_dim_product;

CREATE TABLE gold_dim_product AS
SELECT DISTINCT
    product_id,
    product_catrgory_name AS product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products_cleansed;


DROP TABLE IF EXISTS gold_dim_customer;

CREATE TABLE gold_dim_customer AS
SELECT DISTINCT
    customer_id
FROM orders_cleansed;


DROP TABLE IF EXISTS gold_dim_seller;

CREATE TABLE gold_dim_seller AS
SELECT DISTINCT
    seller_id
FROM order_items_cleansed;


DROP TABLE IF EXISTS gold_dim_date;

CREATE TABLE gold_dim_date AS
SELECT DISTINCT
    purchase_date AS full_date,
    YEAR(purchase_date) AS year,
    QUARTER(purchase_date) AS quarter_no,
    MONTH(purchase_date) AS month_no,
    MONTHNAME(purchase_date) AS month_name,
    WEEK(purchase_date) AS week_no,
    DAY(purchase_date) AS day_no,
    DAYNAME(purchase_date) AS day_name
FROM orders_cleansed
WHERE purchase_date IS NOT NULL;


DROP TABLE IF EXISTS gold_fact_sales;

CREATE TABLE gold_fact_sales AS
SELECT
    o.order_id,

    o.customer_id,

    oi.product_id,

    oi.seller_id,

    DATE(o.purchase_date) AS purchase_date,

    o.order_status,

    oi.order_item_id,

    oi.price,

    oi.freight_value,
        (oi.price + oi.freight_value) AS total_sales_amount,

    DATEDIFF(
        o.delivery_date,
        o.purchase_date
    ) AS delivery_days

FROM orders_cleansed o
JOIN order_items_cleansed oi
    ON o.order_id = oi.order_id;
    
   
   
   -- TOTAL REVENUE
    SELECT
    ROUND(SUM(total_sales_amount),2) AS total_revenue
FROM gold_fact_sales;

-- TOTAL ORDERS
SELECT
    ROUND(SUM(total_sales_amount),2) AS total_revenue
FROM gold_fact_sales;

-- AVERAGE ORDER VALUE 
SELECT
    ROUND(
        SUM(total_sales_amount) /
        COUNT(DISTINCT order_id),
    2) AS avg_order_value
FROM gold_fact_sales;

-- AVERAGE DELIVERY DAYS
SELECT
    ROUND(
        SUM(total_sales_amount) /
        COUNT(DISTINCT order_id),
    2) AS avg_order_value
FROM gold_fact_sales;

-- TOP 10 PRODUCT CATEGORIES BY REVENUE
SELECT
    p.product_category_name,
    ROUND(SUM(f.total_sales_amount),2) AS revenue
FROM gold_fact_sales f
JOIN gold_dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- TOP 10 PRODUCTS BY UNITS SOLD
SELECT
    f.product_id,
    COUNT(*) AS total_units_sold
FROM gold_fact_sales f
GROUP BY f.product_id
ORDER BY total_units_sold DESC
LIMIT 10;

-- FREIGHT REVENUE
SELECT
    ROUND(SUM(freight_value),2) AS freight_revenue
FROM gold_fact_sales;

-- DELAYED DELIVERIES
SELECT
    COUNT(*) AS delayed_deliveries
FROM gold_fact_sales
WHERE delivery_days >
(
    SELECT AVG(delivery_days)
    FROM gold_fact_sales
    WHERE delivery_days IS NOT NULL
);