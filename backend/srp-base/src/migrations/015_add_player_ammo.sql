-- Migration 015: add player_ammo table
--
-- Creates a table to persist ammunition counts per player and weapon type.
-- Ammo counts are keyed by the combination of player_id and weapon_type.

CREATE TABLE IF NOT EXISTS player_ammo (
  player_id VARCHAR(64) NOT NULL,
  weapon_type VARCHAR(100) NOT NULL,
  ammo INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (player_id, weapon_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index to speed up lookups by player ID
CREATE INDEX IF NOT EXISTS idx_player_ammo_player_id ON player_ammo (player_id);