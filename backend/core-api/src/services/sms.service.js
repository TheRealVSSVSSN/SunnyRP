import * as Msg from '../repositories/messages.repo.js';
import * as Phones from '../repositories/phones.repo.js';

function assert(b, code = 'BAD_REQUEST', status = 400) { if (!b) { const e = new Error(code); e.statusCode = status; throw e; } }

export async function send(body, actor) {
    const from = String(body?.from).replace(/\D/g, '');
    const to = String(body?.to).replace(/\D/g, '');
    const text = String(body?.text || '').slice(0, 500);
    assert(from && to && text, 'BAD_REQUEST');
    // validate ownership of from-number
    const phone = await Phones.byNumber(from);
    assert(phone && phone.char_id === Number(actor.char_id || 0), 'FORBIDDEN', 403);
    const id = await Msg.create({ from_number: from, to_number: to, text, idempotency_key: body?.idempotencyKey || null, status: 'sent' });
    return { id, from, to, text };
}
export async function thread(query, actor) {
    const a = String(query.a || '');
    const b = String(query.b || '');
    assert(a && b, 'BAD_REQUEST');
    return await Msg.thread(a, b, Number(query.limit || 200));
}
export async function inbox(query, actor) {
    const n = String(query.number || '');
    assert(n, 'BAD_REQUEST');
    const rows = await Msg.inbox(n, query.sinceId ? Number(query.sinceId) : null, Number(query.limit || 100));
    // mark delivered
    await Msg.markDelivered(rows.map(r => r.id));
    return rows;
}