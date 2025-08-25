const boatshopRepo = require('../repositories/boatshopRepository');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'boatshop-catalog-broadcast';
const INTERVAL_MS = 300000; // 5 minutes

async function broadcastCatalog(wss) {
  const boats = await boatshopRepo.listBoats();
  if (wss) {
    wss.broadcast('boatshop', 'catalog', boats);
  }
  dispatcher.dispatch('boatshop.catalog', boats);
}

module.exports = { JOB_NAME, INTERVAL_MS, broadcastCatalog };
