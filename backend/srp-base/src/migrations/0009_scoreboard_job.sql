ALTER TABLE scoreboard_players
  ADD COLUMN IF NOT EXISTS job VARCHAR(32) NOT NULL DEFAULT '' AFTER display_name,
  ADD INDEX IF NOT EXISTS idx_scoreboard_job (job);
