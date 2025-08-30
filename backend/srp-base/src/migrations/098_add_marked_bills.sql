CREATE TABLE IF NOT EXISTS character_marked_bills (
  character_id BIGINT NOT NULL PRIMARY KEY,
  amount INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_character_marked_bills_character FOREIGN KEY (character_id)
    REFERENCES characters(id) ON DELETE CASCADE
);
