export async function up(knex) {
    // characters (soft-delete)
    const hasChars = await knex.schema.hasTable('characters');
    if (!hasChars) {
        await knex.schema.createTable('characters', (t) => {
            t.increments('id').primary();
            t.integer('user_id').unsigned().notNullable()
                .references('id').inTable('users').onDelete('CASCADE');
            t.integer('slot').unsigned().notNullable();
            t.string('first_name', 50).notNullable();
            t.string('last_name', 50).notNullable();
            t.date('dob').nullable();
            t.string('gender', 10).nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('deleted_at').nullable();
            t.unique(['user_id', 'slot']);
        });
    }

    // per character state
    const hasState = await knex.schema.hasTable('character_state');
    if (!hasState) {
        await knex.schema.createTable('character_state', (t) => {
            t.increments('id').primary();
            t.integer('character_id').unsigned().notNullable()
                .references('id').inTable('characters').onDelete('CASCADE');
            t.json('position').nullable();        // {x,y,z,heading}
            t.integer('routing_bucket').notNullable().defaultTo(0);
            t.datetime('last_played_at').nullable();
            t.unique(['character_id']);
        });
    }

    // accounts (cash/bank/dirty per character)
    const hasAccounts = await knex.schema.hasTable('accounts');
    if (!hasAccounts) {
        await knex.schema.createTable('accounts', (t) => {
            t.increments('id').primary();
            t.integer('character_id').unsigned().notNullable()
                .references('id').inTable('characters').onDelete('CASCADE');
            t.enum('type', ['cash', 'bank', 'dirty']).notNullable();
            t.bigint('balance').notNullable().defaultTo(0);
            t.unique(['character_id', 'type']);
        });
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('accounts');
    await knex.schema.dropTableIfExists('character_state');
    // Keep characters table for safety (or drop if you prefer):
    // await knex.schema.dropTableIfExists('characters');
}