ALTER TABLE zones
  ADD COLUMN IF NOT EXISTS expires_at TIMESTAMP NULL DEFAULT NULL;

CREATE INDEX IF NOT EXISTS idx_zones_expires_at ON zones (expires_at);
