-- ============================================================
-- Migration: Migrate city free-text fields to foreign keys
-- Target Database: MySQL
-- Run this script on the ihwtdb database
-- ============================================================

-- 1. Ensure city table exists
CREATE TABLE IF NOT EXISTS city (
    city_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Populate city table with existing distinct cities from client and leads_master (ignoring null/empty)
INSERT IGNORE INTO city (city_name)
SELECT DISTINCT TRIM(city) FROM client WHERE city IS NOT NULL AND TRIM(city) != '';

INSERT IGNORE INTO city (city_name)
SELECT DISTINCT TRIM(city) FROM leads_master WHERE city IS NOT NULL AND TRIM(city) != '';

-- 3. Add city_id column to client table
ALTER TABLE client ADD COLUMN city_id BIGINT DEFAULT NULL;

-- 4. Add city_id column to leads_master table
ALTER TABLE leads_master ADD COLUMN city_id BIGINT DEFAULT NULL;

-- 5. Update city_id values in client table
UPDATE client cl
JOIN city ci ON TRIM(cl.city) = ci.city_name
SET cl.city_id = ci.city_id;

-- 6. Update city_id values in leads_master table
UPDATE leads_master lm
JOIN city ci ON TRIM(lm.city) = ci.city_name
SET lm.city_id = ci.city_id;

-- 7. Add foreign key constraints
ALTER TABLE client
ADD CONSTRAINT fk_client_city FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE leads_master
ADD CONSTRAINT fk_lead_city FOREIGN KEY (city_id) REFERENCES city(city_id);

-- 8. Drop old free-text city columns to clean up
ALTER TABLE client DROP COLUMN city;
ALTER TABLE leads_master DROP COLUMN city;
