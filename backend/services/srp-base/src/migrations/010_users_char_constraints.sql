-- backend/services/srp-base/src/migrations/010_users_char_constraints.sql
-- Adds/ensures user/character constraints, non-destructive.

-- USERS
-- Ensure primary/unique on hex_id
ALTER TABLE users
  ADD UNIQUE KEY IF NOT EXISTS uniq_users_hex_id (hex_id);

-- CHARACTERS
-- Unique name pair and phone; index for owner
ALTER TABLE characters
  ADD UNIQUE KEY IF NOT EXISTS uniq_character_name (first_name, last_name),
  ADD UNIQUE KEY IF NOT EXISTS uniq_character_phone (phone_number),
  ADD KEY IF NOT EXISTS idx_char_owner_hex (owner_hex);

-- DOWN (manual rollback if needed)
-- ALTER TABLE characters DROP INDEX uniq_character_name;
-- ALTER TABLE characters DROP INDEX uniq_character_phone;
-- ALTER TABLE characters DROP INDEX idx_char_owner_hex;
-- ALTER TABLE users DROP INDEX uniq_users_hex_id;