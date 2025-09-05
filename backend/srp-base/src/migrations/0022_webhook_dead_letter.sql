--[[
-- Type: Migration
-- Name: Create webhook_dead_letter table
-- Created: 2025-09-05
-- By: VSSVSSN
--]]
CREATE TABLE IF NOT EXISTS webhook_dead_letter (
  id INT AUTO_INCREMENT PRIMARY KEY,
  url VARCHAR(512) NOT NULL,
  secret VARCHAR(255) NOT NULL,
  payload JSON NOT NULL,
  attempts INT NOT NULL DEFAULT 0,
  next_attempt_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_webhook_dead_letter_next_attempt ON webhook_dead_letter (next_attempt_at);
