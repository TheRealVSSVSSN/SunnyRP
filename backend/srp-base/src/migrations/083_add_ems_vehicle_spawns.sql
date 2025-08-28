CREATE TABLE IF NOT EXISTS ems_vehicle_spawns (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id INT NOT NULL,
  vehicle_type VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ems_vehicle_spawns_character_id (character_id),
  CONSTRAINT fk_ems_vehicle_spawns_character FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
