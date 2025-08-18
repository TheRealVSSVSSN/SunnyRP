-- Extended services schema for dispatch, evidence, EMS, keys and loot

-- Dispatch alerts store 911 calls, panic buttons or other notifications.
CREATE TABLE IF NOT EXISTS dispatch_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(10) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  sender VARCHAR(255),
  coords JSON,
  status ENUM('new','acknowledged') DEFAULT 'new',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Dispatch codes define preconfigured code numbers and their meanings.
CREATE TABLE IF NOT EXISTS dispatch_codes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(10) NOT NULL UNIQUE,
  description VARCHAR(255) NOT NULL
);

-- Evidence items record forensic evidence collected by police or citizens.
CREATE TABLE IF NOT EXISTS evidence_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR(255),
  owner VARCHAR(255),
  metadata JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EMS records store medical treatments provided by EMS personnel.
CREATE TABLE IF NOT EXISTS ems_records (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id VARCHAR(50) NOT NULL,
  doctor_id VARCHAR(50) NOT NULL,
  treatment TEXT NOT NULL,
  status ENUM('open','closed') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Player keys grant access to vehicles, properties or other items.
CREATE TABLE IF NOT EXISTS keys (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(50) NOT NULL,
  key_type VARCHAR(50) NOT NULL,
  target_id VARCHAR(50) NOT NULL,
  metadata JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Loot items represent dropped items in the world.
CREATE TABLE IF NOT EXISTS loot_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  owner_id VARCHAR(50) NOT NULL,
  item_type VARCHAR(100) NOT NULL,
  value INT DEFAULT 0,
  coordinates JSON,
  metadata JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);