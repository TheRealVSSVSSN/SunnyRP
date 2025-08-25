CREATE TABLE IF NOT EXISTS k9_units (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  name VARCHAR(50) NOT NULL,
  breed VARCHAR(50) NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  retired_at TIMESTAMP NULL,
  CONSTRAINT fk_k9_units_character FOREIGN KEY (character_id) REFERENCES characters(id)
);

CREATE INDEX IF NOT EXISTS idx_k9_units_character_id ON k9_units (character_id);
CREATE INDEX IF NOT EXISTS idx_k9_units_active ON k9_units (active);
