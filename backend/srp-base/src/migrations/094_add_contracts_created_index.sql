-- Migration 094_add_contracts_created_index.sql
--
-- Add index on contracts.created_at to accelerate expiry purges.

ALTER TABLE contracts
  ADD INDEX IF NOT EXISTS idx_contracts_created_at (created_at);
