ALTER TABLE wise_import_orders
  ADD COLUMN IF NOT EXISTS updated_at BIGINT NOT NULL DEFAULT 0,
  ADD INDEX IF NOT EXISTS idx_wise_import_orders_status (status);
