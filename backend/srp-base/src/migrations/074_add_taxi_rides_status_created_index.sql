ALTER TABLE taxi_rides
  ADD INDEX IF NOT EXISTS idx_taxi_status_created_at (status, created_at);
