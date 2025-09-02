CREATE TABLE IF NOT EXISTS scoreboard_players (
  character_id INT NOT NULL PRIMARY KEY,
  account_id INT NOT NULL,
  display_name VARCHAR(64) NOT NULL,
  ping INT NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_account_id (account_id),
  CONSTRAINT fk_scoreboard_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
  CONSTRAINT fk_scoreboard_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
