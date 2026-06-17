-- ============================================================
-- Migration: Add additional user columns (last_working_day, account_lock, remarks)
-- Target Database: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

ALTER TABLE `users`
ADD COLUMN `last_working_day` DATE DEFAULT NULL,
ADD COLUMN `account_lock` TINYINT(1) NOT NULL DEFAULT 0,
ADD COLUMN `remarks` VARCHAR(1000) DEFAULT NULL;
