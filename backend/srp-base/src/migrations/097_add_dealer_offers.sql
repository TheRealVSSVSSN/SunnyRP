CREATE TABLE IF NOT EXISTS dealer_offers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  item VARCHAR(100) NOT NULL,
  price INT NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_dealer_offers_expires_at (expires_at)
);
