-- Migration 016: create secondary_jobs table
--
-- This migration introduces a new table to store secondary job
-- assignments for characters.  A secondary job is an additional
-- occupation that a player can hold in parallel with their primary
-- job.  Each record contains the identifier of the character
-- (player_id), the job name and timestamps.  An auto‑increment
-- primary key allows referencing individual assignments.

CREATE TABLE IF NOT EXISTS secondary_jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  job VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index to speed up lookups by player_id.  IF NOT EXISTS guards against
-- duplicate creation when reapplying migrations.
CREATE INDEX IF NOT EXISTS idx_secondary_jobs_player_id ON secondary_jobs (player_id);