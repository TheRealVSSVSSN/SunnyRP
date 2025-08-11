import { db } from '../repositories/db.js';
import metrics from '../utils/metrics.js';
import clc from 'cli-color';

const BATCH = Number(process.env.OUTBOX_BATCH || 100);
const POLL = Number(process.env.OUTBOX_POLL_MS || 3000);
const MAX_ATT = Number(process.env.OUTBOX_MAX_ATTEMPTS || 12);
const BACKOFF = Number(process.env.OUTBOX_BACKOFF_MS || 30000);
const WORKER_ID = `worker-${process.pid}`;

async function claimBatch() {
    // Claim pending rows due before now
    const now = db.fn.now();
    await db.transaction(async trx => {
        await trx('outbox_events')
            .where('status', 'pending')
            .andWhere('next_run_at', '<=', db.fn.now())
            .orderBy('id', 'asc')
            .limit(BATCH)
            .update({ status: 'processing', worker_id: WORKER_ID, updated_at: now });
    });
    return await db('outbox_events').where({ status: 'processing', worker_id: WORKER_ID }).orderBy('id', 'asc').limit(BATCH);
}

async function handleRow(row) {
    // Dispatch by type
    const payload = row.payload && typeof row.payload === 'string' ? JSON.parse(row.payload) : row.payload || {};
    try {
        switch (row.type) {
            case 'notify.staff':
                // Example: just log; your Phase K hook can poll /admin/alerts or we can emit webhooks here
                console.log(clc.yellow(`[outbox] notify.staff: ${payload.message || ''}`));
                break;
            case 'webhook.audit':
                // TODO: call external URL; keep short timeouts
                break;
            default:
                // No-op
                break;
        }
        await db('outbox_events').where({ id: row.id }).update({ status: 'done', updated_at: db.fn.now() });
        metrics.outboxProcessed.inc({ result: 'ok', type: row.type });
    } catch (e) {
        const attempts = (row.attempts || 0) + 1;
        const status = attempts >= MAX_ATT ? 'dead' : 'pending';
        const next = new Date(Date.now() + BACKOFF * Math.min(attempts, 10));
        await db('outbox_events').where({ id: row.id }).update({
            status, attempts, last_error: String(e.message || e), updated_at: db.fn.now(), next_run_at: next
        });
        metrics.outboxProcessed.inc({ result: status === 'dead' ? 'dead' : 'retry', type: row.type });
    }
}

async function updateLagGauge() {
    const row = await db('outbox_events').where({ status: 'pending' }).orderBy('id', 'desc').first();
    if (!row) return metrics.outboxLag.set(0);
    const created = new Date(row.created_at).getTime();
    metrics.outboxLag.set(Math.max(0, Math.round((Date.now() - created) / 1000)));
}

async function tick() {
    try {
        const batch = await claimBatch();
        for (const row of batch) await handleRow(row);
        await updateLagGauge();
    } catch (e) {
        console.warn('[outbox] tick error:', e.message || e);
    }
    setTimeout(tick, POLL).unref();
}

tick();