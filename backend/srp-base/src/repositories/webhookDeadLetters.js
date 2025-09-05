import { query as dbQuery } from '../db/index.js';

let queryFn = dbQuery;

//[[
// Type: Function
// Name: setWebhookDeadLetterQuery
// Use: Overrides query function, primarily for testing
// Created: 2025-09-05
// By: VSSVSSN
//]]
export function setWebhookDeadLetterQuery(fn) {
  queryFn = fn;
}

//[[
// Type: Function
// Name: insertDeadLetter
// Use: Stores failed webhook for later retry
// Created: 2025-09-05
// By: VSSVSSN
//]]
export async function insertDeadLetter({ url, secret, payload }) {
  await queryFn(
    'INSERT INTO webhook_dead_letter (url, secret, payload, attempts, next_attempt_at) VALUES (?, ?, ?, 0, DATE_ADD(NOW(), INTERVAL 60 SECOND))',
    [url, secret, JSON.stringify(payload)]
  );
}

//[[
// Type: Function
// Name: listDueDeadLetters
// Use: Retrieves dead-lettered webhooks ready for retry
// Created: 2025-09-05
// By: VSSVSSN
//]]
export async function listDueDeadLetters(limit = 10) {
  return queryFn(
    'SELECT id, url, secret, payload, attempts FROM webhook_dead_letter WHERE next_attempt_at <= NOW() LIMIT ?',
    [limit]
  );
}

//[[
// Type: Function
// Name: deleteDeadLetter
// Use: Removes successfully delivered dead-letter from queue
// Created: 2025-09-05
// By: VSSVSSN
//]]
export async function deleteDeadLetter(id) {
  await queryFn('DELETE FROM webhook_dead_letter WHERE id = ?', [id]);
}

//[[
// Type: Function
// Name: rescheduleDeadLetter
// Use: Updates retry schedule with exponential backoff
// Created: 2025-09-05
// By: VSSVSSN
//]]
export async function rescheduleDeadLetter(id, attempts, delaySeconds) {
  await queryFn(
    'UPDATE webhook_dead_letter SET attempts = ?, next_attempt_at = DATE_ADD(NOW(), INTERVAL ? SECOND) WHERE id = ?',
    [attempts, delaySeconds, id]
  );
}
