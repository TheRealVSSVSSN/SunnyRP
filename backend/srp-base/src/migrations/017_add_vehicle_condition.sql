# Migration 017_add_vehicle_condition.sql
#
# Adds condition columns to the vehicles table.  These include engine_damage,
# body_damage, fuel and degradation.  Degradation is stored as a comma‑separated
# string of eight integers representing component wear.  Each column is added
# only if it does not already exist.  An index on plate already exists from
# previous migrations.

-- Add engine_damage column if it does not exist
ALTER TABLE vehicles
  ADD COLUMN IF NOT EXISTS engine_damage INT NULL;

-- Add body_damage column if it does not exist
ALTER TABLE vehicles
  ADD COLUMN IF NOT EXISTS body_damage INT NULL;

-- Add fuel column if it does not exist
ALTER TABLE vehicles
  ADD COLUMN IF NOT EXISTS fuel INT NULL;

-- Add degradation column if it does not exist
ALTER TABLE vehicles
  ADD COLUMN IF NOT EXISTS degradation VARCHAR(255) NULL;