-- ============================================================
-- Migration: Add Client and Lead expansion columns
-- Target Database: MySQL
-- Run this script on the ihwtdb database
-- ============================================================

-- 1. Add columns to the `client` table
ALTER TABLE `client` ADD COLUMN `clientSource` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `clientType` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `organization_name` VARCHAR(200) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `organization_type` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `registration_number` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `website` VARCHAR(200) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `address` TEXT DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `postal_code` VARCHAR(20) DEFAULT NULL;
ALTER TABLE `client` ADD COLUMN `designation` VARCHAR(100) DEFAULT NULL;

-- 2. Add columns to the `leads_master` table
ALTER TABLE `leads_master` ADD COLUMN `leadTitle` VARCHAR(200) DEFAULT NULL;
ALTER TABLE `leads_master` ADD COLUMN `eventName` VARCHAR(200) DEFAULT NULL;

-- 3. Modify columns in the `leads_master` table
ALTER TABLE `leads_master` MODIFY COLUMN `leadSource` VARCHAR(100) DEFAULT NULL;
