import { query } from '../db/index.js';

export async function listQueue(limit = 100) {
  return query(
    `SELECT account_id AS accountId, priority, enqueued_at AS enqueuedAt
     FROM connection_queue
     ORDER BY priority DESC, enqueued_at ASC
     LIMIT ?`,
    [limit]
  );
}

export async function enqueue(accountId, priority = 0) {
  await query(
    `INSERT INTO connection_queue (account_id, priority)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE priority = VALUES(priority), enqueued_at = CURRENT_TIMESTAMP`,
    [accountId, priority]
  );
}

export async function dequeue(accountId) {
  await query(
    `DELETE FROM connection_queue WHERE account_id = ?`,
    [accountId]
  );
}

export async function purgeStaleQueue(thresholdMs) {
  const seconds = Math.floor(thresholdMs / 1000);
  await query(
    `DELETE FROM connection_queue WHERE enqueued_at < (NOW() - INTERVAL ? SECOND)`,
    [seconds]
  );
}
