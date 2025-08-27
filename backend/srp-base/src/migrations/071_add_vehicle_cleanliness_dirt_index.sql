-- Index for carwash dirt queries
CREATE INDEX IF NOT EXISTS idx_vehicle_cleanliness_dirt
  ON vehicle_cleanliness (dirt_level);
