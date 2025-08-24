const db = require('./db');

/**
 * Retrieve HUD preferences for a character. Defaults are returned when none exist.
 * @param {number} characterId
 * @returns {Promise<Object>}
 */
async function getPreferences(characterId) {
  const rows = await db.query(
    'SELECT character_id AS characterId, speed_unit AS speedUnit, show_fuel AS showFuel, hud_theme AS hudTheme FROM character_hud_preferences WHERE character_id = ?',
    [characterId],
  );
  if (rows.length === 0) {
    return {
      characterId,
      speedUnit: 'mph',
      showFuel: true,
      hudTheme: null,
    };
  }
  const row = rows[0];
  return {
    characterId: row.characterId,
    speedUnit: row.speedUnit,
    showFuel: row.showFuel === 1,
    hudTheme: row.hudTheme,
  };
}

/**
 * Create or update HUD preferences for a character.
 * @param {number} characterId
 * @param {Object} prefs
 * @param {string} prefs.speedUnit
 * @param {boolean} prefs.showFuel
 * @param {string|null} prefs.hudTheme
 * @returns {Promise<Object>}
 */
async function upsertPreferences(characterId, { speedUnit, showFuel, hudTheme }) {
  await db.query(
    'INSERT INTO character_hud_preferences (character_id, speed_unit, show_fuel, hud_theme) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE speed_unit = VALUES(speed_unit), show_fuel = VALUES(show_fuel), hud_theme = VALUES(hud_theme)',
    [characterId, speedUnit, showFuel ? 1 : 0, hudTheme],
  );
  return { characterId, speedUnit, showFuel, hudTheme };
}

module.exports = {
  getPreferences,
  upsertPreferences,
};
