-- ============================================================
-- Migration: Add 'roles' column to users table
-- Target: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

ALTER TABLE `users`
    ADD COLUMN IF NOT EXISTS `roles` VARCHAR(500) DEFAULT 'ROLE_ADMIN';

-- Update existing users to have the full admin role
UPDATE `users` SET `roles` = 'ROLE_ADMIN' WHERE `roles` IS NULL OR `roles` = '';

-- ============================================================
-- For MySQL 5.x (no IF NOT EXISTS):
-- ALTER TABLE `users` ADD COLUMN `roles` VARCHAR(500) DEFAULT 'ROLE_ADMIN';
-- ============================================================
