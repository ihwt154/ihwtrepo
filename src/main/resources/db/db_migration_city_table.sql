-- ============================================================
-- Migration: Create city table for dropdowns
-- Target Database: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

CREATE TABLE IF NOT EXISTS city (
    city_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
