CREATE TABLE IF NOT EXISTS character_emotes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  emote VARCHAR(64) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_character_emote (character_id, emote),
  INDEX idx_character_emotes_character_id (character_id),
  CONSTRAINT fk_character_emotes_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
