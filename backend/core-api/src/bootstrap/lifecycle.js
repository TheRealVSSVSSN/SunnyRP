import { logger } from '../utils/logger.js';

export function setupLifecycle(server) {
    const shutdown = (sig) => () => {
        logger.info({ sig }, 'Shutting down...');
        server.close(() => {
            logger.info('HTTP server closed');
            process.exit(0);
        });
        setTimeout(() => process.exit(1), 5000).unref();
    };
    ['SIGINT', 'SIGTERM'].forEach(sig => process.on(sig, shutdown(sig)));
}