import * as Heat from '../repositories/heat.repo.js';

const clamp = (n, min, max) => Math.max(min, Math.min(max, n));

export async function add(body, actor) {
    const char = Number(actor.char_id || 0);
    const area = String(body.area || 'city');
    const amount = Number(body.amount || 0);
    const reason = String(body.reason || 'unknown');
    const pos = body.position || null;

    const cur = (await Heat.get(char, area))?.value || 0;
    const next = clamp(cur + amount, 0, 100);
    const out = await Heat.upsert(char, area, next);
    await Heat.log(char, area, amount, reason, pos);
    return out;
}

export async function decay(body, actor) {
    const char = Number(actor.char_id || 0);
    const area = String(body.area || 'city');
    const amount = Math.abs(Number(body.amount || 1));
    const cur = (await Heat.get(char, area))?.value || 0;
    const next = clamp(cur - amount, 0, 100);
    const out = await Heat.upsert(char, area, next);
    await Heat.log(char, area, -amount, 'decay', null);
    return out;
}