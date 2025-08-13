import { db } from './db.js';

export async function createBan(userId, reason, minutes, actorId) {
    const expires_at = minutes ? new Date(Date.now() + minutes * 60 * 1000) : null;
    const [id] = await db('bans').insert({ user_id: userId, reason, expires_at, actor_id: actorId || null }).returning('id');
    return typeof id === 'object' ? id.id : id;
}

export async function activeBan(userId) {
    const now = new Date();
    return db('bans')
        .where('user_id', userId)
        .andWhere(builder => builder.whereNull('expires_at').orWhere('expires_at', '>', now))
        .orderBy('id', 'desc')
        .first();
}