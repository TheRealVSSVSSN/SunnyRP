-- Create invoices table for character billing
CREATE TABLE IF NOT EXISTS invoices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  from_character_id VARCHAR(64) NOT NULL,
  to_character_id VARCHAR(64) NOT NULL,
  amount BIGINT NOT NULL,
  reason VARCHAR(255) NULL,
  status ENUM('pending','paid','cancelled') NOT NULL DEFAULT 'pending',
  due_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_invoices_to_character (to_character_id),
  INDEX idx_invoices_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
