CREATE TABLE IF NOT EXISTS properties (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type ENUM('APARTMENT','GARAGE','HOTEL_ROOM') NOT NULL,
  name VARCHAR(255) NOT NULL,
  location JSON NULL,
  price INT NOT NULL DEFAULT 0,
  owner_character_id INT NULL,
  expires_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_properties_owner (owner_character_id),
  INDEX idx_properties_expires_at (expires_at),
  CONSTRAINT fk_properties_owner FOREIGN KEY (owner_character_id) REFERENCES characters(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
