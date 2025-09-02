CREATE TABLE IF NOT EXISTS session_password (
  id TINYINT PRIMARY KEY,
  password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS character_cids (
  cid INT PRIMARY KEY AUTO_INCREMENT,
  character_id INT UNIQUE NOT NULL,
  FOREIGN KEY (character_id) REFERENCES characters(id)
);

CREATE TABLE IF NOT EXISTS hospitalizations (
  character_id INT PRIMARY KEY,
  admitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (character_id) REFERENCES characters(id)
);
