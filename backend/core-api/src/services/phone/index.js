import * as Phones from '../repositories/phones.repo.js';

function assert(b, code = 'BAD_REQUEST', status = 400) { if (!b) { const e = new Error(code); e.statusCode = status; throw e; } }

export async function ensure(body, actor) {
    const char = Number(actor.char_id || 0);
    assert(char > 0, 'NO_CHAR', 400);
    const existing = await Phones.listForChar(char);
    if (existing.length) return existing[0];
    const area = String(body?.area || '415').replace(/\D/g, '').slice(0, 3) || '415';
    const number = await Phones.availableNumber(area);
    assert(number, 'NO_AVAILABLE_NUMBER', 503);
    const id = await Phones.create({ char_id: char, number, area, theme: 'light', wallpaper: null, plan: 'basic', active: true });
    return await Phones.get(id);
}
export async function list(body, actor) { return await Phones.listForChar(Number(actor.char_id || 0)); }
export async function claim(body, actor) {
    const char = Number(actor.char_id || 0);
    const area = String(body?.area || '415').replace(/\D/g, '').slice(0, 3) || '415';
    const number = await Phones.availableNumber(area);
    const id = await Phones.create({ char_id: char, number, area, plan: body?.plan || 'basic', active: true });
    return await Phones.get(id);
}
export async function byNumber(number) { return await Phones.byNumber(String(number)); }