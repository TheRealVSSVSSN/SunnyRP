import * as DS from '../repositories/dispatch.repo.js';

export async function call(body, actor) {
    if (!body?.kind || !body?.summary) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    const id = await DS.createCall({
        kind: String(body.kind), summary: String(body.summary),
        caller_char_id: actor?.char_id || null, caller_user_id: actor?.user_id || null,
        location: body.location ? JSON.stringify(body.location) : null,
        metadata: body.metadata ? JSON.stringify(body.metadata) : null,
    });
    return await DS.getCall(id);
}

export async function attach(body, actor) {
    if (!body?.call_id || !body?.unit_job) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    await DS.attachUnit(Number(body.call_id), { unit_char_id: Number(actor.char_id), unit_job: String(body.unit_job), status: 'attached' });
    await DS.setStatus(Number(body.call_id), 'active');
    return await DS.getCall(Number(body.call_id));
}

export async function clear(body, actor) {
    if (!body?.call_id) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    await DS.updateUnit(Number(body.call_id), Number(actor.char_id), { status: 'cleared' });
    const call = await DS.getCall(Number(body.call_id));
    const allCleared = (call.units || []).every(u => u.status === 'cleared');
    if (allCleared) await DS.setStatus(call.id, 'cleared');
    return await DS.getCall(Number(body.call_id));
}

export async function list(kind) { return await DS.listOpen(kind); }