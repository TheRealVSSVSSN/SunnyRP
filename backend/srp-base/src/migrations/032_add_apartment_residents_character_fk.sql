-- Ensure apartment_residents uses character_id and enforces character linkage
ALTER TABLE apartment_residents
  ADD COLUMN IF NOT EXISTS character_id BIGINT NOT NULL AFTER apartment_id,
  ADD INDEX IF NOT EXISTS idx_apartment_residents_character_id (character_id);

UPDATE apartment_residents
  SET character_id = player_id
  WHERE character_id IS NULL AND player_id IS NOT NULL;

ALTER TABLE apartment_residents
  DROP COLUMN IF EXISTS player_id;

-- Add foreign key if missing
SET @fk := (
  SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'apartment_residents'
    AND COLUMN_NAME = 'character_id'
    AND REFERENCED_TABLE_NAME = 'characters'
  LIMIT 1
);
SET @sql := IF(
  @fk IS NULL,
  'ALTER TABLE apartment_residents ADD CONSTRAINT fk_apartment_residents_character FOREIGN KEY (character_id) REFERENCES characters(id)',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
