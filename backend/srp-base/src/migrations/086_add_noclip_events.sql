CREATE TABLE IF NOT EXISTS noclip_events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  actor_id VARCHAR(64) NOT NULL,
  enabled TINYINT(1) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_noclip_player (player_id),
  INDEX idx_noclip_created (created_at)
);
