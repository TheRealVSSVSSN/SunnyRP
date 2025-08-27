-- Index retrieved_at for purge performance
CREATE INDEX IF NOT EXISTS idx_garage_vehicles_retrieved ON garage_vehicles (retrieved_at);

