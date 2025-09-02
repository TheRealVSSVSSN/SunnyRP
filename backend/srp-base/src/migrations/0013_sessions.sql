CREATE TABLE IF NOT EXISTS users_whitelist (
  account_id INT PRIMARY KEY,
  power INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS session_limits (
  id TINYINT PRIMARY KEY,
  max_players INT NOT NULL
);

INSERT IGNORE INTO session_limits (id, max_players) VALUES (1, 32);
