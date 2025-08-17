-- migrations/005_outbox_lock.sql

ALTER TABLE outbox
  ADD COLUMN locked_at TIMESTAMP NULL DEFAULT NULL,
  ADD COLUMN lock_token VARCHAR(64) NULL DEFAULT NULL,
  ADD COLUMN last_error VARCHAR(255) NULL DEFAULT NULL;

CREATE INDEX idx_outbox_locked ON outbox (locked_at);