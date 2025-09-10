/**
 * Type: Module
 * Name: np-interior server
 * Use: Logs interior usage to MySQL
 * Created: 2024-06-15
 * By: VSSVSSN
 */

const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'fivem',
  waitForConnections: true,
  connectionLimit: 10
});

/**
 * Type: Event Handler
 * Name: np-interior:entered
 * Use: Records interior visits in database
 * Created: 2024-06-15
 * By: VSSVSSN
 */
onNet('np-interior:entered', async (interiorId) => {
  const src = global.source;
  const identifier = getIdentifier(src);
  try {
    await pool.execute(
      'INSERT INTO interior_usage (identifier, interior_id) VALUES (?, ?)',
      [identifier, interiorId]
    );
  } catch (err) {
    console.error('[np-interior] Failed to log interior usage:', err);
  }
});

// Helper: obtain player license identifier
function getIdentifier(src) {
  const ids = getPlayerIdentifiers(src);
  for (const id of ids) {
    if (id.startsWith('license:')) return id;
  }
  return 'unknown';
}

