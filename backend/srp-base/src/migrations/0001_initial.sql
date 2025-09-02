-- 0001_initial.sql
-- Idempotent initialization of accounts and characters tables
CREATE TABLE IF NOT EXISTS accounts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS characters (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  CONSTRAINT fk_characters_accounts FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  INDEX idx_characters_account_id (account_id)
);

CREATE TABLE IF NOT EXISTS account_selected_character (
  account_id INT PRIMARY KEY,
  character_id INT NOT NULL,
  CONSTRAINT fk_selected_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  CONSTRAINT fk_selected_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
