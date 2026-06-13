-- ============================================================
-- Migration: Create company_central_config table
-- Run this script once on the ihwthms database
-- ============================================================

CREATE TABLE IF NOT EXISTS `company_central_config` (
    `id`                                       INT AUTO_INCREMENT PRIMARY KEY,

    -- Organisation Info
    `company_name`                             VARCHAR(255),
    `company_address`                          TEXT,
    `company_central_number`                   VARCHAR(50),
    `centralized_email`                        VARCHAR(255),
    `company_gst_number`                       VARCHAR(50),
    `website`                                  VARCHAR(255),
    `baseUrl`                                  VARCHAR(512),
    `escalationEmail`                          VARCHAR(255),
    `escalationPhone`                          VARCHAR(50),

    -- Bank Details
    `accountName`                              VARCHAR(255),
    `bank_name`                                VARCHAR(255),
    `account_number`                           VARCHAR(100),
    `ifsc_code`                                VARCHAR(50),
    `branch`                                   VARCHAR(255),

    -- Watcher Settings
    `global_watcher_emails`                    TEXT,
    `global_watcher_enabled`                   TINYINT(1) DEFAULT 0,

    -- Social Media
    `facebook_link`                            VARCHAR(512),
    `instagram_link`                           VARCHAR(512),
    `linkedin_link`                            VARCHAR(512),
    `youtube_link`                             VARCHAR(512),
    `x_link`                                   VARCHAR(512),

    -- Branding
    `logo_path`                                VARCHAR(512),

    -- Quotation
    `quotationTopCover`                        TEXT,
    `inclusions`                               LONGTEXT,
    `tnc`                                      LONGTEXT,
    `usp`                                      LONGTEXT,
    `companyInfo`                              LONGTEXT,

    -- WhatsApp
    `whats_app_api_url`                        VARCHAR(512),
    `whats_app_api_key`                        VARCHAR(255),
    `whats_app_registration_template_id`       VARCHAR(100),
    `whats_app_stay_quotation_template_id`     VARCHAR(100),
    `whats_app_guest_quotation_template_id`    VARCHAR(100),

    -- Email / SMTP
    `email_smtp_host`                          VARCHAR(255),
    `email_smtp_port`                          VARCHAR(10),
    `email_smtp_username`                      VARCHAR(255),
    `email_smtp_password`                      VARCHAR(255),
    `email_from_address`                       VARCHAR(255),
    `email_reply_to`                           VARCHAR(255),
    `email_default_cc`                         VARCHAR(500),
    `email_notify_to`                          VARCHAR(500),
    `email_client_active`                      VARCHAR(10) DEFAULT 'true',
    `email_internal_active`                    VARCHAR(10) DEFAULT 'true'
);

-- Insert a blank default row so the settings form has something to load
INSERT IGNORE INTO `company_central_config` (`id`, `company_name`)
VALUES (1, 'IHWT Federation');
