CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO customers VALUES
(1, 'Amit', 'Mumbai', '2022-01-10'),
(2, 'Neha', 'Delhi', '2022-03-15'),
(3, 'Raj', 'Pune', '2023-02-20'),
(4, 'Simran', 'Mumbai', '2021-11-01'),
(5, 'Arjun', 'Bangalore', '2023-05-18');
INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 60000),
(102, 'Mobile', 'Electronics', 25000),
(103, 'Headphones', 'Accessories', 2000),
(104, 'Chair', 'Furniture', 5000),
(105, 'Desk', 'Furniture', 10000);
INSERT INTO orders VALUES
(1001, 1, 101, 1, '2023-01-15'),
(1002, 2, 102, 2, '2023-02-10'),
(1003, 1, 103, 3, '2023-03-05'),
(1004, 3, 101, 1, '2023-03-18'),
(1005, 4, 104, 2, '2023-04-11'),
(1006, 2, 105, 1, '2023-05-09'),
(1007, 5, 102, 1, '2023-06-21'),
(1008, 1, 104, 1, '2023-07-02');
SELECT 
    p.product_name,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(o.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(o.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
SELECT 
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_name
HAVING SUM(o.quantity * p.price) > 50000
ORDER BY total_spent DESC;
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(o.quantity) AS total_units,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(o.quantity) DESC) AS rnk
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
) ranked_products
WHERE rnk = 1;
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY lifetime_value DESC;
