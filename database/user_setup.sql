-- ===================================================
-- SQL Commands to Create Users & Leads Tables and Seed Admin
-- Target Database: MySQL
-- ===================================================

-- 1. Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Create leads table
CREATE TABLE IF NOT EXISTS leads (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    company_name VARCHAR(100),
    title VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    status_id VARCHAR(50) NOT NULL, -- e.g., 'NEW', 'CONTACTED', 'QUALIFIED', 'LOST'
    source_id VARCHAR(50),
    assigned_to BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_leads_assignee FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
);

-- 3. Seed default admin user (credentials: admin / admin123)
INSERT INTO users (username, password, email, first_name, last_name, is_active)
VALUES ('admin', 'admin123', 'admin@ihwthms.com', 'Admin', 'User', TRUE)
ON DUPLICATE KEY UPDATE username=username;
