-- Adds character_jobs table for character-scoped job assignments with grade tracking
CREATE TABLE IF NOT EXISTS character_jobs (
  character_id BIGINT NOT NULL,
  job_id INT NOT NULL,
  grade INT DEFAULT 0,
  on_duty TINYINT(1) DEFAULT 0,
  hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id, job_id),
  CONSTRAINT fk_character_jobs_character FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
  CONSTRAINT fk_character_jobs_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
