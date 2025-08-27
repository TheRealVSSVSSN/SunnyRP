ALTER TABLE interiors
  DROP INDEX IF EXISTS uniq_apartment;

CREATE UNIQUE INDEX IF NOT EXISTS uniq_apartment_character ON interiors (apartment_id, character_id);
