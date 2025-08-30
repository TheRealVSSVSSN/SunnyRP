const barriersRepo = require('../repositories/barriersRepository');

const JOB_NAME = 'barriers-reset';
const INTERVAL_MS = 600000; // 10 minutes

async function resetExpired(wss) {
  const ids = await barriersRepo.closeExpired();
  if (!ids.length || !wss) return;
  ids.forEach((id) => {
    wss.broadcast('barriers', 'state', { barrier: { id, state: false } });
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, resetExpired };
