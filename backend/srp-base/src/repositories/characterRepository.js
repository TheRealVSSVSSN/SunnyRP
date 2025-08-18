const db = require('./db');

/**
 * Characters repository.  Provides CRUD operations for characters
 * associated with a user.  Characters have an ID, owner_hex
 * foreign key, first_name, last_name, dob, gender, phone_number,
 * story, created_at.  Additional fields can be added as needed.
 */

/**
 * List all characters for a given owner.  Returns an empty array
 * when the owner has no characters.
 *
 * @param {string} ownerHex
 * @returns {Promise<object[]>}
 */
async function listByOwner(ownerHex) {
  return db.query(
    'SELECT id, owner_hex AS ownerHex, first_name AS firstName, last_name AS lastName, dob, gender, phone_number AS phoneNumber, story, created_at AS createdAt FROM characters WHERE owner_hex = ?',
    [ownerHex],
  );
}

/**
 * Create a new character.  The caller must ensure that the owner
 * exists and that the name/phone are unique.  If the insert
 * succeeds the newly created character is returned.  Throws on
 * constraint violations.
 *
 * @param {object} data
 * @param {string} data.owner_hex
 * @param {string} data.first_name
 * @param {string} data.last_name
 * @param {string} [data.dob]
 * @param {string} [data.gender]
 * @param {string} [data.phone_number]
 * @param {string} [data.story]
 */
async function create(data) {
  const {
    owner_hex,
    first_name,
    last_name,
    dob = null,
    gender = null,
    phone_number = null,
    story = null,
  } = data;
  const result = await db.query(
    'INSERT INTO characters (owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())',
    [owner_hex, first_name, last_name, dob, gender, phone_number, story],
  );
  const id = result.insertId;
  return getById(id);
}

/**
 * Fetch a character by ID.  Returns null if not found.
 *
 * @param {number} id
 * @returns {Promise<object|null>}
 */
async function getById(id) {
  const rows = await db.query(
    'SELECT id, owner_hex AS ownerHex, first_name AS firstName, last_name AS lastName, dob, gender, phone_number AS phoneNumber, story, created_at AS createdAt FROM characters WHERE id = ? LIMIT 1',
    [id],
  );
  return rows[0] || null;
}

/**
 * Update a character record.  Only provided fields are updated.
 * Returns the updated character on success or null if no rows were
 * affected.
 *
 * @param {number} id
 * @param {object} updates
 */
async function update(id, updates) {
  const fields = [];
  const params = [];
  for (const [key, value] of Object.entries(updates)) {
    fields.push(`${key} = ?`);
    params.push(value);
  }
  if (fields.length === 0) {
    return getById(id);
  }
  params.push(id);
  await db.query(`UPDATE characters SET ${fields.join(', ')} WHERE id = ?`, params);
  return getById(id);
}

module.exports = { listByOwner, create, getById, update };