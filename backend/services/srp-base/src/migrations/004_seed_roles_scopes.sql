-- migrations/004_seed_roles_scopes.sql

INSERT IGNORE INTO roles (name) VALUES ('admin');

SET @rid := (SELECT id FROM roles WHERE name = 'admin');

INSERT IGNORE INTO role_scopes (role_id, scope) VALUES
  (@rid, 'admin'),
  (@rid, 'admin.ban'),
  (@rid, 'admin.kick'),
  (@rid, 'admin.permissions');