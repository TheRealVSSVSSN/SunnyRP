CREATE TABLE IF NOT EXISTS wise_audio_tracks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  label VARCHAR(255) NOT NULL,
  url VARCHAR(1024) NOT NULL,
  created_at BIGINT NOT NULL,
  INDEX idx_wise_audio_character (character_id)
);
