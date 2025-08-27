ALTER TABLE import_pack_orders
  ADD COLUMN IF NOT EXISTS expires_at BIGINT NOT NULL DEFAULT 0 AFTER created_at,
  ADD COLUMN IF NOT EXISTS expired_at BIGINT DEFAULT NULL AFTER canceled_at,
  ADD INDEX IF NOT EXISTS idx_import_pack_orders_status_expires (status, expires_at);
