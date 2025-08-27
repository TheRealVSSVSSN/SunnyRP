CREATE INDEX IF NOT EXISTS idx_hardcap_sessions_disconnected_connected
  ON hardcap_sessions (disconnected_at, connected_at);
