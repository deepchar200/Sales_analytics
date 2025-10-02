-- ======================================================
-- Retail Superstore SQL Project
-- Author: Deepchandra Chouryal
-- Date: 2025-10-01
-- ======================================================

-- 1. Create Tables
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50)
);

CREATE TABLE order_details (
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    customer_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    sales DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ======================================================
-- 2. Business Queries
-- ======================================================

-- Total Sales
SELECT SUM(sales) AS total_sales FROM order_details;

-- Total Profit
SELECT SUM(profit) AS total_profit FROM order_details;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM customers;

-- Sales by Region
SELECT c.region, SUM(od.sales) AS total_sales
FROM customers c
JOIN order_details od ON c.customer_id = od.customer_id
GROUP BY c.region
ORDER BY total_sales DESC;

-- Top 3 Products by Sales in each Category
SELECT p.category, p.product_name, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, total_sales DESC
LIMIT 3;

-- Average Sales per Order
SELECT AVG(order_total) AS avg_sales_per_order
FROM (
    SELECT order_id, SUM(sales) AS order_total
    FROM order_details
    GROUP BY order_id
) AS order_summary;

-- Customer with Most Orders
SELECT c.customer_name, COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN order_details od ON c.customer_id = od.customer_id
JOIN orders o ON o.order_id = od.order_id
GROUP BY c.customer_name
ORDER BY order_count DESC
LIMIT 1;
