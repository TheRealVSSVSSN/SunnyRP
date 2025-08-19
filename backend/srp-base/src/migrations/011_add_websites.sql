-- Migration 011_add_websites
--
-- Create the `websites` table to store player‑created websites for the
-- Gurgle phone app.  A website has an auto‑incrementing id, an owner
-- id (character id), a name/title, optional keywords and a
-- description.  Created/updated timestamps are stored.  An index on
-- owner_id is provided to speed up lookups per owner.

CREATE TABLE IF NOT EXISTS websites (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  keywords VARCHAR(255) DEFAULT NULL,
  description TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_websites_owner_id (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;