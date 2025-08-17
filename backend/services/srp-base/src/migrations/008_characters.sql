-- 008_characters.sql
-- Characters table for SunnyRP (authoritative in backend)
CREATE TABLE IF NOT EXISTS characters (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  owner_hex VARCHAR(64) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE NULL,
  gender VARCHAR(16) NULL,
  phone_number VARCHAR(20) NOT NULL,
  story TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uniq_character_name (first_name, last_name),
  UNIQUE KEY uniq_phone (phone_number),
  KEY idx_owner_hex (owner_hex)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;