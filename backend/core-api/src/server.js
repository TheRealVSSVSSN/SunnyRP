import { app } from './app.js';
import { setupLifecycle } from './bootstrap/lifecycle.js';
import { config } from './config/index.js';
import { logger } from './utils/logger.js';

const server = app.listen(config.port, () => {
    logger.info({ port: config.port, env: config.env }, 'Sunny Core API listening');
});

setupLifecycle(server);