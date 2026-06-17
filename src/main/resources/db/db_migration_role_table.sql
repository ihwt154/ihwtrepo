-- ============================================================
-- Migration: Create relational role & user_role_mapping tables
-- Target Database: MySQL / ihwtdb
-- Run ONCE
-- ============================================================

-- 1. Create role table
CREATE TABLE IF NOT EXISTS `role` (
    `role_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `role_name` VARCHAR(100) NOT NULL UNIQUE,
    `role_target` VARCHAR(100) NOT NULL
);

-- 2. Create user_role_mapping join table
CREATE TABLE IF NOT EXISTS `user_role_mapping` (
    `user_id` BIGINT NOT NULL,
    `role_id` BIGINT NOT NULL,
    PRIMARY KEY (`user_id`, `role_id`),
    CONSTRAINT `fk_mapping_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_mapping_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE
);

-- 3. Seed exactly the 7 requested roles
INSERT INTO `role` (`role_id`, `role_name`, `role_target`) VALUES
(1, 'ADMIN', 'PRIV'),
(2, 'USER', 'PRIV'),
(3, 'CLIENT_CREATE', 'CLIENT'),
(4, 'CLIENT_MANAGE', 'CLIENT'),
(5, 'LEADS_CREATE', 'LEADS'),
(6, 'LEADS_MANAGE', 'LEADS'),
(7, 'USER_MANAGE', 'USER')
ON DUPLICATE KEY UPDATE `role_name` = VALUES(`role_name`), `role_target` = VALUES(`role_target`);

-- 4. Associate existing users with the default ADMIN role so they don't lose access
INSERT IGNORE INTO `user_role_mapping` (`user_id`, `role_id`)
SELECT `id`, 1 FROM `users`;
