CREATE TABLE IF NOT EXISTS vehicle_control_states (
  plate VARCHAR(8) NOT NULL PRIMARY KEY,
  siren_muted TINYINT(1) DEFAULT NULL,
  lx_siren_state TINYINT DEFAULT NULL,
  powercall_state TINYINT DEFAULT NULL,
  air_manu_state TINYINT DEFAULT NULL,
  indicator_state TINYINT DEFAULT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_vehicle_control_updated_at (updated_at)
);
