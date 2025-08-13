import { db } from './db.js';

export async function insertChatLog(entry) {
    const row = {
        user_id: entry.user_id,
        character_id: entry.character_id || null,
        channel: entry.channel,
        message: entry.message,
        position: entry.position ? JSON.stringify(entry.position) : null,
        routing_bucket: entry.routing_bucket ?? null,
        src: entry.src ?? null,
    };
    const [id] = await db('chat_log').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}

export async function listHistoryByCharacter(character_id, { limit = 50 } = {}) {
    return db('chat_log')
        .where({ character_id })
        .orderBy('id', 'desc')
        .limit(limit)
        .select(['id', 'user_id', 'character_id', 'channel', 'message', 'position', 'routing_bucket', 'src', 'created_at']);
}