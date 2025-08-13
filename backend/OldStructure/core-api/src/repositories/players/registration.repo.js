import knex from './db.js';

export async function getStatus(playerId) {
    const row = await knex('players').where({ id: playerId }).first();
    if (!row) return null;
    return {
        playerId: row.id,
        verified: !!row.verified,
        phoneNumber: row.phone_number || null,
        phoneVerified: !!row.phone_verified,
        email: row.email || null,
        emailVerified: !!row.email_verified,
        discordVerified: !!row.discord_verified,
        ageVerified: !!row.age_verified,
        tosAccepted: !!row.tos_accepted,
        updatedAt: row.verification_updated_at || row.updated_at || null,
    };
}

/**
 * Partial update for verification flags/fields.
 * Example payload:
 * { verified: true, phoneNumber: '15551234567', phoneVerified: true, tosAccepted: true }
 */
export async function updateVerification(playerId, patch) {
    const map = {};
    if ('verified' in patch) map.verified = !!patch.verified;
    if ('phoneNumber' in patch) map.phone_number = patch.phoneNumber || null;
    if ('phoneVerified' in patch) map.phone_verified = !!patch.phoneVerified;
    if ('email' in patch) map.email = patch.email || null;
    if ('emailVerified' in patch) map.email_verified = !!patch.emailVerified;
    if ('discordVerified' in patch) map.discord_verified = !!patch.discordVerified;
    if ('ageVerified' in patch) map.age_verified = !!patch.ageVerified;
    if ('tosAccepted' in patch) map.tos_accepted = !!patch.tosAccepted;

    if (Object.keys(map).length === 0) return getStatus(playerId);

    map.verification_updated_at = knex.fn.now();

    const updated = await knex('players').where({ id: playerId }).update(map);
    if (!updated) return null;
    return getStatus(playerId);
}