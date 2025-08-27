-- Rename player_id to character_id on police_officers for multi-character readiness
SET @col := (
  SELECT COLUMN_NAME FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'police_officers' AND COLUMN_NAME = 'player_id'
);
SET @sql := IF(@col = 'player_id', 'ALTER TABLE police_officers RENAME COLUMN player_id TO character_id;', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Ensure index for character lookup
CREATE INDEX IF NOT EXISTS idx_police_officers_character_id ON police_officers(character_id);
