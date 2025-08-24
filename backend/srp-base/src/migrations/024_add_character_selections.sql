-- Track active character selection per account
CREATE TABLE IF NOT EXISTS character_selections (
  owner_hex VARCHAR(64) NOT NULL PRIMARY KEY,
  character_id BIGINT NOT NULL,
  selected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_selection_character FOREIGN KEY (character_id) REFERENCES characters (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
