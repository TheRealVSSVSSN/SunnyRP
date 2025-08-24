-- Chat message logging
CREATE TABLE IF NOT EXISTS chat_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  channel VARCHAR(32) NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_chat_character (character_id),
  CONSTRAINT fk_chat_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
