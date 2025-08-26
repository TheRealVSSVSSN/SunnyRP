const config = require('../config/env');
const ChatRepository = require('../repositories/chatRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'chat-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - config.chat.retentionMs);
    const removed = await ChatRepository.deleteOlderThan(cutoff);
    if (removed) logger.info({ removed }, 'Pruned stale chat messages');
  } catch (err) {
    logger.error({ err }, 'Failed to prune chat messages');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
