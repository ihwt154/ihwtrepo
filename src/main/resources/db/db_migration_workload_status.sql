-- ============================================================
-- Migration: Create workload_status table
-- Run this script once on the ihwthms database
-- ============================================================

CREATE TABLE IF NOT EXISTS `workload_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workloadStatusId` int(11) DEFAULT NULL,
  `workloadStatusObj` varchar(255) DEFAULT NULL,
  `workloadStatusObjType` varchar(255) DEFAULT NULL,
  `workloadStatusName` varchar(255) DEFAULT NULL,
  `workloadCategory` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
);

-- Insert requested Lead Status values
INSERT INTO `workload_status` (`id`, `workloadStatusId`, `workloadStatusObj`, `workloadStatusObjType`, `workloadStatusName`, `workloadCategory`, `active`)
VALUES
(1, 101, 'LEAD_STATUS', 'LEAD_STATUS', 'Open', 1000, 1),
(2, 102, 'LEAD_STATUS', 'LEAD_STATUS', 'Work In Progress', 1000, 1),
(3, 103, 'LEAD_STATUS', 'LEAD_STATUS', 'Failed-Closed', 2000, 1),
(4, 104, 'LEAD_STATUS', 'LEAD_STATUS', 'Won-Converted', 2000, 1),
(5, 105, 'LEAD_STATUS', 'LEAD_STATUS', 'Duplicate', 2000, 1);
