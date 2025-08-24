CREATE TABLE IF NOT EXISTS cron_jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  schedule VARCHAR(100) NOT NULL,
  payload JSON NULL,
  account_id INT NULL,
  character_id INT NULL,
  priority INT NOT NULL DEFAULT 0,
  next_run DATETIME NOT NULL,
  last_run DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_cron_jobs_next_run ON cron_jobs(next_run);
CREATE INDEX IF NOT EXISTS idx_cron_jobs_account ON cron_jobs(account_id);
CREATE INDEX IF NOT EXISTS idx_cron_jobs_character ON cron_jobs(character_id);
