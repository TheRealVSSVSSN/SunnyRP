CREATE TABLE IF NOT EXISTS connection_queue (
  account_id BIGINT UNSIGNED NOT NULL,
  priority INT NOT NULL DEFAULT 0,
  enqueued_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (account_id),
  INDEX idx_enqueued_at (enqueued_at)
);
