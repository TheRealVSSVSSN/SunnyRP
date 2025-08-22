-- Migration 018_add_contracts.sql
--
-- Create a contracts table to store agreements between players.
-- Each contract records the sender, receiver, amount in cents,
-- optional info text, whether payment has been made and whether the
-- contract was accepted.  Indices on sender and receiver allow quick
-- lookups for either party.

CREATE TABLE IF NOT EXISTS contracts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sender_id VARCHAR(64) NOT NULL,
  receiver_id VARCHAR(64) NOT NULL,
  amount BIGINT NOT NULL,
  info TEXT DEFAULT NULL,
  paid TINYINT(1) NOT NULL DEFAULT 0,
  accepted TINYINT(1) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_contracts_sender (sender_id),
  INDEX idx_contracts_receiver (receiver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
