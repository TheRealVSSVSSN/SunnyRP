-- 0003_auth_tokens.sql
-- Adds password hash column and refresh token storage
ALTER TABLE accounts
  ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255) NOT NULL AFTER username;

CREATE TABLE IF NOT EXISTS auth_tokens (
  token VARCHAR(255) PRIMARY KEY,
  account_id INT NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  CONSTRAINT fk_auth_tokens_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  INDEX idx_auth_tokens_account_id (account_id),
  INDEX idx_auth_tokens_expires_at (expires_at)
);
