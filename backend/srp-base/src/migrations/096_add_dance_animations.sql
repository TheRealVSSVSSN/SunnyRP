CREATE TABLE IF NOT EXISTS dance_animations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  dict VARCHAR(128) NOT NULL,
  animation VARCHAR(128) NOT NULL,
  disabled TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_dance (name, dict, animation),
  INDEX idx_dance_animations_disabled_updated_at (disabled, updated_at)
);
