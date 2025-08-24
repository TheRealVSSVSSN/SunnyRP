-- Rename player_id columns to character_id for multi-character support
-- and adjust transactions columns accordingly.

ALTER TABLE accounts
  ADD COLUMN IF NOT EXISTS character_id VARCHAR(64) NULL AFTER player_id,
  DROP INDEX IF EXISTS uniq_player_account;

UPDATE accounts SET character_id = player_id WHERE character_id IS NULL;

ALTER TABLE accounts
  DROP COLUMN IF EXISTS player_id,
  MODIFY COLUMN character_id VARCHAR(64) NOT NULL,
  ADD UNIQUE KEY uniq_character_account (character_id);

ALTER TABLE transactions
  ADD COLUMN IF NOT EXISTS from_character_id VARCHAR(64) NULL AFTER from_player_id,
  ADD COLUMN IF NOT EXISTS to_character_id VARCHAR(64) NULL AFTER to_player_id;

UPDATE transactions SET from_character_id = from_player_id WHERE from_character_id IS NULL;
UPDATE transactions SET to_character_id = to_player_id WHERE to_character_id IS NULL;

ALTER TABLE transactions
  DROP COLUMN IF EXISTS from_player_id,
  DROP COLUMN IF EXISTS to_player_id;
