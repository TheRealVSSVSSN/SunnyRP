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
const baseEventTasks = require('./tasks/baseEvents');
const boatshopTasks = require('./tasks/boatshop');
const worldTasks = require('./tasks/world');
const cameraTasks = require('./tasks/camera');
const hudTasks = require('./tasks/hud');
const carwashTasks = require('./tasks/carwash');
const chatTasks = require('./tasks/chat');
const connectqueueTasks = require('./tasks/connectqueue');
const coordinatesTasks = require('./tasks/coordinates');
const cronTasks = require('./tasks/cron');
const emotesTasks = require('./tasks/emotes');
const emsTasks = require('./tasks/ems');
const hospitalTasks = require('./tasks/hospital');
const taxiTasks = require('./tasks/taxi');
const furnitureTasks = require('./tasks/furniture');
const policeTasks = require('./tasks/police');
const garageTasks = require('./tasks/garages');
const hardcapTasks = require('./tasks/hardcap');
const heliTasks = require('./tasks/heli');

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
scheduler.register(
  baseEventTasks.JOB_NAME,
  () => baseEventTasks.purgeOld(),
  baseEventTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  boatshopTasks.JOB_NAME,
  () => boatshopTasks.broadcastCatalog(wss),
  boatshopTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  worldTasks.JOB_NAME,
  () => worldTasks.broadcastIpls(wss),
  worldTasks.INTERVAL_MS,
  { jitter: 5000, persistName: worldTasks.JOB_NAME },
);
scheduler.register(
  cameraTasks.JOB_NAME,
  () => cameraTasks.purgeOld(),
  cameraTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  hudTasks.JOB_NAME,
  () => hudTasks.pruneOld(),
  hudTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  carwashTasks.JOB_NAME,
  () => carwashTasks.tick(wss),
  carwashTasks.INTERVAL_MS,
  { jitter: 60000, persistName: carwashTasks.JOB_NAME },
);
scheduler.register(
  chatTasks.JOB_NAME,
  () => chatTasks.purgeOld(),
  chatTasks.INTERVAL_MS,
  { jitter: 60000 },
);
scheduler.register(
  connectqueueTasks.JOB_NAME,
  () => connectqueueTasks.purgeExpired(),
  connectqueueTasks.INTERVAL_MS,
  { jitter: 5000, persistName: connectqueueTasks.JOB_NAME },
);
scheduler.register(
  hardcapTasks.JOB_NAME,
  () => hardcapTasks.purgeStale(),
  hardcapTasks.INTERVAL_MS,
  { jitter: 5000, persistName: hardcapTasks.JOB_NAME },
);
scheduler.register(
  coordinatesTasks.JOB_NAME,
  () => coordinatesTasks.purgeOld(),
  coordinatesTasks.INTERVAL_MS,
  { jitter: 60000, persistName: coordinatesTasks.JOB_NAME },
);
scheduler.register(
  cronTasks.JOB_NAME,
  () => cronTasks.runDue(),
  cronTasks.INTERVAL_MS,
  { jitter: 5000, persistName: cronTasks.JOB_NAME },
);
scheduler.register(
  emotesTasks.JOB_NAME,
  () => emotesTasks.purgeOld(),
  emotesTasks.INTERVAL_MS,
  { jitter: 60000 },
);

scheduler.register(
  heliTasks.JOB_NAME,
  () => heliTasks.expireStale(),
  heliTasks.INTERVAL_MS,
  { jitter: 5000, persistName: heliTasks.JOB_NAME },
);

scheduler.register(
  emsTasks.JOB_NAME,
  () => emsTasks.syncShifts(wss),
  emsTasks.INTERVAL_MS,
  { jitter: 5000, persistName: emsTasks.JOB_NAME },
);

scheduler.register(
  hospitalTasks.JOB_NAME,
  () => hospitalTasks.syncAdmissions(wss),
  hospitalTasks.INTERVAL_MS,
  { jitter: 5000, persistName: hospitalTasks.JOB_NAME },
);

scheduler.register(
  taxiTasks.JOB_NAME,
  () => taxiTasks.expireRequests(),
  taxiTasks.INTERVAL_MS,
  { jitter: 5000, persistName: taxiTasks.JOB_NAME },
);

scheduler.register(
  furnitureTasks.JOB_NAME,
  () => furnitureTasks.purgeOld(),
  furnitureTasks.INTERVAL_MS,
  { jitter: 60000, persistName: furnitureTasks.JOB_NAME },
);

scheduler.register(
  policeTasks.JOB_NAME,
  () => policeTasks.clearStale(),
  policeTasks.INTERVAL_MS,
  { jitter: 5000, persistName: policeTasks.JOB_NAME },
);

scheduler.register(
  garageTasks.JOB_NAME,
  () => garageTasks.purgeRetrieved(),
  garageTasks.INTERVAL_MS,
  { jitter: 60000, persistName: garageTasks.JOB_NAME },
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
