CREATE INDEX IF NOT EXISTS idx_base_event_logs_type_created_at
  ON base_event_logs (event_type, created_at);
