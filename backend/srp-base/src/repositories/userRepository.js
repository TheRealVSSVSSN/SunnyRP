const db = require('./db');
const logger = require('../utils/logger');

/**
 * User repository provides CRUD operations for the users table.
 * Users represent FiveM accounts and are keyed by a unique hex ID.
 * The callers should enforce input validation.  This module
 * intentionally does not perform schema validation for brevity.
 */

/**
 * Determine whether a user exists.
 *
 * @param {string} hexId
 * @returns {Promise<boolean>}
 */
async function exists(hexId) {
  const rows = await db.query('SELECT 1 FROM users WHERE hex_id = ? LIMIT 1', [hexId]);
  return rows.length > 0;
}

/**
 * Create a new user.  Identifiers is an array of objects with
 * `type` and `value` keys (e.g. { type: 'steam', value: '123' }).
 * Missing fields will be inserted as NULL.  Returns the inserted
 * user record.  Throws on duplicate primary key or other DB error.
 *
 * @param {{hex_id: string, name: string, identifiers: {type: string, value: string}[]}} user
 */
async function create(user) {
  const { hex_id, name, identifiers } = user;
  // Map identifiers to columns
  let steamId = null;
  let license = null;
  let discord = null;
  let communityId = null;
  for (const id of identifiers || []) {
    switch (id.type) {
      case 'steam':
        steamId = id.value;
        break;
      case 'license':
        license = id.value;
        break;
      case 'discord':
        discord = id.value;
        break;
      case 'community_id':
        communityId = id.value;
        break;
      default:
        break;
    }
  }
  await db.query(
    'INSERT INTO users (hex_id, name, steam_id, license, discord, community_id, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())',
    [hex_id, name, steamId, license, discord, communityId],
  );
  return get(hex_id);
}

/**
 * Fetch a user by hex ID.  Returns null if not found.
 *
 * @param {string} hexId
 * @returns {Promise<object|null>}
 */
async function get(hexId) {
  const rows = await db.query('SELECT hex_id, name, rank, steam_id AS steamId, license, discord, community_id AS communityId, created_at AS createdAt FROM users WHERE hex_id = ? LIMIT 1', [hexId]);
  return rows[0] || null;
}

module.exports = {
  exists,
  create,
  get,
};