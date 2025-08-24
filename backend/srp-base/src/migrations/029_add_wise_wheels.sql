CREATE TABLE IF NOT EXISTS wise_wheels_spins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  prize VARCHAR(255) NOT NULL,
  created_at BIGINT NOT NULL,
  INDEX idx_wise_wheels_character (character_id)
);
