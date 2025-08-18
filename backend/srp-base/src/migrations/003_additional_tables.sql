-- Additional tables for inventory, economy, vehicles, world and jobs

-- Accounts table for storing player balances.  Balances are in
-- whole units (e.g. cents) to avoid floating point rounding
-- errors.  Each player has a single account.
CREATE TABLE IF NOT EXISTS accounts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  balance BIGINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_player_account (player_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Transactions table recording transfers between accounts.  Each
-- row represents a single transfer from one player to another
-- along with the amount and optional reason.
CREATE TABLE IF NOT EXISTS transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  from_player_id VARCHAR(64) NOT NULL,
  to_player_id VARCHAR(64) NOT NULL,
  amount BIGINT NOT NULL,
  reason VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inventory table storing items held by players.  Composite
-- unique key on (player_id, item) ensures only one row per item
-- per player.  Quantities are always non‑negative.
CREATE TABLE IF NOT EXISTS inventory (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  item VARCHAR(100) NOT NULL,
  quantity INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_player_item (player_id, item)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vehicles table storing player owned vehicles.  A unique key
-- on plate could be added to prevent duplicates.  Properties
-- contains a JSON blob of vehicle mods, colours, etc.
CREATE TABLE IF NOT EXISTS vehicles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  model VARCHAR(100) NOT NULL,
  plate VARCHAR(50) NOT NULL,
  properties JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- World state table storing snapshots of global settings like
-- time, weather and density.  Each insertion appends a new
-- snapshot.
CREATE TABLE IF NOT EXISTS world_state (
  id INT AUTO_INCREMENT PRIMARY KEY,
  time VARCHAR(100) DEFAULT NULL,
  weather VARCHAR(50) DEFAULT NULL,
  density JSON,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- World events table storing death, kill or other events.  Each
-- event includes optional killer, weapon, coordinates and
-- metadata.
CREATE TABLE IF NOT EXISTS world_events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  player_id VARCHAR(64) NOT NULL,
  killer_id VARCHAR(64) DEFAULT NULL,
  weapon VARCHAR(100) DEFAULT NULL,
  coords JSON,
  meta JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Saved coordinates table for storing arbitrary labelled
-- coordinates.  Useful for admin commands or zone creation.
CREATE TABLE IF NOT EXISTS saved_coords (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  label VARCHAR(255) NOT NULL,
  coords JSON NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Jobs table defining the available jobs/organisations.  Name must
-- be unique.  Label is a friendly display name.  Description
-- describes the role or function of the job.
CREATE TABLE IF NOT EXISTS jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  label VARCHAR(100) DEFAULT NULL,
  description TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_job_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player jobs table storing assignments of players to jobs and
-- whether they are currently on duty.  Composite primary key
-- ensures one row per (player, job).  on_duty is stored as
-- tinyint for boolean semantics.
CREATE TABLE IF NOT EXISTS player_jobs (
  player_id VARCHAR(64) NOT NULL,
  job_id INT NOT NULL,
  on_duty TINYINT(1) DEFAULT 0,
  hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (player_id, job_id),
  CONSTRAINT fk_player_jobs_job FOREIGN KEY (job_id) REFERENCES jobs (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;