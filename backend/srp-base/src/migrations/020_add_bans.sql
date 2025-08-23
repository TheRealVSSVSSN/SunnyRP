-- Create bans table for player moderation.
-- Stores ban reason and optional expiry.

CREATE TABLE IF NOT EXISTS bans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  reason VARCHAR(255) NOT NULL,
  until DATETIME NULL DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_bans_player (player_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
