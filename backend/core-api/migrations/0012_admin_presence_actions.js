export async function up(knex) {
    if (!(await knex.schema.hasTable('admin_presence'))) {
        await knex.schema.createTable('admin_presence', (t) => {
            t.increments('id').primary();
            t.integer('user_id').notNullable().index();
            t.integer('char_id').nullable().index();
            t.string('src', 16).notNullable();        // serverId snapshot (string)
            t.string('name', 64).notNullable();       // display name from server
            t.string('job_code', 32).nullable();
            t.json('position').nullable();            // {x,y,z,heading}
            t.integer('health').nullable();
            t.boolean('in_vehicle').notNullable().defaultTo(false);
            t.datetime('last_heartbeat').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('admin_presence', (t) => {
            t.index(['last_heartbeat']);
            t.index(['user_id', 'char_id']);
        });
    }

    if (!(await knex.schema.hasTable('admin_actions'))) {
        await knex.schema.createTable('admin_actions', (t) => {
            t.increments('id').primary();
            t.integer('actor_user_id').notNullable().index();
            t.integer('actor_char_id').nullable();
            t.string('action', 32).notNullable();        // spectate|noclip|bring|goto|cleanup|kick|ban|unban
            t.string('target_src', 16).nullable();       // serverId string when applicable
            t.integer('target_user_id').nullable();
            t.integer('target_char_id').nullable();
            t.json('params').nullable();
            t.string('status', 16).notNullable().defaultTo('attempt'); // attempt|allowed|denied|success|error
            t.string('scope_used', 64).nullable();       // which scope was required
            t.string('result_code', 64).nullable();      // OK|DENIED|...
            t.text('result_message').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('admin_actions');
    await knex.schema.dropTableIfExists('admin_presence');
}