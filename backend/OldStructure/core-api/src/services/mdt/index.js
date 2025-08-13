import * as MDT from '../repositories/mdt.repo.js';

export async function create(body, actor) {
    if (!body?.type || !body?.title || !body?.body) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    const id = await MDT.createReport({
        type: String(body.type),
        title: String(body.title),
        body: String(body.body),
        author_char_id: Number(actor.char_id),
        author_user_id: Number(actor.user_id),
        metadata: body.metadata ? JSON.stringify(body.metadata) : null,
    });
    return await MDT.getReport(id);
}
export async function update(id, body) {
    await MDT.updateReport(Number(id), {
        title: body.title, body: body.body,
        metadata: body.metadata ? JSON.stringify(body.metadata) : null,
        sealed: body.sealed === true
    });
    return await MDT.getReport(Number(id));
}
export async function get(id) { return await MDT.getReport(Number(id)); }
export async function remove(id) { await MDT.removeReport(Number(id)); return { ok: true }; }
export async function list(q) { return await MDT.listReports(q); }