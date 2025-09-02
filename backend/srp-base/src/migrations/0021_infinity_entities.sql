-- 0021_infinity_entities.sql
-- Track coordinates for streamed entities.
CREATE TABLE IF NOT EXISTS infinity_entities (
  entity_id BIGINT PRIMARY KEY,
  x DOUBLE NOT NULL,
  y DOUBLE NOT NULL,
  z DOUBLE NOT NULL,
  heading DOUBLE NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE INDEX idx_infinity_entities_updated_at ON infinity_entities(updated_at);
