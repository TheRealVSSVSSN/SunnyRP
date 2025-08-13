import { db } from './db.js';

export async function findUserByAnyIdentifier(identMap) {
    const pairs = Object.entries(identMap || {}).filter(([_, v]) => v);
    if (!pairs.length) return null;
    const query = db('user_identifiers')
        .select('users.*')
        .join('users', 'users.id', 'user_identifiers.user_id')
        .where(builder => {
            for (const [type, value] of pairs) {
                builder.orWhere(q => q.where('user_identifiers.type', type).andWhere('user_identifiers.value', value));
            }
        })
        .first();
    return query;
}

export async function createUser(primary_identifier, last_ip) {
    const [id] = await db('users').insert({ primary_identifier, last_ip }).returning('id');
    return typeof id === 'object' ? id.id : id;
}

export async function upsertIdentifiers(userId, identMap) {
    const items = [];
    for (const [type, value] of Object.entries(identMap || {})) {
        if (!value) continue;
        items.push({ user_id: userId, type, value });
    }
    if (!items.length) return;
    for (const row of items) {
        const existing = await db('user_identifiers').where({ type: row.type, value: row.value }).first();
        if (!existing) await db('user_identifiers').insert(row);
        // else ignore (shared identifiers map to the same user by uniqueness)
    }
}

export async function touchUser(userId, last_ip) {
    await db('users').where({ id: userId }).update({ last_ip, last_seen_at: db.fn.now(), updated_at: db.fn.now() });
}

export async function getUserWithIdentifiers(userId) {
    const user = await db('users').where({ id: userId }).first();
    const idents = await db('user_identifiers').where({ user_id: userId });
    return { user, identifiers: idents };
}