import { db } from './db.js';

export async function bySlug(slug) {
    return await db('heists').where({ slug: String(slug) }).first();
}
export async function setActive(slug) {
    const now = db.fn.now();
    await db('heists').where({ slug: String(slug) }).update({ state: 'active', last_started_at: now, updated_at: now });
    return await bySlug(slug);
}
export async function setCooldown(slug, cooldown_s) {
    const until = db.raw(`(now() at time zone 'utc') + interval '${Number(cooldown_s)} seconds'`);
    await db('heists').where({ slug: String(slug) }).update({ state: 'idle', cooldown_until: until, updated_at: db.fn.now() });
    return await bySlug(slug);
}
export async function isOnCooldown(slug) {
    const h = await bySlug(slug);
    if (!h) return { exists: false, cooling: false, seconds: 0, meta: null };
    if (!h.cooldown_until) return { exists: true, cooling: false, seconds: 0, meta: h.metadata };
    const diff = await db.raw(`extract(epoch from (${db.raw(`?::timestamptz`, [h.cooldown_until])} - (now() at time zone 'utc')))`, []);
    const seconds = Math.max(0, Math.floor(Number(diff.rows?.[0]?.extract || 0)));
    return { exists: true, cooling: seconds > 0, seconds, meta: h.metadata };
}