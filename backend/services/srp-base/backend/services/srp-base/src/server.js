// src/server.js
import { buildApp } from './app.js';
import { env } from './config/env.js';
import { logger } from './utils/logger.js';
import { runMigrations } from './bootstrap/migrate.js';

async function main() {
    await runMigrations(); // ensure DB schema is up to date at boot

    const app = buildApp();
    app.listen(env.PORT, () => {
        logger.info({ port: env.PORT }, 'srp-base listening');
    });
}

main().catch((err) => {
    // eslint-disable-next-line no-console
    console.error('Fatal boot error:', err);
    process.exit(1);
});