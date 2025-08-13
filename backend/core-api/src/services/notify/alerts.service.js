import * as Alerts from '../repositories/alerts.repo.js';

export async function list(query) {
    return await Alerts.list({ sinceId: query.sinceId ? Number(query.sinceId) : null, limit: Number(query.limit || 50), includeAck: String(query.includeAck || 'false') === 'true' });
}
export async function ack(body) {
    await Alerts.ack(Number(body.id));
    return { ok: true };
}