export async function up(knex) {
    if (!(await knex.schema.hasTable('heat'))) {
        await knex.schema.createTable('heat', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().index();
            t.string('area', 32).notNullable().defaultTo('city');
            t.integer('value').notNullable().defaultTo(0);         // 0..100
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['char_id', 'area']);
        });
    }

    // Optional audit for increments/decay to satisfy "audited"
    if (!(await knex.schema.hasTable('heat_log'))) {
        await knex.schema.createTable('heat_log', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().index();
            t.string('area', 32).notNullable().defaultTo('city');
            t.integer('delta').notNullable();                      // + or -
            t.string('reason', 64).notNullable();
            t.json('position').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('heat_log', (t) => t.index(['char_id', 'created_at']));
    }

    if (!(await knex.schema.hasTable('contraband_flags'))) {
        await knex.schema.createTable('contraband_flags', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().index();
            t.string('flag', 48).notNullable();           // e.g. carrying_dirty_money, weapons_trafficker
            t.boolean('value').notNullable().defaultTo(true);
            t.json('meta').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['char_id', 'flag']);
        });
    }

    if (!(await knex.schema.hasTable('heists'))) {
        await knex.schema.createTable('heists', (t) => {
            t.increments('id').primary();
            t.string('slug', 64).notNullable().unique();  // e.g., 247_vanilla_reg1
            t.string('label', 96).notNullable();
            t.string('type', 24).notNullable().defaultTo('register'); // register|safe|bank|jewelry...
            t.datetime('last_started_at').nullable();
            t.datetime('cooldown_until').nullable();
            t.string('state', 16).notNullable().defaultTo('idle');    // idle|active|locked
            t.json('metadata').nullable();                            // {cooldown_s, coords, etc}
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });

        // Seed a single register for DoD
        await knex('heists').insert({
            slug: '247_vanilla_reg1',
            label: '24/7 Strawberry — Register #1',
            type: 'register',
            state: 'idle',
            metadata: JSON.stringify({ cooldown_s: 420 })
        });
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('heists');
    await knex.schema.dropTableIfExists('contraband_flags');
    await knex.schema.dropTableIfExists('heat_log');
    await knex.schema.dropTableIfExists('heat');
}