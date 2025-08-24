CREATE TABLE IF NOT EXISTS interiors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  apartment_id INT NOT NULL,
  character_id BIGINT NOT NULL,
  template JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_apartment (apartment_id),
  KEY idx_character (character_id),
  CONSTRAINT fk_interiors_apartment FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON DELETE CASCADE,
  CONSTRAINT fk_interiors_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
