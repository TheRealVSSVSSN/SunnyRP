import * as Contacts from '../repositories/contacts.repo.js';
import * as Phones from '../repositories/phones.repo.js';

function assert(b, code = 'BAD_REQUEST', status = 400) { if (!b) { const e = new Error(code); e.statusCode = status; throw e; } }

async function assertPhoneOwner(phone_id, actor) {
    const p = await Phones.get(Number(phone_id));
    assert(p && p.char_id === Number(actor.char_id || 0), 'FORBIDDEN', 403);
    return p;
}

export async function list(query, actor) {
    const p = await assertPhoneOwner(query.phone_id, actor);
    return await Contacts.list(p.id);
}
export async function create(body, actor) {
    const p = await assertPhoneOwner(body.phone_id, actor);
    const id = await Contacts.create({ phone_id: p.id, name: String(body.name).slice(0, 64), number: String(body.number).replace(/\D/g, ''), favorite: !!body.favorite });
    return await Contacts.list(p.id);
}
export async function update(id, body, actor) {
    const p = await assertPhoneOwner(body.phone_id, actor);
    await Contacts.update(Number(id), { name: String(body.name).slice(0, 64), number: String(body.number).replace(/\D/g, ''), favorite: !!body.favorite });
    return await Contacts.list(p.id);
}
export async function remove(id, query, actor) {
    await assertPhoneOwner(query.phone_id, actor);
    await Contacts.remove(Number(id));
    return { ok: true };
}