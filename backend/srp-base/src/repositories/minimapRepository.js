const db = require('./db');

async function listBlips() {
  const [rows] = await db.query(
    'SELECT id, x, y, z, sprite, color, label, created_at AS createdAt, updated_at AS updatedAt FROM minimap_blips',
    [],
  );
  return rows;
}

async function createBlip({ x, y, z, sprite, color, label }) {
  const [result] = await db.query(
    'INSERT INTO minimap_blips (x, y, z, sprite, color, label) VALUES (?, ?, ?, ?, ?, ?)',
    [x, y, z, sprite, color, label],
  );
  return { id: result.insertId, x, y, z, sprite, color, label };
}

async function deleteBlip(id) {
  await db.query('DELETE FROM minimap_blips WHERE id = ?', [id]);
}

module.exports = {
  listBlips,
  createBlip,
  deleteBlip,
};
