import * as Ads from '../repositories/ads.repo.js';

export async function list(query) {
    const active = query.active == null ? true : (String(query.active) === 'true');
    const limit = Number(query.limit || 50);
    return await Ads.list({ active, limit });
}
export async function create(body, actor) {
    const id = await Ads.create({
        char_id: Number(actor.char_id || 0),
        phone_number: body?.phone_number ? String(body.phone_number).replace(/\D/g, '') : null,
        title: String(body.title || '').slice(0, 80),
        body: String(body.body || '').slice(0, 1000),
        active: true, approved: true
    });
    return { id };
}
export async function deactivate(body, actor) { await Ads.setActive(Number(body.id), false); return { ok: true }; }