import { db } from './db.js';

function clamp01(x) { return Math.max(0, Math.min(100, x)); }

export async function getStatus(character_id) {
    const r = await db('character_status').where({ character_id }).first();
    return r || null;
}

export async function upsertStatus(character_id, values = {}) {
    const now = db.fn.now();
    const row = {
        character_id,
        hunger: values.hunger ?? 100,
        thirst: values.thirst ?? 100,
        stress: values.stress ?? 0,
        temperature: values.temperature ?? 50,
        wetness: values.wetness ?? 0,
        drug: values.drug ?? 0,
        alcohol: values.alcohol ?? 0,
        updated_at: now
    };
    const exists = await db('character_status').where({ character_id }).first();
    if (exists) {
        await db('character_status').where({ character_id }).update(row);
    } else {
        await db('character_status').insert(row);
    }
    return row;
}

export async function patchStatus(character_id, { values = {}, deltas = {} } = {}) {
    const cur = (await getStatus(character_id)) || await upsertStatus(character_id, {});
    const next = { ...cur };

    for (const [k, v] of Object.entries(values)) {
        next[k] = clamp01(Number(v));
    }
    for (const [k, v] of Object.entries(deltas)) {
        next[k] = clamp01(Number((next[k] ?? 0)) + Number(v));
    }

    next.updated_at = db.fn.now();
    await db('character_status').where({ character_id }).update(next);
    return { ...next, character_id };
}