export async function up(knex) {
    await knex.schema.createTable('characters', (t) => {
        t.increments('id').primary();
        t.integer('player_id').unsigned().notNullable().references('id').inTable('players').onDelete('CASCADE');
        t.integer('slot').unsigned().notNullable().defaultTo(1);
        t.string('first_name', 50).nullable();
        t.string('last_name', 50).nullable();
        t.date('dob').nullable();
        t.string('gender', 10).nullable();
        t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        t.datetime('deleted_at').nullable();
        t.unique(['player_id', 'slot']);
    });

    await knex.schema.createTable('audit_log', (t) => {
        t.increments('id').primary();
        t.datetime('ts').notNullable().defaultTo(knex.fn.now());
        t.enum('actor_type', ['system', 'player', 'admin']).notNullable().defaultTo('system');
        t.integer('actor_id').nullable();
        t.string('action', 64).notNullable();
        t.string('target', 64).nullable();
        t.json('meta').nullable();
    });
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('audit_log');
    await knex.schema.dropTableIfExists('characters');
}