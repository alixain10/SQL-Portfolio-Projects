Basic:
-- Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders_placed 
FROM orders

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(od.quantity * p.price),2) AS total_sales
FROM pizzas p
JOIN orders_details od ON p.pizza_id=od.pizza_id

-- Identify the highest-priced pizza.
SELECT pt.name,price
FROM pizzas p
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
ORDER BY price DESC
LIMIT 1

-- Identify the most common pizza size ordered.
SELECT size,COUNT(od.order_details_id) AS quantity_orders
FROM pizzas p
JOIN orders_details od ON od.pizza_id=p.pizza_id
GROUP BY size
LIMIT 1

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name,SUM(od.quantity) AS quantity_orders
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN orders_details od ON od.pizza_id=p.pizza_id 
GROUP BY pt.name
ORDER BY quantity_orders DESC
LIMIT 5

Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category,SUM(od.quantity) AS total_orders
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN orders_details od ON od.pizza_id=p.pizza_id
GROUP BY category


-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS hour,COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time)

Join relevant tables to find the category-wise distribution of pizzas.
SELECT category,COUNT(name) AS total_number
FROM pizza_types
GROUP BY category


Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(total_pizzas),0) AS average_pizzas_ordered FROM 
(SELECT o.order_date,SUM(od.quantity) AS total_pizzas
FROM orders o
JOIN orders_details od ON od.order_id=o.order_id
GROUP BY o.order_date) AS order_quantity

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name,SUM(od.quantity * p.price) AS total_revenue 
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN orders_details od ON p.pizza_id=od.pizza_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3

Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category,ROUND(SUM(od.quantity * p.price) / (SELECT ROUND(SUM(od.quantity * p.price),2) 
FROM pizzas p
JOIN orders_details od ON p.pizza_id=od.pizza_id) * 100,2) AS revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN orders_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue

-- Analyze the cumulative revenue generated over time.
WITH cte AS(
SELECT o.order_date AS day_order,ROUND(SUM(od.quantity * p.price),2) AS revenue
FROM orders o
JOIN orders_details od ON o.order_id=od.order_id
JOIN pizzas p ON od.pizza_id=p.pizza_id
GROUP BY o.order_date)

SELECT *,ROUND(SUM(revenue) OVER(ORDER BY day_order),2) AS cummulative_revenue
FROM cte

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name,revenue FROM
(SELECT category,name,revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
FROM
(SELECT pt.category,pt.name,SUM(od.quantity * p.price) AS revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN orders_details od ON p.pizza_id = od.pizza_id 
GROUP BY pt.category,pt.name) AS a) AS b
WHERE rn <= 3