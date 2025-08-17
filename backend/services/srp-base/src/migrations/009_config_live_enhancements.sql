-- backend/services/srp-base/src/migrations/009_config_live_enhancements.sql
-- Normalize config_live and add admin_audit if missing.
-- Safe to run multiple times.

CREATE TABLE IF NOT EXISTS config_live (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  value JSON NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add index if missing (MySQL-safe via dynamic SQL)
SET @idx_exists := (
  SELECT COUNT(1)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'config_live'
    AND INDEX_NAME = 'idx_config_live_updated_at'
);
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE config_live ADD INDEX idx_config_live_updated_at (updated_at);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Seed a single row if table empty
INSERT INTO config_live (value)
SELECT JSON_OBJECT()
WHERE NOT EXISTS (SELECT 1 FROM config_live);

-- Admin audit (append-only)
CREATE TABLE IF NOT EXISTS admin_audit (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  event VARCHAR(64) NOT NULL,
  actor VARCHAR(128) NULL,
  meta JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Convenience view for the latest row
DROP VIEW IF EXISTS v_config_live_latest;
CREATE VIEW v_config_live_latest AS
  SELECT id, value, updated_at
    FROM config_live
   ORDER BY id DESC
   LIMIT 1;