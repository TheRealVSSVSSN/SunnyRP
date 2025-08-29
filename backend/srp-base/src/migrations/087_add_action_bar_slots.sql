CREATE TABLE IF NOT EXISTS action_bar_slots (
  character_id INT NOT NULL,
  slot TINYINT NOT NULL,
  item VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (character_id, slot),
  CONSTRAINT fk_action_bar_character FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
