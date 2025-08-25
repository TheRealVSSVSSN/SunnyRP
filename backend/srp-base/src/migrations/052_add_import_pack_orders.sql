CREATE TABLE IF NOT EXISTS import_pack_orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  package VARCHAR(64) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'pending',
  created_at BIGINT NOT NULL,
  delivered_at BIGINT DEFAULT NULL,
  CONSTRAINT fk_import_pack_orders_character FOREIGN KEY (character_id) REFERENCES characters(id),
  INDEX idx_import_pack_orders_character (character_id)
);
