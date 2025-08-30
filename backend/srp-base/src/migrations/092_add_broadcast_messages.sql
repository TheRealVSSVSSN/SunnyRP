CREATE TABLE IF NOT EXISTS broadcast_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  message VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_broadcast_messages_created_at (created_at),
  FOREIGN KEY (character_id) REFERENCES characters(id)
);
