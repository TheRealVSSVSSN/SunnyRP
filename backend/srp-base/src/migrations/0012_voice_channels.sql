CREATE TABLE IF NOT EXISTS voice_channels (
  channel_id VARCHAR(64) NOT NULL,
  character_id BIGINT NOT NULL,
  joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (channel_id, character_id),
  INDEX idx_voice_joined_at (joined_at),
  CONSTRAINT fk_voice_character FOREIGN KEY (character_id) REFERENCES characters(id)
);
