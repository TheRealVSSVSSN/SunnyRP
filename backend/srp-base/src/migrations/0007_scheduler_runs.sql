CREATE TABLE IF NOT EXISTS scheduler_runs (
  task_name VARCHAR(100) PRIMARY KEY,
  last_run TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_scheduler_runs_last_run ON scheduler_runs (last_run);
