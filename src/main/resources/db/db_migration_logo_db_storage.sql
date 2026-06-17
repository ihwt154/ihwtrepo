-- ============================================================
-- Migration: Add logo binary storage columns to company_central_config
-- Target Database: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

ALTER TABLE `company_central_config`
ADD COLUMN `logo_data` LONGBLOB DEFAULT NULL,
ADD COLUMN `logo_content_type` VARCHAR(255) DEFAULT NULL;
