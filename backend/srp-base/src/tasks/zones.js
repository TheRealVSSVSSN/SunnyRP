const repo = require('../repositories/zonesRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

async function pruneExpired() {
  const ids = await repo.removeExpiredZones();
  ids.forEach((id) => {
    websocket.broadcast('world', 'zone.deleted', { id });
    hooks.dispatch('zone.deleted', { id });
  });
}

module.exports = { pruneExpired };
