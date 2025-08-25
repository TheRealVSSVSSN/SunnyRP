const db = require('./db');

/**
 * Repository for managing character-bound assets. Assets are arbitrary
 * media references (images, audio, etc.) owned by a character.
 */
class AssetsRepository {
  /**
   * Create a new asset record.
   *
   * @param {Object} params
   * @param {number} params.ownerId Character identifier owning the asset
   * @param {string} params.url Direct URL to the asset
   * @param {string} params.type Asset type or MIME category
   * @param {string} [params.name] Optional human readable name
   * @returns {Promise<Object>} Newly created asset
   */
  static async createAsset({ ownerId, url, type, name }) {
    const result = await db.query(
      'INSERT INTO assets (owner_id, url, type, name) VALUES (?, ?, ?, ?)',
      [ownerId, url, type, name || null],
    );
    const [asset] = await db.query(
      'SELECT id, owner_id AS ownerId, url, type, name, created_at AS createdAt FROM assets WHERE id = ?',
      [result.insertId],
    );
    return asset;
  }

  /**
   * Retrieve a single asset by its identifier.
   *
   * @param {number} id Asset identifier
   * @returns {Promise<Object|null>} Asset or null if not found
   */
  static async getAsset(id) {
    const [asset] = await db.query(
      'SELECT id, owner_id AS ownerId, url, type, name, created_at AS createdAt FROM assets WHERE id = ?',
      [id],
    );
    return asset || null;
  }

  /**
   * List assets belonging to a specific character.
   *
   * @param {number} ownerId Character identifier
   * @returns {Promise<Array>} Array of asset objects
   */
  static async listByOwner(ownerId) {
    const rows = await db.query(
      'SELECT id, owner_id AS ownerId, url, type, name, created_at AS createdAt FROM assets WHERE owner_id = ? ORDER BY id DESC',
      [ownerId],
    );
    return rows;
  }

  /**
   * Delete an asset by its identifier.
   *
   * @param {number} id Asset identifier
   * @returns {Promise<void>}
   */
  static async deleteAsset(id) {
    await db.query('DELETE FROM assets WHERE id = ?', [id]);
  }

  /**
   * Delete assets older than the provided cutoff date.
   *
   * @param {Date} cutoff Remove assets created before this time
   * @returns {Promise<number>} Count of removed rows
   */
  static async deleteOlderThan(cutoff) {
    const result = await db.query('DELETE FROM assets WHERE created_at < ?', [cutoff]);
    return result.affectedRows || 0;
  }
}

module.exports = AssetsRepository;
