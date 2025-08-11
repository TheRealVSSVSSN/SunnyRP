import { db } from '../repositories/db.js';
import metrics from '../utils/metrics.js';

export async function enqueue(trx, type, payload) {
    // must be called INSIDE an existing transaction (trx)
    await trx('outbox_events').insert({ type: String(type), payload: JSON.stringify(payload), status: 'pending' });
}

export async function stats() {
    const [{ c: pending }] = await db('outbox_events').where({ status: 'pending' }).count({ c: '*' });
    const [{ c: processing }] = await db('outbox_events').where({ status: 'processing' }).count({ c: '*' });
    return { pending: Number(pending || 0), processing: Number(processing || 0) };
}