CREATE TABLE IF NOT EXISTS diamond_blackjack_hands (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id VARCHAR(64) NOT NULL,
  table_id INT NOT NULL,
  bet INT NOT NULL,
  payout INT NOT NULL,
  dealer_hand VARCHAR(64) NOT NULL,
  player_hand VARCHAR(64) NOT NULL,
  played_at BIGINT NOT NULL,
  INDEX idx_blackjack_character (character_id),
  INDEX idx_blackjack_played_at (played_at)
);
