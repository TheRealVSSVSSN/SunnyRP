const db = require('./db');

/**
 * Retrieve all notes currently stored in the system.
 * Notes include free‑form text and optional world coordinates.  The
 * returned array is ordered by creation time ascending.
 *
 * @returns {Promise<Array>} List of note records
 */
async function getAllNotes() {
  const [rows] = await db.query(
    'SELECT id, text, x, y, z, created_at AS createdAt, updated_at AS updatedAt FROM notes ORDER BY id ASC',
  );
  return rows.map((row) => ({
    id: row.id,
    text: row.text,
    x: row.x,
    y: row.y,
    z: row.z,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Create a new note record.
 *
 * @param {Object} params - Note details
 * @param {string} params.text - The note text
 * @param {number} params.x - World X coordinate
 * @param {number} params.y - World Y coordinate
 * @param {number} params.z - World Z coordinate
 * @returns {Promise<Object>} The created note record
 */
async function createNote({ text, x, y, z }) {
  const [result] = await db.query(
    'INSERT INTO notes (text, x, y, z) VALUES (?, ?, ?, ?)',
    [text, x, y, z],
  );
  const id = result.insertId;
  return {
    id,
    text,
    x,
    y,
    z,
  };
}

/**
 * Delete a note record by its identifier.
 *
 * @param {number} id - The ID of the note to remove
 * @returns {Promise<void>}
 */
async function deleteNote(id) {
  await db.query('DELETE FROM notes WHERE id = ?', [id]);
}

module.exports = {
  getAllNotes,
  createNote,
  deleteNote,
};