-- Add character association to garage_vehicles for multi-character support
ALTER TABLE garage_vehicles
  ADD COLUMN IF NOT EXISTS character_id BIGINT NULL AFTER vehicle_id;

CREATE INDEX IF NOT EXISTS idx_garage_vehicles_character ON garage_vehicles(character_id);
