CREATE TABLE IF NOT EXISTS jailbreak_attempts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  prison VARCHAR(50) NOT NULL,
  status ENUM('active','completed','failed') NOT NULL DEFAULT 'active',
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ended_at TIMESTAMP NULL,
  success TINYINT(1) NULL,
  INDEX idx_jailbreak_attempts_status (status),
  INDEX idx_jailbreak_attempts_character_id (character_id),
  CONSTRAINT fk_jailbreak_attempts_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
