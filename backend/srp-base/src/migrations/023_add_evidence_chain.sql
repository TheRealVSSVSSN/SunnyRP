-- Add evidence_chain table to track custody events for evidence items
CREATE TABLE IF NOT EXISTS evidence_chain (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  evidence_id BIGINT NOT NULL,
  handler_id BIGINT NOT NULL,
  action VARCHAR(50) NOT NULL,
  notes TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_evidence_id (evidence_id),
  CONSTRAINT fk_chain_evidence FOREIGN KEY (evidence_id) REFERENCES evidence_items (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
