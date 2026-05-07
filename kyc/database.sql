-- Create database
CREATE DATABASE IF NOT EXISTS kyc_banking;
USE kyc_banking;

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(30) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    id_proof_type VARCHAR(30) NOT NULL,
    id_proof_number VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    occupation VARCHAR(50) NOT NULL,
    annual_income DECIMAL(15,2) NOT NULL,
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    registration_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    account_number VARCHAR(20),
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (kyc_status),
    INDEX idx_mobile (mobile_number),
    INDEX idx_email (email)
);

-- Bank accounts table
CREATE TABLE IF NOT EXISTS bank_accounts (
    account_number VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(30) NOT NULL,
    account_type VARCHAR(30) DEFAULT 'SAVINGS',
    balance DECIMAL(15,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    ifsc_code VARCHAR(20) NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_customer (customer_id),
    INDEX idx_status (status)
);

-- KYC validation logs table
CREATE TABLE IF NOT EXISTS kyc_validation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(30) NOT NULL,
    validation_result VARCHAR(20) NOT NULL,
    passed_checks INT NOT NULL,
    total_checks INT NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_customer (customer_id),
    INDEX idx_result (validation_result)
);

-- Create stored procedure for KYC statistics
DELIMITER //
CREATE PROCEDURE GetKYCStatistics()
BEGIN
    SELECT 
        COUNT(*) AS total_applications,
        SUM(CASE WHEN kyc_status = 'VERIFIED' THEN 1 ELSE 0 END) AS verified,
        SUM(CASE WHEN kyc_status = 'REJECTED' THEN 1 ELSE 0 END) AS rejected,
        SUM(CASE WHEN kyc_status = 'PENDING' THEN 1 ELSE 0 END) AS pending,
        SUM(CASE WHEN kyc_status = 'UNDER_REVIEW' THEN 1 ELSE 0 END) AS under_review
    FROM customers;
END//
DELIMITER ;

-- Insert sample data
INSERT INTO customers (customer_id, full_name, date_of_birth, id_proof_type, id_proof_number, 
    address, city, state, pin_code, mobile_number, email, occupation, annual_income, kyc_status, account_number) 
VALUES 
('CUST-20241215-ABC123', 'Rahul Kumar Sharma', '1990-05-15', 'AADHAAR', '234567890123',
    '123 MG Road, Sector 5', 'Bengaluru', 'Karnataka', '560001', '9876543210', 
    'rahul.sharma@email.com', 'Software Engineer', 850000.00, 'VERIFIED', '1234567890123456');

INSERT INTO bank_accounts (account_number, customer_id, account_type, balance, ifsc_code, branch_name)
VALUES ('1234567890123456', 'CUST-20241215-ABC123', 'SAVINGS', 5000.00, 'BNKY0001234', 'Main Branch');

-- Create user for application
CREATE USER IF NOT EXISTS 'kyc_user'@'localhost' IDENTIFIED BY 'SecureBank@2024';
GRANT ALL PRIVILEGES ON kyc_banking.* TO 'kyc_user'@'localhost';
FLUSH PRIVILEGES;