-- Queue priority table for connection queue
CREATE TABLE IF NOT EXISTS queue_priorities (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  priority INT NOT NULL,
  reason VARCHAR(255) DEFAULT NULL,
  expires_at TIMESTAMP NULL DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_account (account_id),
  CONSTRAINT fk_queue_priorities_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  INDEX idx_queue_priorities_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
