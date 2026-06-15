-- ============================================================
-- Migration: Create client_source and client_type tables
-- Run this script on the ihwtdb database
-- ============================================================

CREATE TABLE IF NOT EXISTS `client_source` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `source_name` varchar(100) NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `client_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(100) NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
);

-- Seed initial data
INSERT INTO `client_source` (`id`, `source_name`, `active`) VALUES
(1, 'Google', 1),
(2, 'Referral', 1),
(3, 'Website', 1),
(4, 'Social Media', 1)
ON DUPLICATE KEY UPDATE `source_name` = VALUES(`source_name`);

INSERT INTO `client_type` (`id`, `type_name`, `active`) VALUES
(1, 'Individual', 1),
(2, 'Corporate', 1),
(3, 'VIP', 1),
(4, 'Partner', 1)
ON DUPLICATE KEY UPDATE `type_name` = VALUES(`type_name`);
