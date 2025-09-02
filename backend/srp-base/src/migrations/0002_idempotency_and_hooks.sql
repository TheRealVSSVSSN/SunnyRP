-- 0002_idempotency_and_hooks.sql
-- Adds idempotency key storage and webhook endpoints table

CREATE TABLE IF NOT EXISTS idempotency_keys (
  `key` VARCHAR(100) PRIMARY KEY,
  expires_at DATETIME NOT NULL,
  INDEX idx_idempotency_expires (expires_at)
);

CREATE TABLE IF NOT EXISTS webhook_endpoints (
  id INT AUTO_INCREMENT PRIMARY KEY,
  url VARCHAR(255) NOT NULL,
  secret VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
