const db = require('./db');

/**
 * Outbox repository.  Stores events that should be delivered
 * asynchronously to external systems (e.g. webhook endpoints,
 * message queues).  The outbox pattern ensures reliable delivery
 * regardless of transaction outcome.  Outbox events are identified
 * by id (auto increment) and include a topic, payload (JSON),
 * created_at, claimed_at (nullable), delivered_at (nullable), and
 * delivery_attempts counter.
 */

/**
 * Enqueue an outbox event.  Returns the inserted event ID.
 *
 * @param {string} topic The domain topic (e.g. 'character.created')
 * @param {object} payload Arbitrary JSON payload
 */
async function enqueue(topic, payload) {
  const payloadStr = JSON.stringify(payload);
  const result = await db.query(
    'INSERT INTO outbox (topic, payload, created_at, delivery_attempts) VALUES (?, ?, NOW(), 0)',
    [topic, payloadStr],
  );
  return result.insertId;
}

/**
 * Claim a batch of unclaimed events for delivery.  Marks the
 * events as claimed by setting claimed_at.  Returns the events
 * along with their IDs and payloads parsed.
 *
 * @param {number} limit Maximum number of events to claim
 */
async function claimBatch(limit) {
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();
    // Select events that are not claimed or delivered
    const [rows] = await conn.execute(
      'SELECT id, topic, payload FROM outbox WHERE claimed_at IS NULL AND delivered_at IS NULL ORDER BY id ASC LIMIT ? FOR UPDATE',
      [limit],
    );
    const ids = rows.map((r) => r.id);
    if (ids.length > 0) {
      await conn.execute('UPDATE outbox SET claimed_at = NOW() WHERE id IN (?)', [ids]);
    }
    await conn.commit();
    return rows.map((row) => ({ id: row.id, topic: row.topic, payload: JSON.parse(row.payload) }));
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

/**
 * Mark events as delivered.  Accepts an array of event IDs.
 *
 * @param {number[]} ids
 */
async function markDelivered(ids) {
  if (ids.length === 0) return;
  await db.query('UPDATE outbox SET delivered_at = NOW(), delivery_attempts = delivery_attempts + 1 WHERE id IN (?)', [ids]);
}

module.exports = { enqueue, claimBatch, markDelivered };