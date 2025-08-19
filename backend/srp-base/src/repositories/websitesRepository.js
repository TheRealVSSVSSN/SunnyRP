const db = require('./db');

/**
 * Repository for managing player‑created websites.  Websites are
 * simple entries owned by a character (cid) with a name, keywords
 * and description.  Creation deducts a fee from the player's cash
 * which is enforced at the service layer.
 */
class WebsitesRepository {
  /**
   * Create a new website entry for the given owner.  Returns the
   * inserted website record.
   *
   * @param {number} ownerId Character id of the website owner
   * @param {string} name Website name/title
   * @param {string} keywords Space separated keywords for searching
   * @param {string} description Description text
   */
  static async createWebsite(ownerId, name, keywords, description) {
    const insertSql =
      'INSERT INTO websites (owner_id, name, keywords, description) VALUES (?, ?, ?, ?)';
    const [result] = await db.query(insertSql, [ownerId, name, keywords, description]);
    const [rows] = await db.query('SELECT * FROM websites WHERE id = ?', [result.insertId]);
    return rows[0];
  }

  /**
   * Fetch all websites owned by the given character id.
   *
   * @param {number} ownerId Character id
   * @returns {Promise<Array>} Array of website objects
   */
  static async getWebsitesByOwner(ownerId) {
    const [rows] = await db.query('SELECT * FROM websites WHERE owner_id = ? ORDER BY created_at DESC', [ownerId]);
    return rows;
  }

  /**
   * Fetch all websites in the system.  Used to broadcast to
   * clients when a new website is created.
   */
  static async getAllWebsites() {
    const [rows] = await db.query('SELECT * FROM websites ORDER BY created_at DESC');
    return rows;
  }
}

module.exports = WebsitesRepository;