import knex from './db.js';

export async function listEnabled() {
    const rows = await knex('webhooks').where({ enabled: 1 }).select('*');
    return rows.map(r => ({
        id: r.id, name: r.name, url: r.url,
        channels: Array.isArray(r.channels) ? r.channels : JSON.parse(r.channels || '[]'),
        scopes: Array.isArray(r.scopes) ? r.scopes : JSON.parse(r.scopes || '[]'),
        enabled: !!r.enabled
    }));
}

export async function createEvent(webhookId, type, payload) {
    const [id] = await knex('webhook_events').insert({
        webhook_id: webhookId,
        type,
        payload,
        status: 'pending',
        attempts: 0,
    });
    return id;
}

export async function nextPending(limit = 10) {
    return knex('webhook_events')
        .where({ status: 'pending' })
        .orderBy('id', 'asc')
        .limit(limit);
}

export async function markDelivered(id) {
    return knex('webhook_events')
        .where({ id })
        .update({ status: 'delivered', delivered_at: knex.fn.now(), last_error: null });
}

export async function markFailed(id, err) {
    return knex('webhook_events')
        .where({ id })
        .update({
            status: 'failed',
            attempts: knex.raw('attempts + 1'),
            last_error: String(err).slice(0, 2000),
        });
}

export default { listEnabled, createEvent, nextPending, markDelivered, markFailed };