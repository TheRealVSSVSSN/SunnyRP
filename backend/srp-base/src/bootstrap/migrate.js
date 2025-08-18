const fs = require('fs');
const path = require('path');
const db = require('../repositories/db');
const logger = require('../utils/logger');

/**
 * Simple migration runner.  Executes all .sql files in the
 * src/migrations directory in lexicographical order.  Each file is
 * executed as a single statement batch.  Existing tables are not
 * dropped.  Use at your own risk: this script does not support
 * rollbacks or partial migration detection.
 */
async function runMigrations() {
  const migrationsDir = path.resolve(__dirname, '../migrations');
  const files = fs
    .readdirSync(migrationsDir)
    .filter((f) => f.endsWith('.sql'))
    .sort();
  for (const file of files) {
    const filePath = path.join(migrationsDir, file);
    const sql = fs.readFileSync(filePath, 'utf8');
    logger.info(`Applying migration ${file}`);
    try {
      await db.query(sql);
      logger.info(`Migration ${file} applied`);
    } catch (err) {
      logger.error({ err }, `Failed to apply migration ${file}`);
      throw err;
    }
  }
}

runMigrations()
  .then(() => {
    logger.info('All migrations applied');
    process.exit(0);
  })
  .catch((err) => {
    logger.error({ err }, 'Migration failed');
    process.exit(1);
  });