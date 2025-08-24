CREATE TABLE IF NOT EXISTS wise_uc_profiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  alias VARCHAR(100) NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at BIGINT NOT NULL,
  updated_at BIGINT NOT NULL,
  UNIQUE KEY uniq_character (character_id),
  CONSTRAINT fk_wise_uc_character FOREIGN KEY (character_id) REFERENCES characters(id)
);
