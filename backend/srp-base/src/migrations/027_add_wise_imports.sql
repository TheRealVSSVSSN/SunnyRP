CREATE TABLE IF NOT EXISTS wise_import_orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  model VARCHAR(64) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'pending',
  created_at BIGINT NOT NULL,
  INDEX idx_wise_import_orders_character (character_id)
);
