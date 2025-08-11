// backend/core-api/src/repositories/character_state.repo.js
import { db } from './db.js';

/**
 * Ensures a character_state row exists for the given character_id.
 * Creates a default row if missing.
 */
export async function ensureState(character_id) {
    const row = await db('character_state').where({ character_id }).first();
    if (!row) {
        await db('character_state').insert({
            character_id,
            position: null,
            routing_bucket: 0,
            last_played_at: null
        });
    }
}

/**
 * Returns the state row with position parsed to an object (or null).
 */
export async function getState(character_id) {
    const row = await db('character_state').where({ character_id }).first();
    if (!row) return null;
    let position = null;
    if (row.position) {
        try { position = typeof row.position === 'string' ? JSON.parse(row.position) : row.position; }
        catch { position = null; }
    }
    return { ...row, position };
}

/**
 * Returns only the last saved position (object or null).
 */
export async function getLastPosition(character_id) {
    const row = await getState(character_id);
    return row ? row.position : null;
}

/**
 * Sets/updates the character's position (expects an object {x,y,z,heading?}).
 * Also updates last_played_at unless suppressTouch = true.
 */
export async function setPosition(character_id, position, { suppressTouch = false } = {}) {
    await ensureState(character_id);
    const patch = {
        position: position ? JSON.stringify(position) : null
    };
    if (!suppressTouch) patch.last_played_at = db.fn.now();
    await db('character_state').where({ character_id }).update(patch);
}

/**
 * Sets routing bucket; optionally touches last_played_at.
 */
export async function setRoutingBucket(character_id, routing_bucket = 0, { suppressTouch = false } = {}) {
    await ensureState(character_id);
    const patch = { routing_bucket };
    if (!suppressTouch) patch.last_played_at = db.fn.now();
    await db('character_state').where({ character_id }).update(patch);
}

/**
 * Touches last_played_at timestamp (now).
 */
export async function touchLastPlayed(character_id) {
    await ensureState(character_id);
    await db('character_state').where({ character_id }).update({ last_played_at: db.fn.now() });
}

/**
 * Generic patch helper. Allowed keys: position (object|null), routing_bucket (number),
 * touch (boolean to update last_played_at).
 */
export async function patchState(character_id, { position, routing_bucket, touch = false } = {}) {
    await ensureState(character_id);
    const patch = {};
    if (position !== undefined) patch.position = position ? JSON.stringify(position) : null;
    if (routing_bucket !== undefined) patch.routing_bucket = routing_bucket;
    if (touch) patch.last_played_at = db.fn.now();
    if (Object.keys(patch).length === 0) return;
    await db('character_state').where({ character_id }).update(patch);
}