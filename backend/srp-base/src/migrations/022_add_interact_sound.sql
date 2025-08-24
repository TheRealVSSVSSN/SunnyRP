CREATE TABLE IF NOT EXISTS interact_sound_plays (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id VARCHAR(64) NOT NULL,
  sound VARCHAR(128) NOT NULL,
  volume FLOAT NOT NULL,
  played_at BIGINT NOT NULL,
  INDEX idx_interact_sound_character (character_id),
  INDEX idx_interact_sound_played_at (played_at)
);
