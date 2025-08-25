-- EMS shift logs track on-duty periods for medics.
CREATE TABLE IF NOT EXISTS ems_shift_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT NOT NULL,
  start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  end_time TIMESTAMP NULL DEFAULT NULL,
  INDEX idx_ems_shift_character (character_id),
  CONSTRAINT fk_ems_shift_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
);
