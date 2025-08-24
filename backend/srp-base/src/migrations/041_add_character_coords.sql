CREATE TABLE IF NOT EXISTS character_coords (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  z FLOAT NOT NULL,
  heading FLOAT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_character_name (character_id, name),
  INDEX idx_character_coords_character_id (character_id),
  CONSTRAINT fk_character_coords_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
