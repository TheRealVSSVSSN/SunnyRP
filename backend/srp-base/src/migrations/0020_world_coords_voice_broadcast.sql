-- 0020_world_coords_voice_broadcast.sql
-- Adds coordinate saving, spawn tracking, and voice broadcast state.
CREATE TABLE IF NOT EXISTS character_coords (
  character_id BIGINT PRIMARY KEY,
  x DOUBLE NOT NULL,
  y DOUBLE NOT NULL,
  z DOUBLE NOT NULL,
  heading DOUBLE NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_character_coords_character FOREIGN KEY (character_id)
    REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS character_spawns (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  character_id BIGINT NOT NULL,
  x DOUBLE NOT NULL,
  y DOUBLE NOT NULL,
  z DOUBLE NOT NULL,
  heading DOUBLE NOT NULL,
  spawned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_character_spawns_character_id (character_id),
  CONSTRAINT fk_character_spawns_character FOREIGN KEY (character_id)
    REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS voice_broadcast (
  character_id BIGINT PRIMARY KEY,
  active TINYINT(1) NOT NULL DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_voice_broadcast_character FOREIGN KEY (character_id)
    REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB;
