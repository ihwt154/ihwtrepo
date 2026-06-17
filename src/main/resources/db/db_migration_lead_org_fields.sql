-- ============================================================
-- Migration: Add org fields to leads_master, drop code columns
-- Target Database: MySQL / ihwtdb
-- Run ONCE on your database after deploying this build
-- ============================================================

-- 1. Add organisation columns to leads_master
--    (these are auto-populated from the linked client on lead creation)
ALTER TABLE `leads_master`
    ADD COLUMN IF NOT EXISTS `organization_name`    VARCHAR(200) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `organization_type`    VARCHAR(100) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `registration_number`  VARCHAR(100) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `website`              VARCHAR(200) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `address`              TEXT         DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `postal_code`          VARCHAR(20)  DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `designation`          VARCHAR(100) DEFAULT NULL;

-- 2. Drop leadCode from leads_master (no longer used)
ALTER TABLE `leads_master`
    DROP COLUMN IF EXISTS `leadCode`;

-- 3. Drop clientCode from client table (no longer used)
ALTER TABLE `client`
    DROP COLUMN IF EXISTS `clientCode`;

-- ============================================================
-- NOTE: MySQL 5.x does not support IF NOT EXISTS / IF EXISTS
-- on ALTER TABLE. If on MySQL 5.x use these instead:
--
-- ALTER TABLE `leads_master` ADD COLUMN `organization_name` VARCHAR(200) DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `organization_type` VARCHAR(100) DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `registration_number` VARCHAR(100) DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `website` VARCHAR(200) DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `address` TEXT DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `postal_code` VARCHAR(20) DEFAULT NULL;
-- ALTER TABLE `leads_master` ADD COLUMN `designation` VARCHAR(100) DEFAULT NULL;
-- ALTER TABLE `leads_master` DROP COLUMN `leadCode`;
-- ALTER TABLE `client` DROP COLUMN `clientCode`;
-- ============================================================
