-- Create table to track hospital admissions.
-- Idempotent: uses IF NOT EXISTS and checks for missing columns/indexes.
CREATE TABLE IF NOT EXISTS hospital_admissions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  bed VARCHAR(50) DEFAULT NULL,
  admitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  discharged_at TIMESTAMP NULL DEFAULT NULL,
  notes TEXT DEFAULT NULL,
  INDEX idx_hospital_admissions_character (character_id),
  INDEX idx_hospital_admissions_active (character_id, discharged_at),
  CONSTRAINT fk_hospital_admissions_character FOREIGN KEY (character_id) REFERENCES characters (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
