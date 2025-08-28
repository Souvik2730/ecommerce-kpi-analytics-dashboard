-- creating table for customers_india
CREATE TABLE customers_india(
  customer_id VARCHAR(20) PRIMARY KEY,
  signup_date DATE,
  country VARCHAR(20),
  state VARCHAR(20),
  device_type VARCHAR(20)
);


-- creating table for products_india
CREATE TABLE products_india(
  product_id VARCHAR(20) PRIMARY KEY,
  product_name VARCHAR(20),
  category VARCHAR(20),
  cost_price INT,
  unit_price FLOAT
);

-- creating table for order_items_india
CREATE TABLE order_items_india(
  order_item_id VARCHAR(20) PRIMARY KEY,
  order_id VARCHAR(20),
  product_id VARCHAR(20),
  quantity INT,
  unit_price FLOAT,
  cost_price INT,
  discount_pct FLOAT,
  tax_amount FLOAT,
  shipping_fee INT,
  is_refunded VARCHAR(20)
);


-- creating table for orders_india
CREATE TABLE orders_india(
  order_id VARCHAR(20) PRIMARY KEY,
  order_date DATE,
  customer_id VARCHAR(20),
  payment_status VARCHAR(20),
  fulfillment_status VARCHAR(20),
  channel VARCHAR(20)
);


-- creating table for fact_web_events
CREATE TABLE fact_web_events (
    event_id VARCHAR(20) PRIMARY KEY,    -- event_id can be a string
    session_id VARCHAR(20),              -- session_id as a string
    customer_id VARCHAR(20),             -- customer_id as a string (matches customers_india)
    event_type ENUM('session_start', 'product_view', 'add_to_cart', 'checkout', 'payment', 'purchase') NOT NULL,
    event_time DATETIME NOT NULL,        -- event_time as a DATETIME
    FOREIGN KEY (customer_id) REFERENCES customers_india(customer_id)  -- foreign key to customers_india table
);



-- first order date per customer
CREATE OR REPLACE VIEW v_customer_first_order AS
SELECT
customer_id,
MIN(order_date) AS first_order_date
FROM orders_india
GROUP BY customer_id;


-- Orders per month (for trends)
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,   -- first day of month
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.quantity * oi.unit_price * (1 - IFNULL(oi.discount_pct, 0)))
      + SUM(IFNULL(oi.tax_amount, 0))
      + SUM(IFNULL(oi.shipping_fee, 0))
      - SUM(CASE WHEN oi.is_refunded = '1' THEN oi.quantity * oi.unit_price ELSE 0 END) AS revenue
FROM orders_india o
JOIN order_items_india oi 
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')   -- ✅ exact same as SELECT
ORDER BY month;



-- cohort month = first purchase month
-- Step 1: Customer Cohort
CREATE OR REPLACE VIEW v_customer_cohort AS
SELECT 
    c.customer_id,
    DATE_FORMAT(f.first_order_date, '%Y-%m-01') AS cohort_month
FROM customers_india c
JOIN (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders_india
    GROUP BY customer_id
) f ON c.customer_id = f.customer_id;


-- Step 2: Customer × Month Activity
CREATE OR REPLACE VIEW v_customer_monthly_activity AS
SELECT
    o.customer_id,
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
    COUNT(DISTINCT o.order_id) AS orders_in_month
FROM orders_india o
GROUP BY o.customer_id, DATE_FORMAT(o.order_date, '%Y-%m-01');

-- Step 3: Cohort Retention
CREATE OR REPLACE VIEW v_cohort_retention AS
SELECT
    cm.cohort_month,
    m.month,
    TIMESTAMPDIFF(MONTH, cm.cohort_month, m.month) AS months_since_cohort,
    SUM(CASE WHEN a.orders_in_month > 0 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(DISTINCT cm.customer_id) AS retention_rate
FROM v_customer_cohort cm
JOIN (
    SELECT DISTINCT DATE_FORMAT(order_date, '%Y-%m-01') AS month
    FROM orders_india
) m ON m.month >= cm.cohort_month
LEFT JOIN v_customer_monthly_activity a
    ON a.customer_id = cm.customer_id 
   AND a.month = m.month
GROUP BY cm.cohort_month, m.month, months_since_cohort
ORDER BY cm.cohort_month, months_since_cohort;



-- recency = days since last order (relative to a reference date)
WITH last_order AS (
    SELECT customer_id, MAX(order_date) AS last_order_date
    FROM orders_india
    GROUP BY customer_id
),
freq AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS frequency
    FROM orders_india
    GROUP BY customer_id
),
monetary AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price * (1 - IFNULL(oi.discount_pct, 0))) AS monetary
    FROM order_items_india oi
    JOIN orders_india o
      ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    l.customer_id,
    DATEDIFF(CURDATE(), l.last_order_date) AS recency_days,
    f.frequency,
    m.monetary
FROM last_order l
JOIN freq f
  ON f.customer_id = l.customer_id
LEFT JOIN monetary m
  ON m.customer_id = l.customer_id;


-- Optional: save as a view (no CTEs, so it’s view-safe)
CREATE OR REPLACE VIEW v_customer_rfm AS
SELECT
  l.customer_id,
  DATEDIFF(CURDATE(), l.last_order_date) AS recency_days,
  f.frequency,
  m.monetary
FROM
  (SELECT customer_id, MAX(order_date) AS last_order_date
   FROM orders_india
   GROUP BY customer_id) l
JOIN
  (SELECT customer_id, COUNT(DISTINCT order_id) AS frequency
   FROM orders_india
   GROUP BY customer_id) f
  ON f.customer_id = l.customer_id
LEFT JOIN
  (SELECT o.customer_id,
          SUM(oi.quantity * oi.unit_price * (1 - IFNULL(oi.discount_pct, 0))) AS monetary
   FROM order_items_india oi
   JOIN orders_india o ON o.order_id = oi.order_id
   GROUP BY o.customer_id) m
  ON m.customer_id = l.customer_id;


SELECT * FROM v_customer_rfm;

-- counts per month per stage
CREATE OR REPLACE VIEW v_monthly_funnel AS
SELECT
    DATE_FORMAT(event_time, '%Y-%m-01') AS month,
    SUM(CASE WHEN event_type = 'session_start' THEN 1 ELSE 0 END) AS sessions,
    SUM(CASE WHEN event_type = 'product_view' THEN 1 ELSE 0 END) AS views,
    SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
    SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases
FROM fact_web_events
GROUP BY DATE_FORMAT(event_time, '%Y-%m-01')
ORDER BY DATE_FORMAT(event_time, '%Y-%m-01');

