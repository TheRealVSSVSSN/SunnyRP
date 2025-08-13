/**
 * 0021_player_verification.js
 * Adds verification fields to players (non-intrusive; defaults to false/null).
 */
exports.up = async function (knex) {
    const hasTable = await knex.schema.hasTable('players');
    if (!hasTable) throw new Error('players table not found (run earlier migrations first)');

    const hasVerified = await knex.schema.hasColumn('players', 'verified');
    if (!hasVerified) {
        await knex.schema.alterTable('players', (t) => {
            t.boolean('verified').notNullable().defaultTo(false);
            t.string('phone_number', 32).nullable();
            t.boolean('phone_verified').notNullable().defaultTo(false);
            t.string('email', 191).nullable();
            t.boolean('email_verified').notNullable().defaultTo(false);
            t.boolean('discord_verified').notNullable().defaultTo(false);
            t.boolean('age_verified').notNullable().defaultTo(false);
            t.boolean('tos_accepted').notNullable().defaultTo(false);
            t.timestamp('verification_updated_at').nullable().defaultTo(null);
        });
    }

    // Helpful index for lookups by phone/email
    const hasPhoneIdx = await knex.schema.hasColumn('players', 'phone_number');
    if (hasPhoneIdx) {
        try { await knex.schema.raw('CREATE INDEX IF NOT EXISTS idx_players_phone ON players (phone_number)'); } catch (_) { }
    }
    const hasEmailIdx = await knex.schema.hasColumn('players', 'email');
    if (hasEmailIdx) {
        try { await knex.schema.raw('CREATE INDEX IF NOT EXISTS idx_players_email ON players (email)'); } catch (_) { }
    }
};

exports.down = async function (knex) {
    const hasTable = await knex.schema.hasTable('players');
    if (!hasTable) return;
    await knex.schema.alterTable('players', (t) => {
        t.dropColumn('verified');
        t.dropColumn('phone_number');
        t.dropColumn('phone_verified');
        t.dropColumn('email');
        t.dropColumn('email_verified');
        t.dropColumn('discord_verified');
        t.dropColumn('age_verified');
        t.dropColumn('tos_accepted');
        t.dropColumn('verification_updated_at');
    });
};