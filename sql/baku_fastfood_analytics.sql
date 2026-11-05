-- ============================================================
-- ПРОЕКТ: Аналитика продаж сети "Baku Doner & Burger House"
-- Локация: Баку и Апшерон (Нариманов, Нефтчиляр, 28 Мая, Хырдалан, Масазыр)
-- ============================================================

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

-- 1. СТРУКТУРА ДАННЫХ (DDL)

CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    zone_type VARCHAR(30) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(category_id),
    item_name VARCHAR(100) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    branch_id INT REFERENCES branches(branch_id),
    order_timestamp TIMESTAMP NOT NULL,
    payment_method VARCHAR(30),
    order_type VARCHAR(20)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL
);

-- 2. НАПОЛНЕНИЕ ДАННЫМИ (DML)

INSERT INTO branches (branch_name, zone_type) VALUES
('Narimanov', 'Office Hub'),
('28 May', 'Student & Transit'),
('Neftchiler', 'Residential / Student'),
('Khirdalan', 'Suburban High-Volume'),
('Masazyr', 'Suburban High-Volume');

INSERT INTO categories (category_name) VALUES 
('Doner & Wrap'), ('Burgers'), ('Sides'), ('Drinks'), ('Desserts');

INSERT INTO menu_items (category_id, item_name, cost_price, selling_price) VALUES
(1, 'Beef Doner in Lavash (Et Döner)', 1.80, 4.50),
(1, 'Chicken Doner in Bread (Toyuq Döner)', 1.40, 3.80),
(2, 'Baku Double Smash Burger', 3.00, 7.50),
(2, 'Crispy Chicken Burger', 2.10, 5.20),
(3, 'French Fries (Fri)', 0.60, 2.50),
(3, 'Cheese Sticks', 1.10, 3.50),
(4, 'Ayran 0.3L', 0.30, 1.20),
(4, 'Coca-Cola 0.5L', 0.50, 1.80),
(5, 'Baklava (2 pcs)', 1.00, 3.00);

INSERT INTO orders (branch_id, order_timestamp, payment_method, order_type) VALUES
(1, '2026-10-15 12:30:00', 'BirBank/LeoCard', 'Dine-in'),
(1, '2026-10-15 13:15:00', 'Wolt/Bolt Pay', 'Delivery'),
(2, '2026-10-15 13:40:00', 'm10', 'Takeaway'),
(3, '2026-10-15 14:10:00', 'Cash', 'Dine-in'),
(4, '2026-10-15 18:20:00', 'Wolt/Bolt Pay', 'Delivery'),
(4, '2026-10-15 19:00:00', 'Wolt/Bolt Pay', 'Delivery'),
(5, '2026-10-15 19:30:00', 'Cash', 'Delivery'),
(5, '2026-10-15 20:15:00', 'BirBank/LeoCard', 'Delivery'),
(1, '2026-10-16 12:45:00', 'BirBank/LeoCard', 'Dine-in'),
(2, '2026-10-16 13:00:00', 'BirBank/LeoCard', 'Dine-in'),
(3, '2026-10-16 18:50:00', 'Cash', 'Takeaway'),
(4, '2026-10-16 20:30:00', 'Wolt/Bolt Pay', 'Delivery');

INSERT INTO order_items (order_id, item_id, quantity) VALUES
(1, 1, 2), (1, 5, 2), (1, 8, 2),
(2, 3, 1), (2, 5, 1), (2, 8, 1),
(3, 2, 2), (3, 7, 2),
(4, 1, 1), (4, 5, 1), (4, 7, 1),
(5, 3, 2), (5, 5, 2), (5, 8, 2),
(6, 1, 3), (6, 5, 3), (6, 7, 3),
(7, 2, 4), (7, 5, 4), (7, 8, 4),
(8, 3, 1), (8, 6, 1), (8, 9, 1),
(9, 3, 2), (9, 5, 2), (9, 8, 2),
(10, 2, 2), (10, 7, 2),
(11, 1, 2), (11, 5, 2), (11, 8, 2),
(12, 3, 3), (12, 5, 3), (12, 8, 3);

-- 3. БИЗНЕС-ЗАПРОСЫ

-- Выручка и маржа по филиалам
SELECT 
    b.branch_name,
    b.zone_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * m.selling_price), 2) AS revenue_azn,
    ROUND(SUM(oi.quantity * (m.selling_price - m.cost_price)), 2) AS profit_azn,
    ROUND((SUM(oi.quantity * (m.selling_price - m.cost_price)) / SUM(oi.quantity * m.selling_price)) * 100, 2) AS margin_pct
FROM branches b
JOIN orders o ON b.branch_id = o.branch_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu_items m ON oi.item_id = m.item_id
GROUP BY b.branch_name, b.zone_type
ORDER BY revenue_azn DESC;