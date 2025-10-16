/*
=============================================================
🍕 PIZZA SALES DATA ANALYSIS PROJECT
Author: Saharia Sarder
Goal: Analyze pizza sales data to uncover key business insights
Database: pizzahut
=============================================================
*/


-- ==========================================================
-- 1️⃣ Retrieve the total number of orders placed
-- ==========================================================
SELECT 
    COUNT(order_id) AS Total_orders 
FROM 
    orders;



-- ==========================================================
-- 2️⃣ Calculate the total revenue from pizza sales
-- ==========================================================
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM 
    order_details
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id;



-- ==========================================================
-- 3️⃣ Identify the highest-priced pizza
-- ==========================================================
SELECT 
    pizza_types.name, 
    pizzas.price
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY 
    pizzas.price DESC
LIMIT 1;



-- ==========================================================
-- 4️⃣ Identify the most common pizza size ordered
-- ==========================================================
SELECT 
    pizzas.size,
    COUNT(order_details.order_details) AS order_count
FROM 
    pizzas
JOIN 
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizzas.size
ORDER BY 
    order_count DESC;



-- ==========================================================
-- 5️⃣ List the top 5 pizzas by total quantity sold
-- ==========================================================
SELECT 
    pizza_types.name, 
    SUM(order_details.quantity) AS quantity
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    quantity DESC
LIMIT 5;



-- ==========================================================
-- 6️⃣ Find the total quantity of each pizza category ordered
-- ==========================================================
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    quantity DESC;



-- ==========================================================
-- 7️⃣ Calculate the average number of pizzas ordered per day
-- ==========================================================
SELECT 
    AVG(Quantity) AS avg_pizzas_per_day
FROM
    (SELECT 
        orders.order_date, 
        SUM(order_details.quantity) AS Quantity
    FROM
        orders
    JOIN 
        order_details ON orders.order_id = order_details.order_id
    GROUP BY 
        orders.order_date) AS order_quantity;



-- ==========================================================
-- 8️⃣ Determine the distribution of orders by the hour of the day
-- ==========================================================
SELECT 
    HOUR(order_time) AS hour, 
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY 
    HOUR(order_time)
ORDER BY 
    hour;



-- ==========================================================
-- 9️⃣ Determine the top 3 most ordered pizza types (by revenue)
-- ==========================================================
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    revenue DESC
LIMIT 3;



-- ==========================================================
-- 🔟 Calculate the percentage revenue contribution by category
-- ==========================================================
SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / 
    (SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2)
     FROM order_details
     JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id)
    ) * 100 AS revenue_percentage
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue_percentage DESC;



-- ==========================================================
-- 1️⃣1️⃣ Analyze cumulative revenue generated over time
-- ==========================================================
SELECT 
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT 
        orders.order_date,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM 
        order_details
    JOIN 
        pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN 
        orders ON orders.order_id = order_details.order_id
    GROUP BY 
        orders.order_date
) AS sales;



-- ==========================================================
-- 1️⃣2️⃣ Determine the top 3 pizzas by revenue for each category
-- ==========================================================
SELECT 
    category, 
    name, 
    revenue
FROM (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_number
    FROM (
        SELECT 
            pizza_types.category,
            pizza_types.name,
            SUM(order_details.quantity * pizzas.price) AS revenue
        FROM 
            pizza_types
        JOIN 
            pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN 
            order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            pizza_types.category, pizza_types.name
    ) AS ranked_data
) AS final_ranking
WHERE 
    rank_number <= 3;

-- 🎉 END OF PROJECT 🎉
