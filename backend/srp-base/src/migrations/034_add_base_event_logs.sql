-- Record base player events
CREATE TABLE IF NOT EXISTS base_event_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id VARCHAR(64) NOT NULL,
  character_id BIGINT NOT NULL,
  event_type VARCHAR(50) NOT NULL,
  metadata JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_character_id (character_id),
  KEY idx_event_type (event_type),
  CONSTRAINT fk_base_event_account FOREIGN KEY (account_id) REFERENCES users (hex_id) ON DELETE CASCADE,
  CONSTRAINT fk_base_event_character FOREIGN KEY (character_id) REFERENCES characters (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
