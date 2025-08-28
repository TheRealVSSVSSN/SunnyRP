-- Debug logs and markers

CREATE TABLE IF NOT EXISTS debug_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  level VARCHAR(16) NOT NULL,
  message TEXT NOT NULL,
  context JSON NULL,
  account_id VARCHAR(64) NULL,
  character_id BIGINT NULL,
  source VARCHAR(32) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_debug_logs_created_at (created_at),
  INDEX idx_debug_logs_account (account_id),
  INDEX idx_debug_logs_character (character_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS debug_markers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(32) NOT NULL,
  data JSON NOT NULL,
  created_by BIGINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NULL DEFAULT NULL,
  INDEX idx_debug_markers_expires (expires_at),
  INDEX idx_debug_markers_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

