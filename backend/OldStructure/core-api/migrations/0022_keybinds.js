/**
 * 0022_keybinds.js
 * Per-player/character saved keybinds.
 */
exports.up = async function (knex) {
    const exists = await knex.schema.hasTable('keybinds');
    if (exists) return;
    await knex.schema.createTable('keybinds', (t) => {
        t.increments('id').primary();
        t.integer('player_id').notNullable().index();
        t.integer('character_id').nullable().index();
        t.string('name', 64).notNullable();       // logical bind name (e.g., "openPhone")
        t.string('device', 16).notNullable();     // keyboard | pad
        t.string('key', 32).notNullable();        // e.g., "F1" (note: actual mapping managed by FiveM UI)
        t.json('meta').nullable();                // extra metadata/description
        t.timestamp('updated_at').notNullable().defaultTo(knex.fn.now());
        t.unique(['player_id', 'character_id', 'name']);
    });
};

exports.down = async function (knex) {
    const exists = await knex.schema.hasTable('keybinds');
    if (!exists) return;
    await knex.schema.dropTable('keybinds');
};