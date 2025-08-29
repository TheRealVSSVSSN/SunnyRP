CREATE TABLE IF NOT EXISTS hacking_attempts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  target VARCHAR(64) NOT NULL,
  success TINYINT(1) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
  INDEX idx_hacking_character_id_created_at (character_id, created_at)
);
