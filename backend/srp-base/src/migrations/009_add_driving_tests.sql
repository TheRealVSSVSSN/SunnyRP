-- 009_add_driving_tests.sql
-- Adds the driving_tests table to store completed driving tests.  Each
-- record includes the student CID, instructor CID, instructor name,
-- timestamp, numeric score, pass/fail status and a JSON encoded
-- results payload.  Indexes are added on cid and icid to support
-- lookup by student and instructor.  The migration is idempotent.

CREATE TABLE IF NOT EXISTS driving_tests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cid VARCHAR(64) NOT NULL,
  icid VARCHAR(64) NOT NULL,
  instructor VARCHAR(255) NOT NULL,
  timestamp INT NOT NULL,
  points INT NOT NULL,
  passed TINYINT(1) NOT NULL DEFAULT 0,
  results JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_driving_tests_cid (cid),
  INDEX idx_driving_tests_icid (icid)
);