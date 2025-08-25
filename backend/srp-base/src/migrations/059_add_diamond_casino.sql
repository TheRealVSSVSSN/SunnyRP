CREATE TABLE IF NOT EXISTS diamond_casino_games (
  id INT AUTO_INCREMENT PRIMARY KEY,
  game_type VARCHAR(32) NOT NULL,
  state VARCHAR(16) NOT NULL DEFAULT 'pending',
  metadata JSON NULL,
  result JSON NULL,
  created_at BIGINT NOT NULL,
  resolved_at BIGINT NULL,
  INDEX idx_game_state (state, created_at)
);

CREATE TABLE IF NOT EXISTS diamond_casino_bets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  game_id INT NOT NULL,
  character_id VARCHAR(64) NOT NULL,
  bet_amount INT NOT NULL,
  bet_data JSON NULL,
  result JSON NULL,
  payout INT DEFAULT 0,
  created_at BIGINT NOT NULL,
  resolved_at BIGINT NULL,
  FOREIGN KEY (game_id) REFERENCES diamond_casino_games(id),
  INDEX idx_bets_game_id (game_id),
  INDEX idx_bets_character (character_id)
);
