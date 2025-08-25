CREATE TABLE IF NOT EXISTS world_timecycle (
  id INT AUTO_INCREMENT PRIMARY KEY,
  preset VARCHAR(64) NOT NULL,
  expires_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_world_timecycle_created_at ON world_timecycle (created_at);
