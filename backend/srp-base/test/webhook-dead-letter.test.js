import test from 'node:test';
import assert from 'node:assert/strict';
import {
  setWebhookDeadLetterQuery,
  insertDeadLetter,
  listDueDeadLetters,
  deleteDeadLetter,
  rescheduleDeadLetter
} from '../src/repositories/webhookDeadLetters.js';

//[[
// Type: Test
// Name: Webhook dead-letter repository
// Use: Ensures dead letters store, reschedule, and delete correctly
// Created: 2025-09-05
// By: VSSVSSN
//]]
test('webhook dead-letter round-trip', async () => {
  const store = new Map();
  let idSeq = 1;
  setWebhookDeadLetterQuery(async (sql, params) => {
    if (sql.startsWith('INSERT INTO webhook_dead_letter')) {
      const [url, secret, payload] = params;
      store.set(idSeq, { id: idSeq, url, secret, payload, attempts: 0 });
      return { insertId: idSeq++ };
    }
    if (sql.startsWith('SELECT id, url, secret, payload, attempts FROM webhook_dead_letter')) {
      return Array.from(store.values());
    }
    if (sql.startsWith('DELETE FROM webhook_dead_letter')) {
      store.delete(params[0]);
      return { affectedRows: 1 };
    }
    if (sql.startsWith('UPDATE webhook_dead_letter SET attempts')) {
      const [attempts, , id] = params;
      const row = store.get(id);
      row.attempts = attempts;
      return { affectedRows: 1 };
    }
    throw new Error('unexpected SQL');
  });

  await insertDeadLetter({ url: 'http://x', secret: 's', payload: { a: 1 } });
  let due = await listDueDeadLetters();
  assert.strictEqual(due.length, 1);
  const id = due[0].id;
  await rescheduleDeadLetter(id, 1, 120);
  due = await listDueDeadLetters();
  assert.strictEqual(due[0].attempts, 1);
  await deleteDeadLetter(id);
  due = await listDueDeadLetters();
  assert.strictEqual(due.length, 0);
});
