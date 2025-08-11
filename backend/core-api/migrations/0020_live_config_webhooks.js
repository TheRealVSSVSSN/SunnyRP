/**
 * 0020_live_config_webhooks.js
 * MySQL schema for live config, feature flags, and Discord webhook fan-out
 */
exports.up = async function (knex) {
    // Live config key/value
    await knex.schema.createTable('config_live', (t) => {
        t.string('key', 191).primary();
        t.json('value').notNullable();
        t.timestamp('updated_at').notNullable().defaultTo(knex.fn.now());
    });

    // Feature flags
    await knex.schema.createTable('feature_flags', (t) => {
        t.string('name', 191).primary();
        t.boolean('enabled').notNullable().defaultTo(false);
        t.timestamp('updated_at').notNullable().defaultTo(knex.fn.now());
    });

    // Discord webhooks registry
    await knex.schema.createTable('webhooks', (t) => {
        t.bigIncrements('id').primary();
        t.string('name', 191).notNullable();
        // NOTE: store encrypted in production; plain here for simplicity.
        t.text('url').notNullable();
        t.json('channels').notNullable().defaultTo(JSON.stringify([])); // ["ops","joins","anomalies"]
        t.json('scopes').notNullable().defaultTo(JSON.stringify([]));
        t.boolean('enabled').notNullable().defaultTo(true);
        t.timestamp('created_at').notNullable().defaultTo(knex.fn.now());
        t.timestamp('updated_at').notNullable().defaultTo(knex.fn.now());
    });

    // Webhook delivery outbox
    await knex.schema.createTable('webhook_events', (t) => {
        t.bigIncrements('id').primary();
        t.bigInteger('webhook_id').unsigned().notNullable()
            .references('id').inTable('webhooks').onDelete('CASCADE');
        t.string('type', 191).notNullable();     // e.g. "srp.notify"
        t.json('payload').notNullable();
        t.enum('status', ['pending', 'delivered', 'failed']).notNullable().defaultTo('pending');
        t.integer('attempts').notNullable().defaultTo(0);
        t.timestamp('created_at').notNullable().defaultTo(knex.fn.now());
        t.timestamp('delivered_at').nullable();
        t.text('last_error').nullable();
    });

    // Seed flags
    const flags = [
        { name: 'police', enabled: false },
        { name: 'ems', enabled: false },
        { name: 'doc', enabled: false },
        { name: 'illness', enabled: false },
        { name: 'disabilities', enabled: false },
        { name: 'realisticTime', enabled: true },
        { name: 'realisticWeather', enabled: false },
        { name: 'autoRespawn', enabled: false },
        { name: 'allowPlayerChoice', enabled: true },
    ];
    for (const f of flags) await knex('feature_flags').insert(f).onConflict('name').merge();

    // Initial live config
    const initial = {
        Features: { police: false, ems: false, doc: false, illness: false, disabilities: false },
        Death: { autoRespawn: false, allowPlayerChoice: true, minBleedoutSec: 300, maxBleedoutSec: 900 },
        Time: { realistic: true, timezone: 'America/Phoenix', syncHz: 1 },
        Weather: { mode: 'scripted', syncIntervalSec: 60, current: { type: 'CLEAR', wind: 0.0 } },
        Buckets: { loading: 1, main: 2, charStart: 10001, charCount: 1000, adminStart: 50001 },
        QoL: { holdToSpeak: true, showCompass: true, streetDisplay: 'name', hudRateHz: 6, densityScale: 0.8 },
        AntiCheat: { maxSpeedKmh: 280, maxTeleportMeters: 120 },
        Dev: { fakeBackend: false, debug: false }
    };
    await knex('config_live')
        .insert({ key: 'base', value: JSON.stringify(initial) })
        .onConflict('key')
        .merge();
};

exports.down = async function (knex) {
    await knex.schema.dropTableIfExists('webhook_events');
    await knex.schema.dropTableIfExists('webhooks');
    await knex.schema.dropTableIfExists('feature_flags');
    await knex.schema.dropTableIfExists('config_live');
};