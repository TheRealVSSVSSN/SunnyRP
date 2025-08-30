-- Rename crime_school.player_id to character_id and add FK/index
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'crime_school' AND COLUMN_NAME = 'player_id');
SET @stmt := IF(@col = 1, 'ALTER TABLE crime_school CHANGE COLUMN player_id character_id INT NOT NULL', 'SELECT 1');
PREPARE stmt FROM @stmt; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'crime_school' AND INDEX_NAME = 'idx_crime_school_character');
SET @stmt := IF(@idx = 0, 'CREATE INDEX idx_crime_school_character ON crime_school(character_id)', 'SELECT 1');
PREPARE stmt2 FROM @stmt; EXECUTE stmt2; DEALLOCATE PREPARE stmt2;

SET @fk := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'crime_school' AND CONSTRAINT_NAME = 'fk_crime_school_character');
SET @stmt := IF(@fk = 0, 'ALTER TABLE crime_school ADD CONSTRAINT fk_crime_school_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE stmt3 FROM @stmt; EXECUTE stmt3; DEALLOCATE PREPARE stmt3;
