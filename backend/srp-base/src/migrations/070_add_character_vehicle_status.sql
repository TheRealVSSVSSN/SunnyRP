CREATE TABLE IF NOT EXISTS character_vehicle_status (
  character_id INT NOT NULL PRIMARY KEY,
  seatbelt TINYINT(1) NOT NULL DEFAULT 0,
  harness TINYINT(1) NOT NULL DEFAULT 0,
  nitrous INT NOT NULL DEFAULT 0,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_vehicle_status_character FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX IF NOT EXISTS idx_character_vehicle_status_updated_at
  ON character_vehicle_status(updated_at);
