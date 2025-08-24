-- Carwash transactions and vehicle dirt levels
CREATE TABLE IF NOT EXISTS carwash_transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  plate VARCHAR(32) NOT NULL,
  location VARCHAR(64) NOT NULL,
  cost INT NOT NULL,
  washed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_carwash_character (character_id),
  CONSTRAINT fk_carwash_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicle_cleanliness (
  plate VARCHAR(32) PRIMARY KEY,
  dirt_level INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
