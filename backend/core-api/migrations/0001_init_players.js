export async function up(knex) {
    await knex.schema.createTable('players', (t) => {
        t.increments('id').primary();
        t.string('primary_identifier', 128).notNullable().index();
        t.string('last_ip', 64).nullable();
        t.enum('ban_status', ['none', 'temp', 'perma']).notNullable().defaultTo('none');
        t.string('ban_reason', 255).nullable();
        t.datetime('ban_expires_at').nullable();
        t.timestamps(true, true);
    });

    await knex.schema.createTable('player_identifiers', (t) => {
        t.increments('id').primary();
        t.integer('player_id').unsigned().notNullable().references('id').inTable('players').onDelete('CASCADE');
        t.enum('type', ['license', 'steam', 'discord', 'fivem', 'xbl', 'live', 'ip']).notNullable().index();
        t.string('value', 128).notNullable().index();
        t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
    });
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('player_identifiers');
    await knex.schema.dropTableIfExists('players');
}