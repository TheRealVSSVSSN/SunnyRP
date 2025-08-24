const db = require('./db');

/**
 * Repository for managing character clothing outfits.
 */
class ClothesRepository {
  /**
   * Create a new clothing record.
   * @param {Object} params
   * @param {number} params.characterId Owning character ID
   * @param {string} params.slot Outfit slot identifier
   * @param {Object} params.data Arbitrary outfit data
   * @param {string} [params.name] Optional outfit name
   * @returns {Promise<Object>} Created clothing record
   */
  static async create({ characterId, slot, data, name }) {
    const json = JSON.stringify(data || {});
    const result = await db.query(
      'INSERT INTO clothes (character_id, slot, name, data) VALUES (?, ?, ?, ?)',
      [characterId, slot, name || null, json],
    );
    const rows = await db.query(
      'SELECT id, character_id AS characterId, slot, name, data, created_at AS createdAt FROM clothes WHERE id = ?',
      [result.insertId],
    );
    const row = rows[0];
    return { ...row, data: JSON.parse(row.data) };
  }

  /**
   * List clothing records for a character.
   * @param {number} characterId Character identifier
   * @returns {Promise<Array>} Array of clothing records
   */
  static async listByCharacter(characterId) {
    const rows = await db.query(
      'SELECT id, character_id AS characterId, slot, name, data, created_at AS createdAt FROM clothes WHERE character_id = ? ORDER BY id DESC',
      [characterId],
    );
    return rows.map((r) => ({ ...r, data: JSON.parse(r.data) }));
  }

  /**
   * Delete a clothing record by id.
   * @param {number} id Record identifier
   * @returns {Promise<void>}
   */
  static async delete(id) {
    await db.query('DELETE FROM clothes WHERE id = ?', [id]);
  }
}

module.exports = ClothesRepository;
