-- ============================================================
-- Migration: Add custom profile fields to users table
-- Target Database: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

ALTER TABLE `users`
ADD COLUMN `designation` VARCHAR(100) DEFAULT NULL,
ADD COLUMN `company_email` VARCHAR(100) DEFAULT NULL,
ADD COLUMN `company_mobile` VARCHAR(20) DEFAULT NULL,
ADD COLUMN `personal_email` VARCHAR(100) DEFAULT NULL,
ADD COLUMN `mobile` VARCHAR(20) DEFAULT NULL,
ADD COLUMN `dob` DATE DEFAULT NULL,
ADD COLUMN `doj` DATE DEFAULT NULL,
ADD COLUMN `system_user` VARCHAR(50) DEFAULT NULL,
ADD COLUMN `address` VARCHAR(255) DEFAULT NULL;
