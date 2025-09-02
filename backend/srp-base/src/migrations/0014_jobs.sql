CREATE TABLE IF NOT EXISTS jobs (
  name VARCHAR(32) PRIMARY KEY,
  label VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS character_jobs (
  character_id INT NOT NULL,
  job_name VARCHAR(32) NOT NULL,
  grade INT NOT NULL DEFAULT 0,
  is_secondary TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (character_id, job_name, is_secondary),
  FOREIGN KEY (character_id) REFERENCES characters(id),
  FOREIGN KEY (job_name) REFERENCES jobs(name)
);

CREATE INDEX idx_character_jobs_character ON character_jobs(character_id);
