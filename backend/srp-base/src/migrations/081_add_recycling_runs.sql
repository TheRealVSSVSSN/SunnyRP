-- Adds recycling_runs table for recycling job deliveries.
CREATE TABLE IF NOT EXISTS recycling_runs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  materials INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_recycling_runs_character_created (character_id, created_at)
);
