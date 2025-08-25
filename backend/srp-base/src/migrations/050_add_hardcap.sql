-- Hardcap configuration and session tracking
CREATE TABLE IF NOT EXISTS hardcap_config (
  id TINYINT NOT NULL PRIMARY KEY CHECK (id = 1),
  max_players INT NOT NULL,
  reserved_slots INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO hardcap_config (id, max_players, reserved_slots)
SELECT 1, 64, 0 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM hardcap_config WHERE id = 1);

CREATE TABLE IF NOT EXISTS hardcap_sessions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  character_id BIGINT NOT NULL,
  connected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  disconnected_at TIMESTAMP NULL,
  CONSTRAINT fk_hardcap_session_account FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT fk_hardcap_session_character FOREIGN KEY (character_id) REFERENCES characters(id),
  INDEX idx_hardcap_sessions_active (disconnected_at)
);
