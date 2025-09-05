import http from 'http';
import { app } from './app.js';
import { initGateway, emitEvent } from './websockets/gateway.js';
import { scheduler, registerTask } from './bootstrap/scheduler.js';
import { logger } from './util/logger.js';
import { purgeExpired } from './repositories/idempotency.js';
import { purgeStalePlayers } from './repositories/scoreboard.js';
import { purgeStaleQueue } from './repositories/queue.js';
import { purgeStaleChannels } from './repositories/voice.js';
import { purgeStaleEntities } from './repositories/world.js';
import { refreshEndpoints } from './webhooks/dispatcher.js';
import { getCurrentTime } from './util/time.js';

if (!process.env.SRP_HMAC_SECRET) {
  throw new Error('SRP_HMAC_SECRET environment variable is required');
}
if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}

const port = process.env.PORT || 3000;
const server = http.createServer(app);
const wsDomains = ['jobs','queue','scheduler','scoreboard','sessions','system','telemetry','ux','voice','world'];

registerTask('idempotency_purge', 60_000, purgeExpired);
const timeInterval = Number(process.env.TIME_BROADCAST_INTERVAL_MS) || 60_000;
registerTask('system_time_broadcast', timeInterval, () => {
  emitEvent('system', 'time', '*', { time: getCurrentTime() });
});
const scoreboardStale = Number(process.env.SCOREBOARD_STALE_MS) || 30_000;
registerTask('scoreboard_purge', scoreboardStale, () => purgeStalePlayers(scoreboardStale));
const queueStale = Number(process.env.QUEUE_STALE_MS) || 300_000;
registerTask('queue_purge', 60_000, () => purgeStaleQueue(queueStale));
const voiceStale = Number(process.env.VOICE_STALE_MS) || 300_000;
registerTask('voice_purge', 60_000, () => purgeStaleChannels(voiceStale));
const infinityStale = Number(process.env.INFINITY_STALE_MS) || 300_000;
registerTask('infinity_entity_purge', 60_000, () => purgeStaleEntities(infinityStale));
refreshEndpoints();
initGateway(server, wsDomains);
scheduler.start();

server.listen(port, () => {
  logger.info({ port }, 'srp-base listening');
});

function shutdown() {
  scheduler.stop();
  server.close(() => {
    logger.info('srp-base shutting down');
    process.exit(0);
  });
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
