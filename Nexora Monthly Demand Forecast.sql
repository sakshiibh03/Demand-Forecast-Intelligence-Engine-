CREATE TABLE location_master (
    location_id INTEGER PRIMARY KEY,
    location VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    facility_type VARCHAR(50),
    cost_tier VARCHAR(20)
);


CREATE TABLE calendar (
    date DATE PRIMARY KEY,
    day_of_week VARCHAR(20),
    month INTEGER,
    month_name VARCHAR(20),
    quarter INTEGER,
    year INTEGER,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    holiday_name VARCHAR(100),
    season VARCHAR(20)
);


DROP TABLE calendar;

CREATE TABLE calendar (
    date DATE PRIMARY KEY,
    day_name VARCHAR(20),
    week_number INTEGER,
    month_name VARCHAR(20),
    quarter INTEGER,
    year INTEGER,
    day_of_week VARCHAR(20),
    weekend_flag VARCHAR(3),
    holiday_flag VARCHAR(3),
    holiday_name VARCHAR(100),
    season VARCHAR(20)
);


CREATE TABLE promotions (
    date DATE NOT NULL,
    location VARCHAR(50) NOT NULL,
    promotion_flag VARCHAR(3),
    promotion_type VARCHAR(50),
    promotion_intensity INTEGER,
    PRIMARY KEY (date, location)
);


CREATE TABLE capacity_planning (
    date DATE NOT NULL,
    location VARCHAR(50) NOT NULL,
    workforce INTEGER,
    regular_capacity INTEGER,
    overtime_capacity INTEGER,
    maximum_capacity INTEGER,
    capacity_cost NUMERIC(10,2),
    PRIMARY KEY (date, location)
);


DROP TABLE location_master;

CREATE TABLE location_master (
    location_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location VARCHAR(50) NOT NULL UNIQUE,
    region VARCHAR(50),
    facility_type VARCHAR(50),
    base_capacity INTEGER,
    workforce_limit INTEGER,
    operating_cost_tier VARCHAR(20)
);


CREATE TABLE operations (
    date DATE NOT NULL,
    location VARCHAR(50) NOT NULL,
    demand INTEGER,
    orders_fulfilled INTEGER,
    cancellations INTEGER,
    delayed_orders INTEGER,
    available_capacity INTEGER,
    workforce_available INTEGER,
    inventory_availability NUMERIC(5,3),
    PRIMARY KEY (date, location)
);


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

ALTER TABLE operations
ALTER COLUMN inventory_availability TYPE VARCHAR(10);


SELECT
    'location_master' AS table_name, COUNT(*) AS row_count
FROM location_master

UNION ALL

SELECT
    'calendar', COUNT(*)
FROM calendar

UNION ALL

SELECT
    'operations', COUNT(*)
FROM operations

UNION ALL

SELECT
    'promotions', COUNT(*)
FROM promotions

UNION ALL

SELECT
    'capacity_planning', COUNT(*)
FROM capacity_planning;


SELECT
    'calendar' AS table_name,
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM calendar

UNION ALL

SELECT
    'operations',
    MIN(date),
    MAX(date)
FROM operations

UNION ALL

SELECT
    'promotions',
    MIN(date),
    MAX(date)
FROM promotions

UNION ALL

SELECT
    'capacity_planning',
    MIN(date),
    MAX(date)
FROM capacity_planning;


SELECT DISTINCT location
FROM operations
ORDER BY location;


SELECT
    date,
    location,
    COUNT(*) AS record_count
FROM operations
GROUP BY date, location
HAVING COUNT(*) > 1;


SELECT
    date,
    location,
    COUNT(*) AS record_count
FROM promotions
GROUP BY date, location
HAVING COUNT(*) > 1;


SELECT
    date,
    location,
    COUNT(*) AS record_count
FROM capacity_planning
GROUP BY date, location
HAVING COUNT(*) > 1;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE demand IS NULL) AS missing_demand,
    COUNT(*) FILTER (WHERE orders_fulfilled IS NULL) AS missing_fulfilled,
    COUNT(*) FILTER (WHERE cancellations IS NULL) AS missing_cancellations,
    COUNT(*) FILTER (WHERE delayed_orders IS NULL) AS missing_delays,
    COUNT(*) FILTER (WHERE available_capacity IS NULL) AS missing_capacity,
    COUNT(*) FILTER (WHERE workforce_available IS NULL) AS missing_workforce,
    COUNT(*) FILTER (WHERE inventory_availability IS NULL) AS missing_inventory
FROM operations;


SELECT COUNT(*) AS inconsistent_records
FROM operations
WHERE demand <> (
    orders_fulfilled
    + cancellations
    + delayed_orders
);


SELECT COUNT(*) AS inconsistent_records
FROM capacity_planning
WHERE maximum_capacity <> (
    regular_capacity + overtime_capacity
);


SELECT COUNT(*) AS inconsistent_records
FROM operations o
JOIN capacity_planning c
    ON o.date = c.date
    AND o.location = c.location
WHERE o.available_capacity <> c.maximum_capacity;


SELECT COUNT(*) AS inconsistent_records
FROM operations o
JOIN capacity_planning c
    ON o.date = c.date
    AND o.location = c.location
WHERE o.workforce_available <> c.workforce;





SELECT
    SUM(demand) AS total_demand,
    SUM(orders_fulfilled) AS total_orders_fulfilled,
    SUM(cancellations) AS total_cancellations,
    SUM(delayed_orders) AS total_delayed_orders,
    SUM(available_capacity) AS total_capacity,
    SUM(demand) - SUM(available_capacity) AS total_capacity_gap,
    ROUND(
        SUM(orders_fulfilled)::NUMERIC / NULLIF(SUM(demand), 0) * 100,
        2
    ) AS fulfilment_rate,
    ROUND(
        SUM(cancellations)::NUMERIC / NULLIF(SUM(demand), 0) * 100,
        2
    ) AS cancellation_rate
FROM operations;


SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(demand) AS total_demand,
    SUM(available_capacity) AS total_capacity,
    SUM(demand) - SUM(available_capacity) AS capacity_gap,
    ROUND(
        SUM(demand)::NUMERIC
        / NULLIF(SUM(available_capacity), 0) * 100,
        2
    ) AS capacity_utilisation_rate
FROM operations
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year;


SELECT
    location,
    SUM(demand) AS total_demand,
    SUM(available_capacity) AS total_capacity,
    SUM(demand) - SUM(available_capacity) AS capacity_gap,
    ROUND(
        SUM(demand)::NUMERIC
        / NULLIF(SUM(available_capacity), 0) * 100,
        2
    ) AS utilisation_rate
FROM operations
GROUP BY location
ORDER BY capacity_gap DESC;


SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    SUM(demand) AS demand,
    SUM(available_capacity) AS capacity,
    SUM(demand) - SUM(available_capacity) AS capacity_gap,
    ROUND(
        SUM(demand)::NUMERIC
        / NULLIF(SUM(available_capacity), 0) * 100,
        2
    ) AS utilisation_rate
FROM operations
GROUP BY DATE_TRUNC('month', date)
ORDER BY capacity_gap DESC
LIMIT 10;


SELECT
    location,
    SUM(demand) AS demand,
    SUM(available_capacity) AS capacity,
    SUM(demand) - SUM(available_capacity) AS capacity_gap,
    ROUND(
        SUM(demand)::NUMERIC
        / NULLIF(SUM(available_capacity), 0) * 100,
        2
    ) AS utilisation_rate
FROM operations
WHERE date >= '2025-11-01'
  AND date < '2025-12-01'
GROUP BY location
ORDER BY capacity_gap DESC;


SELECT
    p.promotion_flag,
    COUNT(*) AS operational_days,
    SUM(o.demand) AS total_demand,
    ROUND(AVG(o.demand), 2) AS avg_daily_demand,
    ROUND(AVG(o.available_capacity), 2) AS avg_daily_capacity,
    ROUND(AVG(o.demand - o.available_capacity), 2) AS avg_capacity_gap
FROM operations o
JOIN promotions p
    ON o.date = p.date
    AND o.location = p.location
GROUP BY p.promotion_flag
ORDER BY avg_daily_demand DESC;


SELECT
    p.promotion_type,
    COUNT(*) AS operational_days,
    ROUND(AVG(o.demand), 2) AS avg_daily_demand,
    ROUND(AVG(o.available_capacity), 2) AS avg_daily_capacity,
    ROUND(AVG(o.demand - o.available_capacity), 2) AS avg_capacity_gap
FROM operations o
JOIN promotions p
    ON o.date = p.date
    AND o.location = p.location
WHERE p.promotion_flag = 'Yes'
GROUP BY p.promotion_type
ORDER BY avg_capacity_gap DESC;


SELECT
    CASE
        WHEN demand > available_capacity THEN 'Over Capacity'
        ELSE 'Within Capacity'
    END AS capacity_status,
    COUNT(*) AS operational_days,
    SUM(demand) AS total_demand,
    SUM(delayed_orders) AS delayed_orders,
    SUM(cancellations) AS cancellations,
    ROUND(
        SUM(delayed_orders)::NUMERIC / NULLIF(SUM(demand), 0) * 100,
        2
    ) AS delay_rate,
    ROUND(
        SUM(cancellations)::NUMERIC / NULLIF(SUM(demand), 0) * 100,
        2
    ) AS cancellation_rate
FROM operations
GROUP BY
    CASE
        WHEN demand > available_capacity THEN 'Over Capacity'
        ELSE 'Within Capacity'
    END
ORDER BY capacity_status;


SELECT
    CASE
        WHEN demand > available_capacity THEN 'Critical'
        WHEN demand >= available_capacity * 0.90 THEN 'High'
        WHEN demand >= available_capacity * 0.75 THEN 'Moderate'
        ELSE 'Low'
    END AS risk_level,
    COUNT(*) AS operational_days,
    ROUND(AVG(demand), 2) AS avg_demand,
    ROUND(AVG(available_capacity), 2) AS avg_capacity,
    ROUND(AVG(demand - available_capacity), 2) AS avg_capacity_gap
FROM operations
GROUP BY
    CASE
        WHEN demand > available_capacity THEN 'Critical'
        WHEN demand >= available_capacity * 0.90 THEN 'High'
        WHEN demand >= available_capacity * 0.75 THEN 'Moderate'
        ELSE 'Low'
    END
ORDER BY
    CASE
        WHEN
            CASE
                WHEN demand > available_capacity THEN 'Critical'
                WHEN demand >= available_capacity * 0.90 THEN 'High'
                WHEN demand >= available_capacity * 0.75 THEN 'Moderate'
                ELSE 'Low'
            END = 'Critical' THEN 1
        WHEN
            CASE
                WHEN demand > available_capacity THEN 'Critical'
                WHEN demand >= available_capacity * 0.90 THEN 'High'
                WHEN demand >= available_capacity * 0.75 THEN 'Moderate'
                ELSE 'Low'
            END = 'High' THEN 2
        WHEN
            CASE
                WHEN demand > available_capacity THEN 'Critical'
                WHEN demand >= available_capacity * 0.90 THEN 'High'
                WHEN demand >= available_capacity * 0.75 THEN 'Moderate'
                ELSE 'Low'
            END = 'Moderate' THEN 3
        ELSE 4
    END;


SELECT
    location,
    COUNT(*) AS critical_days,
    ROUND(
        COUNT(*) FILTER (WHERE demand > available_capacity)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS critical_day_rate,
    ROUND(AVG(demand - available_capacity), 2) AS avg_capacity_gap
FROM operations
GROUP BY location
ORDER BY critical_day_rate DESC;



SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    SUM(demand) AS actual_demand,
    SUM(available_capacity) AS total_capacity,
    SUM(demand) - SUM(available_capacity) AS capacity_gap
FROM operations
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;