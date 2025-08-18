const db = require('./db');

/**
 * Repository for managing weapons definitions, attachments, and
 * player owned weapons.  Weapons are defined in a lookup table
 * with a unique identifier, name, label and class.  Attachments
 * belong to a weapon and describe possible modifications (e.g. a
 * suppressor or extended magazine).  Player weapons represent
 * actual items owned by players and may carry a serial number
 * or other metadata in the modifiers column.
 */

// Weapon definitions
async function getAllWeapons() {
  const [rows] = await db.query('SELECT id, name, label, class FROM weapons ORDER BY id');
  return rows;
}

async function getWeapon(id) {
  const [rows] = await db.query('SELECT id, name, label, class FROM weapons WHERE id = ?', [id]);
  return rows[0] || null;
}

async function createWeapon({ name, label, className }) {
  const [result] = await db.query('INSERT INTO weapons (name, label, class) VALUES (?, ?, ?)', [name, label, className]);
  return getWeapon(result.insertId);
}

// Weapon attachments
async function getAttachments(weaponId) {
  const [rows] = await db.query('SELECT id, weapon_id, attachment_name, label FROM weapon_attachments WHERE weapon_id = ?', [weaponId]);
  return rows;
}

async function addAttachment(weaponId, { attachmentName, label }) {
  const [result] = await db.query('INSERT INTO weapon_attachments (weapon_id, attachment_name, label) VALUES (?, ?, ?)', [weaponId, attachmentName, label]);
  const [rows] = await db.query('SELECT id, weapon_id, attachment_name, label FROM weapon_attachments WHERE id = ?', [result.insertId]);
  return rows[0];
}

// Player weapons
async function getPlayerWeapons(playerId) {
  const [rows] = await db.query(
    'SELECT pw.id, pw.player_id, pw.weapon_id, pw.serial, pw.modifiers, w.name, w.label, w.class FROM player_weapons pw JOIN weapons w ON pw.weapon_id = w.id WHERE pw.player_id = ?',
    [playerId],
  );
  return rows.map(r => ({
    id: r.id,
    playerId: r.player_id,
    weaponId: r.weapon_id,
    serial: r.serial,
    modifiers: r.modifiers ? JSON.parse(r.modifiers) : null,
    name: r.name,
    label: r.label,
    class: r.class,
  }));
}

async function addPlayerWeapon(playerId, { weaponId, serial = null, modifiers = null }) {
  const modsJson = modifiers ? JSON.stringify(modifiers) : null;
  const [result] = await db.query('INSERT INTO player_weapons (player_id, weapon_id, serial, modifiers) VALUES (?, ?, ?, ?)', [playerId, weaponId, serial, modsJson]);
  return getPlayerWeaponById(result.insertId);
}

async function getPlayerWeaponById(id) {
  const [rows] = await db.query(
    'SELECT pw.id, pw.player_id, pw.weapon_id, pw.serial, pw.modifiers, w.name, w.label, w.class FROM player_weapons pw JOIN weapons w ON pw.weapon_id = w.id WHERE pw.id = ?',
    [id],
  );
  const r = rows[0];
  if (!r) return null;
  return {
    id: r.id,
    playerId: r.player_id,
    weaponId: r.weapon_id,
    serial: r.serial,
    modifiers: r.modifiers ? JSON.parse(r.modifiers) : null,
    name: r.name,
    label: r.label,
    class: r.class,
  };
}

module.exports = {
  getAllWeapons,
  getWeapon,
  createWeapon,
  getAttachments,
  addAttachment,
  getPlayerWeapons,
  addPlayerWeapon,
};