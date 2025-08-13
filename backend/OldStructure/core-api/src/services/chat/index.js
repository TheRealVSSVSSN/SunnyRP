import { insertChatLog, listHistoryByCharacter } from '../repositories/chat.repo.js';
import { writeAudit } from '../repositories/audit.repo.js';

const PROFANITY = [
    // keep tiny default list; extend later via admin UI
    'fuck', 'shit', 'bitch', 'asshole'
];

function sanitize(input, { maxLen = 300 } = {}) {
    if (!input) return '';
    let s = String(input);
    // strip control chars
    s = s.replace(/[\x00-\x08\x0B-\x1F\x7F]/g, '');
    // normalize whitespace
    s = s.replace(/\s+/g, ' ').trim();
    // truncate
    if (s.length > maxLen) s = s.slice(0, maxLen);
    return s;
}

function filterProfanity(msg, enabled = true) {
    if (!enabled) return msg;
    let m = msg;
    for (const w of PROFANITY) {
        const re = new RegExp(`\\b${w}\\b`, 'gi');
        m = m.replace(re, '*'.repeat(w.length));
    }
    return m;
}

export async function logChat({ userId, characterId, channel, message, position, routing_bucket, src, profanity = true }) {
    const clean = filterProfanity(sanitize(message), profanity);
    const id = await insertChatLog({
        user_id: userId,
        character_id: characterId,
        channel,
        message: clean,
        position,
        routing_bucket,
        src
    });
    // lightweight audit trail
    await writeAudit({
        actor_type: 'player',
        actor_id: userId,
        user_id: userId,
        action: 'chat_message',
        meta: { channel, characterId, src, excerpt: clean.slice(0, 140) }
    });
    return { id, message: clean };
}

export async function getHistory({ characterId, limit }) {
    const rows = await listHistoryByCharacter(characterId, { limit });
    return rows.map(r => ({
        ...r,
        position: r.position ? (typeof r.position === 'string' ? JSON.parse(r.position) : r.position) : null
    }));
}