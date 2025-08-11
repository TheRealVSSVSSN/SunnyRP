// players.service.js
// Link (or create) a player account by identifiers and return gating flags + scopes.
// Returns: { playerId, banned, banReason, verified, whitelisted, scopes }

import knex from '../repositories/db.js';
import { logger } from '../utils/logger.js';

/**
 * Normalize identifiers payload into flat {type:value} string map
 */
function normalizeIdentifiers(identifiers = {}) {
    const out = {};
    for (const [k, v] of Object.entries(identifiers || {})) {
        if (v == null) continue;
        const val = String(v).trim();
        if (!val) continue;
        // Only allow safe identifier keys
        // (license, steam, discord, fivem, ip, xbl, live, license2 etc. — extend as needed)
        out[k.toLowerCase()] = val;
    }
    return out;
}

async function findPlayerIdByIdentifier(trx, type, value) {
    const row = await trx('player_identifiers')
        .select('player_id')
        .where({ type, value })
        .first();
    return row ? row.player_id : null;
}

async function createPlayer(trx, displayName) {
    const [id] = await trx('players').insert(
        {
            display_name: displayName || null,
            verified: 0,
            whitelisted: 0,
            created_at: trx.fn.now(),
            updated_at: trx.fn.now(),
        },
        ['id']
    );
    // MySQL returns insertId, PostgreSQL returns row. Normalize:
    return typeof id === 'object' && id.id ? id.id : id;
}

async function upsertIdentifier(trx, playerId, type, value) {
    // Ensure unique key on (type, value) in schema for ON DUPLICATE to work efficiently
    const sql =
        'INSERT INTO player_identifiers (player_id, type, value) VALUES (?, ?, ?) ' +
        'ON DUPLICATE KEY UPDATE player_id = VALUES(player_id), updated_at = NOW()';
    await trx.raw(sql, [playerId, type, value]);
}

async function getFlags(trx, playerId) {
    const row = await trx('players')
        .select(['verified', 'whitelisted'])
        .where({ id: playerId })
        .first();
    return {
        verified: !!(row && (row.verified === 1 || row.verified === true)),
        whitelisted: !!(row && (row.whitelisted === 1 || row.whitelisted === true)),
    };
}

async function getActiveBan(trx, playerId) {
    const row = await trx('bans')
        .select(['id', 'reason'])
        .where({ player_id: playerId })
        .whereNull('revoked_at')
        .andWhere((qb) => {
            qb.whereNull('expires_at').orWhere('expires_at', '>', trx.fn.now());
        })
        .orderBy('id', 'desc')
        .first();
    if (!row) return { banned: false, banReason: null };
    return { banned: true, banReason: row.reason || null };
}

async function getScopes(trx, playerId) {
    // Distinct scopes from roles assigned to this player.
    // Tables: user_roles(player_id, role_id, revoked_at), role_scopes(role_id, scope)
    const rows = await trx('user_roles as ur')
        .leftJoin('role_scopes as rs', 'ur.role_id', 'rs.role_id')
        .select('rs.scope')
        .where('ur.player_id', playerId)
        .whereNull('ur.revoked_at');

    const scopes = [];
    for (const r of rows) {
        if (r && r.scope && !scopes.includes(r.scope)) scopes.push(r.scope);
    }
    return scopes;
}

/**
 * Link or create a player and ensure all identifiers are recorded.
 * Optionally pass `primary` which must exist in identifiers map.
 */
export async function link({ name, identifiers, primary, meta }) {
    const ids = normalizeIdentifiers(identifiers);
    if (!ids || Object.keys(ids).length === 0) {
        throw new Error('identifiers required');
    }

    // Determine lookup key: prefer primary if provided and present, else license/discord/steam/etc.
    const primaryOrder = [];
    if (primary && typeof primary === 'string') {
        // `primary` may be the actual value; try to infer type if present in map
        // If `primary` equals ids[<type>], we’ll search by that type; else we fall back
        for (const [t, v] of Object.entries(ids)) {
            if (v === primary) primaryOrder.unshift(t);
        }
    }
    // Default priority if not resolved by explicit primary value
    for (const cand of ['license', 'fivem', 'steam', 'discord', 'xbl', 'live']) {
        if (ids[cand]) primaryOrder.push(cand);
    }
    if (primaryOrder.length === 0) {
        // Last resort: pick first key
        primaryOrder.push(Object.keys(ids)[0]);
    }

    let playerId = null;

    await knex.transaction(async (trx) => {
        // 1) Try find by any of the prioritized identifiers
        for (const t of primaryOrder) {
            const v = ids[t];
            if (!v) continue;
            const found = await findPlayerIdByIdentifier(trx, t, v);
            if (found) {
                playerId = found;
                break;
            }
        }

        // 2) Create player if not found
        if (!playerId) {
            playerId = await createPlayer(trx, name);
        }

        // 3) Upsert ALL identifiers to this player
        for (const [t, v] of Object.entries(ids)) {
            await upsertIdentifier(trx, playerId, t, v);
        }

        // 4) Update last_seen / meta if you keep these columns
        try {
            await trx('players')
                .where({ id: playerId })
                .update({
                    last_seen_at: trx.fn.now(),
                    updated_at: trx.fn.now(),
                    // If you have a JSON meta column, uncomment below:
                    // meta: JSON.stringify({ ...(meta || {}), lastEndpoint: ids.ip || null }),
                });
        } catch (e) {
            // optional column; ignore if not present
        }
    });

    // 5) Gather flags & scopes & bans
    const [flags, ban, scopes] = await Promise.all([
        getFlags(knex, playerId),
        getActiveBan(knex, playerId),
        getScopes(knex, playerId),
    ]);

    const response = {
        playerId,
        banned: ban.banned,
        banReason: ban.banReason,
        verified: flags.verified,
        whitelisted: flags.whitelisted,
        scopes,
    };

    logger.debug?.({ msg: 'players.link', playerId, verified: flags.verified, whitelisted: flags.whitelisted, banned: ban.banned });

    return response;
}

export default { link };