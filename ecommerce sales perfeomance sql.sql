CREATE DATABASE ecommerce_db;
use ecommerce_db;
-- Create a new user
CREATE USER 'project_user'@'localhost' IDENTIFIED BY 'Project@2026!';

-- Give full privileges to your database
GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'project_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;


-- STEP 1: DATABASE CHECK

SHOW DATABASES;

-- STEP 2: TABLE CHECK

SHOW TABLES;

-- STEP 3: STRUCTURE CHECK
DESCRIBE orders;
DESCRIBE products;
DESCRIBE customers;
DESCRIBE time;

SELECT order_date
FROM orders
LIMIT 10;

SET SQL_SAFE_UPDATES = 0;

-- Orders table
-- Add a NEW DATE column
ALTER TABLE orders ADD COLUMN order_date_new_col DATE;

UPDATE orders
SET order_date_new_col = STR_TO_DATE(order_date, '%Y-%m-%d');



SET SQL_SAFE_UPDATES = 1;

-- STEP 3: Validate conversion
SELECT order_date, order_date_new
FROM orders
LIMIT 10;

-- STEP 4: Drop old text column & rename
-- Orders
ALTER TABLE orders DROP COLUMN order_date;
ALTER TABLE orders CHANGE order_date_new_col order_date DATE;




-- QUICK CHECK
DESCRIBE orders;


select *
from orders;

select * 
from time;

-- STEP 4: ROW COUNT VALIDATION
SELECT COUNT(*) AS orders_rows FROM orders;
SELECT COUNT(*) AS products_rows FROM products;
SELECT COUNT(*) AS customers_rows FROM customers;



-- STEP 5: SAMPLE DATA CHECK
SELECT * FROM orders LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM customers LIMIT 10;



-- STEP 6: NULL VALUE CHECK (CRITICAL COLUMNS)
-- Orders
SELECT 
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(product_id IS NULL) AS product_id_nulls
FROM orders;


-- Products
SELECT SUM(product_id IS NULL) AS product_id_nulls FROM products;

-- Customers
SELECT SUM(customer_id IS NULL) AS customer_id_nulls FROM customers;


-- STEP 7: DUPLICATE CHECK (BEFORE KEYS)
-- Products
SELECT product_id, COUNT(*) 
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE products_clean_tab AS
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_id) AS rn
    FROM products
) AS t
WHERE rn = 1;

-- Replace old table
DROP TABLE products;
RENAME TABLE products_clean_tab TO products;

-- Add primary key
ALTER TABLE products
ADD PRIMARY KEY (product_id);

SELECT product_id, COUNT(*) 
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

select * from products;

-- Remove duplicates in orders based on order_id (keep first row)
CREATE TABLE orders_clean AS
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS rn
    FROM orders
) AS t
WHERE rn = 1;

-- Replace old table
DROP TABLE orders;
RENAME TABLE orders_clean TO orders;

-- Add primary key
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

select * from orders;

-- Remove duplicates based on customer_id (keep first row)
CREATE TABLE customers_clean AS
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) AS rn
    FROM customers
) AS t
WHERE rn = 1;

-- Replace old table with cleaned version
DROP TABLE customers;
RENAME TABLE customers_clean TO customers;

-- Add primary key
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

select * from customers;

DROP TABLE IF EXISTS time;

-- Customers
SHOW INDEX FROM customers;

-- Products
SHOW INDEX FROM products;

-- Orders
SHOW INDEX FROM orders;

SELECT DISTINCT o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT DISTINCT o.product_id
FROM orders o
LEFT JOIN products p ON o.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ADD FOREIGN KEYS--
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  
  
  SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;


-- EASY LEVEL
-- 1) .... Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;


-- 2) .... Total revenue generated
SELECT round(SUM(revenue),2) AS total_revenue
FROM orders;

-- 3) .... List distinct payment modes used
SELECT DISTINCT payment_mode
FROM customers;

-- MEDIUM LEVEL (Joins + Grouping)

-- 4) .... Count number of customers with active subscription
SELECT COUNT(*) AS subscribed_customers
FROM customers
WHERE subscription_status = 'Yes';


-- 5) .... Avg product rating by category
SELECT
    category,
    ROUND(AVG(rating), 2) AS avg_rating
FROM products
GROUP BY category;

-- Medium level 
-- 1) ..... Revenue by product category
SELECT
    p.category,
    round(SUM(o.revenue),2) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category;

-- 2) .... Top 5 products by revenue
SELECT
    p.product_id,
    round(SUM(o.revenue),2) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 5;


-- 3) .... City-wise total sales
SELECT
    c.city,
    round(SUM(o.revenue),2) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city;


-- 4) .... customers who placed more than 3 orders
SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 3;

-- 5) .... Orders paid using each payment mode
SELECT
    payment_mode,
    COUNT(*) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY payment_mode;


-- Hard level questions
-- 1) .... Top 3 Products in Each Category

SELECT
    category,
    product_id,
    total_revenue
FROM (
    SELECT
        p.category,
        o.product_id,
        round(SUM(o.revenue),2) AS total_revenue,
        RANK() OVER (
            PARTITION BY p.category
            ORDER BY round(SUM(o.revenue),2) DESC
        ) AS rnk
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY p.category, o.product_id
) ranked_products
WHERE rnk <= 3
ORDER BY category, total_revenue DESC;

-- 2) ..... Month-wise Revenue Trend
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    round(SUM(revenue),2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- 3) .... Repeat vs One-Time Customers
SELECT
    customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) customer_segmentation
GROUP BY customer_type;


-- 4) .... Contribution of Each Category to Total Revenue (%)
SELECT
    category,
    category_revenue,
    ROUND(
        category_revenue * 100.0 /
        SUM(category_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM (
    SELECT
        p.category,
        round(SUM(o.revenue),2) AS category_revenue
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY p.category
) category_sales
ORDER BY revenue_percentage DESC;


-- 5) .... Highest Spending Customer
SELECT
    o.customer_id,
    c.city,
    round(SUM(o.revenue),2) AS total_spent
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.city
ORDER BY total_spent DESC
LIMIT 1;


