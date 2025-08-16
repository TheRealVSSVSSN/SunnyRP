-- migrations/006_ident_idx.sql
-- Speed up lookups by id_value (used in admin resolve)
ALTER TABLE user_identifiers
ADD INDEX idx_ident_value (id_value);