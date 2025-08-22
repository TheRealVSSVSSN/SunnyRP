const app = require('./app');
const config = require('./config/env');
const logger = require('./utils/logger');

// Register Prometheus metrics if enabled.  This must be done before
// the server starts so that middleware can increment counters.
if (config.enableMetrics) {
  const client = require('prom-client');
  client.collectDefaultMetrics();
}

const server = app.listen(config.port, () => {
  logger.info(`srp-base listening on port ${config.port}`);
});

// Handle graceful shutdown
function shutdown() {
  logger.info('Shutting down server');
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

process.on('unhandledRejection', (reason) => {
  logger.error({ err: reason }, 'Unhandled promise rejection');
});

process.on('uncaughtException', (err) => {
  logger.fatal({ err }, 'Uncaught exception');
  process.exit(1);
});
