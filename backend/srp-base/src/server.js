const app = require('./app');
const config = require('./config/env');
const logger = require('./utils/logger');
const websocket = require('./realtime/websocket');
const scheduler = require('./bootstrap/scheduler');
const casinoTasks = require('./tasks/diamondCasino');
const interactSoundTasks = require('./tasks/interactSound');
const dispatchTasks = require('./tasks/dispatch');
const zoneTasks = require('./tasks/zones');
const wiseImportsTasks = require('./tasks/wiseImports');
const wiseWheelsTasks = require('./tasks/wiseWheels');
const assetsTasks = require('./tasks/assets');
const propertiesTasks = require('./tasks/properties');
const economyTasks = require('./tasks/economy');

// Register Prometheus metrics if enabled.  This must be done before
// the server starts so that middleware can increment counters.
if (config.enableMetrics) {
  const client = require('prom-client');
  client.collectDefaultMetrics();
}

const server = app.listen(config.port, () => {
  logger.info(`srp-base listening on port ${config.port}`);
});

const wss = websocket.init(server);

// Scheduled tasks
scheduler.register('casino-resolver', () => casinoTasks.resolvePending(wss), 30000, { jitter: 5000 });
scheduler.register('interact-sound-purge', () => interactSoundTasks.purgeOld(), 3600000, { jitter: 60000 });
scheduler.register('dispatch-alert-purge', () => dispatchTasks.purgeOld(), 3600000, { jitter: 60000 });
scheduler.register('zone-expiry-purge', () => zoneTasks.pruneExpired(), 60000, { jitter: 5000 });
scheduler.register(
  wiseImportsTasks.JOB_NAME,
  () => wiseImportsTasks.notifyReady(),
  wiseImportsTasks.INTERVAL_MS,
  { jitter: 60000, persistName: wiseImportsTasks.JOB_NAME },
);
scheduler.register(
  wiseWheelsTasks.JOB_NAME,
  () => wiseWheelsTasks.purgeOld(),
  wiseWheelsTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  assetsTasks.JOB_NAME,
  () => assetsTasks.pruneOld(),
  assetsTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  propertiesTasks.JOB_NAME,
  () => propertiesTasks.releaseExpired(),
  propertiesTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  economyTasks.JOB_NAME,
  () => economyTasks.purgeOld(),
  economyTasks.INTERVAL_MS,
  { jitter: 60000 },
);

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
