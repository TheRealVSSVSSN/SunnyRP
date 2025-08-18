-- New tables to support additional domain features such as
-- doors, error logging, weapons and shops.  These tables are
-- designed for the srp‑base service and provide a foundation
-- upon which other resources can build without implementing
-- gameplay logic directly in the backend.

-- Doors table for locking/unlocking world doors.  The primary
-- key is an auto-incremented id; however, door_id is the
-- canonical identifier used by the game.  state stores a
-- boolean (1 = locked) and heading stores the rotation of
-- the door object.  position holds a JSON object with x, y, z
-- coordinates and possibly additional metadata.
CREATE TABLE IF NOT EXISTS doors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  door_id VARCHAR(100) NOT NULL,
  name VARCHAR(255) DEFAULT NULL,
  state TINYINT(1) DEFAULT 0,
  position JSON,
  heading FLOAT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_door_id (door_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Error log table for storing client/server error reports.
-- Each row includes the source (client/server), severity level,
-- the error message and an optional stack trace.  created_at
-- is set automatically.  No foreign keys are necessary.
CREATE TABLE IF NOT EXISTS error_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  source VARCHAR(50) DEFAULT 'unknown',
  level VARCHAR(20) DEFAULT 'error',
  message TEXT NOT NULL,
  stack TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Weapons definition table.  Each weapon has a unique name and
-- optional label and class (e.g. pistol, rifle).  Additional
-- metadata can be added via separate tables if required.
CREATE TABLE IF NOT EXISTS weapons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  label VARCHAR(100) DEFAULT NULL,
  class VARCHAR(50) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_weapon_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Weapon attachments table.  Attachments belong to a weapon and
-- describe optional modifications such as scopes or suppressors.
CREATE TABLE IF NOT EXISTS weapon_attachments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  weapon_id INT NOT NULL,
  attachment_name VARCHAR(100) NOT NULL,
  label VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (weapon_id) REFERENCES weapons (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player weapons table.  Tracks the weapons owned by players
-- along with optional serial numbers and modifiers (stored as
-- JSON).  player_id refers to the player's hex id.  A foreign
-- key to weapons.id ensures referential integrity.
CREATE TABLE IF NOT EXISTS player_weapons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(64) NOT NULL,
  weapon_id INT NOT NULL,
  serial VARCHAR(100) DEFAULT NULL,
  modifiers JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (weapon_id) REFERENCES weapons (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Shops table defining physical or virtual stores.  location
-- holds JSON containing x, y, z coordinates or other metadata.
-- type can be used to categorise shops (e.g. convenience,
-- hardware).  Names are unique.
CREATE TABLE IF NOT EXISTS shops (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT DEFAULT NULL,
  location JSON,
  type VARCHAR(50) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_shop_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Products sold in shops.  item is a string referencing
-- inventory items, price is stored as BIGINT for whole units,
-- stock is an integer or NULL (unlimited).  shop_id
-- references shops.id.
CREATE TABLE IF NOT EXISTS shop_products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  shop_id INT NOT NULL,
  item VARCHAR(100) NOT NULL,
  price BIGINT NOT NULL,
  stock INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (shop_id) REFERENCES shops (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;