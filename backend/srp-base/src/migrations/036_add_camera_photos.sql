CREATE TABLE IF NOT EXISTS camera_photos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  image_url VARCHAR(1024) NOT NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_camera_photos_character_id (character_id),
  CONSTRAINT fk_camera_photos_character FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
