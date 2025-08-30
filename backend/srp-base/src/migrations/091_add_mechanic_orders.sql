CREATE TABLE IF NOT EXISTS mechanic_orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  vehicle_plate VARCHAR(16) NOT NULL,
  character_id INT NOT NULL,
  description VARCHAR(255) NULL,
  status ENUM('pending','completed') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP NULL,
  INDEX idx_mechanic_orders_plate (vehicle_plate),
  INDEX idx_mechanic_orders_status (status),
  FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
