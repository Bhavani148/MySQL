-- CREATE DTABASE

CREATE DATABASE AmazonDB;
SHOW DATABASES;

---- CREATE TABLE
USE AmazonDB;

-- Create Users Table
CREATE TABLE Users(user_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(100) NOT NULL, email VARCHAR(150) UNIQUE NOT NULL,
registered_date DATE NOT NULL, membership ENUM('Basic', 'Prime') DEFAULT 'Basic');

SELECT * from Users;

-- Create Products Table
CREATE TABLE Products(product_id INT AUTO_INCREMENT PRIMARY KEY, product_name VARCHAR(200) NOT NULL,
price DECIMAL(10, 2) NOT NULL, category VARCHAR(100) NOT NULL, stock INT NOT NULL);

SELECT * from Products;

-- Create Orders Table
CREATE TABLE Orders(
order_id INT AUTO_INCREMENT PRIMARY KEY, 
user_id INT,
order_date DATE NOT NULL,
total_amount DECIMAL(10, 2) NOT NULL, 
FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

SELECT * from Orders;

-- Create OderDetails table
CREATE TABLE OrderDetails(
order_details_id INT AUTO_INCREMENT PRIMARY KEY ,
order_id INT,
product_id INT, 
quantity INT NOT NULL, FOREIGN KEY (order_id) REFERENCES Orders(order_id), 
FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

SELECT * from OrderDetails;

-- INSERT TABLE
-- Insert Users Table

INSERT INTO Users (name, email, registered_date, membership) VALUES
('Alice Johnson', 'alice.j@example.com', '2024-01-15', 'Prime'),
('Bob Smith', 'bob.s@example.com', '2024-02-01', 'Basic'),
('Charlie Brown', 'charlie.b@example.com', '2024-03-10', 'Prime'),
('Daisy Ridley', 'daisy.r@example.com', '2024-04-12', 'Basic');

select * from Users;

-- Insert Products Table

INSERT INTO Products (product_name, price, category, stock) VALUES
('Echo Dot', 49.99, 'Electronics', 120),
('Kindle Paperwhite', 129.99, 'Books', 50),
('Fire Stick', 39.99, 'Electronics', 80),
('Yoga Mat', 19.99, 'Fitness', 200),
('Wireless Mouse', 24.99, 'Electronics', 150);

select * from Products;

-- Insert Orders Table

INSERT INTO Orders (user_id, order_date, total_amount) VALUES
(1, '2024-05-01', 79.98),
(2, '2024-05-03', 129.99),
(1, '2024-05-04', 49.99),
(3, '2024-05-05', 24.99);

select * from users;
select * from Orders;

-- Insert OrderDetails Table

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 1, 1),
(4, 5, 1);

select * from OrderDetails;

-- Assignment Questions:
-- 1. List all customers who have made purchases of more than $80.

SELECT name from Users u Join orders o 
ON u.user_id=o.user_id 
where o.total_amount>80;

-- 2. Retrieve all orders placed in the last 280 days along with the customer

SELECT o.order_id, o.order_date, u.user_id, u.name, u.email from orders o 
Join users u ON o.user_id = u.user_id
where order_date >= CURDATE() - INTERVAL 280 DAY;

-- 3. Find the average product price for each category.

SELECT product_id, product_name, avg(price) AVG_Price , category from products GROUP BY product_id;

-- 4. List all customers who have purchased a product from the category Electronics.

SELECT DISTINCT u.user_id, u.name, u.email, p.category, o.order_id, p.product_id
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Orderdetails od ON o.order_id=od.order_id
JOIN Products p ON od.product_id = p.product_id
WHERE p.category = 'Electronics';

SELECT * from Users;
SELECT * from Products;
SELECT * from Orders;
SELECT * from Orderdetails;
-- 5. Find the total number of products sold and the total revenue generated for each product.

SELECT p.product_id, p.product_name, SUM(od.quantity) as total_quantity_sold, p.price as per_item_price,
SUM(od.quantity * p.price) as Total_Revenue
from Products p 
JOIN Orderdetails od 
ON p.product_id=od.product_id 
GROUP BY p.product_name, p.product_id, od.quantity;

-- 6. Update the price of all products in the Books category, increasing it by 10%. Query

UPDATE products SET price=price*1.10 where category='Books';

-- 7. Remove all orders that were placed before 2020.

delete from orderdetails where order_id IN ( SELECT order_id from orders where order_date < '2020-01-01');

-- 8 Write a query to fetch the order details, including customer name, product name, and
-- quantity, for orders placed on 2024-05-01.

SELECT u.name as customer_name, p.product_name as product_name, 
od.order_id, od.quantity, o.order_date 
from orderdetails od
JOIN products p ON od.product_id = p.product_id
JOIN orders o ON o.order_id = od.order_id
JOIN users u ON u.user_id=o.user_id where o.order_date = '2024-05-01';

--  9. Fetch all customers and the total number of orders they have placed.
-- COALESCE(SUM(o.total_amount), 0) replaces NULL with a default value. 
-- If SUM(o.total_amount) is NULL, it returns 0.
SELECT u.name as Customer_name, count(o.order_id) as total_order, COALESCE(sum(o.total_amount), 0) as total_amount
from users u
LEFT JOIN orders o ON u.user_id=o.user_id
GROUP BY u.name, o.user_id;


-- 10. Retrieve the average rating for all products in the Electronics category.

SELECT p.product_name, p.category, avg(o.total_amount) Average_Rate_Item
FROM products p
JOIN orderdetails od ON p.product_id=od.product_id
JOIN orders o ON o.order_id = od.order_id 
WHERE p.category='Electronics'
GROUP BY p.product_name, p.category ;

-- 11. List all customers who purchased more than 1 units of any product, including the product
-- name and total quantity purchased.

SELECT u.name as Customer_name, p.product_name, SUM(od.quantity)
from users u
LEFT JOIN orders o ON u.user_id=o.user_id
LEFT JOIN orderdetails od ON o.order_id=od.order_id
LEFT JOIN products p ON p.product_id=od.product_id
GROUP BY u.name, p.product_name
hAVING SUM(od.quantity)>1;

-- 12. Find the total revenue generated by each category along with the category name

SELECT p.category as Category, SUM(od.quantity * p.price) as Total_Revenue
from products p
JOIN orderdetails od ON p.product_id=od.product_id
JOIN orders o ON od.order_id=o.order_id
GROUP BY p.category;