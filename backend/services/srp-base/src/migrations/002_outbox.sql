-- migrations/002_outbox.sql

CREATE TABLE IF NOT EXISTS outbox (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  topic VARCHAR(64) NOT NULL,
  payload JSON NOT NULL,
  status ENUM('pending','delivered','failed') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_outbox_status ON outbox (status);
CREATE INDEX idx_outbox_topic ON outbox (topic);