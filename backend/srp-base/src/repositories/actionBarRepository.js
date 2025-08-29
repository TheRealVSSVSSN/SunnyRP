const db = require('./db');

/**
 * Retrieve action bar slots for a character.
 * @param {number} characterId
 * @returns {Promise<Array<{slot:number,item:string|null}>>}
 */
async function getSlots(characterId) {
  const rows = await db.query(
    'SELECT slot, item FROM action_bar_slots WHERE character_id = ? ORDER BY slot',
    [characterId],
  );
  return rows.map((r) => ({ slot: r.slot, item: r.item }));
}

/**
 * Replace action bar slots for a character.
 * Existing slots are deleted then inserted.
 * @param {number} characterId
 * @param {Array<{slot:number,item:string|null}>} slots
 * @returns {Promise<Array<{slot:number,item:string|null}>>}
 */
async function setSlots(characterId, slots) {
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('DELETE FROM action_bar_slots WHERE character_id = ?', [characterId]);
    for (const s of slots) {
      await conn.query(
        'INSERT INTO action_bar_slots (character_id, slot, item) VALUES (?, ?, ?)',
        [characterId, s.slot, s.item],
      );
    }
    await conn.commit();
    return slots;
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = { getSlots, setSlots };
